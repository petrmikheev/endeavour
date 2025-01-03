package endeavour.blackboxes

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.{Apb3, Apb3Config}
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.tilelink

import endeavour.interfaces._

class ApbClockBridge(awidth: Int) extends BlackBox {
  addGeneric("AWIDTH", awidth)
  val apb_conf = Apb3Config(
    addressWidth  = awidth,
    dataWidth     = 32,
    useSlaveError = true
  )
  val io = new Bundle {
    val clk_input = in Bool()
    val clk_output = in Bool()
    val input = slave(Apb3(apb_conf))
    val output = master(Apb3(apb_conf))
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk_input)
}

class BoardController extends BlackBox {
  val io = new Bundle {
    val nreset_in = in Bool()
    val clk_in = in Bool()
    val plla = PLL()
    val pllb = PLL()

    val reset_cpu = out Bool()
    val reset_ram = out Bool()
    val reset_peripheral = out Bool()
    val clk_cpu = out Bool()
    val clk_ram = out Bool()
    val clk_ram_bus = out Bool()
    val clk_peripheral = out Bool()  // uart, audio, usb, sdcard

    val utime = out UInt(64 bits)
    val timer_interrupt = out Bool()

    val video_mode = in Bits(2 bits)
    val clk_tmds_pixel = out Bool()
    val clk_tmds_x5 = out Bool()

    val leds = out Bits(3 bits)
    val keys = in Bits(2 bits)

    val apb = slave(Apb3(Apb3Config(
      addressWidth  = 6,
      dataWidth     = 32,
      useSlaveError = false
    )))
  }
  noIoPrefix()
}

class VideoController extends BlackBox {
  val io = new Bundle {
    val clk = in Bool()
    val reset = in Bool()
    val video_mode_out = out Bits(2 bits)
    val tmds_pixel_clk = in Bool()
    val tmds_x5_clk = in Bool()
    val dvi = DVI()
    val apb = slave(Apb3(Apb3Config(
      addressWidth  = 5,
      dataWidth     = 32,
      useSlaveError = false
    )))
    val tl_bus = master(tilelink.Bus(tilelink.BusParameter(
      addressWidth = 32,
      dataWidth    = 64,
      sizeBytes    = 64,
      sourceWidth  = 2,
      sinkWidth    = 0,
      withBCE      = false,
      withDataA    = false,
      withDataB    = false,
      withDataC    = false,
      withDataD    = true,
      node         = null
    )))
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk, reset=io.reset)
}

class I2C_APB extends BlackBox {
  val io = new Bundle {
    val clk = in Bool()
    val reset = in Bool()
    val i2c = I2C()
    val apb = slave(Apb3(Apb3Config(
      addressWidth  = 4,
      dataWidth     = 32,
      useSlaveError = false
    )))
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk, reset=io.reset)
}

class UartController extends BlackBox {
  val io = new Bundle {
    val clk = in Bool()
    val reset = in Bool()
    val uart = UART()
    val interrupt = out Bool()
    val apb = slave(Apb3(Apb3Config(
      addressWidth  = 4,
      dataWidth     = 32,
      useSlaveError = false
    )))
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk, reset=io.reset)
}

class SdcardController extends BlackBox {
  val io = new Bundle {
    val clk = in Bool()
    val reset = in Bool()
    val sdcard = SDCARD()
    val interrupt = out Bool()
    val apb = slave(Apb3(Apb3Config(
      addressWidth  = 5,
      dataWidth     = 32,
      useSlaveError = true
    )))
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk, reset=io.reset)
}

class AudioController extends BlackBox {
  val io = new Bundle {
    val clk = in Bool()
    val reset = in Bool()
    val shdn = out Bool()
    val i2c = I2C()
    val apb = slave(Apb3(Apb3Config(
      addressWidth  = 3,
      dataWidth     = 32,
      useSlaveError = false
    )))
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk, reset=io.reset)
}

class DDRSdramController(rowBits: Int, colBits: Int, idWidth: Int) extends BlackBox {
  addGeneric("ROW_BITS", rowBits)
  addGeneric("COL_BITS", colBits)
  addGeneric("ID_WIDTH", idWidth)
  val io = new Bundle {
    val clk = in Bool()
    val clk_shifted = in Bool()
    val reset = in Bool()
    val axi = slave(Axi4Shared(Axi4Config(
      addressWidth = rowBits + colBits + 3,
      dataWidth = 64,
      idWidth = idWidth,
      useResp = true,
      useAllStrb = true,
      useLock = false,
      useRegion = false,
      useCache = false,
      useProt = false,
      useQos = false
    )))
    val ddr = DDR_SDRAM(rowBits)
  }
  noIoPrefix()

  private def renameIO(): Unit = {
    io.flatten.foreach(bt => {
      bt.setName(bt.getName()
          .replace("axi_w_payload_", "w")
          .replace("axi_w_", "w")
          .replace("axi_b_payload_", "b")
          .replace("axi_b_", "b")
          .replace("axi_r_payload_", "r")
          .replace("axi_r_", "r")
          .replace("axi_arw_payload_", "arw_")
          .replace("axi_arw_", "arw_")
      )
    })
  }

  addPrePopTask(() => renameIO())
}

class SDR_IO1 extends BlackBox {
  val io = new Bundle {
    val inclock = in Bool()
    val dout = out Bool()

    val outclock = in Bool()
    val din = in Bool()

    val oe = in Bool()

    val pad_io = inout(Analog(Bool()))
  }
  noIoPrefix()
}
