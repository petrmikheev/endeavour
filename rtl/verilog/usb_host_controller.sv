module USBHostController(
  input reset, input clk,

  inout         usb_dp,
  inout         usb_dn,

  input   [5:0] apb_PADDR,
  input         apb_PSEL,
  input         apb_PENABLE,
  output        apb_PREADY,
  input         apb_PWRITE,
  input  [31:0] apb_PWDATA,
  output [31:0] apb_PRDATA,

  output        interrupt
);

  wire       usb_pads_rx_rcv_w;
  wire       usb_pads_rx_dn_w;
  wire       usb_pads_rx_dp_w;
  wire       usb_pads_tx_dn_w;
  wire       usb_pads_tx_dp_w;
  wire       usb_pads_tx_oen_w;

  wire [7:0] utmi_data_out;
  wire       utmi_txvalid;
  wire [1:0] utmi_op_mode;
  wire [1:0] utmi_xcvrselect;
  wire       utmi_termselect;
  wire       utmi_dppulldown;
  wire       utmi_dmpulldown;
  wire [7:0] utmi_data_in;
  wire       utmi_txready;
  wire       utmi_rxvalid;
  wire       utmi_rxactive;
  wire       utmi_rxerror;
  wire [1:0] utmi_linestate;

  usb_transceiver u_usb_xcvr
  (
      // Inputs
      .usb_phy_tx_dp_i(usb_pads_tx_dp_w),
      .usb_phy_tx_dn_i(usb_pads_tx_dn_w),
      .usb_phy_tx_oen_i(usb_pads_tx_oen_w),
      .mode_i(1'b1),

      // Outputs
      .usb_dp_io(usb_dp),
      .usb_dn_io(usb_dn),
      .usb_phy_rx_rcv_o(usb_pads_rx_rcv_w),
      .usb_phy_rx_dp_o(usb_pads_rx_dp_w),
      .usb_phy_rx_dn_o(usb_pads_rx_dn_w)
  );

  usb_fs_phy u_usb_phy
  (
      // Inputs
      .clk_i(clk),
      .rst_i(reset),
      .utmi_data_out_i(utmi_data_out),
      .utmi_txvalid_i(utmi_txvalid),
      .utmi_op_mode_i(utmi_op_mode),
      .utmi_xcvrselect_i(utmi_xcvrselect),
      .utmi_termselect_i(utmi_termselect),
      .utmi_dppulldown_i(utmi_dppulldown),
      .utmi_dmpulldown_i(utmi_dmpulldown),
      .usb_rx_rcv_i(usb_pads_rx_rcv_w),
      .usb_rx_dp_i(usb_pads_rx_dp_w),
      .usb_rx_dn_i(usb_pads_rx_dn_w),
      .usb_reset_assert_i(1'b0),

      // Outputs
      .utmi_data_in_o(utmi_data_in),
      .utmi_txready_o(utmi_txready),
      .utmi_rxvalid_o(utmi_rxvalid),
      .utmi_rxactive_o(utmi_rxactive),
      .utmi_rxerror_o(utmi_rxerror),
      .utmi_linestate_o(utmi_linestate),
      .usb_tx_dp_o(usb_pads_tx_dp_w),
      .usb_tx_dn_o(usb_pads_tx_dn_w),
      .usb_tx_oen_o(usb_pads_tx_oen_w),
      .usb_reset_detect_o(),
      .usb_en_o()
  );

  reg arw_done;
  wire cfg_awready, cfg_arready, cfg_wready, cfg_rvalid;
  assign apb_PREADY = apb_PWRITE ? cfg_wready : cfg_rvalid;

  always @(posedge clk) begin
    if (reset)
      arw_done <= 0;
    else begin
      if (~apb_PSEL)
        arw_done <= 0;
      else if (apb_PWRITE ? cfg_awready : cfg_arready)
        arw_done <= 1;
    end
  end

  usbh_host ctrl(
    .clk_i(clk),
    .rst_i(reset),

    .intr_o(interrupt),

    .cfg_araddr_i({26'b0, apb_PADDR}),
    .cfg_awaddr_i({26'b0, apb_PADDR}),
    .cfg_wdata_i(apb_PWDATA),
    .cfg_rdata_o(apb_PRDATA),
    .cfg_wstrb_i(4'b0),
    .cfg_bready_i(1'b1),
    .cfg_bresp_o(),
    .cfg_bvalid_o(),
    .cfg_rresp_o(),
    .cfg_arvalid_i(apb_PSEL & ~arw_done & ~apb_PWRITE),
    .cfg_awvalid_i(apb_PSEL & ~arw_done & apb_PWRITE),
    .cfg_awready_o(cfg_awready),
    .cfg_arready_o(cfg_arready),
    .cfg_wvalid_i(apb_PSEL & apb_PENABLE & apb_PWRITE),
    .cfg_rready_i(apb_PSEL & apb_PENABLE),
    .cfg_wready_o(cfg_wready),
    .cfg_rvalid_o(cfg_rvalid),

    .utmi_data_in_i(utmi_data_in),
    .utmi_txready_i(utmi_txready),
    .utmi_rxvalid_i(utmi_rxvalid),
    .utmi_rxactive_i(utmi_rxactive),
    .utmi_rxerror_i(utmi_rxerror),
    .utmi_linestate_i(utmi_linestate),
    .utmi_data_out_o(utmi_data_out),
    .utmi_txvalid_o(utmi_txvalid),
    .utmi_op_mode_o(utmi_op_mode),
    .utmi_xcvrselect_o(utmi_xcvrselect),
    .utmi_termselect_o(utmi_termselect),
    .utmi_dppulldown_o(utmi_dppulldown),
    .utmi_dmpulldown_o(utmi_dmpulldown)
  );

endmodule
