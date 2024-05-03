package endeavour

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.misc.SizeMapping

import vexriscv.plugin._

import endeavour.interfaces._
import endeavour.blackboxes._

class EndeavourSoc extends Component {
  val ioBaseAddr = 0x0
  val ioSize = 4096

  val internalRamBaseAddr = 0x40000000L
  val internalRamSize = 16 * 1024

  val externalRamBaseAddr = 0x80000000L
  val externalRamSize = 0x8000000L // 128 MB

  val io = new Bundle {
    val nreset = in Bool()
    val clk_in = in Bool()
    val plla = PLL()
    val pllb = PLL()

    val leds = out Bits(3 bits)
    val keys = in Bits(2 bits)
    val audio_shdn = out Bool()
    val audio_i2c = I2C()
    val uart = UART()
    val dvi = DVI()
    val sdcard = SDCARD()
    val ddr_sdram = DDR_SDRAM(14)
  }

  val board_ctrl = new BoardController()
  board_ctrl.io.nreset_in <> io.nreset
  board_ctrl.io.clk_in <> io.clk_in
  board_ctrl.io.plla <> io.plla
  board_ctrl.io.pllb <> io.pllb
  board_ctrl.io.leds <> io.leds
  board_ctrl.io.keys <> io.keys

  ClockDomainStack.set(ClockDomain(clock=board_ctrl.io.clk_cpu, reset=board_ctrl.io.reset))

  val video_ctrl = new VideoController()
  video_ctrl.io.video_mode_out <> board_ctrl.io.video_mode
  video_ctrl.io.tmds_pixel_clk <> board_ctrl.io.clk_tmds_pixel
  video_ctrl.io.tmds_x5_clk <> board_ctrl.io.clk_tmds_x5
  video_ctrl.io.dvi <> io.dvi
  //board_ctrl.io.video_mode := B(0, 2 bits)

  val peripheral = new ClockingArea(ClockDomain(
      clock = board_ctrl.io.clk_peripheral,
      reset = board_ctrl.io.reset)) {

    val uart_ctrl = new UartController()
    uart_ctrl.io.uart <> io.uart

    val audio_ctrl = new AudioController()
    audio_ctrl.io.shdn <> io.audio_shdn
    audio_ctrl.io.i2c <> io.audio_i2c

    val apb = Apb3(Apb3Config(
      addressWidth  = 11,
      dataWidth     = 32,
      useSlaveError = false
    ))
    val apbDecoder = Apb3Decoder(
      master = apb,
      slaves = List(
        uart_ctrl.io.apb   -> (0x100, 16),
        audio_ctrl.io.apb  -> (0x200, 8)
        // 0x300 reserved for USB_DEVICE
        // 0x400 USB_P1
        // 0x500 USB_P2
      )
    )
  }
  val peripheral_apb_bridge = new ApbClockBridge(11)
  peripheral_apb_bridge.io.clk_output <> board_ctrl.io.clk_peripheral
  peripheral_apb_bridge.io.output <> peripheral.apb

  val sdcard_ctrl = new SdcardController()
  sdcard_ctrl.io.sdcard <> io.sdcard

  val ram_ctrl = new ddr_sdram_ctrl(rowBits = 14, colBits = 10)
  ram_ctrl.io.ddr <> io.ddr_sdram
  ram_ctrl.io.clk <> board_ctrl.io.clk_cpu
  ram_ctrl.io.dqs_clk <> board_ctrl.io.clk_ram
  ram_ctrl.io.reset <> board_ctrl.io.reset

  val cpu = new VexRiscvGen(useCache=true, resetVector=internalRamBaseAddr)

  var iBus : Axi4ReadOnly = null
  var dBus : Axi4Shared = null
  val timerInterrupt = False // TODO
  val externalInterrupt = False // TODO
  for(plugin <- cpu.plugins) plugin match{
    case plugin : IBusSimplePlugin => iBus = plugin.iBus.toAxi4ReadOnly()
    case plugin : IBusCachedPlugin => iBus = plugin.iBus.toAxi4ReadOnly()
    case plugin : DBusSimplePlugin => dBus = plugin.dBus.toAxi4Shared()
    case plugin : DBusCachedPlugin => dBus = plugin.dBus.toAxi4Shared(true)
    case plugin : CsrPlugin        => {
      plugin.externalInterrupt := externalInterrupt
      plugin.timerInterrupt := timerInterrupt
    }
    case _ =>
  }

  val internalRam = Axi4SharedOnChipRam(
    dataWidth = 32,
    byteCount = internalRamSize,
    idWidth = 1
  )
  internalRam.ram.generateAsBlackBox()
  //val internalRam = new InternalRam(internalRamSize)

  val apbBridge = Axi4SharedToApb3Bridge(
    dataWidth = 32,
    addressWidth = log2Up(ioSize),
    idWidth = 1
  )

  val axiCrossbar = Axi4CrossbarFactory()
  axiCrossbar.addSlaves(
    apbBridge.io.axi   -> SizeMapping(ioBaseAddr, ioSize),
    internalRam.io.axi -> SizeMapping(internalRamBaseAddr, internalRamSize),
    ram_ctrl.io.axi    -> SizeMapping(externalRamBaseAddr, externalRamSize)
  )
  axiCrossbar.addConnections(
    iBus -> List(ram_ctrl.io.axi, internalRam.io.axi),
    dBus -> List(ram_ctrl.io.axi, internalRam.io.axi, apbBridge.io.axi)
  )
  axiCrossbar.build()

  val apbDecoder = Apb3Decoder(
    master = apbBridge.io.apb,
    slaves = List(
      peripheral_apb_bridge.io.input -> (0x000, 2048),
      board_ctrl.io.apb  -> (0x800, 16),
      sdcard_ctrl.io.apb -> (0x900, 32)
      // 0x700 timer
      // 0x800 video
    )
  )
}

object EndeavourSoc {
  def main(args: Array[String]): Unit = SpinalVerilog(new EndeavourSoc())
}
