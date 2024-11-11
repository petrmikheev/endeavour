// Instance of https://github.com/ultraembedded/core_usb_cdc

module DummyUsbDevice(input clk, inout usb_dp, inout usb_dn);

  pullup(usb_dp);
  pulldown(usb_dn);

  reg reset = 1;
  initial begin #100; reset = 0; end

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

  usb_cdc_core usb_device(
    .clk_i(clk),
    .rst_i(reset),
    .enable_i(1'b1),
    .inport_valid_i(1'b0),
    .inport_data_i(8'b0),
    .outport_accept_i(1'b1),

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
