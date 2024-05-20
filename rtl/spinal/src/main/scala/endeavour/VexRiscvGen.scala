package endeavour

import scala.collection.mutable.ArrayBuffer

import spinal.core._

import vexriscv.plugin._
import vexriscv.{plugin, VexRiscv, VexRiscvConfig}
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.ip.fpu.FpuParameter

class VexRiscvGen(useCache: Boolean, resetVector: BigInt) {
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
      catchIllegalAccess = false,
      mvendorid      = null,
      marchid        = null,
      mimpid         = null,
      mhartid        = null,
      misaExtensionsInit = (1<<8 /*I*/) | (1<<12 /*M*/),
      misaAccess     = CsrAccess.READ_ONLY,
      mtvecAccess    = CsrAccess.WRITE_ONLY,
      mtvecInit      = resetVector,
      mepcAccess     = CsrAccess.NONE,
      mscratchGen    = false,
      mcauseAccess   = CsrAccess.READ_ONLY,
      mbadaddrAccess = CsrAccess.NONE,
      mcycleAccess   = CsrAccess.READ_ONLY,
      minstretAccess = CsrAccess.READ_ONLY,
      ecallGen       = false,
      wfiGenAsWait   = true,
      ucycleAccess   = CsrAccess.READ_ONLY,
      uinstretAccess = CsrAccess.READ_ONLY
    ))
    //new FpuPlugin(p = FpuParameter(withDouble = false)),
    //PMP plugin?
  )
  if (useCache) {
    plugins += new IBusCachedPlugin(
      resetVector = resetVector,
      compressedGen = false,
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
        withLrSc = true,
        asyncTagMemory = true,
        withAmo = true,
        withWriteAggregation = false // TODO try true
      ),
      memoryTranslatorPortConfig = MmuPortConfig(
        portTlbSize = 4
      )
    )
    plugins += new MmuPlugin(
      virtualRange = _(31 downto 30) === 0x3,
      ioRange      = _(31 downto 30) === 0x0
    )
  } else {
    plugins += new IBusSimplePlugin(
      resetVector = resetVector,
      cmdForkOnSecondStage = false,
      cmdForkPersistence = true,
      prediction = NONE,
      catchAccessFault = false,
      compressedGen = false
    )
    plugins += new DBusSimplePlugin
  }

  new VexRiscv(VexRiscvConfig(plugins))
}

