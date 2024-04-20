package endeavour.blackboxes

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.{Apb3, Apb3Config}
import spinal.lib.bus.amba4.axi._

import endeavour.interfaces._

class Clocking extends BlackBox {
  val io = new Bundle {
    val clk_in = in Bool()
    val nreset_in = in Bool()
    val clk = out Bool()
    val clk_delayed = out Bool()
    val reset = out Bool()
    val video_mode = in Bits(2 bits)
    val tmds_pixel_clk = out Bool()
    val tmds_x5_clk = out Bool()
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
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk, reset=io.reset)
}

class UartController extends BlackBox {
  val io = new Bundle {
    val clk = in Bool()
    val reset = in Bool()
    val uart = UART()
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
    val apb = slave(Apb3(Apb3Config(
      addressWidth  = 5,
      dataWidth     = 32,
      useSlaveError = false
    )))
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk, reset=io.reset)
}

class GpioController extends BlackBox {
  val io = new Bundle {
    val clk = in Bool()
    val reset = in Bool()
    val leds = out Bits(3 bits)
    val keys = in Bits(2 bits)
    val apb = slave(Apb3(Apb3Config(
      addressWidth  = 3,
      dataWidth     = 32,
      useSlaveError = false
    )))
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk, reset=io.reset)
}

class ddr_sdram_ctrl(rowBits: Int, colBits: Int) extends BlackBox {
  addGeneric("ROW_BITS", rowBits)
  addGeneric("COL_BITS", colBits)
  addGeneric("DQ_LEVEL", 2)
  val io = new Bundle {
    val clk = in Bool()
    val dqs_clk = in Bool()
    val reset = in Bool()
    val axi = slave(Axi4Shared(Axi4Config(
      addressWidth = rowBits + colBits + 3,
      dataWidth = 32,
      idWidth = 1,
      useResp = false,
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

class InternalRam(size: BigInt) extends BlackBox {
  val io = new Bundle {
    val clk = in Bool()
    val reset = in Bool()
    val axi = slave(Axi4Shared(Axi4Config(
      addressWidth = log2Up(size),
      dataWidth = 32,
      idWidth = 1,
      useResp = false,
      useLock = false,
      useRegion = false,
      useCache = false,
      useProt = false,
      useQos = false,
      useSize = false
    )))
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk, reset=io.reset)
}

/*class InternalRam extends BlackBox {
  val io = new Bundle {
    val clk = in Bool()
    val en = in Bool()
    val wr = in Bool()
    val addr = in Bits(12 bits)
    val mask = in Bits(4 bits)
    val wrData = in Bits(32 bits)
    val rdData = out Bits(32 bits)
  }
  noIoPrefix()
  mapClockDomain(clock=io.clk)
}*/
