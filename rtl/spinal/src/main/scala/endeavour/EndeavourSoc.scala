package endeavour

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.tilelink
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.misc.plic._
import spinal.lib.system.tag.PMA

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

  val coherent_bus = tilelink.fabric.Node().forceDataWidth(64)
  val mem_bus = tilelink.fabric.Node().forceDataWidth(64)
  val io_bus = tilelink.fabric.Node().forceDataWidth(32)

  val tilelink_hub = new tilelink.coherent.HubFiber()
  tilelink_hub.up << coherent_bus
  mem_bus << tilelink_hub.down

  ClockDomainStack.set(ClockDomain(clock=board_ctrl.io.clk_cpu, reset=board_ctrl.io.reset_cpu))

  val video_ctrl = new VideoController()
  video_ctrl.io.video_mode_out <> board_ctrl.io.video_mode
  video_ctrl.io.tmds_pixel_clk <> board_ctrl.io.clk_tmds_pixel
  video_ctrl.io.tmds_x5_clk <> board_ctrl.io.clk_tmds_x5
  video_ctrl.io.dvi <> io.dvi

  video_ctrl.io.axi.setBlocked()
  /*val video_ctrl_bridge = new Axi4ReadOnlyToTilelink(video_ctrl.io.axi.config.copy(idWidth=0, useId=true, useSize=true), 512)
  video_ctrl_bridge.io.up << video_ctrl.io.axi
  val video_bus = tilelink.fabric.Node.master()
  val video_read = fiber.Fiber build new Area {
    var range = tilelink.SizeRange.upTo(512)
    video_bus.m2s.proposed load tilelink.M2sSupport(
      addressWidth = video_ctrl.io.axi.config.addressWidth,
      dataWidth = video_ctrl.io.axi.config.dataWidth,
      transfers = tilelink.M2sTransfers(get = range)
    )
    video_bus.m2s.parameters load tilelink.M2sParameters(
      sourceCount = 1,
      support = video_bus.m2s.proposed.copy(
        transfers = tilelink.M2sTransfers(get = range)
      )
    )
    video_bus.s2m.supported load tilelink.S2mSupport.none()
    video_ctrl_bridge.io.down >> video_bus.bus
  }
  coherent_bus << video_bus
  */

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

  cpu.utime := board_ctrl.io.utime
  cpu.interrupts.timer := board_ctrl.io.timer_interrupt
  cpu.interrupts.software := False
  cpu.interrupts.external := plic_target.iep

  coherent_bus << cpu.core.lsuL1Bus
  mem_bus << cpu.core.iBus
  io_bus << cpu.core.dBus

  val toApb = new tilelink.fabric.Apb3BridgeFiber()
  toApb.down.addTag(new system.tag.MemoryEndpointTag(SizeMapping(ioBaseAddr, ioSize)))
  toApb.up at (ioBaseAddr, ioSize) of io_bus
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

  val internalRam = new tilelink.fabric.RamFiber(internalRamSize)
  fiber.Handle { internalRam.thread.logic.mem.generateAsBlackBox() }
  internalRam.up at (internalRamBaseAddr, internalRamSize) of mem_bus

  val ramBridge = new tilelink.fabric.Axi4Bridge()
  ramBridge.down.addTag(PMA.MAIN)
  ramBridge.down.addTag(PMA.EXECUTABLE)
  ramBridge.down.addTag(new system.tag.MemoryEndpointTag(SizeMapping(0, externalRamSize)))
  ramBridge.up at (externalRamBaseAddr, externalRamSize) of mem_bus

  val ram = fiber.Fiber build new Area {
    val axi = ramBridge.down.get.toShared

    val ddr_ctrl = new DDRSdramController(rowBits = 14, colBits = 10, idWidth = axi.config.idWidth)
    ddr_ctrl.io.ddr <> io.ddr_sdram
    ddr_ctrl.io.clk <> board_ctrl.io.clk_ram_bus
    ddr_ctrl.io.clk_shifted <> board_ctrl.io.clk_ram
    ddr_ctrl.io.reset <> board_ctrl.io.reset_ram

    val axi_cc = new Axi4SharedCC(
      ddr_ctrl.io.axi.config,
      inputCd = ClockDomain.current,
      outputCd = ClockDomain(clock = board_ctrl.io.clk_ram_bus, reset = board_ctrl.io.reset_ram),
      arwFifoSize = 2, rFifoSize = 128, wFifoSize = 16, bFifoSize = 2
    )
    axi_cc.io.output <> ddr_ctrl.io.axi
    axi_cc.io.input <> axi
  }
}

object EndeavourSoc {
  def main(args: Array[String]): Unit = SpinalVerilog(new EndeavourSoc())
}
