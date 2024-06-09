package endeavour

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.misc.plic._

import vexriscv.plugin._

import endeavour.interfaces._
import endeavour.blackboxes._

class EndeavourSoc extends Component {
  val ioBaseAddr = 0x0
  val ioSize = 0x8000000

  val plicAddr = 0x4000000
  val plicSize = 0x4000000

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
    val usb1 = USB()
    val usb2 = USB()
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

  val peripheral = new ClockingArea(ClockDomain(
      clock = board_ctrl.io.clk_peripheral,
      reset = board_ctrl.io.reset)) {

    val uart_ctrl = new UartController()
    uart_ctrl.io.uart <> io.uart

    val audio_ctrl = new AudioController()
    audio_ctrl.io.shdn <> io.audio_shdn
    audio_ctrl.io.i2c <> io.audio_i2c

    val sdcard_ctrl = new SdcardController()
    sdcard_ctrl.io.sdcard <> io.sdcard

    val usb1_ctrl = new USBHostController()
    val usb2_ctrl = new USBHostController()
    usb1_ctrl.io.usb <> io.usb1
    usb2_ctrl.io.usb <> io.usb2

    val apb = Apb3(Apb3Config(
      addressWidth  = 11,
      dataWidth     = 32,
      useSlaveError = false
    ))
    val apbDecoder = Apb3Decoder(
      master = apb,
      slaves = List(
        uart_ctrl.io.apb   -> (0x100, 16),
        audio_ctrl.io.apb  -> (0x200, 8),
        sdcard_ctrl.io.apb -> (0x300, 32),
        usb1_ctrl.io.apb   -> (0x400, 64),
        usb2_ctrl.io.apb   -> (0x500, 64)
        // 0x600 reserved for USB_DEVICE
      )
    )
  }
  val peripheral_apb_bridge = new ApbClockBridge(11)
  peripheral_apb_bridge.io.clk_output <> board_ctrl.io.clk_peripheral
  peripheral_apb_bridge.io.output <> peripheral.apb

  val ram_ctrl = new DDRSdramController(rowBits = 14, colBits = 10)
  ram_ctrl.io.ddr <> io.ddr_sdram
  ram_ctrl.io.clk <> board_ctrl.io.clk_cpu
  ram_ctrl.io.clk_shifted <> board_ctrl.io.clk_ram
  ram_ctrl.io.reset <> board_ctrl.io.reset

  val plicPriorityWidth = 1
  val plic_gateways = List(
    PlicGatewayActiveHigh(source = peripheral.uart_ctrl.io.interrupt, id = 1, priorityWidth = plicPriorityWidth),
    PlicGatewayActiveHigh(source = peripheral.sdcard_ctrl.io.interrupt, id = 2, priorityWidth = plicPriorityWidth),
    PlicGatewayActiveHigh(source = peripheral.usb1_ctrl.io.interrupt, id = 3, priorityWidth = plicPriorityWidth),
    PlicGatewayActiveHigh(source = peripheral.usb2_ctrl.io.interrupt, id = 4, priorityWidth = plicPriorityWidth)
  )
  val plic_target = PlicTarget(id = 0, gateways = plic_gateways, priorityWidth = plicPriorityWidth)

  val plic_apb = Apb3(Apb3Config(
    addressWidth  = log2Up(plicSize),
    dataWidth     = 32,
    useSlaveError = false
  ))
  val plic = PlicMapper(Apb3SlaveFactory(plic_apb), PlicMapping.sifive)(
    gateways = plic_gateways,
    targets = List(plic_target)
  )

  val cpu = new VexRiscvGen(useCache=true, compressedGen=true, resetVector=internalRamBaseAddr)

  var iBus : Axi4ReadOnly = null
  var dBus : Axi4Shared = null
  for(plugin <- cpu.plugins) plugin match{
    case plugin : IBusSimplePlugin => iBus = plugin.iBus.toAxi4ReadOnly()
    case plugin : IBusCachedPlugin => iBus = plugin.iBus.toAxi4ReadOnly()
    case plugin : DBusSimplePlugin => dBus = plugin.dBus.toAxi4Shared()
    case plugin : DBusCachedPlugin => dBus = plugin.dBus.toAxi4Shared(true)
    case plugin : CsrPlugin        => {
      plugin.externalInterrupt := plic_target.iep
      plugin.externalInterruptS := plic_target.iep
      plugin.timerInterrupt := board_ctrl.io.timer_interrupt
      plugin.utime := board_ctrl.io.utime
    }
    case _ =>
  }

  val internalRam = Axi4SharedOnChipRam(
    dataWidth = 32,
    byteCount = internalRamSize,
    idWidth = 2
  )
  internalRam.ram.generateAsBlackBox()
  //val internalRam = new InternalRam(internalRamSize)

  val apbBridge = Axi4SharedToApb3Bridge(
    dataWidth = 32,
    addressWidth = log2Up(ioSize),
    idWidth = 2
  )

  val axiCrossbar = Axi4CrossbarFactory()
  axiCrossbar.addSlaves(
    apbBridge.io.axi   -> SizeMapping(ioBaseAddr, ioSize),
    internalRam.io.axi -> SizeMapping(internalRamBaseAddr, internalRamSize),
    ram_ctrl.io.axi    -> SizeMapping(externalRamBaseAddr, externalRamSize)
  )
  axiCrossbar.addConnections(
    iBus -> List(ram_ctrl.io.axi, internalRam.io.axi),
    dBus -> List(ram_ctrl.io.axi, internalRam.io.axi, apbBridge.io.axi),
    video_ctrl.io.axi -> List(ram_ctrl.io.axi)
  )
  axiCrossbar.build()

  val apbDecoder = Apb3Decoder(
    master = apbBridge.io.apb,
    slaves = List(
      peripheral_apb_bridge.io.input -> (0x000, 2048),
      board_ctrl.io.apb  -> (0x800, 32),
      video_ctrl.io.apb  -> (0x900, 32),
      plic_apb           -> (plicAddr, plicSize)
    )
  )
}

object EndeavourSoc {
  def main(args: Array[String]): Unit = SpinalVerilog(new EndeavourSoc())
}
