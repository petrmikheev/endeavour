package endeavour

import spinal.core._
import spinal.lib._
import spinal.lib.bus.tilelink
import spinal.lib.bus.tilelink.fabric.Node

import vexiiriscv.ParamSimple
import vexiiriscv.soc.TilelinkVexiiRiscvFiber

class VexiiCore(resetVector: Long) {
  val param = new ParamSimple()
  param.resetVector = resetVector
  param.xlen = 32
  param.hartCount = 1
  param.bootMemClear = true
  param.withCaches

  param.fetchMemDataWidthMin = 64
  param.lsuMemDataWidthMin = 64

  param.withRvc = true
  param.withAlignerBuffer = true
  param.withDispatcherBuffer = true

  param.withMul = true
  param.withDiv = true
  //param.divRadix = 4
  param.withRva = true
  param.withRvZb = false

  param.withMmu = true
  param.withMmuSyncRead

  param.privParam.withSupervisor = true
  param.privParam.withUser = true
  param.privParam.withRdTime = true

  param.decoders = 2
  param.lanes = 2

  param.withBtb = true
  param.withGShare = true
  param.withRas = true

  param.relaxedBranch = true
  param.relaxedShift = true
  param.relaxedSrc = true
  param.relaxedBtb = true
  param.relaxedDiv = true
  param.relaxedMulInputs = true

  param.withLateAlu = true
  param.allowBypassFrom = 0
  param.storeRs2Late = true

  /*param.withRvf = true
  param.fpuFmaFullAccuracy = false
  param.fpuIgnoreSubnormal = true*/

  // To consider
  //fetchL1Prefetch
  //lsuSoftwarePrefetch
  //lsuHardwarePrefetch
  //lsuL1Coherency
  //fetchL1Ways
  //lsuL1Ways

  val core = new TilelinkVexiiRiscvFiber(param.plugins())
  core.priv match {
    case Some(priv) => new Area {
      val mti, msi, mei, sei = misc.InterruptNode.master()
      mti.flag := False
      msi.flag := False
      mei.flag := False
      sei.flag := False
      priv.mti << mti
      priv.msi << msi
      priv.mei << mei
      priv.sei << sei
    }
  }

  val bus = tilelink.fabric.Node()
  bus << core.buses

  val bus32 = tilelink.fabric.Node().forceDataWidth(32)
  bus32 << bus

  // plic and clint

  core.iBus.setDownConnection { (down, up) =>
    down.a << up.a.halfPipe().halfPipe()
    up.d << down.d.m2sPipe()
  }
  //core.lsuL1Bus.setDownConnection(a = withCoherency.mux(StreamPipe.HALF, StreamPipe.FULL), b = StreamPipe.HALF_KEEP, c = StreamPipe.FULL, d = StreamPipe.M2S_KEEP, e = StreamPipe.HALF)
  core.lsuL1Bus.setDownConnection(a = StreamPipe.HALF, b = StreamPipe.HALF_KEEP, c = StreamPipe.FULL, d = StreamPipe.M2S_KEEP, e = StreamPipe.HALF)
  core.dBus.setDownConnection(a = StreamPipe.HALF, d = StreamPipe.M2S_KEEP)
}
