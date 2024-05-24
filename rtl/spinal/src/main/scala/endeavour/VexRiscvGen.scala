package endeavour

import scala.collection.mutable.ArrayBuffer

import spinal.core._

import vexriscv.plugin._
import vexriscv.{plugin, VexRiscv, VexRiscvConfig}
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.ip.fpu.FpuParameter

class VexRiscvGen(useCache: Boolean, compressedGen: Boolean, resetVector: BigInt) {
  val plugins = ArrayBuffer(
    new DecoderSimplePlugin(
      catchIllegalInstruction = true
    ),
    new RegFilePlugin(
      regFileReadyKind = plugin.SYNC,
      zeroBoot = false
    ),
    new IntAluPlugin,
    new SrcPlugin(
      separatedAddSub = false,
      executeInsertion = false,
      decodeAddSub = false
    ),
    new BranchPlugin(
      earlyBranch = false,
      catchAddressMisaligned = false
    ),
    new HazardSimplePlugin(
      bypassExecute           = true,
      bypassMemory            = true,
      bypassWriteBack         = true,
      bypassWriteBackBuffer   = true,
      pessimisticUseSrc       = false,
      pessimisticWriteRegFile = false,
      pessimisticAddressMatch = false
    ),
    new FullBarrelShifterPlugin,
    new MulPlugin(
      inputBuffer = true,
      outputBuffer = true
    ),
    new MulDivIterativePlugin(
      genMul = false,
      genDiv = true,
      mulUnrollFactor = 1,
      divUnrollFactor = 2
    ),
    new CsrPlugin(CsrPluginConfig(
      catchIllegalAccess = true,
      pipelineCsrRead = false,
      mvendorid      = null,
      marchid        = null,
      mimpid         = null,
      mhartid        = null,
      mtvecInit      = resetVector,
      misaExtensionsInit = (1<<8 /*I*/) | (1<<12 /*M*/) | (1<<0 /*A*/) | (1<<2 /*C*/) | (1<<18 /*S*/) | (1<<20 /*U*/),
      misaAccess     = CsrAccess.READ_ONLY,
      medelegAccess  = CsrAccess.READ_WRITE,
      midelegAccess  = CsrAccess.READ_WRITE,
      mtvecAccess    = CsrAccess.READ_WRITE,
      mepcAccess     = CsrAccess.READ_WRITE,
      mcauseAccess   = CsrAccess.READ_WRITE,
      mbadaddrAccess = CsrAccess.READ_WRITE,
      stvecAccess    = CsrAccess.READ_WRITE,
      sepcAccess     = CsrAccess.READ_WRITE,
      scauseAccess   = CsrAccess.READ_WRITE,
      sbadaddrAccess = CsrAccess.READ_WRITE,
      userGen        = true,
      supervisorGen  = true,
      mscratchGen    = true,
      sscratchGen    = true,
      ecallGen       = true,
      ebreakGen      = true,
      wfiGenAsWait   = true,
      mcycleAccess   = CsrAccess.READ_ONLY,
      minstretAccess = CsrAccess.READ_ONLY,
      scycleAccess   = CsrAccess.READ_ONLY,
      sinstretAccess = CsrAccess.READ_ONLY,
      ucycleAccess   = CsrAccess.READ_ONLY,
      uinstretAccess = CsrAccess.READ_ONLY,
      utimeAccess    = CsrAccess.READ_ONLY
    ))
    //new FpuPlugin(p = FpuParameter(withDouble = false)),
  )
  if (useCache) {
    plugins += new IBusCachedPlugin(
      resetVector = resetVector,
      compressedGen = compressedGen,
      injectorStage = compressedGen,
      relaxedPcCalculation = compressedGen,
      prediction = STATIC,
      config = InstructionCacheConfig(
        cacheSize = 4096,
        bytePerLine = 32,
        wayCount = 1,
        addressWidth = 32,
        cpuDataWidth = 32,
        memDataWidth = 32,
        catchIllegalAccess = true,
        catchAccessFault = true,
        asyncTagMemory = true,
        twoCycleRam = false,
        twoCycleCache = true
      ),
      memoryTranslatorPortConfig = MmuPortConfig(
        portTlbSize = 4
      )
    )
    plugins += new DBusCachedPlugin(
      dBusCmdMasterPipe = true,
      dBusCmdSlavePipe = true,
      dBusRspSlavePipe = true,
      config = new DataCacheConfig(
        cacheSize         = 4096,
        bytePerLine       = 32,
        wayCount          = 1,
        addressWidth      = 32,
        cpuDataWidth      = 32,
        memDataWidth      = 32,
        catchAccessError  = true,
        catchIllegal      = true,
        catchUnaligned    = true,
        withLrSc          = true,
        asyncTagMemory    = true,
        withAmo           = true,
        withWriteAggregation = false // TODO try true
      ),
      memoryTranslatorPortConfig = MmuPortConfig(
        portTlbSize = 4
      )
    )
    plugins += new MmuPlugin(ioRange = _(31 downto 30) === 0x0)
  } else {
    plugins += new IBusSimplePlugin(
      resetVector = resetVector,
      cmdForkOnSecondStage = false,
      cmdForkPersistence = true,
      prediction = NONE,
      catchAccessFault = false,
      compressedGen = compressedGen
    )
    plugins += new DBusSimplePlugin
  }

  new VexRiscv(VexRiscvConfig(plugins))
}

