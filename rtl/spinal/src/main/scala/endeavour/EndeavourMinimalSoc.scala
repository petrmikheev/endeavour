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

// Minimal SoC for peripheral controllers debugging
class EndeavourMinimalSoc extends Component {
  val ioBaseAddr = 0x0
  val ioSize = 0x10000

  val internalRamBaseAddr = 0x40000000L
  val internalRamSize = 16 * 1024

  val io = new Bundle {
    val nreset = in Bool()
    val clk_in = in Bool()
    val plla = PLL()
    val pllb = PLL()

    val leds = out Bits(3 bits)
    val keys = in Bits(2 bits)
    //val audio_shdn = out Bool()
    //val audio_i2c = I2C()
    val uart = UART()
    /*val dvi = DVI()
    val sdcard = SDCARD()
    val ddr_sdram = DDR_SDRAM(14)
    val usb1 = USB()
    val usb2 = USB()

    val jtag = slave(new com.jtag.Jtag())*/
  }

  val board_ctrl = new BoardController()
  board_ctrl.io.nreset_in <> io.nreset
  board_ctrl.io.clk_in <> io.clk_in
  board_ctrl.io.plla <> io.plla
  board_ctrl.io.pllb <> io.pllb
  /*board_ctrl.io.pllb.clk0 := io.pllb.clk0
  board_ctrl.io.pllb.clk1 := io.pllb.clk1
  board_ctrl.io.pllb.clk2 := io.pllb.clk2*/
  board_ctrl.io.leds <> io.leds
  board_ctrl.io.keys <> io.keys
  board_ctrl.io.video_mode := B(0, 2 bits)

  ClockDomainStack.set(ClockDomain(clock=board_ctrl.io.clk_peripheral, reset=board_ctrl.io.reset_peripheral))

  val bus = tilelink.fabric.Node().forceDataWidth(32)

  val uart_ctrl = new UartController()
  uart_ctrl.io.uart <> io.uart

  /*val audio_ctrl = new AudioController()
  audio_ctrl.io.shdn <> io.audio_shdn
  audio_ctrl.io.i2c <> io.audio_i2c

  val i2c = new I2C_APB()
  i2c1.io.i2c <> io.pllb.i2c*/

  val cpu = new VexiiMinimalCore(resetVector=internalRamBaseAddr)

  cpu.utime := board_ctrl.io.utime
  cpu.interrupts.timer := board_ctrl.io.timer_interrupt
  cpu.interrupts.software := False
  cpu.interrupts.external := False

  bus << cpu.core.iBus
  bus << cpu.core.dBus

  val toApb = new tilelink.fabric.Apb3BridgeFiber()
  toApb.down.addTag(new system.tag.MemoryEndpointTag(SizeMapping(ioBaseAddr, ioSize)))
  toApb.up at (ioBaseAddr, ioSize) of bus
  fiber.Handle {
    val apbDecoder = Apb3Decoder(
      master = toApb.down.get,
      slaves = List(
        uart_ctrl.io.apb     -> (0x1000, 16),
        //audio_ctrl.io.apb    -> (0x2000, 8),
        //i2c.io.apb          -> (0xb000, 16),
        board_ctrl.io.apb    -> (0x8000, 32)
      )
    )
  }

  val internalRam = new tilelink.fabric.RamFiber(internalRamSize)
  fiber.Handle { internalRam.thread.logic.mem.generateAsBlackBox() }
  internalRam.up at (internalRamBaseAddr, internalRamSize) of bus
}

object EndeavourMinimalSoc {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode=Verilog).generate(new EndeavourMinimalSoc())
  }
}
