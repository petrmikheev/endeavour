package endeavour.interfaces

import spinal.core._

case class UART() extends Bundle {
  val rx = in Bool()
  val tx = out Bool()
}

case class DVI() extends Bundle {
  val tmds0p = out Bool()
  val tmds0m = out Bool()
  val tmds1p = out Bool()
  val tmds1m = out Bool()
  val tmds2p = out Bool()
  val tmds2m = out Bool()
  val tmdsCp = out Bool()
  val tmdsCm = out Bool()
}

case class SDCARD() extends Bundle {
  val clk = out Bool()
  val cmd = inout(Analog(Bool()))
  val data = inout(Analog(Bits(4 bits)))
}

case class DDR_SDRAM() extends Bundle {
  val ck_p = out Bool()
  val ck_n = out Bool()
  val cke = out Bool()
  val cs_n = out Bool()
  val ras_n = out Bool()
  val cas_n = out Bool()
  val we_n = out Bool()
  val ba = out Bits(2 bits)
  val a = out Bits(13 bits)
  val dm = out Bits(2 bits)
  val dqs = inout(Analog(Bits(2 bits)))
  val dq = inout(Analog(Bits(16 bits)))
}
