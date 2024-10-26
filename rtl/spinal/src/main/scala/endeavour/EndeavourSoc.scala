package endeavour

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.tilelink
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.misc.plic._
import spinal.lib.system.tag.PMA
//import spinal.lib.system.tag.{MemoryConnection, MemoryEndpoint, MemoryEndpointTag, MemoryTransferTag, MemoryTransfers, PMA, VirtualEndpoint}

//import vexriscv.plugin._

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

  ClockDomainStack.set(ClockDomain(clock=board_ctrl.io.clk_cpu, reset=board_ctrl.io.reset_cpu))

  val video_ctrl = new VideoController()
  video_ctrl.io.video_mode_out <> board_ctrl.io.video_mode
  video_ctrl.io.tmds_pixel_clk <> board_ctrl.io.clk_tmds_pixel
  video_ctrl.io.tmds_x5_clk <> board_ctrl.io.clk_tmds_x5
  video_ctrl.io.dvi <> io.dvi

  val peripheral = new ClockingArea(ClockDomain(
      clock = board_ctrl.io.clk_peripheral,
      reset = board_ctrl.io.reset_peripheral,
      frequency = FixedFrequency(48 MHz))) {

    val uart_ctrl = new UartController()
    uart_ctrl.io.uart <> io.uart

    val audio_ctrl = new AudioController()
    audio_ctrl.io.shdn <> io.audio_shdn
    audio_ctrl.io.i2c <> io.audio_i2c

    val sdcard_ctrl = new SdcardController()
    sdcard_ctrl.io.sdcard <> io.sdcard

    val usb_ctrl = new EndeavourUSB()
    usb_ctrl.io.usb1 <> io.usb1
    usb_ctrl.io.usb2 <> io.usb2

    val apb = Apb3(Apb3Config(
      addressWidth  = 19,
      dataWidth     = 32,
      useSlaveError = false
    ))
    val apbDecoder = Apb3Decoder(
      master = apb,
      slaves = List(
        uart_ctrl.io.apb     -> (0x10000, 16),
        audio_ctrl.io.apb    -> (0x20000, 8),
        sdcard_ctrl.io.apb   -> (0x30000, 32),
        usb_ctrl.io.apb_ctrl -> (0x40000, 0x1000),
        usb_ctrl.io.apb_dma  -> (0x41000, 0x1000)
      )
    )
  }
  val peripheral_apb_bridge = new ApbClockBridge(19)
  peripheral_apb_bridge.io.clk_output <> board_ctrl.io.clk_peripheral
  peripheral_apb_bridge.io.output <> peripheral.apb

  val ram_ctrl = new DDRSdramController(rowBits = 14, colBits = 10, idWidth = 4)
  ram_ctrl.io.ddr <> io.ddr_sdram
  ram_ctrl.io.clk <> board_ctrl.io.clk_ram_bus
  ram_ctrl.io.clk_shifted <> board_ctrl.io.clk_ram
  ram_ctrl.io.reset <> board_ctrl.io.reset_ram

  val ram_cc = new Axi4SharedCC(
    ram_ctrl.io.axi.config,
    inputCd = ClockDomain.current,
    outputCd = ClockDomain(clock = board_ctrl.io.clk_ram_bus, reset = board_ctrl.io.reset_ram),
    arwFifoSize = 8, rFifoSize = 128, wFifoSize = 8, bFifoSize = 8
  )
  ram_cc.io.output <> ram_ctrl.io.axi

  val usb_interrupt = RegNext(peripheral.usb_ctrl.io.interrupt) addTag(crossClockDomain)

  val plicPriorityWidth = 1
  val plic_gateways = List(
    PlicGatewayActiveHigh(source = peripheral.uart_ctrl.io.interrupt, id = 1, priorityWidth = plicPriorityWidth),
    PlicGatewayActiveHigh(source = peripheral.sdcard_ctrl.io.interrupt, id = 2, priorityWidth = plicPriorityWidth),
    PlicGatewayActiveHigh(source = usb_interrupt, id = 3, priorityWidth = plicPriorityWidth)
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

  val cpu = new VexiiCore(resetVector=internalRamBaseAddr)
  cpu.core.priv match {
    case Some(priv) => priv.rdtime := board_ctrl.io.utime
  }

  //var iBus : Axi4ReadOnly = null
  //var dBus : Axi4Shared = null
  /*for(plugin <- cpu.plugins) plugin match{
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
  }*/

  val internalRam = new tilelink.fabric.RamFiber(internalRamSize)
  internalRam.up at internalRamBaseAddr of cpu.bus32
  fiber.Handle { internalRam.thread.logic.mem.generateAsBlackBox() }

  val toApb = new tilelink.fabric.Apb3BridgeFiber()
  toApb.down.addTag(new system.tag.MemoryEndpointTag(SizeMapping(ioBaseAddr, ioSize)))
  toApb.up at (ioBaseAddr, ioSize) of cpu.bus32
  fiber.Handle {
    val apbDecoder = Apb3Decoder(
      master = toApb.down.get,
      slaves = List(
        peripheral_apb_bridge.io.input -> (0x0, 0x80000),
        board_ctrl.io.apb  -> (0x80000, 32),
        video_ctrl.io.apb  -> (0x90000, 32),
        plic_apb           -> (plicAddr, plicSize)
      )
    )
  }

  val toAxi4 = new tilelink.fabric.Axi4Bridge()
  toAxi4.down.addTag(PMA.MAIN)
  toAxi4.down.addTag(PMA.EXECUTABLE)
  toAxi4.down.addTag(new system.tag.MemoryEndpointTag(SizeMapping(externalRamBaseAddr, externalRamSize)))
  /*toAxi4.up.setUpConnection(d = new StreamPipe {
    override def apply[T <: Data](m: Stream[T]) = m.queue(256)
  })*/
  toAxi4.up << cpu.bus32
  fiber.Handle {
    val axiCrossbar = Axi4CrossbarFactory()
    axiCrossbar.addSlaves(ram_cc.io.input -> SizeMapping(externalRamBaseAddr, externalRamSize))
    axiCrossbar.addConnections(toAxi4.down.get -> List(ram_cc.io.input), video_ctrl.io.axi -> List(ram_cc.io.input))
    axiCrossbar.build()
  }
}

object EndeavourSoc {
  def main(args: Array[String]): Unit = SpinalVerilog(new EndeavourSoc())
}
