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
