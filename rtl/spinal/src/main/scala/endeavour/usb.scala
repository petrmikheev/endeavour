package endeavour

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.{Apb3, Apb3Config}
import spinal.lib.bus.bmb._
import spinal.lib.bus.tilelink
import spinal.lib.com.usb.ohci._
import spinal.lib.com.usb.phy._

import endeavour.interfaces._

class EndeavourUSB(phyCd: ClockDomain, usb1: USB, usb2: USB) extends Area {
  val apb_ctrl = Apb3(Apb3Config(
    addressWidth  = 12,
    dataWidth     = 32,
    useSlaveError = false
  ))
  val dma = tilelink.fabric.Node.down()

  val ctrl_bmbp = BmbParameter(
    addressWidth = 12,
    dataWidth = 32,
    sourceWidth = 0,
    contextWidth = 0,
    lengthWidth = 2
  )

  val ohci_param = UsbOhciParameter(
    noPowerSwitching = true,
    powerSwitchingMode = true,
    noOverCurrentProtection = true,
    powerOnToPowerGoodTime = 10,
    dataWidth = 32,
    portsConfig = List.fill(2)(OhciPortParameter())
  )

  val ohci = UsbOhci(ohci_param, ctrl_bmbp)
  val phy = phyCd(UsbLsFsPhy(ohci_param.portCount))

  val phyCc = UsbHubLsFs.CtrlCc(ohci_param.portCount, ClockDomain.current, phyCd)
  phyCc.input <> ohci.io.phy
  phyCc.output <> phy.io.ctrl

  val dmaBridge = new BmbToTilelink(ohci.io.dma.p)
  dmaBridge.io.up << ohci.io.dma

  fiber.Handle {
    dma.m2s.forceParameters(BmbToTilelink.getTilelinkM2s(ohci.io.dma.p.access, EndeavourUSB.this))
    dma.s2m.supported.load(tilelink.S2mSupport.none())
    dma.bus << dmaBridge.io.down
  }

  val interrupt = ohci.io.interrupt

  val usb1_tri = phy.io.usb(0).toNativeIo()
  usb1_tri.dp.read := usb1.dp
  usb1_tri.dm.read := usb1.dn
  when(usb1_tri.dp.writeEnable) { usb1.dp := usb1_tri.dp.write }
  when(usb1_tri.dm.writeEnable) { usb1.dn := usb1_tri.dm.write }

  val usb2_tri = phy.io.usb(1).toNativeIo()
  usb2_tri.dp.read := usb2.dp
  usb2_tri.dm.read := usb2.dn
  when(usb2_tri.dp.writeEnable) { usb2.dp := usb2_tri.dp.write }
  when(usb2_tri.dm.writeEnable) { usb2.dn := usb2_tri.dm.write }

  phy.io.management(0).overcurrent := False
  phy.io.management(1).overcurrent := False

  val apb_to_bmb = (apb: Apb3, bmb: Bmb) => {
    bmb.cmd.address := apb.PADDR
    bmb.cmd.opcode := B(apb.PWRITE)
    bmb.cmd.data := apb.PWDATA
    bmb.cmd.length := U(3, 2 bits)
    bmb.cmd.mask := B(0xf, 4 bits)
    bmb.cmd.last := True
    bmb.rsp.ready := True
    apb.PRDATA := bmb.rsp.data
    apb.PREADY := bmb.rsp.valid
    val apb_valid = apb.PSEL.asBool & apb.PENABLE
    val cmd_sent = RegInit(False) setWhen(bmb.cmd.valid & bmb.cmd.ready) fallWhen(~apb_valid)
    bmb.cmd.valid := apb_valid & ~cmd_sent
  }

  apb_to_bmb(apb_ctrl, ohci.io.ctrl)
}
