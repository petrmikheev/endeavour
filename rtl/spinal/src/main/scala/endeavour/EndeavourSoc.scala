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
    val clk100mhz = in Bool()
    val nreset = in Bool()
    val leds = out Bits(3 bits)
    val keys = in Bits(2 bits)
    val uart = UART()
    //val dvi = DVI()
    val sdcard = SDCARD()
  }

  val clocks = new Clocking()
  clocks.io.clk_in <> io.clk100mhz
  clocks.io.nreset_in <> io.nreset

  ClockDomainStack.set(ClockDomain(clock=clocks.io.clk, reset=clocks.io.reset))

  /*val video_ctrl = new VideoController()
  video_ctrl.io.video_mode_out <> clocks.io.video_mode
  video_ctrl.io.tmds_pixel_clk <> clocks.io.tmds_pixel_clk
  video_ctrl.io.tmds_x5_clk <> clocks.io.tmds_x5_clk
  video_ctrl.io.dvi <> io.dvi*/
  clocks.io.video_mode := B(0, 2 bits)

  val uart_ctrl = new UartController()
  uart_ctrl.io.uart <> io.uart

  val sdcard_ctrl = new SdcardController()
  sdcard_ctrl.io.sdcard <> io.sdcard

  val gpio_ctrl = new GpioController()
  gpio_ctrl.io.leds <> io.leds
  gpio_ctrl.io.keys <> io.keys

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
    apbBridge.io.axi -> SizeMapping(ioBaseAddr, ioSize),
    internalRam.io.axi -> SizeMapping(internalRamBaseAddr, internalRamSize)
    //io.axi4_ram      -> SizeMapping(externalRamBaseAddr, externalRamSize)
  )
  axiCrossbar.addConnections(
    iBus -> List(/*io.axi4_ram,*/ internalRam.io.axi),
    dBus -> List(/*io.axi4_ram,*/ internalRam.io.axi, apbBridge.io.axi)
  )
  axiCrossbar.build()

  val apbDecoder = Apb3Decoder(
    master = apbBridge.io.apb,
    slaves = List(
      uart_ctrl.io.apb ->   (0x100, 16),
      sdcard_ctrl.io.apb -> (0x200, 32),
      gpio_ctrl.io.apb ->   (0x300, 8)
      // 0x400 USB_P1
      // 0x500 USB_P2
      // 0x600 reserved for USB_DEVICE
      // 0x700 timer
      // 0x800 video
      // 0x900 audio
    )
  )
}

object EndeavourSoc {
  def main(args: Array[String]): Unit = SpinalVerilog(new EndeavourSoc())
}
