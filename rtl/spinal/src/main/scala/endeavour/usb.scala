package endeavour

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb.{Apb3, Apb3Config}
import spinal.lib.bus.bmb._
import spinal.lib.com.usb.ohci._
import spinal.lib.com.usb.phy._

import endeavour.interfaces._

class EndeavourUSB extends Component {
  val io = new Bundle {
    val usb1 = USB()
    val usb2 = USB()
    val apb_ctrl = slave(Apb3(Apb3Config(
      addressWidth  = 12,
      dataWidth     = 32,
      useSlaveError = false
    )))
    val apb_dma = slave(Apb3(Apb3Config(
      addressWidth  = 12,
      dataWidth     = 32,
      useSlaveError = false
    )))
    val interrupt = out Bool()
  }

  val ctrl_bmbp = BmbParameter(
    addressWidth = 12,
    dataWidth = 32,
    sourceWidth = 0,
    contextWidth = 0,
    lengthWidth = 2
  )
  val dma_bmbp = BmbParameter(
    addressWidth = 12,
    dataWidth = 32,
    sourceWidth = 0,
    contextWidth = 0,
    lengthWidth = 6
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
  val phy = UsbLsFsPhyModified(ohci_param.portCount)
  val ram = BmbOnChipRamMultiPort(List(dma_bmbp, ctrl_bmbp), 0x1000)

  io.interrupt := ohci.io.interrupt.toIo

  val usb1_tri = phy.io.usb(0).toNativeIo()
  usb1_tri.dp.read := io.usb1.dp
  usb1_tri.dm.read := io.usb1.dn
  when(usb1_tri.dp.writeEnable) { io.usb1.dp := usb1_tri.dp.write }
  when(usb1_tri.dm.writeEnable) { io.usb1.dn := usb1_tri.dm.write }

  val usb2_tri = phy.io.usb(1).toNativeIo()
  usb2_tri.dp.read := io.usb2.dp
  usb2_tri.dm.read := io.usb2.dn
  when(usb2_tri.dp.writeEnable) { io.usb2.dp := usb2_tri.dp.write }
  when(usb2_tri.dm.writeEnable) { io.usb2.dn := usb2_tri.dm.write }

  phy.io.management(0).overcurrent := False
  phy.io.management(1).overcurrent := False
  phy.io.ctrl <> ohci.io.phy

  ram.io.buses(0).rsp <> ohci.io.dma.rsp
  ram.io.buses(0).cmd.valid <> ohci.io.dma.cmd.valid
  ram.io.buses(0).cmd.ready <> ohci.io.dma.cmd.ready
  ram.io.buses(0).cmd.opcode <> ohci.io.dma.cmd.opcode
  ram.io.buses(0).cmd.data <> ohci.io.dma.cmd.data
  ram.io.buses(0).cmd.mask <> ohci.io.dma.cmd.mask
  ram.io.buses(0).cmd.last <> ohci.io.dma.cmd.last
  ram.io.buses(0).cmd.length <> ohci.io.dma.cmd.length
  ram.io.buses(0).cmd.address <> ohci.io.dma.cmd.address(11 downto 0)

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

  apb_to_bmb(io.apb_ctrl, ohci.io.ctrl)
  apb_to_bmb(io.apb_dma, ram.io.buses(1))
}

object EndeavourUSB {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode=Verilog, defaultClockDomainFrequency=FixedFrequency(48 MHz)).generate(new EndeavourUSB)
  }
}
