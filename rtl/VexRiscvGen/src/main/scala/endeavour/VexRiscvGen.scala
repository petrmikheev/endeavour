package endeavour

import vexriscv.plugin._
import vexriscv.{plugin, VexRiscv, VexRiscvConfig}
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.ip.fpu.FpuParameter

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.misc.SizeMapping

class VexRiscvWithCrossbar extends Component{

  val ioBaseAddr = 0x100000
  val ioSize = 1024

  val internalRamBaseAddr = 0x40000000L
  val internalRamSize = 16 * 1024

  val externalRamBaseAddr = 0x80000000L
  val externalRamSize = 0x10000000L // 256 MB

  val io = new Bundle{
    val axi4_ram = master(Axi4Shared(Axi4Config(
      addressWidth = log2Up(externalRamSize),
      dataWidth = 32,
      idWidth = 1,
      useResp = false,
      useLock = false,
      useRegion = false,
      useCache = false,
      useProt = false,
      useQos = false
    )))
    val apb3 = master(Apb3(Apb3Config(
      addressWidth = log2Up(ioSize),
      dataWidth = 32
    )))
  }

  val cpuPlugins = List(
    /*new IBusSimplePlugin(
      resetVector = internalRamBaseAddr,
      cmdForkOnSecondStage = false,
      cmdForkPersistence = true,
      prediction = NONE,
      catchAccessFault = false,
      compressedGen = false
    ),*/
    new IBusCachedPlugin(
      resetVector = internalRamBaseAddr,
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
    ),
    //new DBusSimplePlugin,
    new DBusCachedPlugin(
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
        withWriteAggregation = false
      ),
      memoryTranslatorPortConfig = MmuPortConfig(
        portTlbSize = 4
      )
    ),
    new MmuPlugin(
      virtualRange = _(31 downto 30) === 0x3,
      ioRange      = _(31 downto 30) === 0x0
    ),
    new CsrPlugin(CsrPluginConfig(
      catchIllegalAccess = false,
      mvendorid      = null,
      marchid        = null,
      mimpid         = null,
      mhartid        = null,
      misaExtensionsInit = 0,  // TODO
      misaAccess     = CsrAccess.READ_WRITE,
      mtvecAccess    = CsrAccess.WRITE_ONLY,
      mtvecInit      = 0x80000020l,
      mepcAccess     = CsrAccess.READ_WRITE,
      mscratchGen    = true,
      mcauseAccess   = CsrAccess.READ_ONLY,
      mbadaddrAccess = CsrAccess.READ_ONLY,
      mcycleAccess   = CsrAccess.NONE,
      minstretAccess = CsrAccess.NONE,
      ecallGen       = true,
      ebreakGen      = true,
      wfiGenAsWait   = false,
      wfiGenAsNop    = true,
      ucycleAccess   = CsrAccess.NONE
    )),
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
    //new LightShifterPlugin,
    new FullBarrelShifterPlugin,
    new MulPlugin,
    new DivPlugin,
    //new FpuPlugin(p = FpuParameter(withDouble = false)),
    //PMP plugin?
    new HazardSimplePlugin(
      bypassExecute           = true,
      bypassMemory            = true,
      bypassWriteBack         = true,
      bypassWriteBackBuffer   = true,
      pessimisticUseSrc       = false,
      pessimisticWriteRegFile = false,
      pessimisticAddressMatch = false
    ),
    new BranchPlugin(
      earlyBranch = false,
      catchAddressMisaligned = false
    )
  )

  val cpu = new VexRiscv(VexRiscvConfig(cpuPlugins))
  var iBus : Axi4ReadOnly = null
  var dBus : Axi4Shared = null
  val timerInterrupt = False // TODO
  val externalInterrupt = False // TODO
  for(plugin <- cpu.plugins) plugin match{
    case plugin : IBusSimplePlugin => iBus = plugin.iBus.toAxi4ReadOnly()
    case plugin : IBusCachedPlugin => iBus = plugin.iBus.toAxi4ReadOnly()
    case plugin : DBusSimplePlugin => dBus = plugin.dBus.toAxi4Shared()
    case plugin : DBusCachedPlugin => dBus = plugin.dBus.toAxi4Shared(true)
    case plugin : CsrPlugin        => {
      plugin.externalInterrupt := externalInterrupt
      plugin.timerInterrupt := timerInterrupt
    }
    case _ =>
  }

  val internalRam = Axi4SharedOnChipRam(
    dataWidth = 32,
    byteCount = internalRamSize,
    idWidth = 1
  )
  internalRam.ram.generateAsBlackBox()

  val apbBridge = Axi4SharedToApb3Bridge(
    dataWidth = 32,
    addressWidth = log2Up(ioSize),
    idWidth = 1
  )
  io.apb3 <> apbBridge.io.apb

  val axiCrossbar = Axi4CrossbarFactory()
  axiCrossbar.addSlaves(
    apbBridge.io.axi -> SizeMapping(ioBaseAddr, ioSize),
    internalRam.io.axi -> SizeMapping(internalRamBaseAddr, internalRamSize),
    io.axi4_ram      -> SizeMapping(externalRamBaseAddr, externalRamSize)
  )
  axiCrossbar.addConnections(
    iBus -> List(io.axi4_ram, internalRam.io.axi),
    dBus -> List(io.axi4_ram, internalRam.io.axi, apbBridge.io.axi)
  )
  /*axiCrossbar.addPipelining(apbBridge.io.axi)((crossbar, bridge) => {
    crossbar.sharedCmd.halfPipe() >> bridge.sharedCmd
    crossbar.writeData.halfPipe() >> bridge.writeData
    crossbar.writeRsp             << bridge.writeRsp
    crossbar.readRsp              << bridge.readRsp
  })
  axiCrossbar.addPipelining(internalRam.io.axi)((crossbar, ctrl) => {
    crossbar.sharedCmd.halfPipe()  >>  ctrl.sharedCmd
    crossbar.writeData            >/-> ctrl.writeData
    crossbar.writeRsp              <<  ctrl.writeRsp
    crossbar.readRsp               <<  ctrl.readRsp
  })
  axiCrossbar.addPipelining(dBus)((cpu, crossbar) => {
    cpu.sharedCmd >>  crossbar.sharedCmd
    cpu.writeData >>  crossbar.writeData
    cpu.writeRsp  <<  crossbar.writeRsp
    cpu.readRsp   <-< crossbar.readRsp
  })*/
  /*axiCrossbar.addPipelining(io.axi4_ram)((crossbar, ctrl) => {
    crossbar.sharedCmd.halfPipe()  >>  ctrl.sharedCmd
    crossbar.writeData            >/-> ctrl.writeData
    crossbar.writeRsp              <<  ctrl.writeRsp
    crossbar.readRsp               <<  ctrl.readRsp
  })*/
  axiCrossbar.build()
}

object VexRiscvGen{
  def main(args: Array[String]): Unit = SpinalVerilog(new VexRiscvWithCrossbar())
}

