// Generator : SpinalHDL v1.10.1    git head : 2527c7c6b0fb0f95e5e1a5722a0be732b364ce43
// Component : UsbOhciTop
// Git hash  : 1ec2f65de6b1815a5dd8a59441e2acc310d030d8

`timescale 1ns/1ps

module UsbOhciTop (
  output wire          irq,
  input  wire          ctrl_cmd_valid,
  output wire          ctrl_cmd_ready,
  input  wire          ctrl_cmd_payload_last,
  input  wire [0:0]    ctrl_cmd_payload_fragment_opcode,
  input  wire [11:0]   ctrl_cmd_payload_fragment_address,
  input  wire [1:0]    ctrl_cmd_payload_fragment_length,
  input  wire [31:0]   ctrl_cmd_payload_fragment_data,
  input  wire [3:0]    ctrl_cmd_payload_fragment_mask,
  output wire          ctrl_rsp_valid,
  input  wire          ctrl_rsp_ready,
  output wire          ctrl_rsp_payload_last,
  output wire [0:0]    ctrl_rsp_payload_fragment_opcode,
  output wire [31:0]   ctrl_rsp_payload_fragment_data,
  output wire          dma_cmd_valid,
  input  wire          dma_cmd_ready,
  output wire          dma_cmd_payload_last,
  output wire [0:0]    dma_cmd_payload_fragment_opcode,
  output wire [31:0]   dma_cmd_payload_fragment_address,
  output wire [5:0]    dma_cmd_payload_fragment_length,
  output wire [63:0]   dma_cmd_payload_fragment_data,
  output wire [7:0]    dma_cmd_payload_fragment_mask,
  input  wire          dma_rsp_valid,
  output wire          dma_rsp_ready,
  input  wire          dma_rsp_payload_last,
  input  wire [0:0]    dma_rsp_payload_fragment_opcode,
  input  wire [63:0]   dma_rsp_payload_fragment_data,
  output wire          usb_0_tx_enable,
  output wire          usb_0_tx_data,
  output wire          usb_0_tx_se0,
  input  wire          usb_0_rx_dp,
  input  wire          usb_0_rx_dm,
  output wire          usb_1_tx_enable,
  output wire          usb_1_tx_data,
  output wire          usb_1_tx_se0,
  input  wire          usb_1_rx_dp,
  input  wire          usb_1_rx_dm,
  output wire          usb_2_tx_enable,
  output wire          usb_2_tx_data,
  output wire          usb_2_tx_se0,
  input  wire          usb_2_rx_dp,
  input  wire          usb_2_rx_dm,
  output wire          usb_3_tx_enable,
  output wire          usb_3_tx_data,
  output wire          usb_3_tx_se0,
  input  wire          usb_3_rx_dp,
  input  wire          usb_3_rx_dm,
  input  wire          management_0_overcurrent,
  output wire          management_0_power,
  input  wire          management_1_overcurrent,
  output wire          management_1_power,
  input  wire          management_2_overcurrent,
  output wire          management_2_power,
  input  wire          management_3_overcurrent,
  output wire          management_3_power,
  input  wire          clk,
  input  wire          reset,
  input  wire          phyCd_clk,
  input  wire          phyCd_reset
);

  wire                ohci_io_ctrl_cmd_ready;
  wire                ohci_io_ctrl_rsp_valid;
  wire                ohci_io_ctrl_rsp_payload_last;
  wire       [0:0]    ohci_io_ctrl_rsp_payload_fragment_opcode;
  wire       [31:0]   ohci_io_ctrl_rsp_payload_fragment_data;
  wire                ohci_io_phy_lowSpeed;
  wire                ohci_io_phy_usbReset;
  wire                ohci_io_phy_usbResume;
  wire                ohci_io_phy_tx_valid;
  wire                ohci_io_phy_tx_payload_last;
  wire       [7:0]    ohci_io_phy_tx_payload_fragment;
  wire                ohci_io_phy_ports_0_removable;
  wire                ohci_io_phy_ports_0_power;
  wire                ohci_io_phy_ports_0_reset_valid;
  wire                ohci_io_phy_ports_0_suspend_valid;
  wire                ohci_io_phy_ports_0_resume_valid;
  wire                ohci_io_phy_ports_0_disable_valid;
  wire                ohci_io_phy_ports_1_removable;
  wire                ohci_io_phy_ports_1_power;
  wire                ohci_io_phy_ports_1_reset_valid;
  wire                ohci_io_phy_ports_1_suspend_valid;
  wire                ohci_io_phy_ports_1_resume_valid;
  wire                ohci_io_phy_ports_1_disable_valid;
  wire                ohci_io_phy_ports_2_removable;
  wire                ohci_io_phy_ports_2_power;
  wire                ohci_io_phy_ports_2_reset_valid;
  wire                ohci_io_phy_ports_2_suspend_valid;
  wire                ohci_io_phy_ports_2_resume_valid;
  wire                ohci_io_phy_ports_2_disable_valid;
  wire                ohci_io_phy_ports_3_removable;
  wire                ohci_io_phy_ports_3_power;
  wire                ohci_io_phy_ports_3_reset_valid;
  wire                ohci_io_phy_ports_3_suspend_valid;
  wire                ohci_io_phy_ports_3_resume_valid;
  wire                ohci_io_phy_ports_3_disable_valid;
  wire                ohci_io_dma_cmd_valid;
  wire                ohci_io_dma_cmd_payload_last;
  wire       [0:0]    ohci_io_dma_cmd_payload_fragment_opcode;
  wire       [31:0]   ohci_io_dma_cmd_payload_fragment_address;
  wire       [5:0]    ohci_io_dma_cmd_payload_fragment_length;
  wire       [63:0]   ohci_io_dma_cmd_payload_fragment_data;
  wire       [7:0]    ohci_io_dma_cmd_payload_fragment_mask;
  wire                ohci_io_dma_rsp_ready;
  wire                ohci_io_interrupt;
  wire                ohci_io_interruptBios;
  wire                phy_io_ctrl_overcurrent;
  wire                phy_io_ctrl_tick;
  wire                phy_io_ctrl_tx_ready;
  wire                phy_io_ctrl_txEop;
  wire                phy_io_ctrl_rx_flow_valid;
  wire                phy_io_ctrl_rx_flow_payload_stuffingError;
  wire       [7:0]    phy_io_ctrl_rx_flow_payload_data;
  wire                phy_io_ctrl_rx_active;
  wire                phy_io_ctrl_ports_0_reset_ready;
  wire                phy_io_ctrl_ports_0_suspend_ready;
  wire                phy_io_ctrl_ports_0_resume_ready;
  wire                phy_io_ctrl_ports_0_disable_ready;
  wire                phy_io_ctrl_ports_0_connect;
  wire                phy_io_ctrl_ports_0_disconnect;
  wire                phy_io_ctrl_ports_0_overcurrent;
  wire                phy_io_ctrl_ports_0_lowSpeed;
  wire                phy_io_ctrl_ports_0_remoteResume;
  wire                phy_io_ctrl_ports_1_reset_ready;
  wire                phy_io_ctrl_ports_1_suspend_ready;
  wire                phy_io_ctrl_ports_1_resume_ready;
  wire                phy_io_ctrl_ports_1_disable_ready;
  wire                phy_io_ctrl_ports_1_connect;
  wire                phy_io_ctrl_ports_1_disconnect;
  wire                phy_io_ctrl_ports_1_overcurrent;
  wire                phy_io_ctrl_ports_1_lowSpeed;
  wire                phy_io_ctrl_ports_1_remoteResume;
  wire                phy_io_ctrl_ports_2_reset_ready;
  wire                phy_io_ctrl_ports_2_suspend_ready;
  wire                phy_io_ctrl_ports_2_resume_ready;
  wire                phy_io_ctrl_ports_2_disable_ready;
  wire                phy_io_ctrl_ports_2_connect;
  wire                phy_io_ctrl_ports_2_disconnect;
  wire                phy_io_ctrl_ports_2_overcurrent;
  wire                phy_io_ctrl_ports_2_lowSpeed;
  wire                phy_io_ctrl_ports_2_remoteResume;
  wire                phy_io_ctrl_ports_3_reset_ready;
  wire                phy_io_ctrl_ports_3_suspend_ready;
  wire                phy_io_ctrl_ports_3_resume_ready;
  wire                phy_io_ctrl_ports_3_disable_ready;
  wire                phy_io_ctrl_ports_3_connect;
  wire                phy_io_ctrl_ports_3_disconnect;
  wire                phy_io_ctrl_ports_3_overcurrent;
  wire                phy_io_ctrl_ports_3_lowSpeed;
  wire                phy_io_ctrl_ports_3_remoteResume;
  wire                phy_io_usb_0_tx_enable;
  wire                phy_io_usb_0_tx_data;
  wire                phy_io_usb_0_tx_se0;
  wire                phy_io_usb_1_tx_enable;
  wire                phy_io_usb_1_tx_data;
  wire                phy_io_usb_1_tx_se0;
  wire                phy_io_usb_2_tx_enable;
  wire                phy_io_usb_2_tx_data;
  wire                phy_io_usb_2_tx_se0;
  wire                phy_io_usb_3_tx_enable;
  wire                phy_io_usb_3_tx_data;
  wire                phy_io_usb_3_tx_se0;
  wire                phy_io_management_0_power;
  wire                phy_io_management_1_power;
  wire                phy_io_management_2_power;
  wire                phy_io_management_3_power;
  wire                phyCc_input_overcurrent;
  wire                phyCc_input_tick;
  wire                phyCc_input_tx_ready;
  wire                phyCc_input_txEop;
  wire                phyCc_input_rx_flow_valid;
  wire                phyCc_input_rx_flow_payload_stuffingError;
  wire       [7:0]    phyCc_input_rx_flow_payload_data;
  wire                phyCc_input_rx_active;
  wire                phyCc_input_ports_0_reset_ready;
  wire                phyCc_input_ports_0_suspend_ready;
  wire                phyCc_input_ports_0_resume_ready;
  wire                phyCc_input_ports_0_disable_ready;
  wire                phyCc_input_ports_0_connect;
  wire                phyCc_input_ports_0_disconnect;
  wire                phyCc_input_ports_0_overcurrent;
  wire                phyCc_input_ports_0_lowSpeed;
  wire                phyCc_input_ports_0_remoteResume;
  wire                phyCc_input_ports_1_reset_ready;
  wire                phyCc_input_ports_1_suspend_ready;
  wire                phyCc_input_ports_1_resume_ready;
  wire                phyCc_input_ports_1_disable_ready;
  wire                phyCc_input_ports_1_connect;
  wire                phyCc_input_ports_1_disconnect;
  wire                phyCc_input_ports_1_overcurrent;
  wire                phyCc_input_ports_1_lowSpeed;
  wire                phyCc_input_ports_1_remoteResume;
  wire                phyCc_input_ports_2_reset_ready;
  wire                phyCc_input_ports_2_suspend_ready;
  wire                phyCc_input_ports_2_resume_ready;
  wire                phyCc_input_ports_2_disable_ready;
  wire                phyCc_input_ports_2_connect;
  wire                phyCc_input_ports_2_disconnect;
  wire                phyCc_input_ports_2_overcurrent;
  wire                phyCc_input_ports_2_lowSpeed;
  wire                phyCc_input_ports_2_remoteResume;
  wire                phyCc_input_ports_3_reset_ready;
  wire                phyCc_input_ports_3_suspend_ready;
  wire                phyCc_input_ports_3_resume_ready;
  wire                phyCc_input_ports_3_disable_ready;
  wire                phyCc_input_ports_3_connect;
  wire                phyCc_input_ports_3_disconnect;
  wire                phyCc_input_ports_3_overcurrent;
  wire                phyCc_input_ports_3_lowSpeed;
  wire                phyCc_input_ports_3_remoteResume;
  wire                phyCc_output_lowSpeed;
  wire                phyCc_output_usbReset;
  wire                phyCc_output_usbResume;
  wire                phyCc_output_tx_valid;
  wire                phyCc_output_tx_payload_last;
  wire       [7:0]    phyCc_output_tx_payload_fragment;
  wire                phyCc_output_ports_0_removable;
  wire                phyCc_output_ports_0_power;
  wire                phyCc_output_ports_0_reset_valid;
  wire                phyCc_output_ports_0_suspend_valid;
  wire                phyCc_output_ports_0_resume_valid;
  wire                phyCc_output_ports_0_disable_valid;
  wire                phyCc_output_ports_1_removable;
  wire                phyCc_output_ports_1_power;
  wire                phyCc_output_ports_1_reset_valid;
  wire                phyCc_output_ports_1_suspend_valid;
  wire                phyCc_output_ports_1_resume_valid;
  wire                phyCc_output_ports_1_disable_valid;
  wire                phyCc_output_ports_2_removable;
  wire                phyCc_output_ports_2_power;
  wire                phyCc_output_ports_2_reset_valid;
  wire                phyCc_output_ports_2_suspend_valid;
  wire                phyCc_output_ports_2_resume_valid;
  wire                phyCc_output_ports_2_disable_valid;
  wire                phyCc_output_ports_3_removable;
  wire                phyCc_output_ports_3_power;
  wire                phyCc_output_ports_3_reset_valid;
  wire                phyCc_output_ports_3_suspend_valid;
  wire                phyCc_output_ports_3_resume_valid;
  wire                phyCc_output_ports_3_disable_valid;

  UsbOhci ohci (
    .io_ctrl_cmd_valid                    (ctrl_cmd_valid                                ), //i
    .io_ctrl_cmd_ready                    (ohci_io_ctrl_cmd_ready                        ), //o
    .io_ctrl_cmd_payload_last             (ctrl_cmd_payload_last                         ), //i
    .io_ctrl_cmd_payload_fragment_opcode  (ctrl_cmd_payload_fragment_opcode              ), //i
    .io_ctrl_cmd_payload_fragment_address (ctrl_cmd_payload_fragment_address[11:0]       ), //i
    .io_ctrl_cmd_payload_fragment_length  (ctrl_cmd_payload_fragment_length[1:0]         ), //i
    .io_ctrl_cmd_payload_fragment_data    (ctrl_cmd_payload_fragment_data[31:0]          ), //i
    .io_ctrl_cmd_payload_fragment_mask    (ctrl_cmd_payload_fragment_mask[3:0]           ), //i
    .io_ctrl_rsp_valid                    (ohci_io_ctrl_rsp_valid                        ), //o
    .io_ctrl_rsp_ready                    (ctrl_rsp_ready                                ), //i
    .io_ctrl_rsp_payload_last             (ohci_io_ctrl_rsp_payload_last                 ), //o
    .io_ctrl_rsp_payload_fragment_opcode  (ohci_io_ctrl_rsp_payload_fragment_opcode      ), //o
    .io_ctrl_rsp_payload_fragment_data    (ohci_io_ctrl_rsp_payload_fragment_data[31:0]  ), //o
    .io_phy_lowSpeed                      (ohci_io_phy_lowSpeed                          ), //o
    .io_phy_tx_valid                      (ohci_io_phy_tx_valid                          ), //o
    .io_phy_tx_ready                      (phyCc_input_tx_ready                          ), //i
    .io_phy_tx_payload_last               (ohci_io_phy_tx_payload_last                   ), //o
    .io_phy_tx_payload_fragment           (ohci_io_phy_tx_payload_fragment[7:0]          ), //o
    .io_phy_txEop                         (phyCc_input_txEop                             ), //i
    .io_phy_rx_flow_valid                 (phyCc_input_rx_flow_valid                     ), //i
    .io_phy_rx_flow_payload_stuffingError (phyCc_input_rx_flow_payload_stuffingError     ), //i
    .io_phy_rx_flow_payload_data          (phyCc_input_rx_flow_payload_data[7:0]         ), //i
    .io_phy_rx_active                     (phyCc_input_rx_active                         ), //i
    .io_phy_usbReset                      (ohci_io_phy_usbReset                          ), //o
    .io_phy_usbResume                     (ohci_io_phy_usbResume                         ), //o
    .io_phy_overcurrent                   (phyCc_input_overcurrent                       ), //i
    .io_phy_tick                          (phyCc_input_tick                              ), //i
    .io_phy_ports_0_disable_valid         (ohci_io_phy_ports_0_disable_valid             ), //o
    .io_phy_ports_0_disable_ready         (phyCc_input_ports_0_disable_ready             ), //i
    .io_phy_ports_0_removable             (ohci_io_phy_ports_0_removable                 ), //o
    .io_phy_ports_0_power                 (ohci_io_phy_ports_0_power                     ), //o
    .io_phy_ports_0_reset_valid           (ohci_io_phy_ports_0_reset_valid               ), //o
    .io_phy_ports_0_reset_ready           (phyCc_input_ports_0_reset_ready               ), //i
    .io_phy_ports_0_suspend_valid         (ohci_io_phy_ports_0_suspend_valid             ), //o
    .io_phy_ports_0_suspend_ready         (phyCc_input_ports_0_suspend_ready             ), //i
    .io_phy_ports_0_resume_valid          (ohci_io_phy_ports_0_resume_valid              ), //o
    .io_phy_ports_0_resume_ready          (phyCc_input_ports_0_resume_ready              ), //i
    .io_phy_ports_0_connect               (phyCc_input_ports_0_connect                   ), //i
    .io_phy_ports_0_disconnect            (phyCc_input_ports_0_disconnect                ), //i
    .io_phy_ports_0_overcurrent           (phyCc_input_ports_0_overcurrent               ), //i
    .io_phy_ports_0_remoteResume          (phyCc_input_ports_0_remoteResume              ), //i
    .io_phy_ports_0_lowSpeed              (phyCc_input_ports_0_lowSpeed                  ), //i
    .io_phy_ports_1_disable_valid         (ohci_io_phy_ports_1_disable_valid             ), //o
    .io_phy_ports_1_disable_ready         (phyCc_input_ports_1_disable_ready             ), //i
    .io_phy_ports_1_removable             (ohci_io_phy_ports_1_removable                 ), //o
    .io_phy_ports_1_power                 (ohci_io_phy_ports_1_power                     ), //o
    .io_phy_ports_1_reset_valid           (ohci_io_phy_ports_1_reset_valid               ), //o
    .io_phy_ports_1_reset_ready           (phyCc_input_ports_1_reset_ready               ), //i
    .io_phy_ports_1_suspend_valid         (ohci_io_phy_ports_1_suspend_valid             ), //o
    .io_phy_ports_1_suspend_ready         (phyCc_input_ports_1_suspend_ready             ), //i
    .io_phy_ports_1_resume_valid          (ohci_io_phy_ports_1_resume_valid              ), //o
    .io_phy_ports_1_resume_ready          (phyCc_input_ports_1_resume_ready              ), //i
    .io_phy_ports_1_connect               (phyCc_input_ports_1_connect                   ), //i
    .io_phy_ports_1_disconnect            (phyCc_input_ports_1_disconnect                ), //i
    .io_phy_ports_1_overcurrent           (phyCc_input_ports_1_overcurrent               ), //i
    .io_phy_ports_1_remoteResume          (phyCc_input_ports_1_remoteResume              ), //i
    .io_phy_ports_1_lowSpeed              (phyCc_input_ports_1_lowSpeed                  ), //i
    .io_phy_ports_2_disable_valid         (ohci_io_phy_ports_2_disable_valid             ), //o
    .io_phy_ports_2_disable_ready         (phyCc_input_ports_2_disable_ready             ), //i
    .io_phy_ports_2_removable             (ohci_io_phy_ports_2_removable                 ), //o
    .io_phy_ports_2_power                 (ohci_io_phy_ports_2_power                     ), //o
    .io_phy_ports_2_reset_valid           (ohci_io_phy_ports_2_reset_valid               ), //o
    .io_phy_ports_2_reset_ready           (phyCc_input_ports_2_reset_ready               ), //i
    .io_phy_ports_2_suspend_valid         (ohci_io_phy_ports_2_suspend_valid             ), //o
    .io_phy_ports_2_suspend_ready         (phyCc_input_ports_2_suspend_ready             ), //i
    .io_phy_ports_2_resume_valid          (ohci_io_phy_ports_2_resume_valid              ), //o
    .io_phy_ports_2_resume_ready          (phyCc_input_ports_2_resume_ready              ), //i
    .io_phy_ports_2_connect               (phyCc_input_ports_2_connect                   ), //i
    .io_phy_ports_2_disconnect            (phyCc_input_ports_2_disconnect                ), //i
    .io_phy_ports_2_overcurrent           (phyCc_input_ports_2_overcurrent               ), //i
    .io_phy_ports_2_remoteResume          (phyCc_input_ports_2_remoteResume              ), //i
    .io_phy_ports_2_lowSpeed              (phyCc_input_ports_2_lowSpeed                  ), //i
    .io_phy_ports_3_disable_valid         (ohci_io_phy_ports_3_disable_valid             ), //o
    .io_phy_ports_3_disable_ready         (phyCc_input_ports_3_disable_ready             ), //i
    .io_phy_ports_3_removable             (ohci_io_phy_ports_3_removable                 ), //o
    .io_phy_ports_3_power                 (ohci_io_phy_ports_3_power                     ), //o
    .io_phy_ports_3_reset_valid           (ohci_io_phy_ports_3_reset_valid               ), //o
    .io_phy_ports_3_reset_ready           (phyCc_input_ports_3_reset_ready               ), //i
    .io_phy_ports_3_suspend_valid         (ohci_io_phy_ports_3_suspend_valid             ), //o
    .io_phy_ports_3_suspend_ready         (phyCc_input_ports_3_suspend_ready             ), //i
    .io_phy_ports_3_resume_valid          (ohci_io_phy_ports_3_resume_valid              ), //o
    .io_phy_ports_3_resume_ready          (phyCc_input_ports_3_resume_ready              ), //i
    .io_phy_ports_3_connect               (phyCc_input_ports_3_connect                   ), //i
    .io_phy_ports_3_disconnect            (phyCc_input_ports_3_disconnect                ), //i
    .io_phy_ports_3_overcurrent           (phyCc_input_ports_3_overcurrent               ), //i
    .io_phy_ports_3_remoteResume          (phyCc_input_ports_3_remoteResume              ), //i
    .io_phy_ports_3_lowSpeed              (phyCc_input_ports_3_lowSpeed                  ), //i
    .io_dma_cmd_valid                     (ohci_io_dma_cmd_valid                         ), //o
    .io_dma_cmd_ready                     (dma_cmd_ready                                 ), //i
    .io_dma_cmd_payload_last              (ohci_io_dma_cmd_payload_last                  ), //o
    .io_dma_cmd_payload_fragment_opcode   (ohci_io_dma_cmd_payload_fragment_opcode       ), //o
    .io_dma_cmd_payload_fragment_address  (ohci_io_dma_cmd_payload_fragment_address[31:0]), //o
    .io_dma_cmd_payload_fragment_length   (ohci_io_dma_cmd_payload_fragment_length[5:0]  ), //o
    .io_dma_cmd_payload_fragment_data     (ohci_io_dma_cmd_payload_fragment_data[63:0]   ), //o
    .io_dma_cmd_payload_fragment_mask     (ohci_io_dma_cmd_payload_fragment_mask[7:0]    ), //o
    .io_dma_rsp_valid                     (dma_rsp_valid                                 ), //i
    .io_dma_rsp_ready                     (ohci_io_dma_rsp_ready                         ), //o
    .io_dma_rsp_payload_last              (dma_rsp_payload_last                          ), //i
    .io_dma_rsp_payload_fragment_opcode   (dma_rsp_payload_fragment_opcode               ), //i
    .io_dma_rsp_payload_fragment_data     (dma_rsp_payload_fragment_data[63:0]           ), //i
    .io_interrupt                         (ohci_io_interrupt                             ), //o
    .io_interruptBios                     (ohci_io_interruptBios                         ), //o
    .clk                                  (clk                                           ), //i
    .reset                                (reset                                         )  //i
  );
  UsbLsFsPhy phy (
    .io_ctrl_lowSpeed                      (phyCc_output_lowSpeed                    ), //i
    .io_ctrl_tx_valid                      (phyCc_output_tx_valid                    ), //i
    .io_ctrl_tx_ready                      (phy_io_ctrl_tx_ready                     ), //o
    .io_ctrl_tx_payload_last               (phyCc_output_tx_payload_last             ), //i
    .io_ctrl_tx_payload_fragment           (phyCc_output_tx_payload_fragment[7:0]    ), //i
    .io_ctrl_txEop                         (phy_io_ctrl_txEop                        ), //o
    .io_ctrl_rx_flow_valid                 (phy_io_ctrl_rx_flow_valid                ), //o
    .io_ctrl_rx_flow_payload_stuffingError (phy_io_ctrl_rx_flow_payload_stuffingError), //o
    .io_ctrl_rx_flow_payload_data          (phy_io_ctrl_rx_flow_payload_data[7:0]    ), //o
    .io_ctrl_rx_active                     (phy_io_ctrl_rx_active                    ), //o
    .io_ctrl_usbReset                      (phyCc_output_usbReset                    ), //i
    .io_ctrl_usbResume                     (phyCc_output_usbResume                   ), //i
    .io_ctrl_overcurrent                   (phy_io_ctrl_overcurrent                  ), //o
    .io_ctrl_tick                          (phy_io_ctrl_tick                         ), //o
    .io_ctrl_ports_0_disable_valid         (phyCc_output_ports_0_disable_valid       ), //i
    .io_ctrl_ports_0_disable_ready         (phy_io_ctrl_ports_0_disable_ready        ), //o
    .io_ctrl_ports_0_removable             (phyCc_output_ports_0_removable           ), //i
    .io_ctrl_ports_0_power                 (phyCc_output_ports_0_power               ), //i
    .io_ctrl_ports_0_reset_valid           (phyCc_output_ports_0_reset_valid         ), //i
    .io_ctrl_ports_0_reset_ready           (phy_io_ctrl_ports_0_reset_ready          ), //o
    .io_ctrl_ports_0_suspend_valid         (phyCc_output_ports_0_suspend_valid       ), //i
    .io_ctrl_ports_0_suspend_ready         (phy_io_ctrl_ports_0_suspend_ready        ), //o
    .io_ctrl_ports_0_resume_valid          (phyCc_output_ports_0_resume_valid        ), //i
    .io_ctrl_ports_0_resume_ready          (phy_io_ctrl_ports_0_resume_ready         ), //o
    .io_ctrl_ports_0_connect               (phy_io_ctrl_ports_0_connect              ), //o
    .io_ctrl_ports_0_disconnect            (phy_io_ctrl_ports_0_disconnect           ), //o
    .io_ctrl_ports_0_overcurrent           (phy_io_ctrl_ports_0_overcurrent          ), //o
    .io_ctrl_ports_0_remoteResume          (phy_io_ctrl_ports_0_remoteResume         ), //o
    .io_ctrl_ports_0_lowSpeed              (phy_io_ctrl_ports_0_lowSpeed             ), //o
    .io_ctrl_ports_1_disable_valid         (phyCc_output_ports_1_disable_valid       ), //i
    .io_ctrl_ports_1_disable_ready         (phy_io_ctrl_ports_1_disable_ready        ), //o
    .io_ctrl_ports_1_removable             (phyCc_output_ports_1_removable           ), //i
    .io_ctrl_ports_1_power                 (phyCc_output_ports_1_power               ), //i
    .io_ctrl_ports_1_reset_valid           (phyCc_output_ports_1_reset_valid         ), //i
    .io_ctrl_ports_1_reset_ready           (phy_io_ctrl_ports_1_reset_ready          ), //o
    .io_ctrl_ports_1_suspend_valid         (phyCc_output_ports_1_suspend_valid       ), //i
    .io_ctrl_ports_1_suspend_ready         (phy_io_ctrl_ports_1_suspend_ready        ), //o
    .io_ctrl_ports_1_resume_valid          (phyCc_output_ports_1_resume_valid        ), //i
    .io_ctrl_ports_1_resume_ready          (phy_io_ctrl_ports_1_resume_ready         ), //o
    .io_ctrl_ports_1_connect               (phy_io_ctrl_ports_1_connect              ), //o
    .io_ctrl_ports_1_disconnect            (phy_io_ctrl_ports_1_disconnect           ), //o
    .io_ctrl_ports_1_overcurrent           (phy_io_ctrl_ports_1_overcurrent          ), //o
    .io_ctrl_ports_1_remoteResume          (phy_io_ctrl_ports_1_remoteResume         ), //o
    .io_ctrl_ports_1_lowSpeed              (phy_io_ctrl_ports_1_lowSpeed             ), //o
    .io_ctrl_ports_2_disable_valid         (phyCc_output_ports_2_disable_valid       ), //i
    .io_ctrl_ports_2_disable_ready         (phy_io_ctrl_ports_2_disable_ready        ), //o
    .io_ctrl_ports_2_removable             (phyCc_output_ports_2_removable           ), //i
    .io_ctrl_ports_2_power                 (phyCc_output_ports_2_power               ), //i
    .io_ctrl_ports_2_reset_valid           (phyCc_output_ports_2_reset_valid         ), //i
    .io_ctrl_ports_2_reset_ready           (phy_io_ctrl_ports_2_reset_ready          ), //o
    .io_ctrl_ports_2_suspend_valid         (phyCc_output_ports_2_suspend_valid       ), //i
    .io_ctrl_ports_2_suspend_ready         (phy_io_ctrl_ports_2_suspend_ready        ), //o
    .io_ctrl_ports_2_resume_valid          (phyCc_output_ports_2_resume_valid        ), //i
    .io_ctrl_ports_2_resume_ready          (phy_io_ctrl_ports_2_resume_ready         ), //o
    .io_ctrl_ports_2_connect               (phy_io_ctrl_ports_2_connect              ), //o
    .io_ctrl_ports_2_disconnect            (phy_io_ctrl_ports_2_disconnect           ), //o
    .io_ctrl_ports_2_overcurrent           (phy_io_ctrl_ports_2_overcurrent          ), //o
    .io_ctrl_ports_2_remoteResume          (phy_io_ctrl_ports_2_remoteResume         ), //o
    .io_ctrl_ports_2_lowSpeed              (phy_io_ctrl_ports_2_lowSpeed             ), //o
    .io_ctrl_ports_3_disable_valid         (phyCc_output_ports_3_disable_valid       ), //i
    .io_ctrl_ports_3_disable_ready         (phy_io_ctrl_ports_3_disable_ready        ), //o
    .io_ctrl_ports_3_removable             (phyCc_output_ports_3_removable           ), //i
    .io_ctrl_ports_3_power                 (phyCc_output_ports_3_power               ), //i
    .io_ctrl_ports_3_reset_valid           (phyCc_output_ports_3_reset_valid         ), //i
    .io_ctrl_ports_3_reset_ready           (phy_io_ctrl_ports_3_reset_ready          ), //o
    .io_ctrl_ports_3_suspend_valid         (phyCc_output_ports_3_suspend_valid       ), //i
    .io_ctrl_ports_3_suspend_ready         (phy_io_ctrl_ports_3_suspend_ready        ), //o
    .io_ctrl_ports_3_resume_valid          (phyCc_output_ports_3_resume_valid        ), //i
    .io_ctrl_ports_3_resume_ready          (phy_io_ctrl_ports_3_resume_ready         ), //o
    .io_ctrl_ports_3_connect               (phy_io_ctrl_ports_3_connect              ), //o
    .io_ctrl_ports_3_disconnect            (phy_io_ctrl_ports_3_disconnect           ), //o
    .io_ctrl_ports_3_overcurrent           (phy_io_ctrl_ports_3_overcurrent          ), //o
    .io_ctrl_ports_3_remoteResume          (phy_io_ctrl_ports_3_remoteResume         ), //o
    .io_ctrl_ports_3_lowSpeed              (phy_io_ctrl_ports_3_lowSpeed             ), //o
    .io_usb_0_tx_enable                    (phy_io_usb_0_tx_enable                   ), //o
    .io_usb_0_tx_data                      (phy_io_usb_0_tx_data                     ), //o
    .io_usb_0_tx_se0                       (phy_io_usb_0_tx_se0                      ), //o
    .io_usb_0_rx_dp                        (usb_0_rx_dp                              ), //i
    .io_usb_0_rx_dm                        (usb_0_rx_dm                              ), //i
    .io_usb_1_tx_enable                    (phy_io_usb_1_tx_enable                   ), //o
    .io_usb_1_tx_data                      (phy_io_usb_1_tx_data                     ), //o
    .io_usb_1_tx_se0                       (phy_io_usb_1_tx_se0                      ), //o
    .io_usb_1_rx_dp                        (usb_1_rx_dp                              ), //i
    .io_usb_1_rx_dm                        (usb_1_rx_dm                              ), //i
    .io_usb_2_tx_enable                    (phy_io_usb_2_tx_enable                   ), //o
    .io_usb_2_tx_data                      (phy_io_usb_2_tx_data                     ), //o
    .io_usb_2_tx_se0                       (phy_io_usb_2_tx_se0                      ), //o
    .io_usb_2_rx_dp                        (usb_2_rx_dp                              ), //i
    .io_usb_2_rx_dm                        (usb_2_rx_dm                              ), //i
    .io_usb_3_tx_enable                    (phy_io_usb_3_tx_enable                   ), //o
    .io_usb_3_tx_data                      (phy_io_usb_3_tx_data                     ), //o
    .io_usb_3_tx_se0                       (phy_io_usb_3_tx_se0                      ), //o
    .io_usb_3_rx_dp                        (usb_3_rx_dp                              ), //i
    .io_usb_3_rx_dm                        (usb_3_rx_dm                              ), //i
    .io_management_0_overcurrent           (management_0_overcurrent                 ), //i
    .io_management_0_power                 (phy_io_management_0_power                ), //o
    .io_management_1_overcurrent           (management_1_overcurrent                 ), //i
    .io_management_1_power                 (phy_io_management_1_power                ), //o
    .io_management_2_overcurrent           (management_2_overcurrent                 ), //i
    .io_management_2_power                 (phy_io_management_2_power                ), //o
    .io_management_3_overcurrent           (management_3_overcurrent                 ), //i
    .io_management_3_power                 (phy_io_management_3_power                ), //o
    .phyCd_clk                             (phyCd_clk                                ), //i
    .phyCd_reset                           (phyCd_reset                              )  //i
  );
  CtrlCc phyCc (
    .input_lowSpeed                       (ohci_io_phy_lowSpeed                     ), //i
    .input_tx_valid                       (ohci_io_phy_tx_valid                     ), //i
    .input_tx_ready                       (phyCc_input_tx_ready                     ), //o
    .input_tx_payload_last                (ohci_io_phy_tx_payload_last              ), //i
    .input_tx_payload_fragment            (ohci_io_phy_tx_payload_fragment[7:0]     ), //i
    .input_txEop                          (phyCc_input_txEop                        ), //o
    .input_rx_flow_valid                  (phyCc_input_rx_flow_valid                ), //o
    .input_rx_flow_payload_stuffingError  (phyCc_input_rx_flow_payload_stuffingError), //o
    .input_rx_flow_payload_data           (phyCc_input_rx_flow_payload_data[7:0]    ), //o
    .input_rx_active                      (phyCc_input_rx_active                    ), //o
    .input_usbReset                       (ohci_io_phy_usbReset                     ), //i
    .input_usbResume                      (ohci_io_phy_usbResume                    ), //i
    .input_overcurrent                    (phyCc_input_overcurrent                  ), //o
    .input_tick                           (phyCc_input_tick                         ), //o
    .input_ports_0_disable_valid          (ohci_io_phy_ports_0_disable_valid        ), //i
    .input_ports_0_disable_ready          (phyCc_input_ports_0_disable_ready        ), //o
    .input_ports_0_removable              (ohci_io_phy_ports_0_removable            ), //i
    .input_ports_0_power                  (ohci_io_phy_ports_0_power                ), //i
    .input_ports_0_reset_valid            (ohci_io_phy_ports_0_reset_valid          ), //i
    .input_ports_0_reset_ready            (phyCc_input_ports_0_reset_ready          ), //o
    .input_ports_0_suspend_valid          (ohci_io_phy_ports_0_suspend_valid        ), //i
    .input_ports_0_suspend_ready          (phyCc_input_ports_0_suspend_ready        ), //o
    .input_ports_0_resume_valid           (ohci_io_phy_ports_0_resume_valid         ), //i
    .input_ports_0_resume_ready           (phyCc_input_ports_0_resume_ready         ), //o
    .input_ports_0_connect                (phyCc_input_ports_0_connect              ), //o
    .input_ports_0_disconnect             (phyCc_input_ports_0_disconnect           ), //o
    .input_ports_0_overcurrent            (phyCc_input_ports_0_overcurrent          ), //o
    .input_ports_0_remoteResume           (phyCc_input_ports_0_remoteResume         ), //o
    .input_ports_0_lowSpeed               (phyCc_input_ports_0_lowSpeed             ), //o
    .input_ports_1_disable_valid          (ohci_io_phy_ports_1_disable_valid        ), //i
    .input_ports_1_disable_ready          (phyCc_input_ports_1_disable_ready        ), //o
    .input_ports_1_removable              (ohci_io_phy_ports_1_removable            ), //i
    .input_ports_1_power                  (ohci_io_phy_ports_1_power                ), //i
    .input_ports_1_reset_valid            (ohci_io_phy_ports_1_reset_valid          ), //i
    .input_ports_1_reset_ready            (phyCc_input_ports_1_reset_ready          ), //o
    .input_ports_1_suspend_valid          (ohci_io_phy_ports_1_suspend_valid        ), //i
    .input_ports_1_suspend_ready          (phyCc_input_ports_1_suspend_ready        ), //o
    .input_ports_1_resume_valid           (ohci_io_phy_ports_1_resume_valid         ), //i
    .input_ports_1_resume_ready           (phyCc_input_ports_1_resume_ready         ), //o
    .input_ports_1_connect                (phyCc_input_ports_1_connect              ), //o
    .input_ports_1_disconnect             (phyCc_input_ports_1_disconnect           ), //o
    .input_ports_1_overcurrent            (phyCc_input_ports_1_overcurrent          ), //o
    .input_ports_1_remoteResume           (phyCc_input_ports_1_remoteResume         ), //o
    .input_ports_1_lowSpeed               (phyCc_input_ports_1_lowSpeed             ), //o
    .input_ports_2_disable_valid          (ohci_io_phy_ports_2_disable_valid        ), //i
    .input_ports_2_disable_ready          (phyCc_input_ports_2_disable_ready        ), //o
    .input_ports_2_removable              (ohci_io_phy_ports_2_removable            ), //i
    .input_ports_2_power                  (ohci_io_phy_ports_2_power                ), //i
    .input_ports_2_reset_valid            (ohci_io_phy_ports_2_reset_valid          ), //i
    .input_ports_2_reset_ready            (phyCc_input_ports_2_reset_ready          ), //o
    .input_ports_2_suspend_valid          (ohci_io_phy_ports_2_suspend_valid        ), //i
    .input_ports_2_suspend_ready          (phyCc_input_ports_2_suspend_ready        ), //o
    .input_ports_2_resume_valid           (ohci_io_phy_ports_2_resume_valid         ), //i
    .input_ports_2_resume_ready           (phyCc_input_ports_2_resume_ready         ), //o
    .input_ports_2_connect                (phyCc_input_ports_2_connect              ), //o
    .input_ports_2_disconnect             (phyCc_input_ports_2_disconnect           ), //o
    .input_ports_2_overcurrent            (phyCc_input_ports_2_overcurrent          ), //o
    .input_ports_2_remoteResume           (phyCc_input_ports_2_remoteResume         ), //o
    .input_ports_2_lowSpeed               (phyCc_input_ports_2_lowSpeed             ), //o
    .input_ports_3_disable_valid          (ohci_io_phy_ports_3_disable_valid        ), //i
    .input_ports_3_disable_ready          (phyCc_input_ports_3_disable_ready        ), //o
    .input_ports_3_removable              (ohci_io_phy_ports_3_removable            ), //i
    .input_ports_3_power                  (ohci_io_phy_ports_3_power                ), //i
    .input_ports_3_reset_valid            (ohci_io_phy_ports_3_reset_valid          ), //i
    .input_ports_3_reset_ready            (phyCc_input_ports_3_reset_ready          ), //o
    .input_ports_3_suspend_valid          (ohci_io_phy_ports_3_suspend_valid        ), //i
    .input_ports_3_suspend_ready          (phyCc_input_ports_3_suspend_ready        ), //o
    .input_ports_3_resume_valid           (ohci_io_phy_ports_3_resume_valid         ), //i
    .input_ports_3_resume_ready           (phyCc_input_ports_3_resume_ready         ), //o
    .input_ports_3_connect                (phyCc_input_ports_3_connect              ), //o
    .input_ports_3_disconnect             (phyCc_input_ports_3_disconnect           ), //o
    .input_ports_3_overcurrent            (phyCc_input_ports_3_overcurrent          ), //o
    .input_ports_3_remoteResume           (phyCc_input_ports_3_remoteResume         ), //o
    .input_ports_3_lowSpeed               (phyCc_input_ports_3_lowSpeed             ), //o
    .output_lowSpeed                      (phyCc_output_lowSpeed                    ), //o
    .output_tx_valid                      (phyCc_output_tx_valid                    ), //o
    .output_tx_ready                      (phy_io_ctrl_tx_ready                     ), //i
    .output_tx_payload_last               (phyCc_output_tx_payload_last             ), //o
    .output_tx_payload_fragment           (phyCc_output_tx_payload_fragment[7:0]    ), //o
    .output_txEop                         (phy_io_ctrl_txEop                        ), //i
    .output_rx_flow_valid                 (phy_io_ctrl_rx_flow_valid                ), //i
    .output_rx_flow_payload_stuffingError (phy_io_ctrl_rx_flow_payload_stuffingError), //i
    .output_rx_flow_payload_data          (phy_io_ctrl_rx_flow_payload_data[7:0]    ), //i
    .output_rx_active                     (phy_io_ctrl_rx_active                    ), //i
    .output_usbReset                      (phyCc_output_usbReset                    ), //o
    .output_usbResume                     (phyCc_output_usbResume                   ), //o
    .output_overcurrent                   (phy_io_ctrl_overcurrent                  ), //i
    .output_tick                          (phy_io_ctrl_tick                         ), //i
    .output_ports_0_disable_valid         (phyCc_output_ports_0_disable_valid       ), //o
    .output_ports_0_disable_ready         (phy_io_ctrl_ports_0_disable_ready        ), //i
    .output_ports_0_removable             (phyCc_output_ports_0_removable           ), //o
    .output_ports_0_power                 (phyCc_output_ports_0_power               ), //o
    .output_ports_0_reset_valid           (phyCc_output_ports_0_reset_valid         ), //o
    .output_ports_0_reset_ready           (phy_io_ctrl_ports_0_reset_ready          ), //i
    .output_ports_0_suspend_valid         (phyCc_output_ports_0_suspend_valid       ), //o
    .output_ports_0_suspend_ready         (phy_io_ctrl_ports_0_suspend_ready        ), //i
    .output_ports_0_resume_valid          (phyCc_output_ports_0_resume_valid        ), //o
    .output_ports_0_resume_ready          (phy_io_ctrl_ports_0_resume_ready         ), //i
    .output_ports_0_connect               (phy_io_ctrl_ports_0_connect              ), //i
    .output_ports_0_disconnect            (phy_io_ctrl_ports_0_disconnect           ), //i
    .output_ports_0_overcurrent           (phy_io_ctrl_ports_0_overcurrent          ), //i
    .output_ports_0_remoteResume          (phy_io_ctrl_ports_0_remoteResume         ), //i
    .output_ports_0_lowSpeed              (phy_io_ctrl_ports_0_lowSpeed             ), //i
    .output_ports_1_disable_valid         (phyCc_output_ports_1_disable_valid       ), //o
    .output_ports_1_disable_ready         (phy_io_ctrl_ports_1_disable_ready        ), //i
    .output_ports_1_removable             (phyCc_output_ports_1_removable           ), //o
    .output_ports_1_power                 (phyCc_output_ports_1_power               ), //o
    .output_ports_1_reset_valid           (phyCc_output_ports_1_reset_valid         ), //o
    .output_ports_1_reset_ready           (phy_io_ctrl_ports_1_reset_ready          ), //i
    .output_ports_1_suspend_valid         (phyCc_output_ports_1_suspend_valid       ), //o
    .output_ports_1_suspend_ready         (phy_io_ctrl_ports_1_suspend_ready        ), //i
    .output_ports_1_resume_valid          (phyCc_output_ports_1_resume_valid        ), //o
    .output_ports_1_resume_ready          (phy_io_ctrl_ports_1_resume_ready         ), //i
    .output_ports_1_connect               (phy_io_ctrl_ports_1_connect              ), //i
    .output_ports_1_disconnect            (phy_io_ctrl_ports_1_disconnect           ), //i
    .output_ports_1_overcurrent           (phy_io_ctrl_ports_1_overcurrent          ), //i
    .output_ports_1_remoteResume          (phy_io_ctrl_ports_1_remoteResume         ), //i
    .output_ports_1_lowSpeed              (phy_io_ctrl_ports_1_lowSpeed             ), //i
    .output_ports_2_disable_valid         (phyCc_output_ports_2_disable_valid       ), //o
    .output_ports_2_disable_ready         (phy_io_ctrl_ports_2_disable_ready        ), //i
    .output_ports_2_removable             (phyCc_output_ports_2_removable           ), //o
    .output_ports_2_power                 (phyCc_output_ports_2_power               ), //o
    .output_ports_2_reset_valid           (phyCc_output_ports_2_reset_valid         ), //o
    .output_ports_2_reset_ready           (phy_io_ctrl_ports_2_reset_ready          ), //i
    .output_ports_2_suspend_valid         (phyCc_output_ports_2_suspend_valid       ), //o
    .output_ports_2_suspend_ready         (phy_io_ctrl_ports_2_suspend_ready        ), //i
    .output_ports_2_resume_valid          (phyCc_output_ports_2_resume_valid        ), //o
    .output_ports_2_resume_ready          (phy_io_ctrl_ports_2_resume_ready         ), //i
    .output_ports_2_connect               (phy_io_ctrl_ports_2_connect              ), //i
    .output_ports_2_disconnect            (phy_io_ctrl_ports_2_disconnect           ), //i
    .output_ports_2_overcurrent           (phy_io_ctrl_ports_2_overcurrent          ), //i
    .output_ports_2_remoteResume          (phy_io_ctrl_ports_2_remoteResume         ), //i
    .output_ports_2_lowSpeed              (phy_io_ctrl_ports_2_lowSpeed             ), //i
    .output_ports_3_disable_valid         (phyCc_output_ports_3_disable_valid       ), //o
    .output_ports_3_disable_ready         (phy_io_ctrl_ports_3_disable_ready        ), //i
    .output_ports_3_removable             (phyCc_output_ports_3_removable           ), //o
    .output_ports_3_power                 (phyCc_output_ports_3_power               ), //o
    .output_ports_3_reset_valid           (phyCc_output_ports_3_reset_valid         ), //o
    .output_ports_3_reset_ready           (phy_io_ctrl_ports_3_reset_ready          ), //i
    .output_ports_3_suspend_valid         (phyCc_output_ports_3_suspend_valid       ), //o
    .output_ports_3_suspend_ready         (phy_io_ctrl_ports_3_suspend_ready        ), //i
    .output_ports_3_resume_valid          (phyCc_output_ports_3_resume_valid        ), //o
    .output_ports_3_resume_ready          (phy_io_ctrl_ports_3_resume_ready         ), //i
    .output_ports_3_connect               (phy_io_ctrl_ports_3_connect              ), //i
    .output_ports_3_disconnect            (phy_io_ctrl_ports_3_disconnect           ), //i
    .output_ports_3_overcurrent           (phy_io_ctrl_ports_3_overcurrent          ), //i
    .output_ports_3_remoteResume          (phy_io_ctrl_ports_3_remoteResume         ), //i
    .output_ports_3_lowSpeed              (phy_io_ctrl_ports_3_lowSpeed             ), //i
    .phyCd_clk                            (phyCd_clk                                ), //i
    .phyCd_reset                          (phyCd_reset                              ), //i
    .clk                                  (clk                                      ), //i
    .reset                                (reset                                    )  //i
  );
  assign irq = ohci_io_interrupt;
  assign ctrl_cmd_ready = ohci_io_ctrl_cmd_ready;
  assign ctrl_rsp_valid = ohci_io_ctrl_rsp_valid;
  assign ctrl_rsp_payload_last = ohci_io_ctrl_rsp_payload_last;
  assign ctrl_rsp_payload_fragment_opcode = ohci_io_ctrl_rsp_payload_fragment_opcode;
  assign ctrl_rsp_payload_fragment_data = ohci_io_ctrl_rsp_payload_fragment_data;
  assign dma_cmd_valid = ohci_io_dma_cmd_valid;
  assign dma_cmd_payload_last = ohci_io_dma_cmd_payload_last;
  assign dma_cmd_payload_fragment_opcode = ohci_io_dma_cmd_payload_fragment_opcode;
  assign dma_cmd_payload_fragment_address = ohci_io_dma_cmd_payload_fragment_address;
  assign dma_cmd_payload_fragment_length = ohci_io_dma_cmd_payload_fragment_length;
  assign dma_cmd_payload_fragment_data = ohci_io_dma_cmd_payload_fragment_data;
  assign dma_cmd_payload_fragment_mask = ohci_io_dma_cmd_payload_fragment_mask;
  assign dma_rsp_ready = ohci_io_dma_rsp_ready;
  assign usb_0_tx_enable = phy_io_usb_0_tx_enable;
  assign usb_0_tx_data = phy_io_usb_0_tx_data;
  assign usb_0_tx_se0 = phy_io_usb_0_tx_se0;
  assign usb_1_tx_enable = phy_io_usb_1_tx_enable;
  assign usb_1_tx_data = phy_io_usb_1_tx_data;
  assign usb_1_tx_se0 = phy_io_usb_1_tx_se0;
  assign usb_2_tx_enable = phy_io_usb_2_tx_enable;
  assign usb_2_tx_data = phy_io_usb_2_tx_data;
  assign usb_2_tx_se0 = phy_io_usb_2_tx_se0;
  assign usb_3_tx_enable = phy_io_usb_3_tx_enable;
  assign usb_3_tx_data = phy_io_usb_3_tx_data;
  assign usb_3_tx_se0 = phy_io_usb_3_tx_se0;
  assign management_0_power = phy_io_management_0_power;
  assign management_1_power = phy_io_management_1_power;
  assign management_2_power = phy_io_management_2_power;
  assign management_3_power = phy_io_management_3_power;

endmodule

module CtrlCc (
  input  wire          input_lowSpeed,
  input  wire          input_tx_valid,
  output wire          input_tx_ready,
  input  wire          input_tx_payload_last,
  input  wire [7:0]    input_tx_payload_fragment,
  output wire          input_txEop,
  output wire          input_rx_flow_valid,
  output wire          input_rx_flow_payload_stuffingError,
  output wire [7:0]    input_rx_flow_payload_data,
  output wire          input_rx_active,
  input  wire          input_usbReset,
  input  wire          input_usbResume,
  output wire          input_overcurrent,
  output wire          input_tick,
  input  wire          input_ports_0_disable_valid,
  output wire          input_ports_0_disable_ready,
  input  wire          input_ports_0_removable,
  input  wire          input_ports_0_power,
  input  wire          input_ports_0_reset_valid,
  output wire          input_ports_0_reset_ready,
  input  wire          input_ports_0_suspend_valid,
  output wire          input_ports_0_suspend_ready,
  input  wire          input_ports_0_resume_valid,
  output wire          input_ports_0_resume_ready,
  output wire          input_ports_0_connect,
  output wire          input_ports_0_disconnect,
  output wire          input_ports_0_overcurrent,
  output wire          input_ports_0_remoteResume,
  output wire          input_ports_0_lowSpeed,
  input  wire          input_ports_1_disable_valid,
  output wire          input_ports_1_disable_ready,
  input  wire          input_ports_1_removable,
  input  wire          input_ports_1_power,
  input  wire          input_ports_1_reset_valid,
  output wire          input_ports_1_reset_ready,
  input  wire          input_ports_1_suspend_valid,
  output wire          input_ports_1_suspend_ready,
  input  wire          input_ports_1_resume_valid,
  output wire          input_ports_1_resume_ready,
  output wire          input_ports_1_connect,
  output wire          input_ports_1_disconnect,
  output wire          input_ports_1_overcurrent,
  output wire          input_ports_1_remoteResume,
  output wire          input_ports_1_lowSpeed,
  input  wire          input_ports_2_disable_valid,
  output wire          input_ports_2_disable_ready,
  input  wire          input_ports_2_removable,
  input  wire          input_ports_2_power,
  input  wire          input_ports_2_reset_valid,
  output wire          input_ports_2_reset_ready,
  input  wire          input_ports_2_suspend_valid,
  output wire          input_ports_2_suspend_ready,
  input  wire          input_ports_2_resume_valid,
  output wire          input_ports_2_resume_ready,
  output wire          input_ports_2_connect,
  output wire          input_ports_2_disconnect,
  output wire          input_ports_2_overcurrent,
  output wire          input_ports_2_remoteResume,
  output wire          input_ports_2_lowSpeed,
  input  wire          input_ports_3_disable_valid,
  output wire          input_ports_3_disable_ready,
  input  wire          input_ports_3_removable,
  input  wire          input_ports_3_power,
  input  wire          input_ports_3_reset_valid,
  output wire          input_ports_3_reset_ready,
  input  wire          input_ports_3_suspend_valid,
  output wire          input_ports_3_suspend_ready,
  input  wire          input_ports_3_resume_valid,
  output wire          input_ports_3_resume_ready,
  output wire          input_ports_3_connect,
  output wire          input_ports_3_disconnect,
  output wire          input_ports_3_overcurrent,
  output wire          input_ports_3_remoteResume,
  output wire          input_ports_3_lowSpeed,
  output wire          output_lowSpeed,
  output wire          output_tx_valid,
  input  wire          output_tx_ready,
  output wire          output_tx_payload_last,
  output wire [7:0]    output_tx_payload_fragment,
  input  wire          output_txEop,
  input  wire          output_rx_flow_valid,
  input  wire          output_rx_flow_payload_stuffingError,
  input  wire [7:0]    output_rx_flow_payload_data,
  input  wire          output_rx_active,
  output wire          output_usbReset,
  output wire          output_usbResume,
  input  wire          output_overcurrent,
  input  wire          output_tick,
  output wire          output_ports_0_disable_valid,
  input  wire          output_ports_0_disable_ready,
  output wire          output_ports_0_removable,
  output wire          output_ports_0_power,
  output wire          output_ports_0_reset_valid,
  input  wire          output_ports_0_reset_ready,
  output wire          output_ports_0_suspend_valid,
  input  wire          output_ports_0_suspend_ready,
  output wire          output_ports_0_resume_valid,
  input  wire          output_ports_0_resume_ready,
  input  wire          output_ports_0_connect,
  input  wire          output_ports_0_disconnect,
  input  wire          output_ports_0_overcurrent,
  input  wire          output_ports_0_remoteResume,
  input  wire          output_ports_0_lowSpeed,
  output wire          output_ports_1_disable_valid,
  input  wire          output_ports_1_disable_ready,
  output wire          output_ports_1_removable,
  output wire          output_ports_1_power,
  output wire          output_ports_1_reset_valid,
  input  wire          output_ports_1_reset_ready,
  output wire          output_ports_1_suspend_valid,
  input  wire          output_ports_1_suspend_ready,
  output wire          output_ports_1_resume_valid,
  input  wire          output_ports_1_resume_ready,
  input  wire          output_ports_1_connect,
  input  wire          output_ports_1_disconnect,
  input  wire          output_ports_1_overcurrent,
  input  wire          output_ports_1_remoteResume,
  input  wire          output_ports_1_lowSpeed,
  output wire          output_ports_2_disable_valid,
  input  wire          output_ports_2_disable_ready,
  output wire          output_ports_2_removable,
  output wire          output_ports_2_power,
  output wire          output_ports_2_reset_valid,
  input  wire          output_ports_2_reset_ready,
  output wire          output_ports_2_suspend_valid,
  input  wire          output_ports_2_suspend_ready,
  output wire          output_ports_2_resume_valid,
  input  wire          output_ports_2_resume_ready,
  input  wire          output_ports_2_connect,
  input  wire          output_ports_2_disconnect,
  input  wire          output_ports_2_overcurrent,
  input  wire          output_ports_2_remoteResume,
  input  wire          output_ports_2_lowSpeed,
  output wire          output_ports_3_disable_valid,
  input  wire          output_ports_3_disable_ready,
  output wire          output_ports_3_removable,
  output wire          output_ports_3_power,
  output wire          output_ports_3_reset_valid,
  input  wire          output_ports_3_reset_ready,
  output wire          output_ports_3_suspend_valid,
  input  wire          output_ports_3_suspend_ready,
  output wire          output_ports_3_resume_valid,
  input  wire          output_ports_3_resume_ready,
  input  wire          output_ports_3_connect,
  input  wire          output_ports_3_disconnect,
  input  wire          output_ports_3_overcurrent,
  input  wire          output_ports_3_remoteResume,
  input  wire          output_ports_3_lowSpeed,
  input  wire          phyCd_clk,
  input  wire          phyCd_reset,
  input  wire          clk,
  input  wire          reset
);

  reg                 input_tx_ccToggle_io_output_ready;
  wire                input_lowSpeed_buffercc_io_dataOut;
  wire                input_usbReset_buffercc_io_dataOut;
  wire                input_usbResume_buffercc_io_dataOut;
  wire                output_overcurrent_buffercc_io_dataOut;
  wire                input_tx_ccToggle_io_input_ready;
  wire                input_tx_ccToggle_io_output_valid;
  wire                input_tx_ccToggle_io_output_payload_last;
  wire       [7:0]    input_tx_ccToggle_io_output_payload_fragment;
  wire                input_tx_ccToggle_reset_syncronized_1;
  wire                pulseCCByToggle_14_io_pulseOut;
  wire                pulseCCByToggle_14_phyCd_reset_syncronized_1;
  wire                output_rx_flow_ccToggle_io_output_valid;
  wire                output_rx_flow_ccToggle_io_output_payload_stuffingError;
  wire       [7:0]    output_rx_flow_ccToggle_io_output_payload_data;
  wire                output_rx_active_buffercc_io_dataOut;
  wire                pulseCCByToggle_15_io_pulseOut;
  wire                input_ports_0_removable_buffercc_io_dataOut;
  wire                input_ports_0_power_buffercc_io_dataOut;
  wire                output_ports_0_lowSpeed_buffercc_io_dataOut;
  wire                output_ports_0_overcurrent_buffercc_io_dataOut;
  wire                pulseCCByToggle_16_io_pulseOut;
  wire                pulseCCByToggle_17_io_pulseOut;
  wire                pulseCCByToggle_18_io_pulseOut;
  wire                input_ports_0_reset_ccToggle_io_input_ready;
  wire                input_ports_0_reset_ccToggle_io_output_valid;
  wire                input_ports_0_suspend_ccToggle_io_input_ready;
  wire                input_ports_0_suspend_ccToggle_io_output_valid;
  wire                input_ports_0_resume_ccToggle_io_input_ready;
  wire                input_ports_0_resume_ccToggle_io_output_valid;
  wire                input_ports_0_disable_ccToggle_io_input_ready;
  wire                input_ports_0_disable_ccToggle_io_output_valid;
  wire                input_ports_1_removable_buffercc_io_dataOut;
  wire                input_ports_1_power_buffercc_io_dataOut;
  wire                output_ports_1_lowSpeed_buffercc_io_dataOut;
  wire                output_ports_1_overcurrent_buffercc_io_dataOut;
  wire                pulseCCByToggle_19_io_pulseOut;
  wire                pulseCCByToggle_20_io_pulseOut;
  wire                pulseCCByToggle_21_io_pulseOut;
  wire                input_ports_1_reset_ccToggle_io_input_ready;
  wire                input_ports_1_reset_ccToggle_io_output_valid;
  wire                input_ports_1_suspend_ccToggle_io_input_ready;
  wire                input_ports_1_suspend_ccToggle_io_output_valid;
  wire                input_ports_1_resume_ccToggle_io_input_ready;
  wire                input_ports_1_resume_ccToggle_io_output_valid;
  wire                input_ports_1_disable_ccToggle_io_input_ready;
  wire                input_ports_1_disable_ccToggle_io_output_valid;
  wire                input_ports_2_removable_buffercc_io_dataOut;
  wire                input_ports_2_power_buffercc_io_dataOut;
  wire                output_ports_2_lowSpeed_buffercc_io_dataOut;
  wire                output_ports_2_overcurrent_buffercc_io_dataOut;
  wire                pulseCCByToggle_22_io_pulseOut;
  wire                pulseCCByToggle_23_io_pulseOut;
  wire                pulseCCByToggle_24_io_pulseOut;
  wire                input_ports_2_reset_ccToggle_io_input_ready;
  wire                input_ports_2_reset_ccToggle_io_output_valid;
  wire                input_ports_2_suspend_ccToggle_io_input_ready;
  wire                input_ports_2_suspend_ccToggle_io_output_valid;
  wire                input_ports_2_resume_ccToggle_io_input_ready;
  wire                input_ports_2_resume_ccToggle_io_output_valid;
  wire                input_ports_2_disable_ccToggle_io_input_ready;
  wire                input_ports_2_disable_ccToggle_io_output_valid;
  wire                input_ports_3_removable_buffercc_io_dataOut;
  wire                input_ports_3_power_buffercc_io_dataOut;
  wire                output_ports_3_lowSpeed_buffercc_io_dataOut;
  wire                output_ports_3_overcurrent_buffercc_io_dataOut;
  wire                pulseCCByToggle_25_io_pulseOut;
  wire                pulseCCByToggle_26_io_pulseOut;
  wire                pulseCCByToggle_27_io_pulseOut;
  wire                input_ports_3_reset_ccToggle_io_input_ready;
  wire                input_ports_3_reset_ccToggle_io_output_valid;
  wire                input_ports_3_suspend_ccToggle_io_input_ready;
  wire                input_ports_3_suspend_ccToggle_io_output_valid;
  wire                input_ports_3_resume_ccToggle_io_input_ready;
  wire                input_ports_3_resume_ccToggle_io_output_valid;
  wire                input_ports_3_disable_ccToggle_io_input_ready;
  wire                input_ports_3_disable_ccToggle_io_output_valid;
  wire                phyCc_input_tx_ccToggle_io_output_m2sPipe_valid;
  wire                phyCc_input_tx_ccToggle_io_output_m2sPipe_ready;
  wire                phyCc_input_tx_ccToggle_io_output_m2sPipe_payload_last;
  wire       [7:0]    phyCc_input_tx_ccToggle_io_output_m2sPipe_payload_fragment;
  reg                 phyCc_input_tx_ccToggle_io_output_rValid;
  reg                 phyCc_input_tx_ccToggle_io_output_rData_last;
  reg        [7:0]    phyCc_input_tx_ccToggle_io_output_rData_fragment;
  wire                when_Stream_l369;

  BufferCC input_lowSpeed_buffercc (
    .io_dataIn   (input_lowSpeed                    ), //i
    .io_dataOut  (input_lowSpeed_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                         ), //i
    .phyCd_reset (phyCd_reset                       )  //i
  );
  BufferCC input_usbReset_buffercc (
    .io_dataIn   (input_usbReset                    ), //i
    .io_dataOut  (input_usbReset_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                         ), //i
    .phyCd_reset (phyCd_reset                       )  //i
  );
  BufferCC input_usbResume_buffercc (
    .io_dataIn   (input_usbResume                    ), //i
    .io_dataOut  (input_usbResume_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                          ), //i
    .phyCd_reset (phyCd_reset                        )  //i
  );
  BufferCC_3 output_overcurrent_buffercc (
    .io_dataIn  (output_overcurrent                    ), //i
    .io_dataOut (output_overcurrent_buffercc_io_dataOut), //o
    .clk        (clk                                   ), //i
    .reset      (reset                                 )  //i
  );
  StreamCCByToggle input_tx_ccToggle (
    .io_input_valid             (input_tx_valid                                   ), //i
    .io_input_ready             (input_tx_ccToggle_io_input_ready                 ), //o
    .io_input_payload_last      (input_tx_payload_last                            ), //i
    .io_input_payload_fragment  (input_tx_payload_fragment[7:0]                   ), //i
    .io_output_valid            (input_tx_ccToggle_io_output_valid                ), //o
    .io_output_ready            (input_tx_ccToggle_io_output_ready                ), //i
    .io_output_payload_last     (input_tx_ccToggle_io_output_payload_last         ), //o
    .io_output_payload_fragment (input_tx_ccToggle_io_output_payload_fragment[7:0]), //o
    .clk                        (clk                                              ), //i
    .reset                      (reset                                            ), //i
    .phyCd_clk                  (phyCd_clk                                        ), //i
    .reset_syncronized_1        (input_tx_ccToggle_reset_syncronized_1            )  //o
  );
  PulseCCByToggle pulseCCByToggle_14 (
    .io_pulseIn                (output_txEop                                ), //i
    .io_pulseOut               (pulseCCByToggle_14_io_pulseOut              ), //o
    .phyCd_clk                 (phyCd_clk                                   ), //i
    .phyCd_reset               (phyCd_reset                                 ), //i
    .clk                       (clk                                         ), //i
    .phyCd_reset_syncronized_1 (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //o
  );
  FlowCCByToggle output_rx_flow_ccToggle (
    .io_input_valid                  (output_rx_flow_valid                                   ), //i
    .io_input_payload_stuffingError  (output_rx_flow_payload_stuffingError                   ), //i
    .io_input_payload_data           (output_rx_flow_payload_data[7:0]                       ), //i
    .io_output_valid                 (output_rx_flow_ccToggle_io_output_valid                ), //o
    .io_output_payload_stuffingError (output_rx_flow_ccToggle_io_output_payload_stuffingError), //o
    .io_output_payload_data          (output_rx_flow_ccToggle_io_output_payload_data[7:0]    ), //o
    .phyCd_clk                       (phyCd_clk                                              ), //i
    .phyCd_reset                     (phyCd_reset                                            ), //i
    .clk                             (clk                                                    ), //i
    .phyCd_reset_syncronized         (pulseCCByToggle_14_phyCd_reset_syncronized_1           )  //i
  );
  BufferCC_3 output_rx_active_buffercc (
    .io_dataIn  (output_rx_active                    ), //i
    .io_dataOut (output_rx_active_buffercc_io_dataOut), //o
    .clk        (clk                                 ), //i
    .reset      (reset                               )  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_15 (
    .io_pulseIn              (output_tick                                 ), //i
    .io_pulseOut             (pulseCCByToggle_15_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  BufferCC input_ports_0_removable_buffercc (
    .io_dataIn   (input_ports_0_removable                    ), //i
    .io_dataOut  (input_ports_0_removable_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                                  ), //i
    .phyCd_reset (phyCd_reset                                )  //i
  );
  BufferCC input_ports_0_power_buffercc (
    .io_dataIn   (input_ports_0_power                    ), //i
    .io_dataOut  (input_ports_0_power_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                              ), //i
    .phyCd_reset (phyCd_reset                            )  //i
  );
  BufferCC_3 output_ports_0_lowSpeed_buffercc (
    .io_dataIn  (output_ports_0_lowSpeed                    ), //i
    .io_dataOut (output_ports_0_lowSpeed_buffercc_io_dataOut), //o
    .clk        (clk                                        ), //i
    .reset      (reset                                      )  //i
  );
  BufferCC_3 output_ports_0_overcurrent_buffercc (
    .io_dataIn  (output_ports_0_overcurrent                    ), //i
    .io_dataOut (output_ports_0_overcurrent_buffercc_io_dataOut), //o
    .clk        (clk                                           ), //i
    .reset      (reset                                         )  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_16 (
    .io_pulseIn              (output_ports_0_connect                      ), //i
    .io_pulseOut             (pulseCCByToggle_16_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_17 (
    .io_pulseIn              (output_ports_0_disconnect                   ), //i
    .io_pulseOut             (pulseCCByToggle_17_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_18 (
    .io_pulseIn              (output_ports_0_remoteResume                 ), //i
    .io_pulseOut             (pulseCCByToggle_18_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  StreamCCByToggle_1 input_ports_0_reset_ccToggle (
    .io_input_valid    (input_ports_0_reset_valid                   ), //i
    .io_input_ready    (input_ports_0_reset_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_0_reset_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_0_reset_ready                  ), //i
    .clk               (clk                                         ), //i
    .reset             (reset                                       ), //i
    .phyCd_clk         (phyCd_clk                                   ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1       )  //i
  );
  StreamCCByToggle_1 input_ports_0_suspend_ccToggle (
    .io_input_valid    (input_ports_0_suspend_valid                   ), //i
    .io_input_ready    (input_ports_0_suspend_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_0_suspend_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_0_suspend_ready                  ), //i
    .clk               (clk                                           ), //i
    .reset             (reset                                         ), //i
    .phyCd_clk         (phyCd_clk                                     ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1         )  //i
  );
  StreamCCByToggle_1 input_ports_0_resume_ccToggle (
    .io_input_valid    (input_ports_0_resume_valid                   ), //i
    .io_input_ready    (input_ports_0_resume_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_0_resume_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_0_resume_ready                  ), //i
    .clk               (clk                                          ), //i
    .reset             (reset                                        ), //i
    .phyCd_clk         (phyCd_clk                                    ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1        )  //i
  );
  StreamCCByToggle_1 input_ports_0_disable_ccToggle (
    .io_input_valid    (input_ports_0_disable_valid                   ), //i
    .io_input_ready    (input_ports_0_disable_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_0_disable_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_0_disable_ready                  ), //i
    .clk               (clk                                           ), //i
    .reset             (reset                                         ), //i
    .phyCd_clk         (phyCd_clk                                     ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1         )  //i
  );
  BufferCC input_ports_1_removable_buffercc (
    .io_dataIn   (input_ports_1_removable                    ), //i
    .io_dataOut  (input_ports_1_removable_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                                  ), //i
    .phyCd_reset (phyCd_reset                                )  //i
  );
  BufferCC input_ports_1_power_buffercc (
    .io_dataIn   (input_ports_1_power                    ), //i
    .io_dataOut  (input_ports_1_power_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                              ), //i
    .phyCd_reset (phyCd_reset                            )  //i
  );
  BufferCC_3 output_ports_1_lowSpeed_buffercc (
    .io_dataIn  (output_ports_1_lowSpeed                    ), //i
    .io_dataOut (output_ports_1_lowSpeed_buffercc_io_dataOut), //o
    .clk        (clk                                        ), //i
    .reset      (reset                                      )  //i
  );
  BufferCC_3 output_ports_1_overcurrent_buffercc (
    .io_dataIn  (output_ports_1_overcurrent                    ), //i
    .io_dataOut (output_ports_1_overcurrent_buffercc_io_dataOut), //o
    .clk        (clk                                           ), //i
    .reset      (reset                                         )  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_19 (
    .io_pulseIn              (output_ports_1_connect                      ), //i
    .io_pulseOut             (pulseCCByToggle_19_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_20 (
    .io_pulseIn              (output_ports_1_disconnect                   ), //i
    .io_pulseOut             (pulseCCByToggle_20_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_21 (
    .io_pulseIn              (output_ports_1_remoteResume                 ), //i
    .io_pulseOut             (pulseCCByToggle_21_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  StreamCCByToggle_1 input_ports_1_reset_ccToggle (
    .io_input_valid    (input_ports_1_reset_valid                   ), //i
    .io_input_ready    (input_ports_1_reset_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_1_reset_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_1_reset_ready                  ), //i
    .clk               (clk                                         ), //i
    .reset             (reset                                       ), //i
    .phyCd_clk         (phyCd_clk                                   ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1       )  //i
  );
  StreamCCByToggle_1 input_ports_1_suspend_ccToggle (
    .io_input_valid    (input_ports_1_suspend_valid                   ), //i
    .io_input_ready    (input_ports_1_suspend_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_1_suspend_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_1_suspend_ready                  ), //i
    .clk               (clk                                           ), //i
    .reset             (reset                                         ), //i
    .phyCd_clk         (phyCd_clk                                     ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1         )  //i
  );
  StreamCCByToggle_1 input_ports_1_resume_ccToggle (
    .io_input_valid    (input_ports_1_resume_valid                   ), //i
    .io_input_ready    (input_ports_1_resume_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_1_resume_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_1_resume_ready                  ), //i
    .clk               (clk                                          ), //i
    .reset             (reset                                        ), //i
    .phyCd_clk         (phyCd_clk                                    ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1        )  //i
  );
  StreamCCByToggle_1 input_ports_1_disable_ccToggle (
    .io_input_valid    (input_ports_1_disable_valid                   ), //i
    .io_input_ready    (input_ports_1_disable_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_1_disable_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_1_disable_ready                  ), //i
    .clk               (clk                                           ), //i
    .reset             (reset                                         ), //i
    .phyCd_clk         (phyCd_clk                                     ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1         )  //i
  );
  BufferCC input_ports_2_removable_buffercc (
    .io_dataIn   (input_ports_2_removable                    ), //i
    .io_dataOut  (input_ports_2_removable_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                                  ), //i
    .phyCd_reset (phyCd_reset                                )  //i
  );
  BufferCC input_ports_2_power_buffercc (
    .io_dataIn   (input_ports_2_power                    ), //i
    .io_dataOut  (input_ports_2_power_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                              ), //i
    .phyCd_reset (phyCd_reset                            )  //i
  );
  BufferCC_3 output_ports_2_lowSpeed_buffercc (
    .io_dataIn  (output_ports_2_lowSpeed                    ), //i
    .io_dataOut (output_ports_2_lowSpeed_buffercc_io_dataOut), //o
    .clk        (clk                                        ), //i
    .reset      (reset                                      )  //i
  );
  BufferCC_3 output_ports_2_overcurrent_buffercc (
    .io_dataIn  (output_ports_2_overcurrent                    ), //i
    .io_dataOut (output_ports_2_overcurrent_buffercc_io_dataOut), //o
    .clk        (clk                                           ), //i
    .reset      (reset                                         )  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_22 (
    .io_pulseIn              (output_ports_2_connect                      ), //i
    .io_pulseOut             (pulseCCByToggle_22_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_23 (
    .io_pulseIn              (output_ports_2_disconnect                   ), //i
    .io_pulseOut             (pulseCCByToggle_23_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_24 (
    .io_pulseIn              (output_ports_2_remoteResume                 ), //i
    .io_pulseOut             (pulseCCByToggle_24_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  StreamCCByToggle_1 input_ports_2_reset_ccToggle (
    .io_input_valid    (input_ports_2_reset_valid                   ), //i
    .io_input_ready    (input_ports_2_reset_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_2_reset_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_2_reset_ready                  ), //i
    .clk               (clk                                         ), //i
    .reset             (reset                                       ), //i
    .phyCd_clk         (phyCd_clk                                   ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1       )  //i
  );
  StreamCCByToggle_1 input_ports_2_suspend_ccToggle (
    .io_input_valid    (input_ports_2_suspend_valid                   ), //i
    .io_input_ready    (input_ports_2_suspend_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_2_suspend_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_2_suspend_ready                  ), //i
    .clk               (clk                                           ), //i
    .reset             (reset                                         ), //i
    .phyCd_clk         (phyCd_clk                                     ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1         )  //i
  );
  StreamCCByToggle_1 input_ports_2_resume_ccToggle (
    .io_input_valid    (input_ports_2_resume_valid                   ), //i
    .io_input_ready    (input_ports_2_resume_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_2_resume_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_2_resume_ready                  ), //i
    .clk               (clk                                          ), //i
    .reset             (reset                                        ), //i
    .phyCd_clk         (phyCd_clk                                    ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1        )  //i
  );
  StreamCCByToggle_1 input_ports_2_disable_ccToggle (
    .io_input_valid    (input_ports_2_disable_valid                   ), //i
    .io_input_ready    (input_ports_2_disable_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_2_disable_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_2_disable_ready                  ), //i
    .clk               (clk                                           ), //i
    .reset             (reset                                         ), //i
    .phyCd_clk         (phyCd_clk                                     ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1         )  //i
  );
  BufferCC input_ports_3_removable_buffercc (
    .io_dataIn   (input_ports_3_removable                    ), //i
    .io_dataOut  (input_ports_3_removable_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                                  ), //i
    .phyCd_reset (phyCd_reset                                )  //i
  );
  BufferCC input_ports_3_power_buffercc (
    .io_dataIn   (input_ports_3_power                    ), //i
    .io_dataOut  (input_ports_3_power_buffercc_io_dataOut), //o
    .phyCd_clk   (phyCd_clk                              ), //i
    .phyCd_reset (phyCd_reset                            )  //i
  );
  BufferCC_3 output_ports_3_lowSpeed_buffercc (
    .io_dataIn  (output_ports_3_lowSpeed                    ), //i
    .io_dataOut (output_ports_3_lowSpeed_buffercc_io_dataOut), //o
    .clk        (clk                                        ), //i
    .reset      (reset                                      )  //i
  );
  BufferCC_3 output_ports_3_overcurrent_buffercc (
    .io_dataIn  (output_ports_3_overcurrent                    ), //i
    .io_dataOut (output_ports_3_overcurrent_buffercc_io_dataOut), //o
    .clk        (clk                                           ), //i
    .reset      (reset                                         )  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_25 (
    .io_pulseIn              (output_ports_3_connect                      ), //i
    .io_pulseOut             (pulseCCByToggle_25_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_26 (
    .io_pulseIn              (output_ports_3_disconnect                   ), //i
    .io_pulseOut             (pulseCCByToggle_26_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  PulseCCByToggle_1 pulseCCByToggle_27 (
    .io_pulseIn              (output_ports_3_remoteResume                 ), //i
    .io_pulseOut             (pulseCCByToggle_27_io_pulseOut              ), //o
    .phyCd_clk               (phyCd_clk                                   ), //i
    .phyCd_reset             (phyCd_reset                                 ), //i
    .clk                     (clk                                         ), //i
    .phyCd_reset_syncronized (pulseCCByToggle_14_phyCd_reset_syncronized_1)  //i
  );
  StreamCCByToggle_1 input_ports_3_reset_ccToggle (
    .io_input_valid    (input_ports_3_reset_valid                   ), //i
    .io_input_ready    (input_ports_3_reset_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_3_reset_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_3_reset_ready                  ), //i
    .clk               (clk                                         ), //i
    .reset             (reset                                       ), //i
    .phyCd_clk         (phyCd_clk                                   ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1       )  //i
  );
  StreamCCByToggle_1 input_ports_3_suspend_ccToggle (
    .io_input_valid    (input_ports_3_suspend_valid                   ), //i
    .io_input_ready    (input_ports_3_suspend_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_3_suspend_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_3_suspend_ready                  ), //i
    .clk               (clk                                           ), //i
    .reset             (reset                                         ), //i
    .phyCd_clk         (phyCd_clk                                     ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1         )  //i
  );
  StreamCCByToggle_1 input_ports_3_resume_ccToggle (
    .io_input_valid    (input_ports_3_resume_valid                   ), //i
    .io_input_ready    (input_ports_3_resume_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_3_resume_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_3_resume_ready                  ), //i
    .clk               (clk                                          ), //i
    .reset             (reset                                        ), //i
    .phyCd_clk         (phyCd_clk                                    ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1        )  //i
  );
  StreamCCByToggle_1 input_ports_3_disable_ccToggle (
    .io_input_valid    (input_ports_3_disable_valid                   ), //i
    .io_input_ready    (input_ports_3_disable_ccToggle_io_input_ready ), //o
    .io_output_valid   (input_ports_3_disable_ccToggle_io_output_valid), //o
    .io_output_ready   (output_ports_3_disable_ready                  ), //i
    .clk               (clk                                           ), //i
    .reset             (reset                                         ), //i
    .phyCd_clk         (phyCd_clk                                     ), //i
    .reset_syncronized (input_tx_ccToggle_reset_syncronized_1         )  //i
  );
  assign output_lowSpeed = input_lowSpeed_buffercc_io_dataOut;
  assign output_usbReset = input_usbReset_buffercc_io_dataOut;
  assign output_usbResume = input_usbResume_buffercc_io_dataOut;
  assign input_overcurrent = output_overcurrent_buffercc_io_dataOut;
  assign input_tx_ready = input_tx_ccToggle_io_input_ready;
  always @(*) begin
    input_tx_ccToggle_io_output_ready = phyCc_input_tx_ccToggle_io_output_m2sPipe_ready;
    if(when_Stream_l369) begin
      input_tx_ccToggle_io_output_ready = 1'b1;
    end
  end

  assign when_Stream_l369 = (! phyCc_input_tx_ccToggle_io_output_m2sPipe_valid);
  assign phyCc_input_tx_ccToggle_io_output_m2sPipe_valid = phyCc_input_tx_ccToggle_io_output_rValid;
  assign phyCc_input_tx_ccToggle_io_output_m2sPipe_payload_last = phyCc_input_tx_ccToggle_io_output_rData_last;
  assign phyCc_input_tx_ccToggle_io_output_m2sPipe_payload_fragment = phyCc_input_tx_ccToggle_io_output_rData_fragment;
  assign output_tx_valid = phyCc_input_tx_ccToggle_io_output_m2sPipe_valid;
  assign phyCc_input_tx_ccToggle_io_output_m2sPipe_ready = output_tx_ready;
  assign output_tx_payload_last = phyCc_input_tx_ccToggle_io_output_m2sPipe_payload_last;
  assign output_tx_payload_fragment = phyCc_input_tx_ccToggle_io_output_m2sPipe_payload_fragment;
  assign input_txEop = pulseCCByToggle_14_io_pulseOut;
  assign input_rx_flow_valid = output_rx_flow_ccToggle_io_output_valid;
  assign input_rx_flow_payload_stuffingError = output_rx_flow_ccToggle_io_output_payload_stuffingError;
  assign input_rx_flow_payload_data = output_rx_flow_ccToggle_io_output_payload_data;
  assign input_rx_active = output_rx_active_buffercc_io_dataOut;
  assign input_tick = pulseCCByToggle_15_io_pulseOut;
  assign output_ports_0_removable = input_ports_0_removable_buffercc_io_dataOut;
  assign output_ports_0_power = input_ports_0_power_buffercc_io_dataOut;
  assign input_ports_0_lowSpeed = output_ports_0_lowSpeed_buffercc_io_dataOut;
  assign input_ports_0_overcurrent = output_ports_0_overcurrent_buffercc_io_dataOut;
  assign input_ports_0_connect = pulseCCByToggle_16_io_pulseOut;
  assign input_ports_0_disconnect = pulseCCByToggle_17_io_pulseOut;
  assign input_ports_0_remoteResume = pulseCCByToggle_18_io_pulseOut;
  assign input_ports_0_reset_ready = input_ports_0_reset_ccToggle_io_input_ready;
  assign output_ports_0_reset_valid = input_ports_0_reset_ccToggle_io_output_valid;
  assign input_ports_0_suspend_ready = input_ports_0_suspend_ccToggle_io_input_ready;
  assign output_ports_0_suspend_valid = input_ports_0_suspend_ccToggle_io_output_valid;
  assign input_ports_0_resume_ready = input_ports_0_resume_ccToggle_io_input_ready;
  assign output_ports_0_resume_valid = input_ports_0_resume_ccToggle_io_output_valid;
  assign input_ports_0_disable_ready = input_ports_0_disable_ccToggle_io_input_ready;
  assign output_ports_0_disable_valid = input_ports_0_disable_ccToggle_io_output_valid;
  assign output_ports_1_removable = input_ports_1_removable_buffercc_io_dataOut;
  assign output_ports_1_power = input_ports_1_power_buffercc_io_dataOut;
  assign input_ports_1_lowSpeed = output_ports_1_lowSpeed_buffercc_io_dataOut;
  assign input_ports_1_overcurrent = output_ports_1_overcurrent_buffercc_io_dataOut;
  assign input_ports_1_connect = pulseCCByToggle_19_io_pulseOut;
  assign input_ports_1_disconnect = pulseCCByToggle_20_io_pulseOut;
  assign input_ports_1_remoteResume = pulseCCByToggle_21_io_pulseOut;
  assign input_ports_1_reset_ready = input_ports_1_reset_ccToggle_io_input_ready;
  assign output_ports_1_reset_valid = input_ports_1_reset_ccToggle_io_output_valid;
  assign input_ports_1_suspend_ready = input_ports_1_suspend_ccToggle_io_input_ready;
  assign output_ports_1_suspend_valid = input_ports_1_suspend_ccToggle_io_output_valid;
  assign input_ports_1_resume_ready = input_ports_1_resume_ccToggle_io_input_ready;
  assign output_ports_1_resume_valid = input_ports_1_resume_ccToggle_io_output_valid;
  assign input_ports_1_disable_ready = input_ports_1_disable_ccToggle_io_input_ready;
  assign output_ports_1_disable_valid = input_ports_1_disable_ccToggle_io_output_valid;
  assign output_ports_2_removable = input_ports_2_removable_buffercc_io_dataOut;
  assign output_ports_2_power = input_ports_2_power_buffercc_io_dataOut;
  assign input_ports_2_lowSpeed = output_ports_2_lowSpeed_buffercc_io_dataOut;
  assign input_ports_2_overcurrent = output_ports_2_overcurrent_buffercc_io_dataOut;
  assign input_ports_2_connect = pulseCCByToggle_22_io_pulseOut;
  assign input_ports_2_disconnect = pulseCCByToggle_23_io_pulseOut;
  assign input_ports_2_remoteResume = pulseCCByToggle_24_io_pulseOut;
  assign input_ports_2_reset_ready = input_ports_2_reset_ccToggle_io_input_ready;
  assign output_ports_2_reset_valid = input_ports_2_reset_ccToggle_io_output_valid;
  assign input_ports_2_suspend_ready = input_ports_2_suspend_ccToggle_io_input_ready;
  assign output_ports_2_suspend_valid = input_ports_2_suspend_ccToggle_io_output_valid;
  assign input_ports_2_resume_ready = input_ports_2_resume_ccToggle_io_input_ready;
  assign output_ports_2_resume_valid = input_ports_2_resume_ccToggle_io_output_valid;
  assign input_ports_2_disable_ready = input_ports_2_disable_ccToggle_io_input_ready;
  assign output_ports_2_disable_valid = input_ports_2_disable_ccToggle_io_output_valid;
  assign output_ports_3_removable = input_ports_3_removable_buffercc_io_dataOut;
  assign output_ports_3_power = input_ports_3_power_buffercc_io_dataOut;
  assign input_ports_3_lowSpeed = output_ports_3_lowSpeed_buffercc_io_dataOut;
  assign input_ports_3_overcurrent = output_ports_3_overcurrent_buffercc_io_dataOut;
  assign input_ports_3_connect = pulseCCByToggle_25_io_pulseOut;
  assign input_ports_3_disconnect = pulseCCByToggle_26_io_pulseOut;
  assign input_ports_3_remoteResume = pulseCCByToggle_27_io_pulseOut;
  assign input_ports_3_reset_ready = input_ports_3_reset_ccToggle_io_input_ready;
  assign output_ports_3_reset_valid = input_ports_3_reset_ccToggle_io_output_valid;
  assign input_ports_3_suspend_ready = input_ports_3_suspend_ccToggle_io_input_ready;
  assign output_ports_3_suspend_valid = input_ports_3_suspend_ccToggle_io_output_valid;
  assign input_ports_3_resume_ready = input_ports_3_resume_ccToggle_io_input_ready;
  assign output_ports_3_resume_valid = input_ports_3_resume_ccToggle_io_output_valid;
  assign input_ports_3_disable_ready = input_ports_3_disable_ccToggle_io_input_ready;
  assign output_ports_3_disable_valid = input_ports_3_disable_ccToggle_io_output_valid;
  always @(posedge phyCd_clk or posedge phyCd_reset) begin
    if(phyCd_reset) begin
      phyCc_input_tx_ccToggle_io_output_rValid <= 1'b0;
    end else begin
      if(input_tx_ccToggle_io_output_ready) begin
        phyCc_input_tx_ccToggle_io_output_rValid <= input_tx_ccToggle_io_output_valid;
      end
    end
  end

  always @(posedge phyCd_clk) begin
    if(input_tx_ccToggle_io_output_ready) begin
      phyCc_input_tx_ccToggle_io_output_rData_last <= input_tx_ccToggle_io_output_payload_last;
      phyCc_input_tx_ccToggle_io_output_rData_fragment <= input_tx_ccToggle_io_output_payload_fragment;
    end
  end


endmodule

module UsbLsFsPhy (
  input  wire          io_ctrl_lowSpeed,
  input  wire          io_ctrl_tx_valid,
  output reg           io_ctrl_tx_ready,
  input  wire          io_ctrl_tx_payload_last,
  input  wire [7:0]    io_ctrl_tx_payload_fragment,
  output reg           io_ctrl_txEop,
  output reg           io_ctrl_rx_flow_valid,
  output reg           io_ctrl_rx_flow_payload_stuffingError,
  output reg  [7:0]    io_ctrl_rx_flow_payload_data,
  output reg           io_ctrl_rx_active,
  input  wire          io_ctrl_usbReset,
  input  wire          io_ctrl_usbResume,
  output wire          io_ctrl_overcurrent,
  output wire          io_ctrl_tick,
  input  wire          io_ctrl_ports_0_disable_valid,
  output wire          io_ctrl_ports_0_disable_ready,
  input  wire          io_ctrl_ports_0_removable,
  input  wire          io_ctrl_ports_0_power,
  input  wire          io_ctrl_ports_0_reset_valid,
  output reg           io_ctrl_ports_0_reset_ready,
  input  wire          io_ctrl_ports_0_suspend_valid,
  output wire          io_ctrl_ports_0_suspend_ready,
  input  wire          io_ctrl_ports_0_resume_valid,
  output wire          io_ctrl_ports_0_resume_ready,
  output reg           io_ctrl_ports_0_connect,
  output wire          io_ctrl_ports_0_disconnect,
  output wire          io_ctrl_ports_0_overcurrent,
  output wire          io_ctrl_ports_0_remoteResume,
  output wire          io_ctrl_ports_0_lowSpeed,
  input  wire          io_ctrl_ports_1_disable_valid,
  output wire          io_ctrl_ports_1_disable_ready,
  input  wire          io_ctrl_ports_1_removable,
  input  wire          io_ctrl_ports_1_power,
  input  wire          io_ctrl_ports_1_reset_valid,
  output reg           io_ctrl_ports_1_reset_ready,
  input  wire          io_ctrl_ports_1_suspend_valid,
  output wire          io_ctrl_ports_1_suspend_ready,
  input  wire          io_ctrl_ports_1_resume_valid,
  output wire          io_ctrl_ports_1_resume_ready,
  output reg           io_ctrl_ports_1_connect,
  output wire          io_ctrl_ports_1_disconnect,
  output wire          io_ctrl_ports_1_overcurrent,
  output wire          io_ctrl_ports_1_remoteResume,
  output wire          io_ctrl_ports_1_lowSpeed,
  input  wire          io_ctrl_ports_2_disable_valid,
  output wire          io_ctrl_ports_2_disable_ready,
  input  wire          io_ctrl_ports_2_removable,
  input  wire          io_ctrl_ports_2_power,
  input  wire          io_ctrl_ports_2_reset_valid,
  output reg           io_ctrl_ports_2_reset_ready,
  input  wire          io_ctrl_ports_2_suspend_valid,
  output wire          io_ctrl_ports_2_suspend_ready,
  input  wire          io_ctrl_ports_2_resume_valid,
  output wire          io_ctrl_ports_2_resume_ready,
  output reg           io_ctrl_ports_2_connect,
  output wire          io_ctrl_ports_2_disconnect,
  output wire          io_ctrl_ports_2_overcurrent,
  output wire          io_ctrl_ports_2_remoteResume,
  output wire          io_ctrl_ports_2_lowSpeed,
  input  wire          io_ctrl_ports_3_disable_valid,
  output wire          io_ctrl_ports_3_disable_ready,
  input  wire          io_ctrl_ports_3_removable,
  input  wire          io_ctrl_ports_3_power,
  input  wire          io_ctrl_ports_3_reset_valid,
  output reg           io_ctrl_ports_3_reset_ready,
  input  wire          io_ctrl_ports_3_suspend_valid,
  output wire          io_ctrl_ports_3_suspend_ready,
  input  wire          io_ctrl_ports_3_resume_valid,
  output wire          io_ctrl_ports_3_resume_ready,
  output reg           io_ctrl_ports_3_connect,
  output wire          io_ctrl_ports_3_disconnect,
  output wire          io_ctrl_ports_3_overcurrent,
  output wire          io_ctrl_ports_3_remoteResume,
  output wire          io_ctrl_ports_3_lowSpeed,
  output reg           io_usb_0_tx_enable,
  output reg           io_usb_0_tx_data,
  output reg           io_usb_0_tx_se0,
  input  wire          io_usb_0_rx_dp,
  input  wire          io_usb_0_rx_dm,
  output reg           io_usb_1_tx_enable,
  output reg           io_usb_1_tx_data,
  output reg           io_usb_1_tx_se0,
  input  wire          io_usb_1_rx_dp,
  input  wire          io_usb_1_rx_dm,
  output reg           io_usb_2_tx_enable,
  output reg           io_usb_2_tx_data,
  output reg           io_usb_2_tx_se0,
  input  wire          io_usb_2_rx_dp,
  input  wire          io_usb_2_rx_dm,
  output reg           io_usb_3_tx_enable,
  output reg           io_usb_3_tx_data,
  output reg           io_usb_3_tx_se0,
  input  wire          io_usb_3_rx_dp,
  input  wire          io_usb_3_rx_dm,
  input  wire          io_management_0_overcurrent,
  output wire          io_management_0_power,
  input  wire          io_management_1_overcurrent,
  output wire          io_management_1_power,
  input  wire          io_management_2_overcurrent,
  output wire          io_management_2_power,
  input  wire          io_management_3_overcurrent,
  output wire          io_management_3_power,
  input  wire          phyCd_clk,
  input  wire          phyCd_reset
);
  localparam txShared_frame_enumDef_BOOT = 4'd0;
  localparam txShared_frame_enumDef_IDLE = 4'd1;
  localparam txShared_frame_enumDef_TAKE_LINE = 4'd2;
  localparam txShared_frame_enumDef_PREAMBLE_SYNC = 4'd3;
  localparam txShared_frame_enumDef_PREAMBLE_PID = 4'd4;
  localparam txShared_frame_enumDef_PREAMBLE_DELAY = 4'd5;
  localparam txShared_frame_enumDef_SYNC = 4'd6;
  localparam txShared_frame_enumDef_DATA = 4'd7;
  localparam txShared_frame_enumDef_EOP_0 = 4'd8;
  localparam txShared_frame_enumDef_EOP_1 = 4'd9;
  localparam txShared_frame_enumDef_EOP_2 = 4'd10;
  localparam ports_0_fsm_enumDef_BOOT = 4'd0;
  localparam ports_0_fsm_enumDef_POWER_OFF = 4'd1;
  localparam ports_0_fsm_enumDef_DISCONNECTED = 4'd2;
  localparam ports_0_fsm_enumDef_DISABLED = 4'd3;
  localparam ports_0_fsm_enumDef_RESETTING = 4'd4;
  localparam ports_0_fsm_enumDef_RESETTING_DELAY = 4'd5;
  localparam ports_0_fsm_enumDef_RESETTING_SYNC = 4'd6;
  localparam ports_0_fsm_enumDef_ENABLED = 4'd7;
  localparam ports_0_fsm_enumDef_SUSPENDED = 4'd8;
  localparam ports_0_fsm_enumDef_RESUMING = 4'd9;
  localparam ports_0_fsm_enumDef_SEND_EOP_0 = 4'd10;
  localparam ports_0_fsm_enumDef_SEND_EOP_1 = 4'd11;
  localparam ports_0_fsm_enumDef_RESTART_S = 4'd12;
  localparam ports_0_fsm_enumDef_RESTART_E = 4'd13;
  localparam ports_1_fsm_enumDef_BOOT = 4'd0;
  localparam ports_1_fsm_enumDef_POWER_OFF = 4'd1;
  localparam ports_1_fsm_enumDef_DISCONNECTED = 4'd2;
  localparam ports_1_fsm_enumDef_DISABLED = 4'd3;
  localparam ports_1_fsm_enumDef_RESETTING = 4'd4;
  localparam ports_1_fsm_enumDef_RESETTING_DELAY = 4'd5;
  localparam ports_1_fsm_enumDef_RESETTING_SYNC = 4'd6;
  localparam ports_1_fsm_enumDef_ENABLED = 4'd7;
  localparam ports_1_fsm_enumDef_SUSPENDED = 4'd8;
  localparam ports_1_fsm_enumDef_RESUMING = 4'd9;
  localparam ports_1_fsm_enumDef_SEND_EOP_0 = 4'd10;
  localparam ports_1_fsm_enumDef_SEND_EOP_1 = 4'd11;
  localparam ports_1_fsm_enumDef_RESTART_S = 4'd12;
  localparam ports_1_fsm_enumDef_RESTART_E = 4'd13;
  localparam ports_2_fsm_enumDef_BOOT = 4'd0;
  localparam ports_2_fsm_enumDef_POWER_OFF = 4'd1;
  localparam ports_2_fsm_enumDef_DISCONNECTED = 4'd2;
  localparam ports_2_fsm_enumDef_DISABLED = 4'd3;
  localparam ports_2_fsm_enumDef_RESETTING = 4'd4;
  localparam ports_2_fsm_enumDef_RESETTING_DELAY = 4'd5;
  localparam ports_2_fsm_enumDef_RESETTING_SYNC = 4'd6;
  localparam ports_2_fsm_enumDef_ENABLED = 4'd7;
  localparam ports_2_fsm_enumDef_SUSPENDED = 4'd8;
  localparam ports_2_fsm_enumDef_RESUMING = 4'd9;
  localparam ports_2_fsm_enumDef_SEND_EOP_0 = 4'd10;
  localparam ports_2_fsm_enumDef_SEND_EOP_1 = 4'd11;
  localparam ports_2_fsm_enumDef_RESTART_S = 4'd12;
  localparam ports_2_fsm_enumDef_RESTART_E = 4'd13;
  localparam ports_3_fsm_enumDef_BOOT = 4'd0;
  localparam ports_3_fsm_enumDef_POWER_OFF = 4'd1;
  localparam ports_3_fsm_enumDef_DISCONNECTED = 4'd2;
  localparam ports_3_fsm_enumDef_DISABLED = 4'd3;
  localparam ports_3_fsm_enumDef_RESETTING = 4'd4;
  localparam ports_3_fsm_enumDef_RESETTING_DELAY = 4'd5;
  localparam ports_3_fsm_enumDef_RESETTING_SYNC = 4'd6;
  localparam ports_3_fsm_enumDef_ENABLED = 4'd7;
  localparam ports_3_fsm_enumDef_SUSPENDED = 4'd8;
  localparam ports_3_fsm_enumDef_RESUMING = 4'd9;
  localparam ports_3_fsm_enumDef_SEND_EOP_0 = 4'd10;
  localparam ports_3_fsm_enumDef_SEND_EOP_1 = 4'd11;
  localparam ports_3_fsm_enumDef_RESTART_S = 4'd12;
  localparam ports_3_fsm_enumDef_RESTART_E = 4'd13;
  localparam upstreamRx_enumDef_BOOT = 2'd0;
  localparam upstreamRx_enumDef_IDLE = 2'd1;
  localparam upstreamRx_enumDef_SUSPEND = 2'd2;
  localparam ports_0_rx_packet_enumDef_BOOT = 2'd0;
  localparam ports_0_rx_packet_enumDef_IDLE = 2'd1;
  localparam ports_0_rx_packet_enumDef_PACKET = 2'd2;
  localparam ports_0_rx_packet_enumDef_ERRORED = 2'd3;
  localparam ports_1_rx_packet_enumDef_BOOT = 2'd0;
  localparam ports_1_rx_packet_enumDef_IDLE = 2'd1;
  localparam ports_1_rx_packet_enumDef_PACKET = 2'd2;
  localparam ports_1_rx_packet_enumDef_ERRORED = 2'd3;
  localparam ports_2_rx_packet_enumDef_BOOT = 2'd0;
  localparam ports_2_rx_packet_enumDef_IDLE = 2'd1;
  localparam ports_2_rx_packet_enumDef_PACKET = 2'd2;
  localparam ports_2_rx_packet_enumDef_ERRORED = 2'd3;
  localparam ports_3_rx_packet_enumDef_BOOT = 2'd0;
  localparam ports_3_rx_packet_enumDef_IDLE = 2'd1;
  localparam ports_3_rx_packet_enumDef_PACKET = 2'd2;
  localparam ports_3_rx_packet_enumDef_ERRORED = 2'd3;

  wire                ports_0_filter_io_filtred_dp;
  wire                ports_0_filter_io_filtred_dm;
  wire                ports_0_filter_io_filtred_d;
  wire                ports_0_filter_io_filtred_se0;
  wire                ports_0_filter_io_filtred_sample;
  wire                ports_1_filter_io_filtred_dp;
  wire                ports_1_filter_io_filtred_dm;
  wire                ports_1_filter_io_filtred_d;
  wire                ports_1_filter_io_filtred_se0;
  wire                ports_1_filter_io_filtred_sample;
  wire                ports_2_filter_io_filtred_dp;
  wire                ports_2_filter_io_filtred_dm;
  wire                ports_2_filter_io_filtred_d;
  wire                ports_2_filter_io_filtred_se0;
  wire                ports_2_filter_io_filtred_sample;
  wire                ports_3_filter_io_filtred_dp;
  wire                ports_3_filter_io_filtred_dm;
  wire                ports_3_filter_io_filtred_d;
  wire                ports_3_filter_io_filtred_se0;
  wire                ports_3_filter_io_filtred_sample;
  wire       [1:0]    _zz_tickTimer_counter_valueNext;
  wire       [0:0]    _zz_tickTimer_counter_valueNext_1;
  wire       [9:0]    _zz_txShared_timer_oneCycle;
  wire       [4:0]    _zz_txShared_timer_oneCycle_1;
  wire       [9:0]    _zz_txShared_timer_twoCycle;
  wire       [5:0]    _zz_txShared_timer_twoCycle_1;
  wire       [9:0]    _zz_txShared_timer_fourCycle;
  wire       [7:0]    _zz_txShared_timer_fourCycle_1;
  wire       [8:0]    _zz_txShared_rxToTxDelay_twoCycle;
  wire       [6:0]    _zz_txShared_rxToTxDelay_twoCycle_1;
  wire       [1:0]    _zz_txShared_lowSpeedSof_state;
  wire       [0:0]    _zz_txShared_lowSpeedSof_state_1;
  wire       [6:0]    _zz_when_UsbHubPhy_l501;
  wire       [11:0]   _zz_ports_0_rx_packet_errorTimeout_trigger;
  wire       [9:0]    _zz_ports_0_rx_packet_errorTimeout_trigger_1;
  wire       [6:0]    _zz_ports_0_rx_disconnect_counter;
  wire       [0:0]    _zz_ports_0_rx_disconnect_counter_1;
  wire       [23:0]   _zz_ports_0_fsm_timer_ONE_BIT;
  wire       [4:0]    _zz_ports_0_fsm_timer_ONE_BIT_1;
  wire       [23:0]   _zz_ports_0_fsm_timer_TWO_BIT;
  wire       [5:0]    _zz_ports_0_fsm_timer_TWO_BIT_1;
  wire       [6:0]    _zz_when_UsbHubPhy_l501_1;
  wire       [11:0]   _zz_ports_1_rx_packet_errorTimeout_trigger;
  wire       [9:0]    _zz_ports_1_rx_packet_errorTimeout_trigger_1;
  wire       [6:0]    _zz_ports_1_rx_disconnect_counter;
  wire       [0:0]    _zz_ports_1_rx_disconnect_counter_1;
  wire       [23:0]   _zz_ports_1_fsm_timer_ONE_BIT;
  wire       [4:0]    _zz_ports_1_fsm_timer_ONE_BIT_1;
  wire       [23:0]   _zz_ports_1_fsm_timer_TWO_BIT;
  wire       [5:0]    _zz_ports_1_fsm_timer_TWO_BIT_1;
  wire       [6:0]    _zz_when_UsbHubPhy_l501_2;
  wire       [11:0]   _zz_ports_2_rx_packet_errorTimeout_trigger;
  wire       [9:0]    _zz_ports_2_rx_packet_errorTimeout_trigger_1;
  wire       [6:0]    _zz_ports_2_rx_disconnect_counter;
  wire       [0:0]    _zz_ports_2_rx_disconnect_counter_1;
  wire       [23:0]   _zz_ports_2_fsm_timer_ONE_BIT;
  wire       [4:0]    _zz_ports_2_fsm_timer_ONE_BIT_1;
  wire       [23:0]   _zz_ports_2_fsm_timer_TWO_BIT;
  wire       [5:0]    _zz_ports_2_fsm_timer_TWO_BIT_1;
  wire       [6:0]    _zz_when_UsbHubPhy_l501_3;
  wire       [11:0]   _zz_ports_3_rx_packet_errorTimeout_trigger;
  wire       [9:0]    _zz_ports_3_rx_packet_errorTimeout_trigger_1;
  wire       [6:0]    _zz_ports_3_rx_disconnect_counter;
  wire       [0:0]    _zz_ports_3_rx_disconnect_counter_1;
  wire       [23:0]   _zz_ports_3_fsm_timer_ONE_BIT;
  wire       [4:0]    _zz_ports_3_fsm_timer_ONE_BIT_1;
  wire       [23:0]   _zz_ports_3_fsm_timer_TWO_BIT;
  wire       [5:0]    _zz_ports_3_fsm_timer_TWO_BIT_1;
  wire                tickTimer_counter_willIncrement;
  wire                tickTimer_counter_willClear;
  reg        [1:0]    tickTimer_counter_valueNext;
  reg        [1:0]    tickTimer_counter_value;
  wire                tickTimer_counter_willOverflowIfInc;
  wire                tickTimer_counter_willOverflow;
  wire                tickTimer_tick;
  reg                 txShared_timer_lowSpeed;
  reg        [9:0]    txShared_timer_counter;
  reg                 txShared_timer_clear;
  wire                txShared_timer_inc;
  wire                txShared_timer_oneCycle;
  wire                txShared_timer_twoCycle;
  wire                txShared_timer_fourCycle;
  reg                 txShared_rxToTxDelay_lowSpeed;
  reg        [8:0]    txShared_rxToTxDelay_counter;
  reg                 txShared_rxToTxDelay_clear;
  wire                txShared_rxToTxDelay_inc;
  wire                txShared_rxToTxDelay_twoCycle;
  reg                 txShared_rxToTxDelay_active;
  reg                 txShared_encoder_input_valid;
  reg                 txShared_encoder_input_ready;
  reg                 txShared_encoder_input_data;
  reg                 txShared_encoder_input_lowSpeed;
  reg                 txShared_encoder_output_valid;
  reg                 txShared_encoder_output_se0;
  reg                 txShared_encoder_output_lowSpeed;
  reg                 txShared_encoder_output_data;
  reg        [2:0]    txShared_encoder_counter;
  reg                 txShared_encoder_state;
  wire                when_UsbHubPhy_l189;
  wire                when_UsbHubPhy_l194;
  wire                when_UsbHubPhy_l208;
  reg                 txShared_serialiser_input_valid;
  reg                 txShared_serialiser_input_ready;
  reg        [7:0]    txShared_serialiser_input_data;
  reg                 txShared_serialiser_input_lowSpeed;
  reg        [2:0]    txShared_serialiser_bitCounter;
  wire                when_UsbHubPhy_l234;
  wire                when_UsbHubPhy_l240;
  reg        [4:0]    txShared_lowSpeedSof_timer;
  reg        [1:0]    txShared_lowSpeedSof_state;
  reg                 txShared_lowSpeedSof_increment;
  reg                 txShared_lowSpeedSof_overrideEncoder;
  reg                 txShared_encoder_output_valid_regNext;
  wire                when_UsbHubPhy_l249;
  wire                when_UsbHubPhy_l251;
  wire                io_ctrl_tx_fire;
  reg                 io_ctrl_tx_payload_first;
  wire                when_UsbHubPhy_l252;
  wire                when_UsbHubPhy_l259;
  wire                txShared_lowSpeedSof_valid;
  wire                txShared_lowSpeedSof_data;
  wire                txShared_lowSpeedSof_se0;
  wire                txShared_frame_wantExit;
  reg                 txShared_frame_wantStart;
  wire                txShared_frame_wantKill;
  wire                txShared_frame_busy;
  reg                 txShared_frame_wasLowSpeed;
  wire                upstreamRx_wantExit;
  reg                 upstreamRx_wantStart;
  wire                upstreamRx_wantKill;
  wire                upstreamRx_timer_lowSpeed;
  reg        [19:0]   upstreamRx_timer_counter;
  reg                 upstreamRx_timer_clear;
  wire                upstreamRx_timer_inc;
  wire                upstreamRx_timer_IDLE_EOI;
  wire                Rx_Suspend;
  reg                 resumeFromPort;
  reg                 ports_0_portLowSpeed;
  reg                 ports_0_rx_enablePackets;
  wire                ports_0_rx_j;
  wire                ports_0_rx_k;
  reg                 ports_0_rx_stuffingError;
  reg                 ports_0_rx_waitSync;
  reg                 ports_0_rx_decoder_state;
  reg                 ports_0_rx_decoder_output_valid;
  reg                 ports_0_rx_decoder_output_payload;
  wire                when_UsbHubPhy_l445;
  reg        [2:0]    ports_0_rx_destuffer_counter;
  wire                ports_0_rx_destuffer_unstuffNext;
  wire                ports_0_rx_destuffer_output_valid;
  wire                ports_0_rx_destuffer_output_payload;
  wire                when_UsbHubPhy_l466;
  wire                ports_0_rx_history_updated;
  wire                _zz_ports_0_rx_history_value;
  reg                 _zz_ports_0_rx_history_value_1;
  reg                 _zz_ports_0_rx_history_value_2;
  reg                 _zz_ports_0_rx_history_value_3;
  reg                 _zz_ports_0_rx_history_value_4;
  reg                 _zz_ports_0_rx_history_value_5;
  reg                 _zz_ports_0_rx_history_value_6;
  reg                 _zz_ports_0_rx_history_value_7;
  wire       [7:0]    ports_0_rx_history_value;
  wire                ports_0_rx_history_sync_hit;
  wire       [6:0]    ports_0_rx_eop_maxThreshold;
  wire       [5:0]    ports_0_rx_eop_minThreshold;
  reg        [6:0]    ports_0_rx_eop_counter;
  wire                ports_0_rx_eop_maxHit;
  reg                 ports_0_rx_eop_hit;
  wire                when_UsbHubPhy_l493;
  wire                when_UsbHubPhy_l494;
  wire                when_UsbHubPhy_l501;
  wire                ports_0_rx_packet_wantExit;
  reg                 ports_0_rx_packet_wantStart;
  wire                ports_0_rx_packet_wantKill;
  reg        [2:0]    ports_0_rx_packet_counter;
  wire                ports_0_rx_packet_errorTimeout_lowSpeed;
  reg        [11:0]   ports_0_rx_packet_errorTimeout_counter;
  reg                 ports_0_rx_packet_errorTimeout_clear;
  wire                ports_0_rx_packet_errorTimeout_inc;
  wire                ports_0_rx_packet_errorTimeout_trigger;
  reg                 ports_0_rx_packet_errorTimeout_p;
  reg                 ports_0_rx_packet_errorTimeout_n;
  reg        [6:0]    ports_0_rx_disconnect_counter;
  reg                 ports_0_rx_disconnect_clear;
  wire                ports_0_rx_disconnect_hit;
  reg                 ports_0_rx_disconnect_hitLast;
  wire                ports_0_rx_disconnect_event;
  wire                when_UsbHubPhy_l573;
  wire                ports_0_fsm_wantExit;
  reg                 ports_0_fsm_wantStart;
  wire                ports_0_fsm_wantKill;
  reg                 ports_0_fsm_timer_lowSpeed;
  reg        [23:0]   ports_0_fsm_timer_counter;
  reg                 ports_0_fsm_timer_clear;
  wire                ports_0_fsm_timer_inc;
  wire                ports_0_fsm_timer_DISCONNECTED_EOI;
  wire                ports_0_fsm_timer_RESET_DELAY;
  wire                ports_0_fsm_timer_RESET_EOI;
  wire                ports_0_fsm_timer_RESUME_EOI;
  wire                ports_0_fsm_timer_RESTART_EOI;
  wire                ports_0_fsm_timer_ONE_BIT;
  wire                ports_0_fsm_timer_TWO_BIT;
  reg                 ports_0_fsm_resetInProgress;
  reg                 ports_0_fsm_lowSpeedEop;
  wire                ports_0_fsm_forceJ;
  wire                when_UsbHubPhy_l767;
  reg                 ports_1_portLowSpeed;
  reg                 ports_1_rx_enablePackets;
  wire                ports_1_rx_j;
  wire                ports_1_rx_k;
  reg                 ports_1_rx_stuffingError;
  reg                 ports_1_rx_waitSync;
  reg                 ports_1_rx_decoder_state;
  reg                 ports_1_rx_decoder_output_valid;
  reg                 ports_1_rx_decoder_output_payload;
  wire                when_UsbHubPhy_l445_1;
  reg        [2:0]    ports_1_rx_destuffer_counter;
  wire                ports_1_rx_destuffer_unstuffNext;
  wire                ports_1_rx_destuffer_output_valid;
  wire                ports_1_rx_destuffer_output_payload;
  wire                when_UsbHubPhy_l466_1;
  wire                ports_1_rx_history_updated;
  wire                _zz_ports_1_rx_history_value;
  reg                 _zz_ports_1_rx_history_value_1;
  reg                 _zz_ports_1_rx_history_value_2;
  reg                 _zz_ports_1_rx_history_value_3;
  reg                 _zz_ports_1_rx_history_value_4;
  reg                 _zz_ports_1_rx_history_value_5;
  reg                 _zz_ports_1_rx_history_value_6;
  reg                 _zz_ports_1_rx_history_value_7;
  wire       [7:0]    ports_1_rx_history_value;
  wire                ports_1_rx_history_sync_hit;
  wire       [6:0]    ports_1_rx_eop_maxThreshold;
  wire       [5:0]    ports_1_rx_eop_minThreshold;
  reg        [6:0]    ports_1_rx_eop_counter;
  wire                ports_1_rx_eop_maxHit;
  reg                 ports_1_rx_eop_hit;
  wire                when_UsbHubPhy_l493_1;
  wire                when_UsbHubPhy_l494_1;
  wire                when_UsbHubPhy_l501_1;
  wire                ports_1_rx_packet_wantExit;
  reg                 ports_1_rx_packet_wantStart;
  wire                ports_1_rx_packet_wantKill;
  reg        [2:0]    ports_1_rx_packet_counter;
  wire                ports_1_rx_packet_errorTimeout_lowSpeed;
  reg        [11:0]   ports_1_rx_packet_errorTimeout_counter;
  reg                 ports_1_rx_packet_errorTimeout_clear;
  wire                ports_1_rx_packet_errorTimeout_inc;
  wire                ports_1_rx_packet_errorTimeout_trigger;
  reg                 ports_1_rx_packet_errorTimeout_p;
  reg                 ports_1_rx_packet_errorTimeout_n;
  reg        [6:0]    ports_1_rx_disconnect_counter;
  reg                 ports_1_rx_disconnect_clear;
  wire                ports_1_rx_disconnect_hit;
  reg                 ports_1_rx_disconnect_hitLast;
  wire                ports_1_rx_disconnect_event;
  wire                when_UsbHubPhy_l573_1;
  wire                ports_1_fsm_wantExit;
  reg                 ports_1_fsm_wantStart;
  wire                ports_1_fsm_wantKill;
  reg                 ports_1_fsm_timer_lowSpeed;
  reg        [23:0]   ports_1_fsm_timer_counter;
  reg                 ports_1_fsm_timer_clear;
  wire                ports_1_fsm_timer_inc;
  wire                ports_1_fsm_timer_DISCONNECTED_EOI;
  wire                ports_1_fsm_timer_RESET_DELAY;
  wire                ports_1_fsm_timer_RESET_EOI;
  wire                ports_1_fsm_timer_RESUME_EOI;
  wire                ports_1_fsm_timer_RESTART_EOI;
  wire                ports_1_fsm_timer_ONE_BIT;
  wire                ports_1_fsm_timer_TWO_BIT;
  reg                 ports_1_fsm_resetInProgress;
  reg                 ports_1_fsm_lowSpeedEop;
  wire                ports_1_fsm_forceJ;
  wire                when_UsbHubPhy_l767_1;
  reg                 ports_2_portLowSpeed;
  reg                 ports_2_rx_enablePackets;
  wire                ports_2_rx_j;
  wire                ports_2_rx_k;
  reg                 ports_2_rx_stuffingError;
  reg                 ports_2_rx_waitSync;
  reg                 ports_2_rx_decoder_state;
  reg                 ports_2_rx_decoder_output_valid;
  reg                 ports_2_rx_decoder_output_payload;
  wire                when_UsbHubPhy_l445_2;
  reg        [2:0]    ports_2_rx_destuffer_counter;
  wire                ports_2_rx_destuffer_unstuffNext;
  wire                ports_2_rx_destuffer_output_valid;
  wire                ports_2_rx_destuffer_output_payload;
  wire                when_UsbHubPhy_l466_2;
  wire                ports_2_rx_history_updated;
  wire                _zz_ports_2_rx_history_value;
  reg                 _zz_ports_2_rx_history_value_1;
  reg                 _zz_ports_2_rx_history_value_2;
  reg                 _zz_ports_2_rx_history_value_3;
  reg                 _zz_ports_2_rx_history_value_4;
  reg                 _zz_ports_2_rx_history_value_5;
  reg                 _zz_ports_2_rx_history_value_6;
  reg                 _zz_ports_2_rx_history_value_7;
  wire       [7:0]    ports_2_rx_history_value;
  wire                ports_2_rx_history_sync_hit;
  wire       [6:0]    ports_2_rx_eop_maxThreshold;
  wire       [5:0]    ports_2_rx_eop_minThreshold;
  reg        [6:0]    ports_2_rx_eop_counter;
  wire                ports_2_rx_eop_maxHit;
  reg                 ports_2_rx_eop_hit;
  wire                when_UsbHubPhy_l493_2;
  wire                when_UsbHubPhy_l494_2;
  wire                when_UsbHubPhy_l501_2;
  wire                ports_2_rx_packet_wantExit;
  reg                 ports_2_rx_packet_wantStart;
  wire                ports_2_rx_packet_wantKill;
  reg        [2:0]    ports_2_rx_packet_counter;
  wire                ports_2_rx_packet_errorTimeout_lowSpeed;
  reg        [11:0]   ports_2_rx_packet_errorTimeout_counter;
  reg                 ports_2_rx_packet_errorTimeout_clear;
  wire                ports_2_rx_packet_errorTimeout_inc;
  wire                ports_2_rx_packet_errorTimeout_trigger;
  reg                 ports_2_rx_packet_errorTimeout_p;
  reg                 ports_2_rx_packet_errorTimeout_n;
  reg        [6:0]    ports_2_rx_disconnect_counter;
  reg                 ports_2_rx_disconnect_clear;
  wire                ports_2_rx_disconnect_hit;
  reg                 ports_2_rx_disconnect_hitLast;
  wire                ports_2_rx_disconnect_event;
  wire                when_UsbHubPhy_l573_2;
  wire                ports_2_fsm_wantExit;
  reg                 ports_2_fsm_wantStart;
  wire                ports_2_fsm_wantKill;
  reg                 ports_2_fsm_timer_lowSpeed;
  reg        [23:0]   ports_2_fsm_timer_counter;
  reg                 ports_2_fsm_timer_clear;
  wire                ports_2_fsm_timer_inc;
  wire                ports_2_fsm_timer_DISCONNECTED_EOI;
  wire                ports_2_fsm_timer_RESET_DELAY;
  wire                ports_2_fsm_timer_RESET_EOI;
  wire                ports_2_fsm_timer_RESUME_EOI;
  wire                ports_2_fsm_timer_RESTART_EOI;
  wire                ports_2_fsm_timer_ONE_BIT;
  wire                ports_2_fsm_timer_TWO_BIT;
  reg                 ports_2_fsm_resetInProgress;
  reg                 ports_2_fsm_lowSpeedEop;
  wire                ports_2_fsm_forceJ;
  wire                when_UsbHubPhy_l767_2;
  reg                 ports_3_portLowSpeed;
  reg                 ports_3_rx_enablePackets;
  wire                ports_3_rx_j;
  wire                ports_3_rx_k;
  reg                 ports_3_rx_stuffingError;
  reg                 ports_3_rx_waitSync;
  reg                 ports_3_rx_decoder_state;
  reg                 ports_3_rx_decoder_output_valid;
  reg                 ports_3_rx_decoder_output_payload;
  wire                when_UsbHubPhy_l445_3;
  reg        [2:0]    ports_3_rx_destuffer_counter;
  wire                ports_3_rx_destuffer_unstuffNext;
  wire                ports_3_rx_destuffer_output_valid;
  wire                ports_3_rx_destuffer_output_payload;
  wire                when_UsbHubPhy_l466_3;
  wire                ports_3_rx_history_updated;
  wire                _zz_ports_3_rx_history_value;
  reg                 _zz_ports_3_rx_history_value_1;
  reg                 _zz_ports_3_rx_history_value_2;
  reg                 _zz_ports_3_rx_history_value_3;
  reg                 _zz_ports_3_rx_history_value_4;
  reg                 _zz_ports_3_rx_history_value_5;
  reg                 _zz_ports_3_rx_history_value_6;
  reg                 _zz_ports_3_rx_history_value_7;
  wire       [7:0]    ports_3_rx_history_value;
  wire                ports_3_rx_history_sync_hit;
  wire       [6:0]    ports_3_rx_eop_maxThreshold;
  wire       [5:0]    ports_3_rx_eop_minThreshold;
  reg        [6:0]    ports_3_rx_eop_counter;
  wire                ports_3_rx_eop_maxHit;
  reg                 ports_3_rx_eop_hit;
  wire                when_UsbHubPhy_l493_3;
  wire                when_UsbHubPhy_l494_3;
  wire                when_UsbHubPhy_l501_3;
  wire                ports_3_rx_packet_wantExit;
  reg                 ports_3_rx_packet_wantStart;
  wire                ports_3_rx_packet_wantKill;
  reg        [2:0]    ports_3_rx_packet_counter;
  wire                ports_3_rx_packet_errorTimeout_lowSpeed;
  reg        [11:0]   ports_3_rx_packet_errorTimeout_counter;
  reg                 ports_3_rx_packet_errorTimeout_clear;
  wire                ports_3_rx_packet_errorTimeout_inc;
  wire                ports_3_rx_packet_errorTimeout_trigger;
  reg                 ports_3_rx_packet_errorTimeout_p;
  reg                 ports_3_rx_packet_errorTimeout_n;
  reg        [6:0]    ports_3_rx_disconnect_counter;
  reg                 ports_3_rx_disconnect_clear;
  wire                ports_3_rx_disconnect_hit;
  reg                 ports_3_rx_disconnect_hitLast;
  wire                ports_3_rx_disconnect_event;
  wire                when_UsbHubPhy_l573_3;
  wire                ports_3_fsm_wantExit;
  reg                 ports_3_fsm_wantStart;
  wire                ports_3_fsm_wantKill;
  reg                 ports_3_fsm_timer_lowSpeed;
  reg        [23:0]   ports_3_fsm_timer_counter;
  reg                 ports_3_fsm_timer_clear;
  wire                ports_3_fsm_timer_inc;
  wire                ports_3_fsm_timer_DISCONNECTED_EOI;
  wire                ports_3_fsm_timer_RESET_DELAY;
  wire                ports_3_fsm_timer_RESET_EOI;
  wire                ports_3_fsm_timer_RESUME_EOI;
  wire                ports_3_fsm_timer_RESTART_EOI;
  wire                ports_3_fsm_timer_ONE_BIT;
  wire                ports_3_fsm_timer_TWO_BIT;
  reg                 ports_3_fsm_resetInProgress;
  reg                 ports_3_fsm_lowSpeedEop;
  wire                ports_3_fsm_forceJ;
  wire                when_UsbHubPhy_l767_3;
  reg        [3:0]    txShared_frame_stateReg;
  reg        [3:0]    txShared_frame_stateNext;
  wire                when_UsbHubPhy_l289;
  reg        [1:0]    upstreamRx_stateReg;
  reg        [1:0]    upstreamRx_stateNext;
  reg        [1:0]    ports_0_rx_packet_stateReg;
  reg        [1:0]    ports_0_rx_packet_stateNext;
  wire                when_UsbHubPhy_l527;
  wire                when_UsbHubPhy_l549;
  wire                when_StateMachine_l253;
  wire                when_StateMachine_l253_1;
  reg        [3:0]    ports_0_fsm_stateReg;
  reg        [3:0]    ports_0_fsm_stateNext;
  wire                when_UsbHubPhy_l638;
  wire                when_UsbHubPhy_l675;
  wire                when_UsbHubPhy_l688;
  wire                when_UsbHubPhy_l697;
  wire                when_UsbHubPhy_l705;
  wire                when_UsbHubPhy_l707;
  wire                when_UsbHubPhy_l748;
  wire                when_UsbHubPhy_l758;
  wire                when_StateMachine_l253_2;
  wire                when_StateMachine_l253_3;
  wire                when_StateMachine_l253_4;
  wire                when_StateMachine_l253_5;
  wire                when_StateMachine_l253_6;
  wire                when_StateMachine_l253_7;
  wire                when_StateMachine_l253_8;
  wire                when_StateMachine_l253_9;
  wire                when_UsbHubPhy_l610;
  wire                when_UsbHubPhy_l617;
  wire                when_UsbHubPhy_l618;
  reg        [1:0]    ports_1_rx_packet_stateReg;
  reg        [1:0]    ports_1_rx_packet_stateNext;
  wire                when_UsbHubPhy_l527_1;
  wire                when_UsbHubPhy_l549_1;
  wire                when_StateMachine_l253_10;
  wire                when_StateMachine_l253_11;
  reg        [3:0]    ports_1_fsm_stateReg;
  reg        [3:0]    ports_1_fsm_stateNext;
  wire                when_UsbHubPhy_l638_1;
  wire                when_UsbHubPhy_l675_1;
  wire                when_UsbHubPhy_l688_1;
  wire                when_UsbHubPhy_l697_1;
  wire                when_UsbHubPhy_l705_1;
  wire                when_UsbHubPhy_l707_1;
  wire                when_UsbHubPhy_l748_1;
  wire                when_UsbHubPhy_l758_1;
  wire                when_StateMachine_l253_12;
  wire                when_StateMachine_l253_13;
  wire                when_StateMachine_l253_14;
  wire                when_StateMachine_l253_15;
  wire                when_StateMachine_l253_16;
  wire                when_StateMachine_l253_17;
  wire                when_StateMachine_l253_18;
  wire                when_StateMachine_l253_19;
  wire                when_UsbHubPhy_l610_1;
  wire                when_UsbHubPhy_l617_1;
  wire                when_UsbHubPhy_l618_1;
  reg        [1:0]    ports_2_rx_packet_stateReg;
  reg        [1:0]    ports_2_rx_packet_stateNext;
  wire                when_UsbHubPhy_l527_2;
  wire                when_UsbHubPhy_l549_2;
  wire                when_StateMachine_l253_20;
  wire                when_StateMachine_l253_21;
  reg        [3:0]    ports_2_fsm_stateReg;
  reg        [3:0]    ports_2_fsm_stateNext;
  wire                when_UsbHubPhy_l638_2;
  wire                when_UsbHubPhy_l675_2;
  wire                when_UsbHubPhy_l688_2;
  wire                when_UsbHubPhy_l697_2;
  wire                when_UsbHubPhy_l705_2;
  wire                when_UsbHubPhy_l707_2;
  wire                when_UsbHubPhy_l748_2;
  wire                when_UsbHubPhy_l758_2;
  wire                when_StateMachine_l253_22;
  wire                when_StateMachine_l253_23;
  wire                when_StateMachine_l253_24;
  wire                when_StateMachine_l253_25;
  wire                when_StateMachine_l253_26;
  wire                when_StateMachine_l253_27;
  wire                when_StateMachine_l253_28;
  wire                when_StateMachine_l253_29;
  wire                when_UsbHubPhy_l610_2;
  wire                when_UsbHubPhy_l617_2;
  wire                when_UsbHubPhy_l618_2;
  reg        [1:0]    ports_3_rx_packet_stateReg;
  reg        [1:0]    ports_3_rx_packet_stateNext;
  wire                when_UsbHubPhy_l527_3;
  wire                when_UsbHubPhy_l549_3;
  wire                when_StateMachine_l253_30;
  wire                when_StateMachine_l253_31;
  reg        [3:0]    ports_3_fsm_stateReg;
  reg        [3:0]    ports_3_fsm_stateNext;
  wire                when_UsbHubPhy_l638_3;
  wire                when_UsbHubPhy_l675_3;
  wire                when_UsbHubPhy_l688_3;
  wire                when_UsbHubPhy_l697_3;
  wire                when_UsbHubPhy_l705_3;
  wire                when_UsbHubPhy_l707_3;
  wire                when_UsbHubPhy_l748_3;
  wire                when_UsbHubPhy_l758_3;
  wire                when_StateMachine_l253_32;
  wire                when_StateMachine_l253_33;
  wire                when_StateMachine_l253_34;
  wire                when_StateMachine_l253_35;
  wire                when_StateMachine_l253_36;
  wire                when_StateMachine_l253_37;
  wire                when_StateMachine_l253_38;
  wire                when_StateMachine_l253_39;
  wire                when_UsbHubPhy_l610_3;
  wire                when_UsbHubPhy_l617_3;
  wire                when_UsbHubPhy_l618_3;
  `ifndef SYNTHESIS
  reg [111:0] txShared_frame_stateReg_string;
  reg [111:0] txShared_frame_stateNext_string;
  reg [55:0] upstreamRx_stateReg_string;
  reg [55:0] upstreamRx_stateNext_string;
  reg [55:0] ports_0_rx_packet_stateReg_string;
  reg [55:0] ports_0_rx_packet_stateNext_string;
  reg [119:0] ports_0_fsm_stateReg_string;
  reg [119:0] ports_0_fsm_stateNext_string;
  reg [55:0] ports_1_rx_packet_stateReg_string;
  reg [55:0] ports_1_rx_packet_stateNext_string;
  reg [119:0] ports_1_fsm_stateReg_string;
  reg [119:0] ports_1_fsm_stateNext_string;
  reg [55:0] ports_2_rx_packet_stateReg_string;
  reg [55:0] ports_2_rx_packet_stateNext_string;
  reg [119:0] ports_2_fsm_stateReg_string;
  reg [119:0] ports_2_fsm_stateNext_string;
  reg [55:0] ports_3_rx_packet_stateReg_string;
  reg [55:0] ports_3_rx_packet_stateNext_string;
  reg [119:0] ports_3_fsm_stateReg_string;
  reg [119:0] ports_3_fsm_stateNext_string;
  `endif


  assign _zz_tickTimer_counter_valueNext_1 = tickTimer_counter_willIncrement;
  assign _zz_tickTimer_counter_valueNext = {1'd0, _zz_tickTimer_counter_valueNext_1};
  assign _zz_txShared_timer_oneCycle_1 = (txShared_timer_lowSpeed ? 5'h1f : 5'h03);
  assign _zz_txShared_timer_oneCycle = {5'd0, _zz_txShared_timer_oneCycle_1};
  assign _zz_txShared_timer_twoCycle_1 = (txShared_timer_lowSpeed ? 6'h3f : 6'h07);
  assign _zz_txShared_timer_twoCycle = {4'd0, _zz_txShared_timer_twoCycle_1};
  assign _zz_txShared_timer_fourCycle_1 = (txShared_timer_lowSpeed ? 8'h9f : 8'h13);
  assign _zz_txShared_timer_fourCycle = {2'd0, _zz_txShared_timer_fourCycle_1};
  assign _zz_txShared_rxToTxDelay_twoCycle_1 = (txShared_rxToTxDelay_lowSpeed ? 7'h7f : 7'h0f);
  assign _zz_txShared_rxToTxDelay_twoCycle = {2'd0, _zz_txShared_rxToTxDelay_twoCycle_1};
  assign _zz_txShared_lowSpeedSof_state_1 = txShared_lowSpeedSof_increment;
  assign _zz_txShared_lowSpeedSof_state = {1'd0, _zz_txShared_lowSpeedSof_state_1};
  assign _zz_when_UsbHubPhy_l501 = {1'd0, ports_0_rx_eop_minThreshold};
  assign _zz_ports_0_rx_packet_errorTimeout_trigger_1 = (ports_0_rx_packet_errorTimeout_lowSpeed ? 10'h27f : 10'h04f);
  assign _zz_ports_0_rx_packet_errorTimeout_trigger = {2'd0, _zz_ports_0_rx_packet_errorTimeout_trigger_1};
  assign _zz_ports_0_rx_disconnect_counter_1 = (! ports_0_rx_disconnect_hit);
  assign _zz_ports_0_rx_disconnect_counter = {6'd0, _zz_ports_0_rx_disconnect_counter_1};
  assign _zz_ports_0_fsm_timer_ONE_BIT_1 = (ports_0_fsm_timer_lowSpeed ? 5'h1f : 5'h03);
  assign _zz_ports_0_fsm_timer_ONE_BIT = {19'd0, _zz_ports_0_fsm_timer_ONE_BIT_1};
  assign _zz_ports_0_fsm_timer_TWO_BIT_1 = (ports_0_fsm_timer_lowSpeed ? 6'h3f : 6'h07);
  assign _zz_ports_0_fsm_timer_TWO_BIT = {18'd0, _zz_ports_0_fsm_timer_TWO_BIT_1};
  assign _zz_when_UsbHubPhy_l501_1 = {1'd0, ports_1_rx_eop_minThreshold};
  assign _zz_ports_1_rx_packet_errorTimeout_trigger_1 = (ports_1_rx_packet_errorTimeout_lowSpeed ? 10'h27f : 10'h04f);
  assign _zz_ports_1_rx_packet_errorTimeout_trigger = {2'd0, _zz_ports_1_rx_packet_errorTimeout_trigger_1};
  assign _zz_ports_1_rx_disconnect_counter_1 = (! ports_1_rx_disconnect_hit);
  assign _zz_ports_1_rx_disconnect_counter = {6'd0, _zz_ports_1_rx_disconnect_counter_1};
  assign _zz_ports_1_fsm_timer_ONE_BIT_1 = (ports_1_fsm_timer_lowSpeed ? 5'h1f : 5'h03);
  assign _zz_ports_1_fsm_timer_ONE_BIT = {19'd0, _zz_ports_1_fsm_timer_ONE_BIT_1};
  assign _zz_ports_1_fsm_timer_TWO_BIT_1 = (ports_1_fsm_timer_lowSpeed ? 6'h3f : 6'h07);
  assign _zz_ports_1_fsm_timer_TWO_BIT = {18'd0, _zz_ports_1_fsm_timer_TWO_BIT_1};
  assign _zz_when_UsbHubPhy_l501_2 = {1'd0, ports_2_rx_eop_minThreshold};
  assign _zz_ports_2_rx_packet_errorTimeout_trigger_1 = (ports_2_rx_packet_errorTimeout_lowSpeed ? 10'h27f : 10'h04f);
  assign _zz_ports_2_rx_packet_errorTimeout_trigger = {2'd0, _zz_ports_2_rx_packet_errorTimeout_trigger_1};
  assign _zz_ports_2_rx_disconnect_counter_1 = (! ports_2_rx_disconnect_hit);
  assign _zz_ports_2_rx_disconnect_counter = {6'd0, _zz_ports_2_rx_disconnect_counter_1};
  assign _zz_ports_2_fsm_timer_ONE_BIT_1 = (ports_2_fsm_timer_lowSpeed ? 5'h1f : 5'h03);
  assign _zz_ports_2_fsm_timer_ONE_BIT = {19'd0, _zz_ports_2_fsm_timer_ONE_BIT_1};
  assign _zz_ports_2_fsm_timer_TWO_BIT_1 = (ports_2_fsm_timer_lowSpeed ? 6'h3f : 6'h07);
  assign _zz_ports_2_fsm_timer_TWO_BIT = {18'd0, _zz_ports_2_fsm_timer_TWO_BIT_1};
  assign _zz_when_UsbHubPhy_l501_3 = {1'd0, ports_3_rx_eop_minThreshold};
  assign _zz_ports_3_rx_packet_errorTimeout_trigger_1 = (ports_3_rx_packet_errorTimeout_lowSpeed ? 10'h27f : 10'h04f);
  assign _zz_ports_3_rx_packet_errorTimeout_trigger = {2'd0, _zz_ports_3_rx_packet_errorTimeout_trigger_1};
  assign _zz_ports_3_rx_disconnect_counter_1 = (! ports_3_rx_disconnect_hit);
  assign _zz_ports_3_rx_disconnect_counter = {6'd0, _zz_ports_3_rx_disconnect_counter_1};
  assign _zz_ports_3_fsm_timer_ONE_BIT_1 = (ports_3_fsm_timer_lowSpeed ? 5'h1f : 5'h03);
  assign _zz_ports_3_fsm_timer_ONE_BIT = {19'd0, _zz_ports_3_fsm_timer_ONE_BIT_1};
  assign _zz_ports_3_fsm_timer_TWO_BIT_1 = (ports_3_fsm_timer_lowSpeed ? 6'h3f : 6'h07);
  assign _zz_ports_3_fsm_timer_TWO_BIT = {18'd0, _zz_ports_3_fsm_timer_TWO_BIT_1};
  UsbLsFsPhyFilter ports_0_filter (
    .io_lowSpeed       (io_ctrl_lowSpeed                ), //i
    .io_usb_dp         (io_usb_0_rx_dp                  ), //i
    .io_usb_dm         (io_usb_0_rx_dm                  ), //i
    .io_filtred_dp     (ports_0_filter_io_filtred_dp    ), //o
    .io_filtred_dm     (ports_0_filter_io_filtred_dm    ), //o
    .io_filtred_d      (ports_0_filter_io_filtred_d     ), //o
    .io_filtred_se0    (ports_0_filter_io_filtred_se0   ), //o
    .io_filtred_sample (ports_0_filter_io_filtred_sample), //o
    .phyCd_clk         (phyCd_clk                       ), //i
    .phyCd_reset       (phyCd_reset                     )  //i
  );
  UsbLsFsPhyFilter ports_1_filter (
    .io_lowSpeed       (io_ctrl_lowSpeed                ), //i
    .io_usb_dp         (io_usb_1_rx_dp                  ), //i
    .io_usb_dm         (io_usb_1_rx_dm                  ), //i
    .io_filtred_dp     (ports_1_filter_io_filtred_dp    ), //o
    .io_filtred_dm     (ports_1_filter_io_filtred_dm    ), //o
    .io_filtred_d      (ports_1_filter_io_filtred_d     ), //o
    .io_filtred_se0    (ports_1_filter_io_filtred_se0   ), //o
    .io_filtred_sample (ports_1_filter_io_filtred_sample), //o
    .phyCd_clk         (phyCd_clk                       ), //i
    .phyCd_reset       (phyCd_reset                     )  //i
  );
  UsbLsFsPhyFilter ports_2_filter (
    .io_lowSpeed       (io_ctrl_lowSpeed                ), //i
    .io_usb_dp         (io_usb_2_rx_dp                  ), //i
    .io_usb_dm         (io_usb_2_rx_dm                  ), //i
    .io_filtred_dp     (ports_2_filter_io_filtred_dp    ), //o
    .io_filtred_dm     (ports_2_filter_io_filtred_dm    ), //o
    .io_filtred_d      (ports_2_filter_io_filtred_d     ), //o
    .io_filtred_se0    (ports_2_filter_io_filtred_se0   ), //o
    .io_filtred_sample (ports_2_filter_io_filtred_sample), //o
    .phyCd_clk         (phyCd_clk                       ), //i
    .phyCd_reset       (phyCd_reset                     )  //i
  );
  UsbLsFsPhyFilter ports_3_filter (
    .io_lowSpeed       (io_ctrl_lowSpeed                ), //i
    .io_usb_dp         (io_usb_3_rx_dp                  ), //i
    .io_usb_dm         (io_usb_3_rx_dm                  ), //i
    .io_filtred_dp     (ports_3_filter_io_filtred_dp    ), //o
    .io_filtred_dm     (ports_3_filter_io_filtred_dm    ), //o
    .io_filtred_d      (ports_3_filter_io_filtred_d     ), //o
    .io_filtred_se0    (ports_3_filter_io_filtred_se0   ), //o
    .io_filtred_sample (ports_3_filter_io_filtred_sample), //o
    .phyCd_clk         (phyCd_clk                       ), //i
    .phyCd_reset       (phyCd_reset                     )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_BOOT : txShared_frame_stateReg_string = "BOOT          ";
      txShared_frame_enumDef_IDLE : txShared_frame_stateReg_string = "IDLE          ";
      txShared_frame_enumDef_TAKE_LINE : txShared_frame_stateReg_string = "TAKE_LINE     ";
      txShared_frame_enumDef_PREAMBLE_SYNC : txShared_frame_stateReg_string = "PREAMBLE_SYNC ";
      txShared_frame_enumDef_PREAMBLE_PID : txShared_frame_stateReg_string = "PREAMBLE_PID  ";
      txShared_frame_enumDef_PREAMBLE_DELAY : txShared_frame_stateReg_string = "PREAMBLE_DELAY";
      txShared_frame_enumDef_SYNC : txShared_frame_stateReg_string = "SYNC          ";
      txShared_frame_enumDef_DATA : txShared_frame_stateReg_string = "DATA          ";
      txShared_frame_enumDef_EOP_0 : txShared_frame_stateReg_string = "EOP_0         ";
      txShared_frame_enumDef_EOP_1 : txShared_frame_stateReg_string = "EOP_1         ";
      txShared_frame_enumDef_EOP_2 : txShared_frame_stateReg_string = "EOP_2         ";
      default : txShared_frame_stateReg_string = "??????????????";
    endcase
  end
  always @(*) begin
    case(txShared_frame_stateNext)
      txShared_frame_enumDef_BOOT : txShared_frame_stateNext_string = "BOOT          ";
      txShared_frame_enumDef_IDLE : txShared_frame_stateNext_string = "IDLE          ";
      txShared_frame_enumDef_TAKE_LINE : txShared_frame_stateNext_string = "TAKE_LINE     ";
      txShared_frame_enumDef_PREAMBLE_SYNC : txShared_frame_stateNext_string = "PREAMBLE_SYNC ";
      txShared_frame_enumDef_PREAMBLE_PID : txShared_frame_stateNext_string = "PREAMBLE_PID  ";
      txShared_frame_enumDef_PREAMBLE_DELAY : txShared_frame_stateNext_string = "PREAMBLE_DELAY";
      txShared_frame_enumDef_SYNC : txShared_frame_stateNext_string = "SYNC          ";
      txShared_frame_enumDef_DATA : txShared_frame_stateNext_string = "DATA          ";
      txShared_frame_enumDef_EOP_0 : txShared_frame_stateNext_string = "EOP_0         ";
      txShared_frame_enumDef_EOP_1 : txShared_frame_stateNext_string = "EOP_1         ";
      txShared_frame_enumDef_EOP_2 : txShared_frame_stateNext_string = "EOP_2         ";
      default : txShared_frame_stateNext_string = "??????????????";
    endcase
  end
  always @(*) begin
    case(upstreamRx_stateReg)
      upstreamRx_enumDef_BOOT : upstreamRx_stateReg_string = "BOOT   ";
      upstreamRx_enumDef_IDLE : upstreamRx_stateReg_string = "IDLE   ";
      upstreamRx_enumDef_SUSPEND : upstreamRx_stateReg_string = "SUSPEND";
      default : upstreamRx_stateReg_string = "???????";
    endcase
  end
  always @(*) begin
    case(upstreamRx_stateNext)
      upstreamRx_enumDef_BOOT : upstreamRx_stateNext_string = "BOOT   ";
      upstreamRx_enumDef_IDLE : upstreamRx_stateNext_string = "IDLE   ";
      upstreamRx_enumDef_SUSPEND : upstreamRx_stateNext_string = "SUSPEND";
      default : upstreamRx_stateNext_string = "???????";
    endcase
  end
  always @(*) begin
    case(ports_0_rx_packet_stateReg)
      ports_0_rx_packet_enumDef_BOOT : ports_0_rx_packet_stateReg_string = "BOOT   ";
      ports_0_rx_packet_enumDef_IDLE : ports_0_rx_packet_stateReg_string = "IDLE   ";
      ports_0_rx_packet_enumDef_PACKET : ports_0_rx_packet_stateReg_string = "PACKET ";
      ports_0_rx_packet_enumDef_ERRORED : ports_0_rx_packet_stateReg_string = "ERRORED";
      default : ports_0_rx_packet_stateReg_string = "???????";
    endcase
  end
  always @(*) begin
    case(ports_0_rx_packet_stateNext)
      ports_0_rx_packet_enumDef_BOOT : ports_0_rx_packet_stateNext_string = "BOOT   ";
      ports_0_rx_packet_enumDef_IDLE : ports_0_rx_packet_stateNext_string = "IDLE   ";
      ports_0_rx_packet_enumDef_PACKET : ports_0_rx_packet_stateNext_string = "PACKET ";
      ports_0_rx_packet_enumDef_ERRORED : ports_0_rx_packet_stateNext_string = "ERRORED";
      default : ports_0_rx_packet_stateNext_string = "???????";
    endcase
  end
  always @(*) begin
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_BOOT : ports_0_fsm_stateReg_string = "BOOT           ";
      ports_0_fsm_enumDef_POWER_OFF : ports_0_fsm_stateReg_string = "POWER_OFF      ";
      ports_0_fsm_enumDef_DISCONNECTED : ports_0_fsm_stateReg_string = "DISCONNECTED   ";
      ports_0_fsm_enumDef_DISABLED : ports_0_fsm_stateReg_string = "DISABLED       ";
      ports_0_fsm_enumDef_RESETTING : ports_0_fsm_stateReg_string = "RESETTING      ";
      ports_0_fsm_enumDef_RESETTING_DELAY : ports_0_fsm_stateReg_string = "RESETTING_DELAY";
      ports_0_fsm_enumDef_RESETTING_SYNC : ports_0_fsm_stateReg_string = "RESETTING_SYNC ";
      ports_0_fsm_enumDef_ENABLED : ports_0_fsm_stateReg_string = "ENABLED        ";
      ports_0_fsm_enumDef_SUSPENDED : ports_0_fsm_stateReg_string = "SUSPENDED      ";
      ports_0_fsm_enumDef_RESUMING : ports_0_fsm_stateReg_string = "RESUMING       ";
      ports_0_fsm_enumDef_SEND_EOP_0 : ports_0_fsm_stateReg_string = "SEND_EOP_0     ";
      ports_0_fsm_enumDef_SEND_EOP_1 : ports_0_fsm_stateReg_string = "SEND_EOP_1     ";
      ports_0_fsm_enumDef_RESTART_S : ports_0_fsm_stateReg_string = "RESTART_S      ";
      ports_0_fsm_enumDef_RESTART_E : ports_0_fsm_stateReg_string = "RESTART_E      ";
      default : ports_0_fsm_stateReg_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(ports_0_fsm_stateNext)
      ports_0_fsm_enumDef_BOOT : ports_0_fsm_stateNext_string = "BOOT           ";
      ports_0_fsm_enumDef_POWER_OFF : ports_0_fsm_stateNext_string = "POWER_OFF      ";
      ports_0_fsm_enumDef_DISCONNECTED : ports_0_fsm_stateNext_string = "DISCONNECTED   ";
      ports_0_fsm_enumDef_DISABLED : ports_0_fsm_stateNext_string = "DISABLED       ";
      ports_0_fsm_enumDef_RESETTING : ports_0_fsm_stateNext_string = "RESETTING      ";
      ports_0_fsm_enumDef_RESETTING_DELAY : ports_0_fsm_stateNext_string = "RESETTING_DELAY";
      ports_0_fsm_enumDef_RESETTING_SYNC : ports_0_fsm_stateNext_string = "RESETTING_SYNC ";
      ports_0_fsm_enumDef_ENABLED : ports_0_fsm_stateNext_string = "ENABLED        ";
      ports_0_fsm_enumDef_SUSPENDED : ports_0_fsm_stateNext_string = "SUSPENDED      ";
      ports_0_fsm_enumDef_RESUMING : ports_0_fsm_stateNext_string = "RESUMING       ";
      ports_0_fsm_enumDef_SEND_EOP_0 : ports_0_fsm_stateNext_string = "SEND_EOP_0     ";
      ports_0_fsm_enumDef_SEND_EOP_1 : ports_0_fsm_stateNext_string = "SEND_EOP_1     ";
      ports_0_fsm_enumDef_RESTART_S : ports_0_fsm_stateNext_string = "RESTART_S      ";
      ports_0_fsm_enumDef_RESTART_E : ports_0_fsm_stateNext_string = "RESTART_E      ";
      default : ports_0_fsm_stateNext_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(ports_1_rx_packet_stateReg)
      ports_1_rx_packet_enumDef_BOOT : ports_1_rx_packet_stateReg_string = "BOOT   ";
      ports_1_rx_packet_enumDef_IDLE : ports_1_rx_packet_stateReg_string = "IDLE   ";
      ports_1_rx_packet_enumDef_PACKET : ports_1_rx_packet_stateReg_string = "PACKET ";
      ports_1_rx_packet_enumDef_ERRORED : ports_1_rx_packet_stateReg_string = "ERRORED";
      default : ports_1_rx_packet_stateReg_string = "???????";
    endcase
  end
  always @(*) begin
    case(ports_1_rx_packet_stateNext)
      ports_1_rx_packet_enumDef_BOOT : ports_1_rx_packet_stateNext_string = "BOOT   ";
      ports_1_rx_packet_enumDef_IDLE : ports_1_rx_packet_stateNext_string = "IDLE   ";
      ports_1_rx_packet_enumDef_PACKET : ports_1_rx_packet_stateNext_string = "PACKET ";
      ports_1_rx_packet_enumDef_ERRORED : ports_1_rx_packet_stateNext_string = "ERRORED";
      default : ports_1_rx_packet_stateNext_string = "???????";
    endcase
  end
  always @(*) begin
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_BOOT : ports_1_fsm_stateReg_string = "BOOT           ";
      ports_1_fsm_enumDef_POWER_OFF : ports_1_fsm_stateReg_string = "POWER_OFF      ";
      ports_1_fsm_enumDef_DISCONNECTED : ports_1_fsm_stateReg_string = "DISCONNECTED   ";
      ports_1_fsm_enumDef_DISABLED : ports_1_fsm_stateReg_string = "DISABLED       ";
      ports_1_fsm_enumDef_RESETTING : ports_1_fsm_stateReg_string = "RESETTING      ";
      ports_1_fsm_enumDef_RESETTING_DELAY : ports_1_fsm_stateReg_string = "RESETTING_DELAY";
      ports_1_fsm_enumDef_RESETTING_SYNC : ports_1_fsm_stateReg_string = "RESETTING_SYNC ";
      ports_1_fsm_enumDef_ENABLED : ports_1_fsm_stateReg_string = "ENABLED        ";
      ports_1_fsm_enumDef_SUSPENDED : ports_1_fsm_stateReg_string = "SUSPENDED      ";
      ports_1_fsm_enumDef_RESUMING : ports_1_fsm_stateReg_string = "RESUMING       ";
      ports_1_fsm_enumDef_SEND_EOP_0 : ports_1_fsm_stateReg_string = "SEND_EOP_0     ";
      ports_1_fsm_enumDef_SEND_EOP_1 : ports_1_fsm_stateReg_string = "SEND_EOP_1     ";
      ports_1_fsm_enumDef_RESTART_S : ports_1_fsm_stateReg_string = "RESTART_S      ";
      ports_1_fsm_enumDef_RESTART_E : ports_1_fsm_stateReg_string = "RESTART_E      ";
      default : ports_1_fsm_stateReg_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(ports_1_fsm_stateNext)
      ports_1_fsm_enumDef_BOOT : ports_1_fsm_stateNext_string = "BOOT           ";
      ports_1_fsm_enumDef_POWER_OFF : ports_1_fsm_stateNext_string = "POWER_OFF      ";
      ports_1_fsm_enumDef_DISCONNECTED : ports_1_fsm_stateNext_string = "DISCONNECTED   ";
      ports_1_fsm_enumDef_DISABLED : ports_1_fsm_stateNext_string = "DISABLED       ";
      ports_1_fsm_enumDef_RESETTING : ports_1_fsm_stateNext_string = "RESETTING      ";
      ports_1_fsm_enumDef_RESETTING_DELAY : ports_1_fsm_stateNext_string = "RESETTING_DELAY";
      ports_1_fsm_enumDef_RESETTING_SYNC : ports_1_fsm_stateNext_string = "RESETTING_SYNC ";
      ports_1_fsm_enumDef_ENABLED : ports_1_fsm_stateNext_string = "ENABLED        ";
      ports_1_fsm_enumDef_SUSPENDED : ports_1_fsm_stateNext_string = "SUSPENDED      ";
      ports_1_fsm_enumDef_RESUMING : ports_1_fsm_stateNext_string = "RESUMING       ";
      ports_1_fsm_enumDef_SEND_EOP_0 : ports_1_fsm_stateNext_string = "SEND_EOP_0     ";
      ports_1_fsm_enumDef_SEND_EOP_1 : ports_1_fsm_stateNext_string = "SEND_EOP_1     ";
      ports_1_fsm_enumDef_RESTART_S : ports_1_fsm_stateNext_string = "RESTART_S      ";
      ports_1_fsm_enumDef_RESTART_E : ports_1_fsm_stateNext_string = "RESTART_E      ";
      default : ports_1_fsm_stateNext_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(ports_2_rx_packet_stateReg)
      ports_2_rx_packet_enumDef_BOOT : ports_2_rx_packet_stateReg_string = "BOOT   ";
      ports_2_rx_packet_enumDef_IDLE : ports_2_rx_packet_stateReg_string = "IDLE   ";
      ports_2_rx_packet_enumDef_PACKET : ports_2_rx_packet_stateReg_string = "PACKET ";
      ports_2_rx_packet_enumDef_ERRORED : ports_2_rx_packet_stateReg_string = "ERRORED";
      default : ports_2_rx_packet_stateReg_string = "???????";
    endcase
  end
  always @(*) begin
    case(ports_2_rx_packet_stateNext)
      ports_2_rx_packet_enumDef_BOOT : ports_2_rx_packet_stateNext_string = "BOOT   ";
      ports_2_rx_packet_enumDef_IDLE : ports_2_rx_packet_stateNext_string = "IDLE   ";
      ports_2_rx_packet_enumDef_PACKET : ports_2_rx_packet_stateNext_string = "PACKET ";
      ports_2_rx_packet_enumDef_ERRORED : ports_2_rx_packet_stateNext_string = "ERRORED";
      default : ports_2_rx_packet_stateNext_string = "???????";
    endcase
  end
  always @(*) begin
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_BOOT : ports_2_fsm_stateReg_string = "BOOT           ";
      ports_2_fsm_enumDef_POWER_OFF : ports_2_fsm_stateReg_string = "POWER_OFF      ";
      ports_2_fsm_enumDef_DISCONNECTED : ports_2_fsm_stateReg_string = "DISCONNECTED   ";
      ports_2_fsm_enumDef_DISABLED : ports_2_fsm_stateReg_string = "DISABLED       ";
      ports_2_fsm_enumDef_RESETTING : ports_2_fsm_stateReg_string = "RESETTING      ";
      ports_2_fsm_enumDef_RESETTING_DELAY : ports_2_fsm_stateReg_string = "RESETTING_DELAY";
      ports_2_fsm_enumDef_RESETTING_SYNC : ports_2_fsm_stateReg_string = "RESETTING_SYNC ";
      ports_2_fsm_enumDef_ENABLED : ports_2_fsm_stateReg_string = "ENABLED        ";
      ports_2_fsm_enumDef_SUSPENDED : ports_2_fsm_stateReg_string = "SUSPENDED      ";
      ports_2_fsm_enumDef_RESUMING : ports_2_fsm_stateReg_string = "RESUMING       ";
      ports_2_fsm_enumDef_SEND_EOP_0 : ports_2_fsm_stateReg_string = "SEND_EOP_0     ";
      ports_2_fsm_enumDef_SEND_EOP_1 : ports_2_fsm_stateReg_string = "SEND_EOP_1     ";
      ports_2_fsm_enumDef_RESTART_S : ports_2_fsm_stateReg_string = "RESTART_S      ";
      ports_2_fsm_enumDef_RESTART_E : ports_2_fsm_stateReg_string = "RESTART_E      ";
      default : ports_2_fsm_stateReg_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(ports_2_fsm_stateNext)
      ports_2_fsm_enumDef_BOOT : ports_2_fsm_stateNext_string = "BOOT           ";
      ports_2_fsm_enumDef_POWER_OFF : ports_2_fsm_stateNext_string = "POWER_OFF      ";
      ports_2_fsm_enumDef_DISCONNECTED : ports_2_fsm_stateNext_string = "DISCONNECTED   ";
      ports_2_fsm_enumDef_DISABLED : ports_2_fsm_stateNext_string = "DISABLED       ";
      ports_2_fsm_enumDef_RESETTING : ports_2_fsm_stateNext_string = "RESETTING      ";
      ports_2_fsm_enumDef_RESETTING_DELAY : ports_2_fsm_stateNext_string = "RESETTING_DELAY";
      ports_2_fsm_enumDef_RESETTING_SYNC : ports_2_fsm_stateNext_string = "RESETTING_SYNC ";
      ports_2_fsm_enumDef_ENABLED : ports_2_fsm_stateNext_string = "ENABLED        ";
      ports_2_fsm_enumDef_SUSPENDED : ports_2_fsm_stateNext_string = "SUSPENDED      ";
      ports_2_fsm_enumDef_RESUMING : ports_2_fsm_stateNext_string = "RESUMING       ";
      ports_2_fsm_enumDef_SEND_EOP_0 : ports_2_fsm_stateNext_string = "SEND_EOP_0     ";
      ports_2_fsm_enumDef_SEND_EOP_1 : ports_2_fsm_stateNext_string = "SEND_EOP_1     ";
      ports_2_fsm_enumDef_RESTART_S : ports_2_fsm_stateNext_string = "RESTART_S      ";
      ports_2_fsm_enumDef_RESTART_E : ports_2_fsm_stateNext_string = "RESTART_E      ";
      default : ports_2_fsm_stateNext_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(ports_3_rx_packet_stateReg)
      ports_3_rx_packet_enumDef_BOOT : ports_3_rx_packet_stateReg_string = "BOOT   ";
      ports_3_rx_packet_enumDef_IDLE : ports_3_rx_packet_stateReg_string = "IDLE   ";
      ports_3_rx_packet_enumDef_PACKET : ports_3_rx_packet_stateReg_string = "PACKET ";
      ports_3_rx_packet_enumDef_ERRORED : ports_3_rx_packet_stateReg_string = "ERRORED";
      default : ports_3_rx_packet_stateReg_string = "???????";
    endcase
  end
  always @(*) begin
    case(ports_3_rx_packet_stateNext)
      ports_3_rx_packet_enumDef_BOOT : ports_3_rx_packet_stateNext_string = "BOOT   ";
      ports_3_rx_packet_enumDef_IDLE : ports_3_rx_packet_stateNext_string = "IDLE   ";
      ports_3_rx_packet_enumDef_PACKET : ports_3_rx_packet_stateNext_string = "PACKET ";
      ports_3_rx_packet_enumDef_ERRORED : ports_3_rx_packet_stateNext_string = "ERRORED";
      default : ports_3_rx_packet_stateNext_string = "???????";
    endcase
  end
  always @(*) begin
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_BOOT : ports_3_fsm_stateReg_string = "BOOT           ";
      ports_3_fsm_enumDef_POWER_OFF : ports_3_fsm_stateReg_string = "POWER_OFF      ";
      ports_3_fsm_enumDef_DISCONNECTED : ports_3_fsm_stateReg_string = "DISCONNECTED   ";
      ports_3_fsm_enumDef_DISABLED : ports_3_fsm_stateReg_string = "DISABLED       ";
      ports_3_fsm_enumDef_RESETTING : ports_3_fsm_stateReg_string = "RESETTING      ";
      ports_3_fsm_enumDef_RESETTING_DELAY : ports_3_fsm_stateReg_string = "RESETTING_DELAY";
      ports_3_fsm_enumDef_RESETTING_SYNC : ports_3_fsm_stateReg_string = "RESETTING_SYNC ";
      ports_3_fsm_enumDef_ENABLED : ports_3_fsm_stateReg_string = "ENABLED        ";
      ports_3_fsm_enumDef_SUSPENDED : ports_3_fsm_stateReg_string = "SUSPENDED      ";
      ports_3_fsm_enumDef_RESUMING : ports_3_fsm_stateReg_string = "RESUMING       ";
      ports_3_fsm_enumDef_SEND_EOP_0 : ports_3_fsm_stateReg_string = "SEND_EOP_0     ";
      ports_3_fsm_enumDef_SEND_EOP_1 : ports_3_fsm_stateReg_string = "SEND_EOP_1     ";
      ports_3_fsm_enumDef_RESTART_S : ports_3_fsm_stateReg_string = "RESTART_S      ";
      ports_3_fsm_enumDef_RESTART_E : ports_3_fsm_stateReg_string = "RESTART_E      ";
      default : ports_3_fsm_stateReg_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(ports_3_fsm_stateNext)
      ports_3_fsm_enumDef_BOOT : ports_3_fsm_stateNext_string = "BOOT           ";
      ports_3_fsm_enumDef_POWER_OFF : ports_3_fsm_stateNext_string = "POWER_OFF      ";
      ports_3_fsm_enumDef_DISCONNECTED : ports_3_fsm_stateNext_string = "DISCONNECTED   ";
      ports_3_fsm_enumDef_DISABLED : ports_3_fsm_stateNext_string = "DISABLED       ";
      ports_3_fsm_enumDef_RESETTING : ports_3_fsm_stateNext_string = "RESETTING      ";
      ports_3_fsm_enumDef_RESETTING_DELAY : ports_3_fsm_stateNext_string = "RESETTING_DELAY";
      ports_3_fsm_enumDef_RESETTING_SYNC : ports_3_fsm_stateNext_string = "RESETTING_SYNC ";
      ports_3_fsm_enumDef_ENABLED : ports_3_fsm_stateNext_string = "ENABLED        ";
      ports_3_fsm_enumDef_SUSPENDED : ports_3_fsm_stateNext_string = "SUSPENDED      ";
      ports_3_fsm_enumDef_RESUMING : ports_3_fsm_stateNext_string = "RESUMING       ";
      ports_3_fsm_enumDef_SEND_EOP_0 : ports_3_fsm_stateNext_string = "SEND_EOP_0     ";
      ports_3_fsm_enumDef_SEND_EOP_1 : ports_3_fsm_stateNext_string = "SEND_EOP_1     ";
      ports_3_fsm_enumDef_RESTART_S : ports_3_fsm_stateNext_string = "RESTART_S      ";
      ports_3_fsm_enumDef_RESTART_E : ports_3_fsm_stateNext_string = "RESTART_E      ";
      default : ports_3_fsm_stateNext_string = "???????????????";
    endcase
  end
  `endif

  assign tickTimer_counter_willClear = 1'b0;
  assign tickTimer_counter_willOverflowIfInc = (tickTimer_counter_value == 2'b11);
  assign tickTimer_counter_willOverflow = (tickTimer_counter_willOverflowIfInc && tickTimer_counter_willIncrement);
  always @(*) begin
    tickTimer_counter_valueNext = (tickTimer_counter_value + _zz_tickTimer_counter_valueNext);
    if(tickTimer_counter_willClear) begin
      tickTimer_counter_valueNext = 2'b00;
    end
  end

  assign tickTimer_counter_willIncrement = 1'b1;
  assign tickTimer_tick = (tickTimer_counter_willOverflow == 1'b1);
  assign io_ctrl_tick = tickTimer_tick;
  always @(*) begin
    txShared_timer_clear = 1'b0;
    if(txShared_encoder_input_valid) begin
      if(txShared_encoder_input_data) begin
        if(txShared_timer_oneCycle) begin
          if(when_UsbHubPhy_l189) begin
            txShared_timer_clear = 1'b1;
          end
        end
      end
    end
    if(txShared_encoder_input_ready) begin
      txShared_timer_clear = 1'b1;
    end
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
        txShared_timer_clear = 1'b1;
      end
      txShared_frame_enumDef_TAKE_LINE : begin
        if(txShared_timer_oneCycle) begin
          txShared_timer_clear = 1'b1;
        end
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
        if(txShared_timer_fourCycle) begin
          txShared_timer_clear = 1'b1;
        end
      end
      txShared_frame_enumDef_SYNC : begin
      end
      txShared_frame_enumDef_DATA : begin
      end
      txShared_frame_enumDef_EOP_0 : begin
        if(txShared_timer_twoCycle) begin
          txShared_timer_clear = 1'b1;
        end
      end
      txShared_frame_enumDef_EOP_1 : begin
        if(txShared_timer_oneCycle) begin
          txShared_timer_clear = 1'b1;
        end
      end
      txShared_frame_enumDef_EOP_2 : begin
        if(txShared_timer_twoCycle) begin
          txShared_timer_clear = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign txShared_timer_inc = 1'b1;
  assign txShared_timer_oneCycle = (txShared_timer_counter == _zz_txShared_timer_oneCycle);
  assign txShared_timer_twoCycle = (txShared_timer_counter == _zz_txShared_timer_twoCycle);
  assign txShared_timer_fourCycle = (txShared_timer_counter == _zz_txShared_timer_fourCycle);
  always @(*) begin
    txShared_timer_lowSpeed = 1'b0;
    if(txShared_encoder_input_valid) begin
      txShared_timer_lowSpeed = txShared_encoder_input_lowSpeed;
    end
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
        txShared_timer_lowSpeed = 1'b0;
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
        txShared_timer_lowSpeed = 1'b0;
      end
      txShared_frame_enumDef_SYNC : begin
      end
      txShared_frame_enumDef_DATA : begin
      end
      txShared_frame_enumDef_EOP_0 : begin
        txShared_timer_lowSpeed = txShared_frame_wasLowSpeed;
      end
      txShared_frame_enumDef_EOP_1 : begin
        txShared_timer_lowSpeed = txShared_frame_wasLowSpeed;
      end
      txShared_frame_enumDef_EOP_2 : begin
        txShared_timer_lowSpeed = txShared_frame_wasLowSpeed;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    txShared_rxToTxDelay_clear = 1'b0;
    if(ports_0_rx_eop_hit) begin
      txShared_rxToTxDelay_clear = 1'b1;
    end
    if(ports_1_rx_eop_hit) begin
      txShared_rxToTxDelay_clear = 1'b1;
    end
    if(ports_2_rx_eop_hit) begin
      txShared_rxToTxDelay_clear = 1'b1;
    end
    if(ports_3_rx_eop_hit) begin
      txShared_rxToTxDelay_clear = 1'b1;
    end
  end

  assign txShared_rxToTxDelay_inc = 1'b1;
  assign txShared_rxToTxDelay_twoCycle = (txShared_rxToTxDelay_counter == _zz_txShared_rxToTxDelay_twoCycle);
  always @(*) begin
    txShared_encoder_input_valid = 1'b0;
    if(txShared_serialiser_input_valid) begin
      txShared_encoder_input_valid = 1'b1;
    end
  end

  always @(*) begin
    txShared_encoder_input_ready = 1'b0;
    if(txShared_encoder_input_valid) begin
      if(txShared_encoder_input_data) begin
        if(txShared_timer_oneCycle) begin
          txShared_encoder_input_ready = 1'b1;
          if(when_UsbHubPhy_l189) begin
            txShared_encoder_input_ready = 1'b0;
          end
        end
      end else begin
        if(txShared_timer_oneCycle) begin
          txShared_encoder_input_ready = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    txShared_encoder_input_data = 1'bx;
    if(txShared_serialiser_input_valid) begin
      txShared_encoder_input_data = txShared_serialiser_input_data[txShared_serialiser_bitCounter];
    end
  end

  always @(*) begin
    txShared_encoder_input_lowSpeed = 1'bx;
    if(txShared_serialiser_input_valid) begin
      txShared_encoder_input_lowSpeed = txShared_serialiser_input_lowSpeed;
    end
  end

  always @(*) begin
    txShared_encoder_output_valid = 1'b0;
    if(txShared_encoder_input_valid) begin
      txShared_encoder_output_valid = txShared_encoder_input_valid;
    end
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
        txShared_encoder_output_valid = 1'b1;
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
        txShared_encoder_output_valid = 1'b1;
      end
      txShared_frame_enumDef_SYNC : begin
      end
      txShared_frame_enumDef_DATA : begin
      end
      txShared_frame_enumDef_EOP_0 : begin
        txShared_encoder_output_valid = 1'b1;
      end
      txShared_frame_enumDef_EOP_1 : begin
        txShared_encoder_output_valid = 1'b1;
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    txShared_encoder_output_se0 = 1'b0;
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
      end
      txShared_frame_enumDef_SYNC : begin
      end
      txShared_frame_enumDef_DATA : begin
      end
      txShared_frame_enumDef_EOP_0 : begin
        txShared_encoder_output_se0 = 1'b1;
      end
      txShared_frame_enumDef_EOP_1 : begin
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    txShared_encoder_output_lowSpeed = 1'bx;
    if(txShared_encoder_input_valid) begin
      txShared_encoder_output_lowSpeed = txShared_encoder_input_lowSpeed;
    end
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
        txShared_encoder_output_lowSpeed = 1'b0;
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
        txShared_encoder_output_lowSpeed = 1'b0;
      end
      txShared_frame_enumDef_SYNC : begin
      end
      txShared_frame_enumDef_DATA : begin
      end
      txShared_frame_enumDef_EOP_0 : begin
        txShared_encoder_output_lowSpeed = txShared_frame_wasLowSpeed;
      end
      txShared_frame_enumDef_EOP_1 : begin
        txShared_encoder_output_lowSpeed = txShared_frame_wasLowSpeed;
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    txShared_encoder_output_data = 1'bx;
    if(txShared_encoder_input_valid) begin
      if(txShared_encoder_input_data) begin
        txShared_encoder_output_data = txShared_encoder_state;
      end else begin
        txShared_encoder_output_data = (! txShared_encoder_state);
      end
    end
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
        txShared_encoder_output_data = 1'b1;
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
        txShared_encoder_output_data = 1'b1;
      end
      txShared_frame_enumDef_SYNC : begin
      end
      txShared_frame_enumDef_DATA : begin
      end
      txShared_frame_enumDef_EOP_0 : begin
      end
      txShared_frame_enumDef_EOP_1 : begin
        txShared_encoder_output_data = 1'b1;
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
      end
    endcase
  end

  assign when_UsbHubPhy_l189 = (txShared_encoder_counter == 3'b101);
  assign when_UsbHubPhy_l194 = (txShared_encoder_counter == 3'b110);
  assign when_UsbHubPhy_l208 = (! txShared_encoder_input_valid);
  always @(*) begin
    txShared_serialiser_input_valid = 1'b0;
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
        txShared_serialiser_input_valid = 1'b1;
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
        txShared_serialiser_input_valid = 1'b1;
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
      end
      txShared_frame_enumDef_SYNC : begin
        txShared_serialiser_input_valid = 1'b1;
      end
      txShared_frame_enumDef_DATA : begin
        txShared_serialiser_input_valid = 1'b1;
      end
      txShared_frame_enumDef_EOP_0 : begin
      end
      txShared_frame_enumDef_EOP_1 : begin
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    txShared_serialiser_input_ready = 1'b0;
    if(txShared_serialiser_input_valid) begin
      if(txShared_encoder_input_ready) begin
        if(when_UsbHubPhy_l234) begin
          txShared_serialiser_input_ready = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    txShared_serialiser_input_data = 8'bxxxxxxxx;
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
        txShared_serialiser_input_data = 8'h80;
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
        txShared_serialiser_input_data = 8'h3c;
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
      end
      txShared_frame_enumDef_SYNC : begin
        txShared_serialiser_input_data = 8'h80;
      end
      txShared_frame_enumDef_DATA : begin
        txShared_serialiser_input_data = io_ctrl_tx_payload_fragment;
      end
      txShared_frame_enumDef_EOP_0 : begin
      end
      txShared_frame_enumDef_EOP_1 : begin
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    txShared_serialiser_input_lowSpeed = 1'bx;
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
        txShared_serialiser_input_lowSpeed = 1'b0;
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
        txShared_serialiser_input_lowSpeed = 1'b0;
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
      end
      txShared_frame_enumDef_SYNC : begin
        txShared_serialiser_input_lowSpeed = txShared_frame_wasLowSpeed;
      end
      txShared_frame_enumDef_DATA : begin
        txShared_serialiser_input_lowSpeed = txShared_frame_wasLowSpeed;
      end
      txShared_frame_enumDef_EOP_0 : begin
      end
      txShared_frame_enumDef_EOP_1 : begin
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
      end
    endcase
  end

  assign when_UsbHubPhy_l234 = (txShared_serialiser_bitCounter == 3'b111);
  assign when_UsbHubPhy_l240 = ((! txShared_serialiser_input_valid) || txShared_serialiser_input_ready);
  always @(*) begin
    txShared_lowSpeedSof_increment = 1'b0;
    if(when_UsbHubPhy_l251) begin
      if(when_UsbHubPhy_l252) begin
        txShared_lowSpeedSof_increment = 1'b1;
      end
    end
  end

  assign when_UsbHubPhy_l249 = ((! txShared_encoder_output_valid) && txShared_encoder_output_valid_regNext);
  assign when_UsbHubPhy_l251 = (txShared_lowSpeedSof_state == 2'b00);
  assign io_ctrl_tx_fire = (io_ctrl_tx_valid && io_ctrl_tx_ready);
  assign when_UsbHubPhy_l252 = ((io_ctrl_tx_valid && io_ctrl_tx_payload_first) && (io_ctrl_tx_payload_fragment == 8'ha5));
  assign when_UsbHubPhy_l259 = (txShared_lowSpeedSof_timer == 5'h1f);
  assign txShared_lowSpeedSof_valid = (txShared_lowSpeedSof_state != 2'b00);
  assign txShared_lowSpeedSof_data = 1'b0;
  assign txShared_lowSpeedSof_se0 = (txShared_lowSpeedSof_state != 2'b11);
  assign txShared_frame_wantExit = 1'b0;
  always @(*) begin
    txShared_frame_wantStart = 1'b0;
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
      end
      txShared_frame_enumDef_SYNC : begin
      end
      txShared_frame_enumDef_DATA : begin
      end
      txShared_frame_enumDef_EOP_0 : begin
      end
      txShared_frame_enumDef_EOP_1 : begin
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
        txShared_frame_wantStart = 1'b1;
      end
    endcase
  end

  assign txShared_frame_wantKill = 1'b0;
  assign txShared_frame_busy = (! (txShared_frame_stateReg == txShared_frame_enumDef_BOOT));
  always @(*) begin
    io_ctrl_tx_ready = 1'b0;
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
      end
      txShared_frame_enumDef_SYNC : begin
      end
      txShared_frame_enumDef_DATA : begin
        if(txShared_serialiser_input_ready) begin
          io_ctrl_tx_ready = 1'b1;
        end
      end
      txShared_frame_enumDef_EOP_0 : begin
      end
      txShared_frame_enumDef_EOP_1 : begin
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_ctrl_txEop = 1'b0;
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
      end
      txShared_frame_enumDef_TAKE_LINE : begin
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
      end
      txShared_frame_enumDef_SYNC : begin
      end
      txShared_frame_enumDef_DATA : begin
      end
      txShared_frame_enumDef_EOP_0 : begin
        if(txShared_timer_twoCycle) begin
          io_ctrl_txEop = 1'b1;
        end
      end
      txShared_frame_enumDef_EOP_1 : begin
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
      end
    endcase
  end

  assign upstreamRx_wantExit = 1'b0;
  always @(*) begin
    upstreamRx_wantStart = 1'b0;
    case(upstreamRx_stateReg)
      upstreamRx_enumDef_IDLE : begin
      end
      upstreamRx_enumDef_SUSPEND : begin
      end
      default : begin
        upstreamRx_wantStart = 1'b1;
      end
    endcase
  end

  assign upstreamRx_wantKill = 1'b0;
  always @(*) begin
    upstreamRx_timer_clear = 1'b0;
    if(txShared_encoder_output_valid) begin
      upstreamRx_timer_clear = 1'b1;
    end
  end

  assign upstreamRx_timer_inc = 1'b1;
  assign upstreamRx_timer_IDLE_EOI = (upstreamRx_timer_counter == 20'h2327f);
  assign io_ctrl_overcurrent = 1'b0;
  always @(*) begin
    io_ctrl_rx_flow_valid = 1'b0;
    case(ports_0_rx_packet_stateReg)
      ports_0_rx_packet_enumDef_IDLE : begin
      end
      ports_0_rx_packet_enumDef_PACKET : begin
        if(ports_0_rx_destuffer_output_valid) begin
          if(when_UsbHubPhy_l527) begin
            io_ctrl_rx_flow_valid = ports_0_rx_enablePackets;
          end
        end
      end
      ports_0_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    case(ports_1_rx_packet_stateReg)
      ports_1_rx_packet_enumDef_IDLE : begin
      end
      ports_1_rx_packet_enumDef_PACKET : begin
        if(ports_1_rx_destuffer_output_valid) begin
          if(when_UsbHubPhy_l527_1) begin
            io_ctrl_rx_flow_valid = ports_1_rx_enablePackets;
          end
        end
      end
      ports_1_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    case(ports_2_rx_packet_stateReg)
      ports_2_rx_packet_enumDef_IDLE : begin
      end
      ports_2_rx_packet_enumDef_PACKET : begin
        if(ports_2_rx_destuffer_output_valid) begin
          if(when_UsbHubPhy_l527_2) begin
            io_ctrl_rx_flow_valid = ports_2_rx_enablePackets;
          end
        end
      end
      ports_2_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    case(ports_3_rx_packet_stateReg)
      ports_3_rx_packet_enumDef_IDLE : begin
      end
      ports_3_rx_packet_enumDef_PACKET : begin
        if(ports_3_rx_destuffer_output_valid) begin
          if(when_UsbHubPhy_l527_3) begin
            io_ctrl_rx_flow_valid = ports_3_rx_enablePackets;
          end
        end
      end
      ports_3_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_ctrl_rx_active = 1'b0;
    case(ports_0_rx_packet_stateReg)
      ports_0_rx_packet_enumDef_IDLE : begin
      end
      ports_0_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_active = 1'b1;
      end
      ports_0_rx_packet_enumDef_ERRORED : begin
        io_ctrl_rx_active = 1'b1;
      end
      default : begin
      end
    endcase
    case(ports_1_rx_packet_stateReg)
      ports_1_rx_packet_enumDef_IDLE : begin
      end
      ports_1_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_active = 1'b1;
      end
      ports_1_rx_packet_enumDef_ERRORED : begin
        io_ctrl_rx_active = 1'b1;
      end
      default : begin
      end
    endcase
    case(ports_2_rx_packet_stateReg)
      ports_2_rx_packet_enumDef_IDLE : begin
      end
      ports_2_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_active = 1'b1;
      end
      ports_2_rx_packet_enumDef_ERRORED : begin
        io_ctrl_rx_active = 1'b1;
      end
      default : begin
      end
    endcase
    case(ports_3_rx_packet_stateReg)
      ports_3_rx_packet_enumDef_IDLE : begin
      end
      ports_3_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_active = 1'b1;
      end
      ports_3_rx_packet_enumDef_ERRORED : begin
        io_ctrl_rx_active = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_ctrl_rx_flow_payload_stuffingError = 1'b0;
    case(ports_0_rx_packet_stateReg)
      ports_0_rx_packet_enumDef_IDLE : begin
      end
      ports_0_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_flow_payload_stuffingError = ports_0_rx_stuffingError;
      end
      ports_0_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    case(ports_1_rx_packet_stateReg)
      ports_1_rx_packet_enumDef_IDLE : begin
      end
      ports_1_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_flow_payload_stuffingError = ports_1_rx_stuffingError;
      end
      ports_1_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    case(ports_2_rx_packet_stateReg)
      ports_2_rx_packet_enumDef_IDLE : begin
      end
      ports_2_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_flow_payload_stuffingError = ports_2_rx_stuffingError;
      end
      ports_2_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    case(ports_3_rx_packet_stateReg)
      ports_3_rx_packet_enumDef_IDLE : begin
      end
      ports_3_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_flow_payload_stuffingError = ports_3_rx_stuffingError;
      end
      ports_3_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_ctrl_rx_flow_payload_data = 8'bxxxxxxxx;
    case(ports_0_rx_packet_stateReg)
      ports_0_rx_packet_enumDef_IDLE : begin
      end
      ports_0_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_flow_payload_data = ports_0_rx_history_value;
      end
      ports_0_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    case(ports_1_rx_packet_stateReg)
      ports_1_rx_packet_enumDef_IDLE : begin
      end
      ports_1_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_flow_payload_data = ports_1_rx_history_value;
      end
      ports_1_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    case(ports_2_rx_packet_stateReg)
      ports_2_rx_packet_enumDef_IDLE : begin
      end
      ports_2_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_flow_payload_data = ports_2_rx_history_value;
      end
      ports_2_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    case(ports_3_rx_packet_stateReg)
      ports_3_rx_packet_enumDef_IDLE : begin
      end
      ports_3_rx_packet_enumDef_PACKET : begin
        io_ctrl_rx_flow_payload_data = ports_3_rx_history_value;
      end
      ports_3_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    resumeFromPort = 1'b0;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_0_fsm_enumDef_ENABLED : begin
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_0_fsm_enumDef_RESTART_S : begin
        if(when_UsbHubPhy_l748) begin
          resumeFromPort = 1'b1;
        end
      end
      ports_0_fsm_enumDef_RESTART_E : begin
        if(when_UsbHubPhy_l758) begin
          resumeFromPort = 1'b1;
        end
      end
      default : begin
      end
    endcase
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_1_fsm_enumDef_ENABLED : begin
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_1_fsm_enumDef_RESTART_S : begin
        if(when_UsbHubPhy_l748_1) begin
          resumeFromPort = 1'b1;
        end
      end
      ports_1_fsm_enumDef_RESTART_E : begin
        if(when_UsbHubPhy_l758_1) begin
          resumeFromPort = 1'b1;
        end
      end
      default : begin
      end
    endcase
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_2_fsm_enumDef_ENABLED : begin
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_2_fsm_enumDef_RESTART_S : begin
        if(when_UsbHubPhy_l748_2) begin
          resumeFromPort = 1'b1;
        end
      end
      ports_2_fsm_enumDef_RESTART_E : begin
        if(when_UsbHubPhy_l758_2) begin
          resumeFromPort = 1'b1;
        end
      end
      default : begin
      end
    endcase
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_3_fsm_enumDef_ENABLED : begin
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_3_fsm_enumDef_RESTART_S : begin
        if(when_UsbHubPhy_l748_3) begin
          resumeFromPort = 1'b1;
        end
      end
      ports_3_fsm_enumDef_RESTART_E : begin
        if(when_UsbHubPhy_l758_3) begin
          resumeFromPort = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_ports_0_lowSpeed = ports_0_portLowSpeed;
  assign io_ctrl_ports_0_remoteResume = 1'b0;
  always @(*) begin
    ports_0_rx_enablePackets = 1'b0;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_0_fsm_enumDef_ENABLED : begin
        ports_0_rx_enablePackets = 1'b1;
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign ports_0_rx_j = ((ports_0_filter_io_filtred_dp == (! ports_0_portLowSpeed)) && (ports_0_filter_io_filtred_dm == ports_0_portLowSpeed));
  assign ports_0_rx_k = ((ports_0_filter_io_filtred_dp == ports_0_portLowSpeed) && (ports_0_filter_io_filtred_dm == (! ports_0_portLowSpeed)));
  assign io_management_0_power = io_ctrl_ports_0_power;
  assign io_ctrl_ports_0_overcurrent = io_management_0_overcurrent;
  always @(*) begin
    ports_0_rx_waitSync = 1'b0;
    case(ports_0_rx_packet_stateReg)
      ports_0_rx_packet_enumDef_IDLE : begin
        ports_0_rx_waitSync = 1'b1;
      end
      ports_0_rx_packet_enumDef_PACKET : begin
      end
      ports_0_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253) begin
      ports_0_rx_waitSync = 1'b1;
    end
  end

  always @(*) begin
    ports_0_rx_decoder_output_valid = 1'b0;
    if(ports_0_filter_io_filtred_sample) begin
      ports_0_rx_decoder_output_valid = 1'b1;
    end
  end

  always @(*) begin
    ports_0_rx_decoder_output_payload = 1'bx;
    if(ports_0_filter_io_filtred_sample) begin
      if(when_UsbHubPhy_l445) begin
        ports_0_rx_decoder_output_payload = 1'b0;
      end else begin
        ports_0_rx_decoder_output_payload = 1'b1;
      end
    end
  end

  assign when_UsbHubPhy_l445 = ((ports_0_rx_decoder_state ^ ports_0_filter_io_filtred_d) ^ ports_0_portLowSpeed);
  assign ports_0_rx_destuffer_unstuffNext = (ports_0_rx_destuffer_counter == 3'b110);
  assign ports_0_rx_destuffer_output_valid = (ports_0_rx_decoder_output_valid && (! ports_0_rx_destuffer_unstuffNext));
  assign ports_0_rx_destuffer_output_payload = ports_0_rx_decoder_output_payload;
  assign when_UsbHubPhy_l466 = ((! ports_0_rx_decoder_output_payload) || ports_0_rx_destuffer_unstuffNext);
  assign ports_0_rx_history_updated = ports_0_rx_destuffer_output_valid;
  assign _zz_ports_0_rx_history_value = ports_0_rx_destuffer_output_payload;
  assign ports_0_rx_history_value = {_zz_ports_0_rx_history_value,{_zz_ports_0_rx_history_value_1,{_zz_ports_0_rx_history_value_2,{_zz_ports_0_rx_history_value_3,{_zz_ports_0_rx_history_value_4,{_zz_ports_0_rx_history_value_5,{_zz_ports_0_rx_history_value_6,_zz_ports_0_rx_history_value_7}}}}}}};
  assign ports_0_rx_history_sync_hit = (ports_0_rx_history_updated && (ports_0_rx_history_value == 8'hd5));
  assign ports_0_rx_eop_maxThreshold = (io_ctrl_lowSpeed ? 7'h60 : 7'h0c);
  assign ports_0_rx_eop_minThreshold = (io_ctrl_lowSpeed ? 6'h2a : 6'h05);
  assign ports_0_rx_eop_maxHit = (ports_0_rx_eop_counter == ports_0_rx_eop_maxThreshold);
  always @(*) begin
    ports_0_rx_eop_hit = 1'b0;
    if(ports_0_rx_j) begin
      if(when_UsbHubPhy_l501) begin
        ports_0_rx_eop_hit = 1'b1;
      end
    end
  end

  assign when_UsbHubPhy_l493 = ((! ports_0_filter_io_filtred_dp) && (! ports_0_filter_io_filtred_dm));
  assign when_UsbHubPhy_l494 = (! ports_0_rx_eop_maxHit);
  assign when_UsbHubPhy_l501 = ((_zz_when_UsbHubPhy_l501 <= ports_0_rx_eop_counter) && (! ports_0_rx_eop_maxHit));
  assign ports_0_rx_packet_wantExit = 1'b0;
  always @(*) begin
    ports_0_rx_packet_wantStart = 1'b0;
    case(ports_0_rx_packet_stateReg)
      ports_0_rx_packet_enumDef_IDLE : begin
      end
      ports_0_rx_packet_enumDef_PACKET : begin
      end
      ports_0_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
        ports_0_rx_packet_wantStart = 1'b1;
      end
    endcase
  end

  assign ports_0_rx_packet_wantKill = 1'b0;
  always @(*) begin
    ports_0_rx_packet_errorTimeout_clear = 1'b0;
    case(ports_0_rx_packet_stateReg)
      ports_0_rx_packet_enumDef_IDLE : begin
      end
      ports_0_rx_packet_enumDef_PACKET : begin
      end
      ports_0_rx_packet_enumDef_ERRORED : begin
        if(when_UsbHubPhy_l549) begin
          ports_0_rx_packet_errorTimeout_clear = 1'b1;
        end
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_1) begin
      ports_0_rx_packet_errorTimeout_clear = 1'b1;
    end
  end

  assign ports_0_rx_packet_errorTimeout_inc = 1'b1;
  assign ports_0_rx_packet_errorTimeout_lowSpeed = io_ctrl_lowSpeed;
  assign ports_0_rx_packet_errorTimeout_trigger = (ports_0_rx_packet_errorTimeout_counter == _zz_ports_0_rx_packet_errorTimeout_trigger);
  always @(*) begin
    ports_0_rx_disconnect_clear = 1'b0;
    if(when_UsbHubPhy_l573) begin
      ports_0_rx_disconnect_clear = 1'b1;
    end
    if(when_UsbHubPhy_l767) begin
      ports_0_rx_disconnect_clear = 1'b1;
    end
  end

  assign ports_0_rx_disconnect_hit = (ports_0_rx_disconnect_counter == 7'h68);
  assign ports_0_rx_disconnect_event = (ports_0_rx_disconnect_hit && (! ports_0_rx_disconnect_hitLast));
  assign when_UsbHubPhy_l573 = ((! ports_0_filter_io_filtred_se0) || io_usb_0_tx_enable);
  assign io_ctrl_ports_0_disconnect = ports_0_rx_disconnect_event;
  assign ports_0_fsm_wantExit = 1'b0;
  always @(*) begin
    ports_0_fsm_wantStart = 1'b0;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_0_fsm_enumDef_ENABLED : begin
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
        ports_0_fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign ports_0_fsm_wantKill = 1'b0;
  always @(*) begin
    ports_0_fsm_timer_clear = 1'b0;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
        if(when_UsbHubPhy_l638) begin
          ports_0_fsm_timer_clear = 1'b1;
        end
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_0_fsm_enumDef_ENABLED : begin
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_2) begin
      ports_0_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_3) begin
      ports_0_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_4) begin
      ports_0_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_5) begin
      ports_0_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_6) begin
      ports_0_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_7) begin
      ports_0_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_8) begin
      ports_0_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_9) begin
      ports_0_fsm_timer_clear = 1'b1;
    end
  end

  assign ports_0_fsm_timer_inc = 1'b1;
  assign ports_0_fsm_timer_DISCONNECTED_EOI = (ports_0_fsm_timer_counter == 24'h005dbf);
  assign ports_0_fsm_timer_RESET_DELAY = (ports_0_fsm_timer_counter == 24'h00095f);
  assign ports_0_fsm_timer_RESET_EOI = (ports_0_fsm_timer_counter == 24'h02327f);
  assign ports_0_fsm_timer_RESUME_EOI = (ports_0_fsm_timer_counter == 24'h0176ff);
  assign ports_0_fsm_timer_RESTART_EOI = (ports_0_fsm_timer_counter == 24'h0012bf);
  assign ports_0_fsm_timer_ONE_BIT = (ports_0_fsm_timer_counter == _zz_ports_0_fsm_timer_ONE_BIT);
  assign ports_0_fsm_timer_TWO_BIT = (ports_0_fsm_timer_counter == _zz_ports_0_fsm_timer_TWO_BIT);
  always @(*) begin
    ports_0_fsm_timer_lowSpeed = ports_0_portLowSpeed;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_0_fsm_enumDef_ENABLED : begin
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
        if(ports_0_fsm_lowSpeedEop) begin
          ports_0_fsm_timer_lowSpeed = 1'b1;
        end
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
        if(ports_0_fsm_lowSpeedEop) begin
          ports_0_fsm_timer_lowSpeed = 1'b1;
        end
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_ports_0_disable_ready = 1'b1;
  always @(*) begin
    io_ctrl_ports_0_reset_ready = 1'b0;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
        if(when_UsbHubPhy_l675) begin
          io_ctrl_ports_0_reset_ready = 1'b1;
        end
      end
      ports_0_fsm_enumDef_ENABLED : begin
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_ports_0_resume_ready = 1'b1;
  assign io_ctrl_ports_0_suspend_ready = 1'b1;
  always @(*) begin
    io_ctrl_ports_0_connect = 1'b0;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
        if(ports_0_fsm_timer_DISCONNECTED_EOI) begin
          io_ctrl_ports_0_connect = 1'b1;
        end
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_0_fsm_enumDef_ENABLED : begin
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_0_tx_enable = 1'b0;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
        io_usb_0_tx_enable = 1'b1;
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
        io_usb_0_tx_enable = 1'b1;
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_0_fsm_enumDef_ENABLED : begin
        io_usb_0_tx_enable = txShared_encoder_output_valid;
        if(when_UsbHubPhy_l688) begin
          io_usb_0_tx_enable = txShared_lowSpeedSof_valid;
        end
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
        io_usb_0_tx_enable = 1'b1;
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
        io_usb_0_tx_enable = 1'b1;
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_0_tx_enable = 1'b1;
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_0_tx_data = 1'bx;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_0_fsm_enumDef_ENABLED : begin
        io_usb_0_tx_data = ((txShared_encoder_output_data || ports_0_fsm_forceJ) ^ ports_0_portLowSpeed);
        if(when_UsbHubPhy_l688) begin
          io_usb_0_tx_data = txShared_lowSpeedSof_data;
        end
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
        io_usb_0_tx_data = ports_0_portLowSpeed;
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_0_tx_data = (! ports_0_portLowSpeed);
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_0_tx_se0 = 1'bx;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
        io_usb_0_tx_se0 = 1'b1;
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
        io_usb_0_tx_se0 = 1'b1;
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_0_fsm_enumDef_ENABLED : begin
        io_usb_0_tx_se0 = (txShared_encoder_output_se0 && (! ports_0_fsm_forceJ));
        if(when_UsbHubPhy_l688) begin
          io_usb_0_tx_se0 = txShared_lowSpeedSof_se0;
        end
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
        io_usb_0_tx_se0 = 1'b0;
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
        io_usb_0_tx_se0 = 1'b1;
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_0_tx_se0 = 1'b0;
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ports_0_fsm_resetInProgress = 1'b0;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
        ports_0_fsm_resetInProgress = 1'b1;
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
        ports_0_fsm_resetInProgress = 1'b1;
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
        ports_0_fsm_resetInProgress = 1'b1;
      end
      ports_0_fsm_enumDef_ENABLED : begin
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign ports_0_fsm_forceJ = (ports_0_portLowSpeed && (! txShared_encoder_output_lowSpeed));
  assign when_UsbHubPhy_l767 = (&{(! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_DISABLED)),{(! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_SUSPENDED)),(! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_ENABLED))}});
  assign io_ctrl_ports_1_lowSpeed = ports_1_portLowSpeed;
  assign io_ctrl_ports_1_remoteResume = 1'b0;
  always @(*) begin
    ports_1_rx_enablePackets = 1'b0;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_1_fsm_enumDef_ENABLED : begin
        ports_1_rx_enablePackets = 1'b1;
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign ports_1_rx_j = ((ports_1_filter_io_filtred_dp == (! ports_1_portLowSpeed)) && (ports_1_filter_io_filtred_dm == ports_1_portLowSpeed));
  assign ports_1_rx_k = ((ports_1_filter_io_filtred_dp == ports_1_portLowSpeed) && (ports_1_filter_io_filtred_dm == (! ports_1_portLowSpeed)));
  assign io_management_1_power = io_ctrl_ports_1_power;
  assign io_ctrl_ports_1_overcurrent = io_management_1_overcurrent;
  always @(*) begin
    ports_1_rx_waitSync = 1'b0;
    case(ports_1_rx_packet_stateReg)
      ports_1_rx_packet_enumDef_IDLE : begin
        ports_1_rx_waitSync = 1'b1;
      end
      ports_1_rx_packet_enumDef_PACKET : begin
      end
      ports_1_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_10) begin
      ports_1_rx_waitSync = 1'b1;
    end
  end

  always @(*) begin
    ports_1_rx_decoder_output_valid = 1'b0;
    if(ports_1_filter_io_filtred_sample) begin
      ports_1_rx_decoder_output_valid = 1'b1;
    end
  end

  always @(*) begin
    ports_1_rx_decoder_output_payload = 1'bx;
    if(ports_1_filter_io_filtred_sample) begin
      if(when_UsbHubPhy_l445_1) begin
        ports_1_rx_decoder_output_payload = 1'b0;
      end else begin
        ports_1_rx_decoder_output_payload = 1'b1;
      end
    end
  end

  assign when_UsbHubPhy_l445_1 = ((ports_1_rx_decoder_state ^ ports_1_filter_io_filtred_d) ^ ports_1_portLowSpeed);
  assign ports_1_rx_destuffer_unstuffNext = (ports_1_rx_destuffer_counter == 3'b110);
  assign ports_1_rx_destuffer_output_valid = (ports_1_rx_decoder_output_valid && (! ports_1_rx_destuffer_unstuffNext));
  assign ports_1_rx_destuffer_output_payload = ports_1_rx_decoder_output_payload;
  assign when_UsbHubPhy_l466_1 = ((! ports_1_rx_decoder_output_payload) || ports_1_rx_destuffer_unstuffNext);
  assign ports_1_rx_history_updated = ports_1_rx_destuffer_output_valid;
  assign _zz_ports_1_rx_history_value = ports_1_rx_destuffer_output_payload;
  assign ports_1_rx_history_value = {_zz_ports_1_rx_history_value,{_zz_ports_1_rx_history_value_1,{_zz_ports_1_rx_history_value_2,{_zz_ports_1_rx_history_value_3,{_zz_ports_1_rx_history_value_4,{_zz_ports_1_rx_history_value_5,{_zz_ports_1_rx_history_value_6,_zz_ports_1_rx_history_value_7}}}}}}};
  assign ports_1_rx_history_sync_hit = (ports_1_rx_history_updated && (ports_1_rx_history_value == 8'hd5));
  assign ports_1_rx_eop_maxThreshold = (io_ctrl_lowSpeed ? 7'h60 : 7'h0c);
  assign ports_1_rx_eop_minThreshold = (io_ctrl_lowSpeed ? 6'h2a : 6'h05);
  assign ports_1_rx_eop_maxHit = (ports_1_rx_eop_counter == ports_1_rx_eop_maxThreshold);
  always @(*) begin
    ports_1_rx_eop_hit = 1'b0;
    if(ports_1_rx_j) begin
      if(when_UsbHubPhy_l501_1) begin
        ports_1_rx_eop_hit = 1'b1;
      end
    end
  end

  assign when_UsbHubPhy_l493_1 = ((! ports_1_filter_io_filtred_dp) && (! ports_1_filter_io_filtred_dm));
  assign when_UsbHubPhy_l494_1 = (! ports_1_rx_eop_maxHit);
  assign when_UsbHubPhy_l501_1 = ((_zz_when_UsbHubPhy_l501_1 <= ports_1_rx_eop_counter) && (! ports_1_rx_eop_maxHit));
  assign ports_1_rx_packet_wantExit = 1'b0;
  always @(*) begin
    ports_1_rx_packet_wantStart = 1'b0;
    case(ports_1_rx_packet_stateReg)
      ports_1_rx_packet_enumDef_IDLE : begin
      end
      ports_1_rx_packet_enumDef_PACKET : begin
      end
      ports_1_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
        ports_1_rx_packet_wantStart = 1'b1;
      end
    endcase
  end

  assign ports_1_rx_packet_wantKill = 1'b0;
  always @(*) begin
    ports_1_rx_packet_errorTimeout_clear = 1'b0;
    case(ports_1_rx_packet_stateReg)
      ports_1_rx_packet_enumDef_IDLE : begin
      end
      ports_1_rx_packet_enumDef_PACKET : begin
      end
      ports_1_rx_packet_enumDef_ERRORED : begin
        if(when_UsbHubPhy_l549_1) begin
          ports_1_rx_packet_errorTimeout_clear = 1'b1;
        end
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_11) begin
      ports_1_rx_packet_errorTimeout_clear = 1'b1;
    end
  end

  assign ports_1_rx_packet_errorTimeout_inc = 1'b1;
  assign ports_1_rx_packet_errorTimeout_lowSpeed = io_ctrl_lowSpeed;
  assign ports_1_rx_packet_errorTimeout_trigger = (ports_1_rx_packet_errorTimeout_counter == _zz_ports_1_rx_packet_errorTimeout_trigger);
  always @(*) begin
    ports_1_rx_disconnect_clear = 1'b0;
    if(when_UsbHubPhy_l573_1) begin
      ports_1_rx_disconnect_clear = 1'b1;
    end
    if(when_UsbHubPhy_l767_1) begin
      ports_1_rx_disconnect_clear = 1'b1;
    end
  end

  assign ports_1_rx_disconnect_hit = (ports_1_rx_disconnect_counter == 7'h68);
  assign ports_1_rx_disconnect_event = (ports_1_rx_disconnect_hit && (! ports_1_rx_disconnect_hitLast));
  assign when_UsbHubPhy_l573_1 = ((! ports_1_filter_io_filtred_se0) || io_usb_1_tx_enable);
  assign io_ctrl_ports_1_disconnect = ports_1_rx_disconnect_event;
  assign ports_1_fsm_wantExit = 1'b0;
  always @(*) begin
    ports_1_fsm_wantStart = 1'b0;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_1_fsm_enumDef_ENABLED : begin
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
        ports_1_fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign ports_1_fsm_wantKill = 1'b0;
  always @(*) begin
    ports_1_fsm_timer_clear = 1'b0;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
        if(when_UsbHubPhy_l638_1) begin
          ports_1_fsm_timer_clear = 1'b1;
        end
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_1_fsm_enumDef_ENABLED : begin
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_12) begin
      ports_1_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_13) begin
      ports_1_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_14) begin
      ports_1_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_15) begin
      ports_1_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_16) begin
      ports_1_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_17) begin
      ports_1_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_18) begin
      ports_1_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_19) begin
      ports_1_fsm_timer_clear = 1'b1;
    end
  end

  assign ports_1_fsm_timer_inc = 1'b1;
  assign ports_1_fsm_timer_DISCONNECTED_EOI = (ports_1_fsm_timer_counter == 24'h005dbf);
  assign ports_1_fsm_timer_RESET_DELAY = (ports_1_fsm_timer_counter == 24'h00095f);
  assign ports_1_fsm_timer_RESET_EOI = (ports_1_fsm_timer_counter == 24'h02327f);
  assign ports_1_fsm_timer_RESUME_EOI = (ports_1_fsm_timer_counter == 24'h0176ff);
  assign ports_1_fsm_timer_RESTART_EOI = (ports_1_fsm_timer_counter == 24'h0012bf);
  assign ports_1_fsm_timer_ONE_BIT = (ports_1_fsm_timer_counter == _zz_ports_1_fsm_timer_ONE_BIT);
  assign ports_1_fsm_timer_TWO_BIT = (ports_1_fsm_timer_counter == _zz_ports_1_fsm_timer_TWO_BIT);
  always @(*) begin
    ports_1_fsm_timer_lowSpeed = ports_1_portLowSpeed;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_1_fsm_enumDef_ENABLED : begin
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
        if(ports_1_fsm_lowSpeedEop) begin
          ports_1_fsm_timer_lowSpeed = 1'b1;
        end
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
        if(ports_1_fsm_lowSpeedEop) begin
          ports_1_fsm_timer_lowSpeed = 1'b1;
        end
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_ports_1_disable_ready = 1'b1;
  always @(*) begin
    io_ctrl_ports_1_reset_ready = 1'b0;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
        if(when_UsbHubPhy_l675_1) begin
          io_ctrl_ports_1_reset_ready = 1'b1;
        end
      end
      ports_1_fsm_enumDef_ENABLED : begin
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_ports_1_resume_ready = 1'b1;
  assign io_ctrl_ports_1_suspend_ready = 1'b1;
  always @(*) begin
    io_ctrl_ports_1_connect = 1'b0;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
        if(ports_1_fsm_timer_DISCONNECTED_EOI) begin
          io_ctrl_ports_1_connect = 1'b1;
        end
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_1_fsm_enumDef_ENABLED : begin
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_1_tx_enable = 1'b0;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
        io_usb_1_tx_enable = 1'b1;
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
        io_usb_1_tx_enable = 1'b1;
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_1_fsm_enumDef_ENABLED : begin
        io_usb_1_tx_enable = txShared_encoder_output_valid;
        if(when_UsbHubPhy_l688_1) begin
          io_usb_1_tx_enable = txShared_lowSpeedSof_valid;
        end
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
        io_usb_1_tx_enable = 1'b1;
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
        io_usb_1_tx_enable = 1'b1;
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_1_tx_enable = 1'b1;
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_1_tx_data = 1'bx;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_1_fsm_enumDef_ENABLED : begin
        io_usb_1_tx_data = ((txShared_encoder_output_data || ports_1_fsm_forceJ) ^ ports_1_portLowSpeed);
        if(when_UsbHubPhy_l688_1) begin
          io_usb_1_tx_data = txShared_lowSpeedSof_data;
        end
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
        io_usb_1_tx_data = ports_1_portLowSpeed;
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_1_tx_data = (! ports_1_portLowSpeed);
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_1_tx_se0 = 1'bx;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
        io_usb_1_tx_se0 = 1'b1;
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
        io_usb_1_tx_se0 = 1'b1;
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_1_fsm_enumDef_ENABLED : begin
        io_usb_1_tx_se0 = (txShared_encoder_output_se0 && (! ports_1_fsm_forceJ));
        if(when_UsbHubPhy_l688_1) begin
          io_usb_1_tx_se0 = txShared_lowSpeedSof_se0;
        end
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
        io_usb_1_tx_se0 = 1'b0;
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
        io_usb_1_tx_se0 = 1'b1;
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_1_tx_se0 = 1'b0;
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ports_1_fsm_resetInProgress = 1'b0;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
        ports_1_fsm_resetInProgress = 1'b1;
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
        ports_1_fsm_resetInProgress = 1'b1;
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
        ports_1_fsm_resetInProgress = 1'b1;
      end
      ports_1_fsm_enumDef_ENABLED : begin
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign ports_1_fsm_forceJ = (ports_1_portLowSpeed && (! txShared_encoder_output_lowSpeed));
  assign when_UsbHubPhy_l767_1 = (&{(! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_DISABLED)),{(! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_SUSPENDED)),(! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_ENABLED))}});
  assign io_ctrl_ports_2_lowSpeed = ports_2_portLowSpeed;
  assign io_ctrl_ports_2_remoteResume = 1'b0;
  always @(*) begin
    ports_2_rx_enablePackets = 1'b0;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_2_fsm_enumDef_ENABLED : begin
        ports_2_rx_enablePackets = 1'b1;
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign ports_2_rx_j = ((ports_2_filter_io_filtred_dp == (! ports_2_portLowSpeed)) && (ports_2_filter_io_filtred_dm == ports_2_portLowSpeed));
  assign ports_2_rx_k = ((ports_2_filter_io_filtred_dp == ports_2_portLowSpeed) && (ports_2_filter_io_filtred_dm == (! ports_2_portLowSpeed)));
  assign io_management_2_power = io_ctrl_ports_2_power;
  assign io_ctrl_ports_2_overcurrent = io_management_2_overcurrent;
  always @(*) begin
    ports_2_rx_waitSync = 1'b0;
    case(ports_2_rx_packet_stateReg)
      ports_2_rx_packet_enumDef_IDLE : begin
        ports_2_rx_waitSync = 1'b1;
      end
      ports_2_rx_packet_enumDef_PACKET : begin
      end
      ports_2_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_20) begin
      ports_2_rx_waitSync = 1'b1;
    end
  end

  always @(*) begin
    ports_2_rx_decoder_output_valid = 1'b0;
    if(ports_2_filter_io_filtred_sample) begin
      ports_2_rx_decoder_output_valid = 1'b1;
    end
  end

  always @(*) begin
    ports_2_rx_decoder_output_payload = 1'bx;
    if(ports_2_filter_io_filtred_sample) begin
      if(when_UsbHubPhy_l445_2) begin
        ports_2_rx_decoder_output_payload = 1'b0;
      end else begin
        ports_2_rx_decoder_output_payload = 1'b1;
      end
    end
  end

  assign when_UsbHubPhy_l445_2 = ((ports_2_rx_decoder_state ^ ports_2_filter_io_filtred_d) ^ ports_2_portLowSpeed);
  assign ports_2_rx_destuffer_unstuffNext = (ports_2_rx_destuffer_counter == 3'b110);
  assign ports_2_rx_destuffer_output_valid = (ports_2_rx_decoder_output_valid && (! ports_2_rx_destuffer_unstuffNext));
  assign ports_2_rx_destuffer_output_payload = ports_2_rx_decoder_output_payload;
  assign when_UsbHubPhy_l466_2 = ((! ports_2_rx_decoder_output_payload) || ports_2_rx_destuffer_unstuffNext);
  assign ports_2_rx_history_updated = ports_2_rx_destuffer_output_valid;
  assign _zz_ports_2_rx_history_value = ports_2_rx_destuffer_output_payload;
  assign ports_2_rx_history_value = {_zz_ports_2_rx_history_value,{_zz_ports_2_rx_history_value_1,{_zz_ports_2_rx_history_value_2,{_zz_ports_2_rx_history_value_3,{_zz_ports_2_rx_history_value_4,{_zz_ports_2_rx_history_value_5,{_zz_ports_2_rx_history_value_6,_zz_ports_2_rx_history_value_7}}}}}}};
  assign ports_2_rx_history_sync_hit = (ports_2_rx_history_updated && (ports_2_rx_history_value == 8'hd5));
  assign ports_2_rx_eop_maxThreshold = (io_ctrl_lowSpeed ? 7'h60 : 7'h0c);
  assign ports_2_rx_eop_minThreshold = (io_ctrl_lowSpeed ? 6'h2a : 6'h05);
  assign ports_2_rx_eop_maxHit = (ports_2_rx_eop_counter == ports_2_rx_eop_maxThreshold);
  always @(*) begin
    ports_2_rx_eop_hit = 1'b0;
    if(ports_2_rx_j) begin
      if(when_UsbHubPhy_l501_2) begin
        ports_2_rx_eop_hit = 1'b1;
      end
    end
  end

  assign when_UsbHubPhy_l493_2 = ((! ports_2_filter_io_filtred_dp) && (! ports_2_filter_io_filtred_dm));
  assign when_UsbHubPhy_l494_2 = (! ports_2_rx_eop_maxHit);
  assign when_UsbHubPhy_l501_2 = ((_zz_when_UsbHubPhy_l501_2 <= ports_2_rx_eop_counter) && (! ports_2_rx_eop_maxHit));
  assign ports_2_rx_packet_wantExit = 1'b0;
  always @(*) begin
    ports_2_rx_packet_wantStart = 1'b0;
    case(ports_2_rx_packet_stateReg)
      ports_2_rx_packet_enumDef_IDLE : begin
      end
      ports_2_rx_packet_enumDef_PACKET : begin
      end
      ports_2_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
        ports_2_rx_packet_wantStart = 1'b1;
      end
    endcase
  end

  assign ports_2_rx_packet_wantKill = 1'b0;
  always @(*) begin
    ports_2_rx_packet_errorTimeout_clear = 1'b0;
    case(ports_2_rx_packet_stateReg)
      ports_2_rx_packet_enumDef_IDLE : begin
      end
      ports_2_rx_packet_enumDef_PACKET : begin
      end
      ports_2_rx_packet_enumDef_ERRORED : begin
        if(when_UsbHubPhy_l549_2) begin
          ports_2_rx_packet_errorTimeout_clear = 1'b1;
        end
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_21) begin
      ports_2_rx_packet_errorTimeout_clear = 1'b1;
    end
  end

  assign ports_2_rx_packet_errorTimeout_inc = 1'b1;
  assign ports_2_rx_packet_errorTimeout_lowSpeed = io_ctrl_lowSpeed;
  assign ports_2_rx_packet_errorTimeout_trigger = (ports_2_rx_packet_errorTimeout_counter == _zz_ports_2_rx_packet_errorTimeout_trigger);
  always @(*) begin
    ports_2_rx_disconnect_clear = 1'b0;
    if(when_UsbHubPhy_l573_2) begin
      ports_2_rx_disconnect_clear = 1'b1;
    end
    if(when_UsbHubPhy_l767_2) begin
      ports_2_rx_disconnect_clear = 1'b1;
    end
  end

  assign ports_2_rx_disconnect_hit = (ports_2_rx_disconnect_counter == 7'h68);
  assign ports_2_rx_disconnect_event = (ports_2_rx_disconnect_hit && (! ports_2_rx_disconnect_hitLast));
  assign when_UsbHubPhy_l573_2 = ((! ports_2_filter_io_filtred_se0) || io_usb_2_tx_enable);
  assign io_ctrl_ports_2_disconnect = ports_2_rx_disconnect_event;
  assign ports_2_fsm_wantExit = 1'b0;
  always @(*) begin
    ports_2_fsm_wantStart = 1'b0;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_2_fsm_enumDef_ENABLED : begin
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
        ports_2_fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign ports_2_fsm_wantKill = 1'b0;
  always @(*) begin
    ports_2_fsm_timer_clear = 1'b0;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
        if(when_UsbHubPhy_l638_2) begin
          ports_2_fsm_timer_clear = 1'b1;
        end
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_2_fsm_enumDef_ENABLED : begin
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_22) begin
      ports_2_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_23) begin
      ports_2_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_24) begin
      ports_2_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_25) begin
      ports_2_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_26) begin
      ports_2_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_27) begin
      ports_2_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_28) begin
      ports_2_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_29) begin
      ports_2_fsm_timer_clear = 1'b1;
    end
  end

  assign ports_2_fsm_timer_inc = 1'b1;
  assign ports_2_fsm_timer_DISCONNECTED_EOI = (ports_2_fsm_timer_counter == 24'h005dbf);
  assign ports_2_fsm_timer_RESET_DELAY = (ports_2_fsm_timer_counter == 24'h00095f);
  assign ports_2_fsm_timer_RESET_EOI = (ports_2_fsm_timer_counter == 24'h02327f);
  assign ports_2_fsm_timer_RESUME_EOI = (ports_2_fsm_timer_counter == 24'h0176ff);
  assign ports_2_fsm_timer_RESTART_EOI = (ports_2_fsm_timer_counter == 24'h0012bf);
  assign ports_2_fsm_timer_ONE_BIT = (ports_2_fsm_timer_counter == _zz_ports_2_fsm_timer_ONE_BIT);
  assign ports_2_fsm_timer_TWO_BIT = (ports_2_fsm_timer_counter == _zz_ports_2_fsm_timer_TWO_BIT);
  always @(*) begin
    ports_2_fsm_timer_lowSpeed = ports_2_portLowSpeed;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_2_fsm_enumDef_ENABLED : begin
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
        if(ports_2_fsm_lowSpeedEop) begin
          ports_2_fsm_timer_lowSpeed = 1'b1;
        end
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
        if(ports_2_fsm_lowSpeedEop) begin
          ports_2_fsm_timer_lowSpeed = 1'b1;
        end
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_ports_2_disable_ready = 1'b1;
  always @(*) begin
    io_ctrl_ports_2_reset_ready = 1'b0;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
        if(when_UsbHubPhy_l675_2) begin
          io_ctrl_ports_2_reset_ready = 1'b1;
        end
      end
      ports_2_fsm_enumDef_ENABLED : begin
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_ports_2_resume_ready = 1'b1;
  assign io_ctrl_ports_2_suspend_ready = 1'b1;
  always @(*) begin
    io_ctrl_ports_2_connect = 1'b0;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
        if(ports_2_fsm_timer_DISCONNECTED_EOI) begin
          io_ctrl_ports_2_connect = 1'b1;
        end
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_2_fsm_enumDef_ENABLED : begin
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_2_tx_enable = 1'b0;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
        io_usb_2_tx_enable = 1'b1;
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
        io_usb_2_tx_enable = 1'b1;
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_2_fsm_enumDef_ENABLED : begin
        io_usb_2_tx_enable = txShared_encoder_output_valid;
        if(when_UsbHubPhy_l688_2) begin
          io_usb_2_tx_enable = txShared_lowSpeedSof_valid;
        end
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
        io_usb_2_tx_enable = 1'b1;
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
        io_usb_2_tx_enable = 1'b1;
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_2_tx_enable = 1'b1;
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_2_tx_data = 1'bx;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_2_fsm_enumDef_ENABLED : begin
        io_usb_2_tx_data = ((txShared_encoder_output_data || ports_2_fsm_forceJ) ^ ports_2_portLowSpeed);
        if(when_UsbHubPhy_l688_2) begin
          io_usb_2_tx_data = txShared_lowSpeedSof_data;
        end
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
        io_usb_2_tx_data = ports_2_portLowSpeed;
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_2_tx_data = (! ports_2_portLowSpeed);
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_2_tx_se0 = 1'bx;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
        io_usb_2_tx_se0 = 1'b1;
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
        io_usb_2_tx_se0 = 1'b1;
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_2_fsm_enumDef_ENABLED : begin
        io_usb_2_tx_se0 = (txShared_encoder_output_se0 && (! ports_2_fsm_forceJ));
        if(when_UsbHubPhy_l688_2) begin
          io_usb_2_tx_se0 = txShared_lowSpeedSof_se0;
        end
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
        io_usb_2_tx_se0 = 1'b0;
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
        io_usb_2_tx_se0 = 1'b1;
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_2_tx_se0 = 1'b0;
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ports_2_fsm_resetInProgress = 1'b0;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
        ports_2_fsm_resetInProgress = 1'b1;
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
        ports_2_fsm_resetInProgress = 1'b1;
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
        ports_2_fsm_resetInProgress = 1'b1;
      end
      ports_2_fsm_enumDef_ENABLED : begin
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign ports_2_fsm_forceJ = (ports_2_portLowSpeed && (! txShared_encoder_output_lowSpeed));
  assign when_UsbHubPhy_l767_2 = (&{(! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_DISABLED)),{(! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_SUSPENDED)),(! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_ENABLED))}});
  assign io_ctrl_ports_3_lowSpeed = ports_3_portLowSpeed;
  assign io_ctrl_ports_3_remoteResume = 1'b0;
  always @(*) begin
    ports_3_rx_enablePackets = 1'b0;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_3_fsm_enumDef_ENABLED : begin
        ports_3_rx_enablePackets = 1'b1;
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign ports_3_rx_j = ((ports_3_filter_io_filtred_dp == (! ports_3_portLowSpeed)) && (ports_3_filter_io_filtred_dm == ports_3_portLowSpeed));
  assign ports_3_rx_k = ((ports_3_filter_io_filtred_dp == ports_3_portLowSpeed) && (ports_3_filter_io_filtred_dm == (! ports_3_portLowSpeed)));
  assign io_management_3_power = io_ctrl_ports_3_power;
  assign io_ctrl_ports_3_overcurrent = io_management_3_overcurrent;
  always @(*) begin
    ports_3_rx_waitSync = 1'b0;
    case(ports_3_rx_packet_stateReg)
      ports_3_rx_packet_enumDef_IDLE : begin
        ports_3_rx_waitSync = 1'b1;
      end
      ports_3_rx_packet_enumDef_PACKET : begin
      end
      ports_3_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_30) begin
      ports_3_rx_waitSync = 1'b1;
    end
  end

  always @(*) begin
    ports_3_rx_decoder_output_valid = 1'b0;
    if(ports_3_filter_io_filtred_sample) begin
      ports_3_rx_decoder_output_valid = 1'b1;
    end
  end

  always @(*) begin
    ports_3_rx_decoder_output_payload = 1'bx;
    if(ports_3_filter_io_filtred_sample) begin
      if(when_UsbHubPhy_l445_3) begin
        ports_3_rx_decoder_output_payload = 1'b0;
      end else begin
        ports_3_rx_decoder_output_payload = 1'b1;
      end
    end
  end

  assign when_UsbHubPhy_l445_3 = ((ports_3_rx_decoder_state ^ ports_3_filter_io_filtred_d) ^ ports_3_portLowSpeed);
  assign ports_3_rx_destuffer_unstuffNext = (ports_3_rx_destuffer_counter == 3'b110);
  assign ports_3_rx_destuffer_output_valid = (ports_3_rx_decoder_output_valid && (! ports_3_rx_destuffer_unstuffNext));
  assign ports_3_rx_destuffer_output_payload = ports_3_rx_decoder_output_payload;
  assign when_UsbHubPhy_l466_3 = ((! ports_3_rx_decoder_output_payload) || ports_3_rx_destuffer_unstuffNext);
  assign ports_3_rx_history_updated = ports_3_rx_destuffer_output_valid;
  assign _zz_ports_3_rx_history_value = ports_3_rx_destuffer_output_payload;
  assign ports_3_rx_history_value = {_zz_ports_3_rx_history_value,{_zz_ports_3_rx_history_value_1,{_zz_ports_3_rx_history_value_2,{_zz_ports_3_rx_history_value_3,{_zz_ports_3_rx_history_value_4,{_zz_ports_3_rx_history_value_5,{_zz_ports_3_rx_history_value_6,_zz_ports_3_rx_history_value_7}}}}}}};
  assign ports_3_rx_history_sync_hit = (ports_3_rx_history_updated && (ports_3_rx_history_value == 8'hd5));
  assign ports_3_rx_eop_maxThreshold = (io_ctrl_lowSpeed ? 7'h60 : 7'h0c);
  assign ports_3_rx_eop_minThreshold = (io_ctrl_lowSpeed ? 6'h2a : 6'h05);
  assign ports_3_rx_eop_maxHit = (ports_3_rx_eop_counter == ports_3_rx_eop_maxThreshold);
  always @(*) begin
    ports_3_rx_eop_hit = 1'b0;
    if(ports_3_rx_j) begin
      if(when_UsbHubPhy_l501_3) begin
        ports_3_rx_eop_hit = 1'b1;
      end
    end
  end

  assign when_UsbHubPhy_l493_3 = ((! ports_3_filter_io_filtred_dp) && (! ports_3_filter_io_filtred_dm));
  assign when_UsbHubPhy_l494_3 = (! ports_3_rx_eop_maxHit);
  assign when_UsbHubPhy_l501_3 = ((_zz_when_UsbHubPhy_l501_3 <= ports_3_rx_eop_counter) && (! ports_3_rx_eop_maxHit));
  assign ports_3_rx_packet_wantExit = 1'b0;
  always @(*) begin
    ports_3_rx_packet_wantStart = 1'b0;
    case(ports_3_rx_packet_stateReg)
      ports_3_rx_packet_enumDef_IDLE : begin
      end
      ports_3_rx_packet_enumDef_PACKET : begin
      end
      ports_3_rx_packet_enumDef_ERRORED : begin
      end
      default : begin
        ports_3_rx_packet_wantStart = 1'b1;
      end
    endcase
  end

  assign ports_3_rx_packet_wantKill = 1'b0;
  always @(*) begin
    ports_3_rx_packet_errorTimeout_clear = 1'b0;
    case(ports_3_rx_packet_stateReg)
      ports_3_rx_packet_enumDef_IDLE : begin
      end
      ports_3_rx_packet_enumDef_PACKET : begin
      end
      ports_3_rx_packet_enumDef_ERRORED : begin
        if(when_UsbHubPhy_l549_3) begin
          ports_3_rx_packet_errorTimeout_clear = 1'b1;
        end
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_31) begin
      ports_3_rx_packet_errorTimeout_clear = 1'b1;
    end
  end

  assign ports_3_rx_packet_errorTimeout_inc = 1'b1;
  assign ports_3_rx_packet_errorTimeout_lowSpeed = io_ctrl_lowSpeed;
  assign ports_3_rx_packet_errorTimeout_trigger = (ports_3_rx_packet_errorTimeout_counter == _zz_ports_3_rx_packet_errorTimeout_trigger);
  always @(*) begin
    ports_3_rx_disconnect_clear = 1'b0;
    if(when_UsbHubPhy_l573_3) begin
      ports_3_rx_disconnect_clear = 1'b1;
    end
    if(when_UsbHubPhy_l767_3) begin
      ports_3_rx_disconnect_clear = 1'b1;
    end
  end

  assign ports_3_rx_disconnect_hit = (ports_3_rx_disconnect_counter == 7'h68);
  assign ports_3_rx_disconnect_event = (ports_3_rx_disconnect_hit && (! ports_3_rx_disconnect_hitLast));
  assign when_UsbHubPhy_l573_3 = ((! ports_3_filter_io_filtred_se0) || io_usb_3_tx_enable);
  assign io_ctrl_ports_3_disconnect = ports_3_rx_disconnect_event;
  assign ports_3_fsm_wantExit = 1'b0;
  always @(*) begin
    ports_3_fsm_wantStart = 1'b0;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_3_fsm_enumDef_ENABLED : begin
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
        ports_3_fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign ports_3_fsm_wantKill = 1'b0;
  always @(*) begin
    ports_3_fsm_timer_clear = 1'b0;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
        if(when_UsbHubPhy_l638_3) begin
          ports_3_fsm_timer_clear = 1'b1;
        end
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_3_fsm_enumDef_ENABLED : begin
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_32) begin
      ports_3_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_33) begin
      ports_3_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_34) begin
      ports_3_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_35) begin
      ports_3_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_36) begin
      ports_3_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_37) begin
      ports_3_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_38) begin
      ports_3_fsm_timer_clear = 1'b1;
    end
    if(when_StateMachine_l253_39) begin
      ports_3_fsm_timer_clear = 1'b1;
    end
  end

  assign ports_3_fsm_timer_inc = 1'b1;
  assign ports_3_fsm_timer_DISCONNECTED_EOI = (ports_3_fsm_timer_counter == 24'h005dbf);
  assign ports_3_fsm_timer_RESET_DELAY = (ports_3_fsm_timer_counter == 24'h00095f);
  assign ports_3_fsm_timer_RESET_EOI = (ports_3_fsm_timer_counter == 24'h02327f);
  assign ports_3_fsm_timer_RESUME_EOI = (ports_3_fsm_timer_counter == 24'h0176ff);
  assign ports_3_fsm_timer_RESTART_EOI = (ports_3_fsm_timer_counter == 24'h0012bf);
  assign ports_3_fsm_timer_ONE_BIT = (ports_3_fsm_timer_counter == _zz_ports_3_fsm_timer_ONE_BIT);
  assign ports_3_fsm_timer_TWO_BIT = (ports_3_fsm_timer_counter == _zz_ports_3_fsm_timer_TWO_BIT);
  always @(*) begin
    ports_3_fsm_timer_lowSpeed = ports_3_portLowSpeed;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_3_fsm_enumDef_ENABLED : begin
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
        if(ports_3_fsm_lowSpeedEop) begin
          ports_3_fsm_timer_lowSpeed = 1'b1;
        end
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
        if(ports_3_fsm_lowSpeedEop) begin
          ports_3_fsm_timer_lowSpeed = 1'b1;
        end
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_ports_3_disable_ready = 1'b1;
  always @(*) begin
    io_ctrl_ports_3_reset_ready = 1'b0;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
        if(when_UsbHubPhy_l675_3) begin
          io_ctrl_ports_3_reset_ready = 1'b1;
        end
      end
      ports_3_fsm_enumDef_ENABLED : begin
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_ports_3_resume_ready = 1'b1;
  assign io_ctrl_ports_3_suspend_ready = 1'b1;
  always @(*) begin
    io_ctrl_ports_3_connect = 1'b0;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
        if(ports_3_fsm_timer_DISCONNECTED_EOI) begin
          io_ctrl_ports_3_connect = 1'b1;
        end
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_3_fsm_enumDef_ENABLED : begin
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_3_tx_enable = 1'b0;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
        io_usb_3_tx_enable = 1'b1;
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
        io_usb_3_tx_enable = 1'b1;
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_3_fsm_enumDef_ENABLED : begin
        io_usb_3_tx_enable = txShared_encoder_output_valid;
        if(when_UsbHubPhy_l688_3) begin
          io_usb_3_tx_enable = txShared_lowSpeedSof_valid;
        end
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
        io_usb_3_tx_enable = 1'b1;
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
        io_usb_3_tx_enable = 1'b1;
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_3_tx_enable = 1'b1;
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_3_tx_data = 1'bx;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_3_fsm_enumDef_ENABLED : begin
        io_usb_3_tx_data = ((txShared_encoder_output_data || ports_3_fsm_forceJ) ^ ports_3_portLowSpeed);
        if(when_UsbHubPhy_l688_3) begin
          io_usb_3_tx_data = txShared_lowSpeedSof_data;
        end
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
        io_usb_3_tx_data = ports_3_portLowSpeed;
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_3_tx_data = (! ports_3_portLowSpeed);
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_usb_3_tx_se0 = 1'bx;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
        io_usb_3_tx_se0 = 1'b1;
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
        io_usb_3_tx_se0 = 1'b1;
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_3_fsm_enumDef_ENABLED : begin
        io_usb_3_tx_se0 = (txShared_encoder_output_se0 && (! ports_3_fsm_forceJ));
        if(when_UsbHubPhy_l688_3) begin
          io_usb_3_tx_se0 = txShared_lowSpeedSof_se0;
        end
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
        io_usb_3_tx_se0 = 1'b0;
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
        io_usb_3_tx_se0 = 1'b1;
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
        io_usb_3_tx_se0 = 1'b0;
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ports_3_fsm_resetInProgress = 1'b0;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
        ports_3_fsm_resetInProgress = 1'b1;
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
        ports_3_fsm_resetInProgress = 1'b1;
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
        ports_3_fsm_resetInProgress = 1'b1;
      end
      ports_3_fsm_enumDef_ENABLED : begin
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
  end

  assign ports_3_fsm_forceJ = (ports_3_portLowSpeed && (! txShared_encoder_output_lowSpeed));
  assign when_UsbHubPhy_l767_3 = (&{(! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_DISABLED)),{(! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_SUSPENDED)),(! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_ENABLED))}});
  always @(*) begin
    txShared_frame_stateNext = txShared_frame_stateReg;
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
        if(when_UsbHubPhy_l289) begin
          txShared_frame_stateNext = txShared_frame_enumDef_TAKE_LINE;
        end
      end
      txShared_frame_enumDef_TAKE_LINE : begin
        if(txShared_timer_oneCycle) begin
          if(io_ctrl_lowSpeed) begin
            txShared_frame_stateNext = txShared_frame_enumDef_PREAMBLE_SYNC;
          end else begin
            txShared_frame_stateNext = txShared_frame_enumDef_SYNC;
          end
        end
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
        if(txShared_serialiser_input_ready) begin
          txShared_frame_stateNext = txShared_frame_enumDef_PREAMBLE_PID;
        end
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
        if(txShared_serialiser_input_ready) begin
          txShared_frame_stateNext = txShared_frame_enumDef_PREAMBLE_DELAY;
        end
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
        if(txShared_timer_fourCycle) begin
          txShared_frame_stateNext = txShared_frame_enumDef_SYNC;
        end
      end
      txShared_frame_enumDef_SYNC : begin
        if(txShared_serialiser_input_ready) begin
          txShared_frame_stateNext = txShared_frame_enumDef_DATA;
        end
      end
      txShared_frame_enumDef_DATA : begin
        if(txShared_serialiser_input_ready) begin
          if(io_ctrl_tx_payload_last) begin
            txShared_frame_stateNext = txShared_frame_enumDef_EOP_0;
          end
        end
      end
      txShared_frame_enumDef_EOP_0 : begin
        if(txShared_timer_twoCycle) begin
          txShared_frame_stateNext = txShared_frame_enumDef_EOP_1;
        end
      end
      txShared_frame_enumDef_EOP_1 : begin
        if(txShared_timer_oneCycle) begin
          txShared_frame_stateNext = txShared_frame_enumDef_EOP_2;
        end
      end
      txShared_frame_enumDef_EOP_2 : begin
        if(txShared_timer_twoCycle) begin
          txShared_frame_stateNext = txShared_frame_enumDef_IDLE;
        end
      end
      default : begin
      end
    endcase
    if(txShared_frame_wantStart) begin
      txShared_frame_stateNext = txShared_frame_enumDef_IDLE;
    end
    if(txShared_frame_wantKill) begin
      txShared_frame_stateNext = txShared_frame_enumDef_BOOT;
    end
  end

  assign when_UsbHubPhy_l289 = (io_ctrl_tx_valid && (! txShared_rxToTxDelay_active));
  always @(*) begin
    upstreamRx_stateNext = upstreamRx_stateReg;
    case(upstreamRx_stateReg)
      upstreamRx_enumDef_IDLE : begin
        if(upstreamRx_timer_IDLE_EOI) begin
          upstreamRx_stateNext = upstreamRx_enumDef_SUSPEND;
        end
      end
      upstreamRx_enumDef_SUSPEND : begin
        if(txShared_encoder_output_valid) begin
          upstreamRx_stateNext = upstreamRx_enumDef_IDLE;
        end
      end
      default : begin
      end
    endcase
    if(upstreamRx_wantStart) begin
      upstreamRx_stateNext = upstreamRx_enumDef_IDLE;
    end
    if(upstreamRx_wantKill) begin
      upstreamRx_stateNext = upstreamRx_enumDef_BOOT;
    end
  end

  assign Rx_Suspend = (upstreamRx_stateReg == upstreamRx_enumDef_SUSPEND);
  always @(*) begin
    ports_0_rx_packet_stateNext = ports_0_rx_packet_stateReg;
    case(ports_0_rx_packet_stateReg)
      ports_0_rx_packet_enumDef_IDLE : begin
        if(ports_0_rx_history_sync_hit) begin
          ports_0_rx_packet_stateNext = ports_0_rx_packet_enumDef_PACKET;
        end
      end
      ports_0_rx_packet_enumDef_PACKET : begin
        if(ports_0_rx_destuffer_output_valid) begin
          if(when_UsbHubPhy_l527) begin
            if(ports_0_rx_stuffingError) begin
              ports_0_rx_packet_stateNext = ports_0_rx_packet_enumDef_ERRORED;
            end
          end
        end
      end
      ports_0_rx_packet_enumDef_ERRORED : begin
        if(ports_0_rx_packet_errorTimeout_trigger) begin
          ports_0_rx_packet_stateNext = ports_0_rx_packet_enumDef_IDLE;
        end
      end
      default : begin
      end
    endcase
    if(ports_0_rx_eop_hit) begin
      ports_0_rx_packet_stateNext = ports_0_rx_packet_enumDef_IDLE;
    end
    if(txShared_encoder_output_valid) begin
      ports_0_rx_packet_stateNext = ports_0_rx_packet_enumDef_IDLE;
    end
    if(ports_0_rx_packet_wantStart) begin
      ports_0_rx_packet_stateNext = ports_0_rx_packet_enumDef_IDLE;
    end
    if(ports_0_rx_packet_wantKill) begin
      ports_0_rx_packet_stateNext = ports_0_rx_packet_enumDef_BOOT;
    end
  end

  assign when_UsbHubPhy_l527 = (ports_0_rx_packet_counter == 3'b111);
  assign when_UsbHubPhy_l549 = ((ports_0_rx_packet_errorTimeout_p != ports_0_filter_io_filtred_dp) || (ports_0_rx_packet_errorTimeout_n != ports_0_filter_io_filtred_dm));
  assign when_StateMachine_l253 = ((! (ports_0_rx_packet_stateReg == ports_0_rx_packet_enumDef_IDLE)) && (ports_0_rx_packet_stateNext == ports_0_rx_packet_enumDef_IDLE));
  assign when_StateMachine_l253_1 = ((! (ports_0_rx_packet_stateReg == ports_0_rx_packet_enumDef_ERRORED)) && (ports_0_rx_packet_stateNext == ports_0_rx_packet_enumDef_ERRORED));
  always @(*) begin
    ports_0_fsm_stateNext = ports_0_fsm_stateReg;
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
        if(io_ctrl_ports_0_power) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_DISCONNECTED;
        end
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
        if(ports_0_fsm_timer_DISCONNECTED_EOI) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_DISABLED;
        end
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
        if(ports_0_fsm_timer_RESET_EOI) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_RESETTING_DELAY;
        end
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
        if(ports_0_fsm_timer_RESET_DELAY) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_RESETTING_SYNC;
        end
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
        if(when_UsbHubPhy_l675) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_ENABLED;
        end
      end
      ports_0_fsm_enumDef_ENABLED : begin
        if(io_ctrl_ports_0_suspend_valid) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_SUSPENDED;
        end else begin
          if(when_UsbHubPhy_l697) begin
            ports_0_fsm_stateNext = ports_0_fsm_enumDef_RESTART_E;
          end else begin
            if(io_ctrl_usbResume) begin
              ports_0_fsm_stateNext = ports_0_fsm_enumDef_RESUMING;
            end
          end
        end
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
        if(when_UsbHubPhy_l705) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_RESUMING;
        end else begin
          if(when_UsbHubPhy_l707) begin
            ports_0_fsm_stateNext = ports_0_fsm_enumDef_RESTART_S;
          end
        end
      end
      ports_0_fsm_enumDef_RESUMING : begin
        if(ports_0_fsm_timer_RESUME_EOI) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_SEND_EOP_0;
        end
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
        if(ports_0_fsm_timer_TWO_BIT) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_SEND_EOP_1;
        end
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
        if(ports_0_fsm_timer_ONE_BIT) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_ENABLED;
        end
      end
      ports_0_fsm_enumDef_RESTART_S : begin
        if(when_UsbHubPhy_l748) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_RESUMING;
        end
        if(ports_0_fsm_timer_RESTART_EOI) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_DISCONNECTED;
        end
      end
      ports_0_fsm_enumDef_RESTART_E : begin
        if(when_UsbHubPhy_l758) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_RESUMING;
        end
        if(ports_0_fsm_timer_RESTART_EOI) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_DISCONNECTED;
        end
      end
      default : begin
      end
    endcase
    if(when_UsbHubPhy_l610) begin
      ports_0_fsm_stateNext = ports_0_fsm_enumDef_POWER_OFF;
    end else begin
      if(ports_0_rx_disconnect_event) begin
        ports_0_fsm_stateNext = ports_0_fsm_enumDef_DISCONNECTED;
      end else begin
        if(io_ctrl_ports_0_disable_valid) begin
          ports_0_fsm_stateNext = ports_0_fsm_enumDef_DISABLED;
        end else begin
          if(io_ctrl_ports_0_reset_valid) begin
            if(when_UsbHubPhy_l617) begin
              if(when_UsbHubPhy_l618) begin
                ports_0_fsm_stateNext = ports_0_fsm_enumDef_RESETTING;
              end
            end
          end
        end
      end
    end
    if(ports_0_fsm_wantStart) begin
      ports_0_fsm_stateNext = ports_0_fsm_enumDef_POWER_OFF;
    end
    if(ports_0_fsm_wantKill) begin
      ports_0_fsm_stateNext = ports_0_fsm_enumDef_BOOT;
    end
  end

  assign when_UsbHubPhy_l638 = ((! ports_0_filter_io_filtred_dp) && (! ports_0_filter_io_filtred_dm));
  assign when_UsbHubPhy_l675 = (! txShared_encoder_output_valid);
  assign when_UsbHubPhy_l688 = (ports_0_portLowSpeed && txShared_lowSpeedSof_overrideEncoder);
  assign when_UsbHubPhy_l697 = (Rx_Suspend && (ports_0_filter_io_filtred_se0 || ((! ports_0_filter_io_filtred_se0) && ((! ports_0_filter_io_filtred_d) ^ ports_0_portLowSpeed))));
  assign when_UsbHubPhy_l705 = (io_ctrl_ports_0_resume_valid || ((! Rx_Suspend) && ((! ports_0_filter_io_filtred_se0) && ((! ports_0_filter_io_filtred_d) ^ ports_0_portLowSpeed))));
  assign when_UsbHubPhy_l707 = (Rx_Suspend && (ports_0_filter_io_filtred_se0 || ((! ports_0_filter_io_filtred_se0) && ((! ports_0_filter_io_filtred_d) ^ ports_0_portLowSpeed))));
  assign when_UsbHubPhy_l748 = ((! ports_0_filter_io_filtred_se0) && ((! ports_0_filter_io_filtred_d) ^ ports_0_portLowSpeed));
  assign when_UsbHubPhy_l758 = ((! ports_0_filter_io_filtred_se0) && ((! ports_0_filter_io_filtred_d) ^ ports_0_portLowSpeed));
  assign when_StateMachine_l253_2 = ((! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_DISCONNECTED)) && (ports_0_fsm_stateNext == ports_0_fsm_enumDef_DISCONNECTED));
  assign when_StateMachine_l253_3 = ((! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_RESETTING)) && (ports_0_fsm_stateNext == ports_0_fsm_enumDef_RESETTING));
  assign when_StateMachine_l253_4 = ((! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_RESETTING_DELAY)) && (ports_0_fsm_stateNext == ports_0_fsm_enumDef_RESETTING_DELAY));
  assign when_StateMachine_l253_5 = ((! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_RESUMING)) && (ports_0_fsm_stateNext == ports_0_fsm_enumDef_RESUMING));
  assign when_StateMachine_l253_6 = ((! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_SEND_EOP_0)) && (ports_0_fsm_stateNext == ports_0_fsm_enumDef_SEND_EOP_0));
  assign when_StateMachine_l253_7 = ((! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_SEND_EOP_1)) && (ports_0_fsm_stateNext == ports_0_fsm_enumDef_SEND_EOP_1));
  assign when_StateMachine_l253_8 = ((! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_RESTART_S)) && (ports_0_fsm_stateNext == ports_0_fsm_enumDef_RESTART_S));
  assign when_StateMachine_l253_9 = ((! (ports_0_fsm_stateReg == ports_0_fsm_enumDef_RESTART_E)) && (ports_0_fsm_stateNext == ports_0_fsm_enumDef_RESTART_E));
  assign when_UsbHubPhy_l610 = ((! io_ctrl_ports_0_power) || io_ctrl_usbReset);
  assign when_UsbHubPhy_l617 = (! ports_0_fsm_resetInProgress);
  assign when_UsbHubPhy_l618 = (ports_0_filter_io_filtred_dm != ports_0_filter_io_filtred_dp);
  always @(*) begin
    ports_1_rx_packet_stateNext = ports_1_rx_packet_stateReg;
    case(ports_1_rx_packet_stateReg)
      ports_1_rx_packet_enumDef_IDLE : begin
        if(ports_1_rx_history_sync_hit) begin
          ports_1_rx_packet_stateNext = ports_1_rx_packet_enumDef_PACKET;
        end
      end
      ports_1_rx_packet_enumDef_PACKET : begin
        if(ports_1_rx_destuffer_output_valid) begin
          if(when_UsbHubPhy_l527_1) begin
            if(ports_1_rx_stuffingError) begin
              ports_1_rx_packet_stateNext = ports_1_rx_packet_enumDef_ERRORED;
            end
          end
        end
      end
      ports_1_rx_packet_enumDef_ERRORED : begin
        if(ports_1_rx_packet_errorTimeout_trigger) begin
          ports_1_rx_packet_stateNext = ports_1_rx_packet_enumDef_IDLE;
        end
      end
      default : begin
      end
    endcase
    if(ports_1_rx_eop_hit) begin
      ports_1_rx_packet_stateNext = ports_1_rx_packet_enumDef_IDLE;
    end
    if(txShared_encoder_output_valid) begin
      ports_1_rx_packet_stateNext = ports_1_rx_packet_enumDef_IDLE;
    end
    if(ports_1_rx_packet_wantStart) begin
      ports_1_rx_packet_stateNext = ports_1_rx_packet_enumDef_IDLE;
    end
    if(ports_1_rx_packet_wantKill) begin
      ports_1_rx_packet_stateNext = ports_1_rx_packet_enumDef_BOOT;
    end
  end

  assign when_UsbHubPhy_l527_1 = (ports_1_rx_packet_counter == 3'b111);
  assign when_UsbHubPhy_l549_1 = ((ports_1_rx_packet_errorTimeout_p != ports_1_filter_io_filtred_dp) || (ports_1_rx_packet_errorTimeout_n != ports_1_filter_io_filtred_dm));
  assign when_StateMachine_l253_10 = ((! (ports_1_rx_packet_stateReg == ports_1_rx_packet_enumDef_IDLE)) && (ports_1_rx_packet_stateNext == ports_1_rx_packet_enumDef_IDLE));
  assign when_StateMachine_l253_11 = ((! (ports_1_rx_packet_stateReg == ports_1_rx_packet_enumDef_ERRORED)) && (ports_1_rx_packet_stateNext == ports_1_rx_packet_enumDef_ERRORED));
  always @(*) begin
    ports_1_fsm_stateNext = ports_1_fsm_stateReg;
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
        if(io_ctrl_ports_1_power) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_DISCONNECTED;
        end
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
        if(ports_1_fsm_timer_DISCONNECTED_EOI) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_DISABLED;
        end
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
        if(ports_1_fsm_timer_RESET_EOI) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_RESETTING_DELAY;
        end
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
        if(ports_1_fsm_timer_RESET_DELAY) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_RESETTING_SYNC;
        end
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
        if(when_UsbHubPhy_l675_1) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_ENABLED;
        end
      end
      ports_1_fsm_enumDef_ENABLED : begin
        if(io_ctrl_ports_1_suspend_valid) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_SUSPENDED;
        end else begin
          if(when_UsbHubPhy_l697_1) begin
            ports_1_fsm_stateNext = ports_1_fsm_enumDef_RESTART_E;
          end else begin
            if(io_ctrl_usbResume) begin
              ports_1_fsm_stateNext = ports_1_fsm_enumDef_RESUMING;
            end
          end
        end
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
        if(when_UsbHubPhy_l705_1) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_RESUMING;
        end else begin
          if(when_UsbHubPhy_l707_1) begin
            ports_1_fsm_stateNext = ports_1_fsm_enumDef_RESTART_S;
          end
        end
      end
      ports_1_fsm_enumDef_RESUMING : begin
        if(ports_1_fsm_timer_RESUME_EOI) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_SEND_EOP_0;
        end
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
        if(ports_1_fsm_timer_TWO_BIT) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_SEND_EOP_1;
        end
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
        if(ports_1_fsm_timer_ONE_BIT) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_ENABLED;
        end
      end
      ports_1_fsm_enumDef_RESTART_S : begin
        if(when_UsbHubPhy_l748_1) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_RESUMING;
        end
        if(ports_1_fsm_timer_RESTART_EOI) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_DISCONNECTED;
        end
      end
      ports_1_fsm_enumDef_RESTART_E : begin
        if(when_UsbHubPhy_l758_1) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_RESUMING;
        end
        if(ports_1_fsm_timer_RESTART_EOI) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_DISCONNECTED;
        end
      end
      default : begin
      end
    endcase
    if(when_UsbHubPhy_l610_1) begin
      ports_1_fsm_stateNext = ports_1_fsm_enumDef_POWER_OFF;
    end else begin
      if(ports_1_rx_disconnect_event) begin
        ports_1_fsm_stateNext = ports_1_fsm_enumDef_DISCONNECTED;
      end else begin
        if(io_ctrl_ports_1_disable_valid) begin
          ports_1_fsm_stateNext = ports_1_fsm_enumDef_DISABLED;
        end else begin
          if(io_ctrl_ports_1_reset_valid) begin
            if(when_UsbHubPhy_l617_1) begin
              if(when_UsbHubPhy_l618_1) begin
                ports_1_fsm_stateNext = ports_1_fsm_enumDef_RESETTING;
              end
            end
          end
        end
      end
    end
    if(ports_1_fsm_wantStart) begin
      ports_1_fsm_stateNext = ports_1_fsm_enumDef_POWER_OFF;
    end
    if(ports_1_fsm_wantKill) begin
      ports_1_fsm_stateNext = ports_1_fsm_enumDef_BOOT;
    end
  end

  assign when_UsbHubPhy_l638_1 = ((! ports_1_filter_io_filtred_dp) && (! ports_1_filter_io_filtred_dm));
  assign when_UsbHubPhy_l675_1 = (! txShared_encoder_output_valid);
  assign when_UsbHubPhy_l688_1 = (ports_1_portLowSpeed && txShared_lowSpeedSof_overrideEncoder);
  assign when_UsbHubPhy_l697_1 = (Rx_Suspend && (ports_1_filter_io_filtred_se0 || ((! ports_1_filter_io_filtred_se0) && ((! ports_1_filter_io_filtred_d) ^ ports_1_portLowSpeed))));
  assign when_UsbHubPhy_l705_1 = (io_ctrl_ports_1_resume_valid || ((! Rx_Suspend) && ((! ports_1_filter_io_filtred_se0) && ((! ports_1_filter_io_filtred_d) ^ ports_1_portLowSpeed))));
  assign when_UsbHubPhy_l707_1 = (Rx_Suspend && (ports_1_filter_io_filtred_se0 || ((! ports_1_filter_io_filtred_se0) && ((! ports_1_filter_io_filtred_d) ^ ports_1_portLowSpeed))));
  assign when_UsbHubPhy_l748_1 = ((! ports_1_filter_io_filtred_se0) && ((! ports_1_filter_io_filtred_d) ^ ports_1_portLowSpeed));
  assign when_UsbHubPhy_l758_1 = ((! ports_1_filter_io_filtred_se0) && ((! ports_1_filter_io_filtred_d) ^ ports_1_portLowSpeed));
  assign when_StateMachine_l253_12 = ((! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_DISCONNECTED)) && (ports_1_fsm_stateNext == ports_1_fsm_enumDef_DISCONNECTED));
  assign when_StateMachine_l253_13 = ((! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_RESETTING)) && (ports_1_fsm_stateNext == ports_1_fsm_enumDef_RESETTING));
  assign when_StateMachine_l253_14 = ((! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_RESETTING_DELAY)) && (ports_1_fsm_stateNext == ports_1_fsm_enumDef_RESETTING_DELAY));
  assign when_StateMachine_l253_15 = ((! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_RESUMING)) && (ports_1_fsm_stateNext == ports_1_fsm_enumDef_RESUMING));
  assign when_StateMachine_l253_16 = ((! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_SEND_EOP_0)) && (ports_1_fsm_stateNext == ports_1_fsm_enumDef_SEND_EOP_0));
  assign when_StateMachine_l253_17 = ((! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_SEND_EOP_1)) && (ports_1_fsm_stateNext == ports_1_fsm_enumDef_SEND_EOP_1));
  assign when_StateMachine_l253_18 = ((! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_RESTART_S)) && (ports_1_fsm_stateNext == ports_1_fsm_enumDef_RESTART_S));
  assign when_StateMachine_l253_19 = ((! (ports_1_fsm_stateReg == ports_1_fsm_enumDef_RESTART_E)) && (ports_1_fsm_stateNext == ports_1_fsm_enumDef_RESTART_E));
  assign when_UsbHubPhy_l610_1 = ((! io_ctrl_ports_1_power) || io_ctrl_usbReset);
  assign when_UsbHubPhy_l617_1 = (! ports_1_fsm_resetInProgress);
  assign when_UsbHubPhy_l618_1 = (ports_1_filter_io_filtred_dm != ports_1_filter_io_filtred_dp);
  always @(*) begin
    ports_2_rx_packet_stateNext = ports_2_rx_packet_stateReg;
    case(ports_2_rx_packet_stateReg)
      ports_2_rx_packet_enumDef_IDLE : begin
        if(ports_2_rx_history_sync_hit) begin
          ports_2_rx_packet_stateNext = ports_2_rx_packet_enumDef_PACKET;
        end
      end
      ports_2_rx_packet_enumDef_PACKET : begin
        if(ports_2_rx_destuffer_output_valid) begin
          if(when_UsbHubPhy_l527_2) begin
            if(ports_2_rx_stuffingError) begin
              ports_2_rx_packet_stateNext = ports_2_rx_packet_enumDef_ERRORED;
            end
          end
        end
      end
      ports_2_rx_packet_enumDef_ERRORED : begin
        if(ports_2_rx_packet_errorTimeout_trigger) begin
          ports_2_rx_packet_stateNext = ports_2_rx_packet_enumDef_IDLE;
        end
      end
      default : begin
      end
    endcase
    if(ports_2_rx_eop_hit) begin
      ports_2_rx_packet_stateNext = ports_2_rx_packet_enumDef_IDLE;
    end
    if(txShared_encoder_output_valid) begin
      ports_2_rx_packet_stateNext = ports_2_rx_packet_enumDef_IDLE;
    end
    if(ports_2_rx_packet_wantStart) begin
      ports_2_rx_packet_stateNext = ports_2_rx_packet_enumDef_IDLE;
    end
    if(ports_2_rx_packet_wantKill) begin
      ports_2_rx_packet_stateNext = ports_2_rx_packet_enumDef_BOOT;
    end
  end

  assign when_UsbHubPhy_l527_2 = (ports_2_rx_packet_counter == 3'b111);
  assign when_UsbHubPhy_l549_2 = ((ports_2_rx_packet_errorTimeout_p != ports_2_filter_io_filtred_dp) || (ports_2_rx_packet_errorTimeout_n != ports_2_filter_io_filtred_dm));
  assign when_StateMachine_l253_20 = ((! (ports_2_rx_packet_stateReg == ports_2_rx_packet_enumDef_IDLE)) && (ports_2_rx_packet_stateNext == ports_2_rx_packet_enumDef_IDLE));
  assign when_StateMachine_l253_21 = ((! (ports_2_rx_packet_stateReg == ports_2_rx_packet_enumDef_ERRORED)) && (ports_2_rx_packet_stateNext == ports_2_rx_packet_enumDef_ERRORED));
  always @(*) begin
    ports_2_fsm_stateNext = ports_2_fsm_stateReg;
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
        if(io_ctrl_ports_2_power) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_DISCONNECTED;
        end
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
        if(ports_2_fsm_timer_DISCONNECTED_EOI) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_DISABLED;
        end
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
        if(ports_2_fsm_timer_RESET_EOI) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_RESETTING_DELAY;
        end
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
        if(ports_2_fsm_timer_RESET_DELAY) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_RESETTING_SYNC;
        end
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
        if(when_UsbHubPhy_l675_2) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_ENABLED;
        end
      end
      ports_2_fsm_enumDef_ENABLED : begin
        if(io_ctrl_ports_2_suspend_valid) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_SUSPENDED;
        end else begin
          if(when_UsbHubPhy_l697_2) begin
            ports_2_fsm_stateNext = ports_2_fsm_enumDef_RESTART_E;
          end else begin
            if(io_ctrl_usbResume) begin
              ports_2_fsm_stateNext = ports_2_fsm_enumDef_RESUMING;
            end
          end
        end
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
        if(when_UsbHubPhy_l705_2) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_RESUMING;
        end else begin
          if(when_UsbHubPhy_l707_2) begin
            ports_2_fsm_stateNext = ports_2_fsm_enumDef_RESTART_S;
          end
        end
      end
      ports_2_fsm_enumDef_RESUMING : begin
        if(ports_2_fsm_timer_RESUME_EOI) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_SEND_EOP_0;
        end
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
        if(ports_2_fsm_timer_TWO_BIT) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_SEND_EOP_1;
        end
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
        if(ports_2_fsm_timer_ONE_BIT) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_ENABLED;
        end
      end
      ports_2_fsm_enumDef_RESTART_S : begin
        if(when_UsbHubPhy_l748_2) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_RESUMING;
        end
        if(ports_2_fsm_timer_RESTART_EOI) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_DISCONNECTED;
        end
      end
      ports_2_fsm_enumDef_RESTART_E : begin
        if(when_UsbHubPhy_l758_2) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_RESUMING;
        end
        if(ports_2_fsm_timer_RESTART_EOI) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_DISCONNECTED;
        end
      end
      default : begin
      end
    endcase
    if(when_UsbHubPhy_l610_2) begin
      ports_2_fsm_stateNext = ports_2_fsm_enumDef_POWER_OFF;
    end else begin
      if(ports_2_rx_disconnect_event) begin
        ports_2_fsm_stateNext = ports_2_fsm_enumDef_DISCONNECTED;
      end else begin
        if(io_ctrl_ports_2_disable_valid) begin
          ports_2_fsm_stateNext = ports_2_fsm_enumDef_DISABLED;
        end else begin
          if(io_ctrl_ports_2_reset_valid) begin
            if(when_UsbHubPhy_l617_2) begin
              if(when_UsbHubPhy_l618_2) begin
                ports_2_fsm_stateNext = ports_2_fsm_enumDef_RESETTING;
              end
            end
          end
        end
      end
    end
    if(ports_2_fsm_wantStart) begin
      ports_2_fsm_stateNext = ports_2_fsm_enumDef_POWER_OFF;
    end
    if(ports_2_fsm_wantKill) begin
      ports_2_fsm_stateNext = ports_2_fsm_enumDef_BOOT;
    end
  end

  assign when_UsbHubPhy_l638_2 = ((! ports_2_filter_io_filtred_dp) && (! ports_2_filter_io_filtred_dm));
  assign when_UsbHubPhy_l675_2 = (! txShared_encoder_output_valid);
  assign when_UsbHubPhy_l688_2 = (ports_2_portLowSpeed && txShared_lowSpeedSof_overrideEncoder);
  assign when_UsbHubPhy_l697_2 = (Rx_Suspend && (ports_2_filter_io_filtred_se0 || ((! ports_2_filter_io_filtred_se0) && ((! ports_2_filter_io_filtred_d) ^ ports_2_portLowSpeed))));
  assign when_UsbHubPhy_l705_2 = (io_ctrl_ports_2_resume_valid || ((! Rx_Suspend) && ((! ports_2_filter_io_filtred_se0) && ((! ports_2_filter_io_filtred_d) ^ ports_2_portLowSpeed))));
  assign when_UsbHubPhy_l707_2 = (Rx_Suspend && (ports_2_filter_io_filtred_se0 || ((! ports_2_filter_io_filtred_se0) && ((! ports_2_filter_io_filtred_d) ^ ports_2_portLowSpeed))));
  assign when_UsbHubPhy_l748_2 = ((! ports_2_filter_io_filtred_se0) && ((! ports_2_filter_io_filtred_d) ^ ports_2_portLowSpeed));
  assign when_UsbHubPhy_l758_2 = ((! ports_2_filter_io_filtred_se0) && ((! ports_2_filter_io_filtred_d) ^ ports_2_portLowSpeed));
  assign when_StateMachine_l253_22 = ((! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_DISCONNECTED)) && (ports_2_fsm_stateNext == ports_2_fsm_enumDef_DISCONNECTED));
  assign when_StateMachine_l253_23 = ((! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_RESETTING)) && (ports_2_fsm_stateNext == ports_2_fsm_enumDef_RESETTING));
  assign when_StateMachine_l253_24 = ((! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_RESETTING_DELAY)) && (ports_2_fsm_stateNext == ports_2_fsm_enumDef_RESETTING_DELAY));
  assign when_StateMachine_l253_25 = ((! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_RESUMING)) && (ports_2_fsm_stateNext == ports_2_fsm_enumDef_RESUMING));
  assign when_StateMachine_l253_26 = ((! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_SEND_EOP_0)) && (ports_2_fsm_stateNext == ports_2_fsm_enumDef_SEND_EOP_0));
  assign when_StateMachine_l253_27 = ((! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_SEND_EOP_1)) && (ports_2_fsm_stateNext == ports_2_fsm_enumDef_SEND_EOP_1));
  assign when_StateMachine_l253_28 = ((! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_RESTART_S)) && (ports_2_fsm_stateNext == ports_2_fsm_enumDef_RESTART_S));
  assign when_StateMachine_l253_29 = ((! (ports_2_fsm_stateReg == ports_2_fsm_enumDef_RESTART_E)) && (ports_2_fsm_stateNext == ports_2_fsm_enumDef_RESTART_E));
  assign when_UsbHubPhy_l610_2 = ((! io_ctrl_ports_2_power) || io_ctrl_usbReset);
  assign when_UsbHubPhy_l617_2 = (! ports_2_fsm_resetInProgress);
  assign when_UsbHubPhy_l618_2 = (ports_2_filter_io_filtred_dm != ports_2_filter_io_filtred_dp);
  always @(*) begin
    ports_3_rx_packet_stateNext = ports_3_rx_packet_stateReg;
    case(ports_3_rx_packet_stateReg)
      ports_3_rx_packet_enumDef_IDLE : begin
        if(ports_3_rx_history_sync_hit) begin
          ports_3_rx_packet_stateNext = ports_3_rx_packet_enumDef_PACKET;
        end
      end
      ports_3_rx_packet_enumDef_PACKET : begin
        if(ports_3_rx_destuffer_output_valid) begin
          if(when_UsbHubPhy_l527_3) begin
            if(ports_3_rx_stuffingError) begin
              ports_3_rx_packet_stateNext = ports_3_rx_packet_enumDef_ERRORED;
            end
          end
        end
      end
      ports_3_rx_packet_enumDef_ERRORED : begin
        if(ports_3_rx_packet_errorTimeout_trigger) begin
          ports_3_rx_packet_stateNext = ports_3_rx_packet_enumDef_IDLE;
        end
      end
      default : begin
      end
    endcase
    if(ports_3_rx_eop_hit) begin
      ports_3_rx_packet_stateNext = ports_3_rx_packet_enumDef_IDLE;
    end
    if(txShared_encoder_output_valid) begin
      ports_3_rx_packet_stateNext = ports_3_rx_packet_enumDef_IDLE;
    end
    if(ports_3_rx_packet_wantStart) begin
      ports_3_rx_packet_stateNext = ports_3_rx_packet_enumDef_IDLE;
    end
    if(ports_3_rx_packet_wantKill) begin
      ports_3_rx_packet_stateNext = ports_3_rx_packet_enumDef_BOOT;
    end
  end

  assign when_UsbHubPhy_l527_3 = (ports_3_rx_packet_counter == 3'b111);
  assign when_UsbHubPhy_l549_3 = ((ports_3_rx_packet_errorTimeout_p != ports_3_filter_io_filtred_dp) || (ports_3_rx_packet_errorTimeout_n != ports_3_filter_io_filtred_dm));
  assign when_StateMachine_l253_30 = ((! (ports_3_rx_packet_stateReg == ports_3_rx_packet_enumDef_IDLE)) && (ports_3_rx_packet_stateNext == ports_3_rx_packet_enumDef_IDLE));
  assign when_StateMachine_l253_31 = ((! (ports_3_rx_packet_stateReg == ports_3_rx_packet_enumDef_ERRORED)) && (ports_3_rx_packet_stateNext == ports_3_rx_packet_enumDef_ERRORED));
  always @(*) begin
    ports_3_fsm_stateNext = ports_3_fsm_stateReg;
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
        if(io_ctrl_ports_3_power) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_DISCONNECTED;
        end
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
        if(ports_3_fsm_timer_DISCONNECTED_EOI) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_DISABLED;
        end
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
        if(ports_3_fsm_timer_RESET_EOI) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_RESETTING_DELAY;
        end
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
        if(ports_3_fsm_timer_RESET_DELAY) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_RESETTING_SYNC;
        end
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
        if(when_UsbHubPhy_l675_3) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_ENABLED;
        end
      end
      ports_3_fsm_enumDef_ENABLED : begin
        if(io_ctrl_ports_3_suspend_valid) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_SUSPENDED;
        end else begin
          if(when_UsbHubPhy_l697_3) begin
            ports_3_fsm_stateNext = ports_3_fsm_enumDef_RESTART_E;
          end else begin
            if(io_ctrl_usbResume) begin
              ports_3_fsm_stateNext = ports_3_fsm_enumDef_RESUMING;
            end
          end
        end
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
        if(when_UsbHubPhy_l705_3) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_RESUMING;
        end else begin
          if(when_UsbHubPhy_l707_3) begin
            ports_3_fsm_stateNext = ports_3_fsm_enumDef_RESTART_S;
          end
        end
      end
      ports_3_fsm_enumDef_RESUMING : begin
        if(ports_3_fsm_timer_RESUME_EOI) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_SEND_EOP_0;
        end
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
        if(ports_3_fsm_timer_TWO_BIT) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_SEND_EOP_1;
        end
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
        if(ports_3_fsm_timer_ONE_BIT) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_ENABLED;
        end
      end
      ports_3_fsm_enumDef_RESTART_S : begin
        if(when_UsbHubPhy_l748_3) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_RESUMING;
        end
        if(ports_3_fsm_timer_RESTART_EOI) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_DISCONNECTED;
        end
      end
      ports_3_fsm_enumDef_RESTART_E : begin
        if(when_UsbHubPhy_l758_3) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_RESUMING;
        end
        if(ports_3_fsm_timer_RESTART_EOI) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_DISCONNECTED;
        end
      end
      default : begin
      end
    endcase
    if(when_UsbHubPhy_l610_3) begin
      ports_3_fsm_stateNext = ports_3_fsm_enumDef_POWER_OFF;
    end else begin
      if(ports_3_rx_disconnect_event) begin
        ports_3_fsm_stateNext = ports_3_fsm_enumDef_DISCONNECTED;
      end else begin
        if(io_ctrl_ports_3_disable_valid) begin
          ports_3_fsm_stateNext = ports_3_fsm_enumDef_DISABLED;
        end else begin
          if(io_ctrl_ports_3_reset_valid) begin
            if(when_UsbHubPhy_l617_3) begin
              if(when_UsbHubPhy_l618_3) begin
                ports_3_fsm_stateNext = ports_3_fsm_enumDef_RESETTING;
              end
            end
          end
        end
      end
    end
    if(ports_3_fsm_wantStart) begin
      ports_3_fsm_stateNext = ports_3_fsm_enumDef_POWER_OFF;
    end
    if(ports_3_fsm_wantKill) begin
      ports_3_fsm_stateNext = ports_3_fsm_enumDef_BOOT;
    end
  end

  assign when_UsbHubPhy_l638_3 = ((! ports_3_filter_io_filtred_dp) && (! ports_3_filter_io_filtred_dm));
  assign when_UsbHubPhy_l675_3 = (! txShared_encoder_output_valid);
  assign when_UsbHubPhy_l688_3 = (ports_3_portLowSpeed && txShared_lowSpeedSof_overrideEncoder);
  assign when_UsbHubPhy_l697_3 = (Rx_Suspend && (ports_3_filter_io_filtred_se0 || ((! ports_3_filter_io_filtred_se0) && ((! ports_3_filter_io_filtred_d) ^ ports_3_portLowSpeed))));
  assign when_UsbHubPhy_l705_3 = (io_ctrl_ports_3_resume_valid || ((! Rx_Suspend) && ((! ports_3_filter_io_filtred_se0) && ((! ports_3_filter_io_filtred_d) ^ ports_3_portLowSpeed))));
  assign when_UsbHubPhy_l707_3 = (Rx_Suspend && (ports_3_filter_io_filtred_se0 || ((! ports_3_filter_io_filtred_se0) && ((! ports_3_filter_io_filtred_d) ^ ports_3_portLowSpeed))));
  assign when_UsbHubPhy_l748_3 = ((! ports_3_filter_io_filtred_se0) && ((! ports_3_filter_io_filtred_d) ^ ports_3_portLowSpeed));
  assign when_UsbHubPhy_l758_3 = ((! ports_3_filter_io_filtred_se0) && ((! ports_3_filter_io_filtred_d) ^ ports_3_portLowSpeed));
  assign when_StateMachine_l253_32 = ((! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_DISCONNECTED)) && (ports_3_fsm_stateNext == ports_3_fsm_enumDef_DISCONNECTED));
  assign when_StateMachine_l253_33 = ((! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_RESETTING)) && (ports_3_fsm_stateNext == ports_3_fsm_enumDef_RESETTING));
  assign when_StateMachine_l253_34 = ((! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_RESETTING_DELAY)) && (ports_3_fsm_stateNext == ports_3_fsm_enumDef_RESETTING_DELAY));
  assign when_StateMachine_l253_35 = ((! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_RESUMING)) && (ports_3_fsm_stateNext == ports_3_fsm_enumDef_RESUMING));
  assign when_StateMachine_l253_36 = ((! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_SEND_EOP_0)) && (ports_3_fsm_stateNext == ports_3_fsm_enumDef_SEND_EOP_0));
  assign when_StateMachine_l253_37 = ((! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_SEND_EOP_1)) && (ports_3_fsm_stateNext == ports_3_fsm_enumDef_SEND_EOP_1));
  assign when_StateMachine_l253_38 = ((! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_RESTART_S)) && (ports_3_fsm_stateNext == ports_3_fsm_enumDef_RESTART_S));
  assign when_StateMachine_l253_39 = ((! (ports_3_fsm_stateReg == ports_3_fsm_enumDef_RESTART_E)) && (ports_3_fsm_stateNext == ports_3_fsm_enumDef_RESTART_E));
  assign when_UsbHubPhy_l610_3 = ((! io_ctrl_ports_3_power) || io_ctrl_usbReset);
  assign when_UsbHubPhy_l617_3 = (! ports_3_fsm_resetInProgress);
  assign when_UsbHubPhy_l618_3 = (ports_3_filter_io_filtred_dm != ports_3_filter_io_filtred_dp);
  always @(posedge phyCd_clk or posedge phyCd_reset) begin
    if(phyCd_reset) begin
      tickTimer_counter_value <= 2'b00;
      txShared_rxToTxDelay_active <= 1'b0;
      txShared_lowSpeedSof_state <= 2'b00;
      txShared_lowSpeedSof_overrideEncoder <= 1'b0;
      ports_0_rx_eop_counter <= 7'h00;
      ports_0_rx_disconnect_counter <= 7'h00;
      ports_1_rx_eop_counter <= 7'h00;
      ports_1_rx_disconnect_counter <= 7'h00;
      ports_2_rx_eop_counter <= 7'h00;
      ports_2_rx_disconnect_counter <= 7'h00;
      ports_3_rx_eop_counter <= 7'h00;
      ports_3_rx_disconnect_counter <= 7'h00;
      txShared_frame_stateReg <= txShared_frame_enumDef_BOOT;
      upstreamRx_stateReg <= upstreamRx_enumDef_BOOT;
      ports_0_rx_packet_stateReg <= ports_0_rx_packet_enumDef_BOOT;
      ports_0_fsm_stateReg <= ports_0_fsm_enumDef_BOOT;
      ports_1_rx_packet_stateReg <= ports_1_rx_packet_enumDef_BOOT;
      ports_1_fsm_stateReg <= ports_1_fsm_enumDef_BOOT;
      ports_2_rx_packet_stateReg <= ports_2_rx_packet_enumDef_BOOT;
      ports_2_fsm_stateReg <= ports_2_fsm_enumDef_BOOT;
      ports_3_rx_packet_stateReg <= ports_3_rx_packet_enumDef_BOOT;
      ports_3_fsm_stateReg <= ports_3_fsm_enumDef_BOOT;
    end else begin
      tickTimer_counter_value <= tickTimer_counter_valueNext;
      if(txShared_rxToTxDelay_twoCycle) begin
        txShared_rxToTxDelay_active <= 1'b0;
      end
      if(when_UsbHubPhy_l249) begin
        txShared_lowSpeedSof_overrideEncoder <= 1'b0;
      end
      txShared_lowSpeedSof_state <= (txShared_lowSpeedSof_state + _zz_txShared_lowSpeedSof_state);
      if(when_UsbHubPhy_l251) begin
        if(when_UsbHubPhy_l252) begin
          txShared_lowSpeedSof_overrideEncoder <= 1'b1;
        end
      end else begin
        if(when_UsbHubPhy_l259) begin
          txShared_lowSpeedSof_state <= (txShared_lowSpeedSof_state + 2'b01);
        end
      end
      if(when_UsbHubPhy_l493) begin
        if(when_UsbHubPhy_l494) begin
          ports_0_rx_eop_counter <= (ports_0_rx_eop_counter + 7'h01);
        end
      end else begin
        ports_0_rx_eop_counter <= 7'h00;
      end
      ports_0_rx_disconnect_counter <= (ports_0_rx_disconnect_counter + _zz_ports_0_rx_disconnect_counter);
      if(ports_0_rx_disconnect_clear) begin
        ports_0_rx_disconnect_counter <= 7'h00;
      end
      if(when_UsbHubPhy_l493_1) begin
        if(when_UsbHubPhy_l494_1) begin
          ports_1_rx_eop_counter <= (ports_1_rx_eop_counter + 7'h01);
        end
      end else begin
        ports_1_rx_eop_counter <= 7'h00;
      end
      ports_1_rx_disconnect_counter <= (ports_1_rx_disconnect_counter + _zz_ports_1_rx_disconnect_counter);
      if(ports_1_rx_disconnect_clear) begin
        ports_1_rx_disconnect_counter <= 7'h00;
      end
      if(when_UsbHubPhy_l493_2) begin
        if(when_UsbHubPhy_l494_2) begin
          ports_2_rx_eop_counter <= (ports_2_rx_eop_counter + 7'h01);
        end
      end else begin
        ports_2_rx_eop_counter <= 7'h00;
      end
      ports_2_rx_disconnect_counter <= (ports_2_rx_disconnect_counter + _zz_ports_2_rx_disconnect_counter);
      if(ports_2_rx_disconnect_clear) begin
        ports_2_rx_disconnect_counter <= 7'h00;
      end
      if(when_UsbHubPhy_l493_3) begin
        if(when_UsbHubPhy_l494_3) begin
          ports_3_rx_eop_counter <= (ports_3_rx_eop_counter + 7'h01);
        end
      end else begin
        ports_3_rx_eop_counter <= 7'h00;
      end
      ports_3_rx_disconnect_counter <= (ports_3_rx_disconnect_counter + _zz_ports_3_rx_disconnect_counter);
      if(ports_3_rx_disconnect_clear) begin
        ports_3_rx_disconnect_counter <= 7'h00;
      end
      txShared_frame_stateReg <= txShared_frame_stateNext;
      upstreamRx_stateReg <= upstreamRx_stateNext;
      ports_0_rx_packet_stateReg <= ports_0_rx_packet_stateNext;
      if(ports_0_rx_eop_hit) begin
        txShared_rxToTxDelay_active <= 1'b1;
      end
      ports_0_fsm_stateReg <= ports_0_fsm_stateNext;
      ports_1_rx_packet_stateReg <= ports_1_rx_packet_stateNext;
      if(ports_1_rx_eop_hit) begin
        txShared_rxToTxDelay_active <= 1'b1;
      end
      ports_1_fsm_stateReg <= ports_1_fsm_stateNext;
      ports_2_rx_packet_stateReg <= ports_2_rx_packet_stateNext;
      if(ports_2_rx_eop_hit) begin
        txShared_rxToTxDelay_active <= 1'b1;
      end
      ports_2_fsm_stateReg <= ports_2_fsm_stateNext;
      ports_3_rx_packet_stateReg <= ports_3_rx_packet_stateNext;
      if(ports_3_rx_eop_hit) begin
        txShared_rxToTxDelay_active <= 1'b1;
      end
      ports_3_fsm_stateReg <= ports_3_fsm_stateNext;
    end
  end

  always @(posedge phyCd_clk) begin
    if(txShared_timer_inc) begin
      txShared_timer_counter <= (txShared_timer_counter + 10'h001);
    end
    if(txShared_timer_clear) begin
      txShared_timer_counter <= 10'h000;
    end
    if(txShared_rxToTxDelay_inc) begin
      txShared_rxToTxDelay_counter <= (txShared_rxToTxDelay_counter + 9'h001);
    end
    if(txShared_rxToTxDelay_clear) begin
      txShared_rxToTxDelay_counter <= 9'h000;
    end
    if(txShared_encoder_input_valid) begin
      if(txShared_encoder_input_data) begin
        if(txShared_timer_oneCycle) begin
          txShared_encoder_counter <= (txShared_encoder_counter + 3'b001);
          if(when_UsbHubPhy_l189) begin
            txShared_encoder_state <= (! txShared_encoder_state);
          end
          if(when_UsbHubPhy_l194) begin
            txShared_encoder_counter <= 3'b000;
          end
        end
      end else begin
        if(txShared_timer_oneCycle) begin
          txShared_encoder_counter <= 3'b000;
          txShared_encoder_state <= (! txShared_encoder_state);
        end
      end
    end
    if(when_UsbHubPhy_l208) begin
      txShared_encoder_counter <= 3'b000;
      txShared_encoder_state <= 1'b1;
    end
    if(txShared_serialiser_input_valid) begin
      if(txShared_encoder_input_ready) begin
        txShared_serialiser_bitCounter <= (txShared_serialiser_bitCounter + 3'b001);
      end
    end
    if(when_UsbHubPhy_l240) begin
      txShared_serialiser_bitCounter <= 3'b000;
    end
    txShared_encoder_output_valid_regNext <= txShared_encoder_output_valid;
    if(when_UsbHubPhy_l251) begin
      if(when_UsbHubPhy_l252) begin
        txShared_lowSpeedSof_timer <= 5'h00;
      end
    end else begin
      txShared_lowSpeedSof_timer <= (txShared_lowSpeedSof_timer + 5'h01);
    end
    if(upstreamRx_timer_inc) begin
      upstreamRx_timer_counter <= (upstreamRx_timer_counter + 20'h00001);
    end
    if(upstreamRx_timer_clear) begin
      upstreamRx_timer_counter <= 20'h00000;
    end
    if(ports_0_filter_io_filtred_sample) begin
      if(when_UsbHubPhy_l445) begin
        ports_0_rx_decoder_state <= (! ports_0_rx_decoder_state);
      end
    end
    if(ports_0_rx_waitSync) begin
      ports_0_rx_decoder_state <= 1'b0;
    end
    if(ports_0_rx_decoder_output_valid) begin
      ports_0_rx_destuffer_counter <= (ports_0_rx_destuffer_counter + 3'b001);
      if(when_UsbHubPhy_l466) begin
        ports_0_rx_destuffer_counter <= 3'b000;
        if(ports_0_rx_decoder_output_payload) begin
          ports_0_rx_stuffingError <= 1'b1;
        end
      end
    end
    if(ports_0_rx_waitSync) begin
      ports_0_rx_destuffer_counter <= 3'b000;
    end
    if(ports_0_rx_history_updated) begin
      _zz_ports_0_rx_history_value_1 <= _zz_ports_0_rx_history_value;
    end
    if(ports_0_rx_history_updated) begin
      _zz_ports_0_rx_history_value_2 <= _zz_ports_0_rx_history_value_1;
    end
    if(ports_0_rx_history_updated) begin
      _zz_ports_0_rx_history_value_3 <= _zz_ports_0_rx_history_value_2;
    end
    if(ports_0_rx_history_updated) begin
      _zz_ports_0_rx_history_value_4 <= _zz_ports_0_rx_history_value_3;
    end
    if(ports_0_rx_history_updated) begin
      _zz_ports_0_rx_history_value_5 <= _zz_ports_0_rx_history_value_4;
    end
    if(ports_0_rx_history_updated) begin
      _zz_ports_0_rx_history_value_6 <= _zz_ports_0_rx_history_value_5;
    end
    if(ports_0_rx_history_updated) begin
      _zz_ports_0_rx_history_value_7 <= _zz_ports_0_rx_history_value_6;
    end
    if(ports_0_rx_packet_errorTimeout_inc) begin
      ports_0_rx_packet_errorTimeout_counter <= (ports_0_rx_packet_errorTimeout_counter + 12'h001);
    end
    if(ports_0_rx_packet_errorTimeout_clear) begin
      ports_0_rx_packet_errorTimeout_counter <= 12'h000;
    end
    ports_0_rx_disconnect_hitLast <= ports_0_rx_disconnect_hit;
    if(ports_0_fsm_timer_inc) begin
      ports_0_fsm_timer_counter <= (ports_0_fsm_timer_counter + 24'h000001);
    end
    if(ports_0_fsm_timer_clear) begin
      ports_0_fsm_timer_counter <= 24'h000000;
    end
    if(ports_1_filter_io_filtred_sample) begin
      if(when_UsbHubPhy_l445_1) begin
        ports_1_rx_decoder_state <= (! ports_1_rx_decoder_state);
      end
    end
    if(ports_1_rx_waitSync) begin
      ports_1_rx_decoder_state <= 1'b0;
    end
    if(ports_1_rx_decoder_output_valid) begin
      ports_1_rx_destuffer_counter <= (ports_1_rx_destuffer_counter + 3'b001);
      if(when_UsbHubPhy_l466_1) begin
        ports_1_rx_destuffer_counter <= 3'b000;
        if(ports_1_rx_decoder_output_payload) begin
          ports_1_rx_stuffingError <= 1'b1;
        end
      end
    end
    if(ports_1_rx_waitSync) begin
      ports_1_rx_destuffer_counter <= 3'b000;
    end
    if(ports_1_rx_history_updated) begin
      _zz_ports_1_rx_history_value_1 <= _zz_ports_1_rx_history_value;
    end
    if(ports_1_rx_history_updated) begin
      _zz_ports_1_rx_history_value_2 <= _zz_ports_1_rx_history_value_1;
    end
    if(ports_1_rx_history_updated) begin
      _zz_ports_1_rx_history_value_3 <= _zz_ports_1_rx_history_value_2;
    end
    if(ports_1_rx_history_updated) begin
      _zz_ports_1_rx_history_value_4 <= _zz_ports_1_rx_history_value_3;
    end
    if(ports_1_rx_history_updated) begin
      _zz_ports_1_rx_history_value_5 <= _zz_ports_1_rx_history_value_4;
    end
    if(ports_1_rx_history_updated) begin
      _zz_ports_1_rx_history_value_6 <= _zz_ports_1_rx_history_value_5;
    end
    if(ports_1_rx_history_updated) begin
      _zz_ports_1_rx_history_value_7 <= _zz_ports_1_rx_history_value_6;
    end
    if(ports_1_rx_packet_errorTimeout_inc) begin
      ports_1_rx_packet_errorTimeout_counter <= (ports_1_rx_packet_errorTimeout_counter + 12'h001);
    end
    if(ports_1_rx_packet_errorTimeout_clear) begin
      ports_1_rx_packet_errorTimeout_counter <= 12'h000;
    end
    ports_1_rx_disconnect_hitLast <= ports_1_rx_disconnect_hit;
    if(ports_1_fsm_timer_inc) begin
      ports_1_fsm_timer_counter <= (ports_1_fsm_timer_counter + 24'h000001);
    end
    if(ports_1_fsm_timer_clear) begin
      ports_1_fsm_timer_counter <= 24'h000000;
    end
    if(ports_2_filter_io_filtred_sample) begin
      if(when_UsbHubPhy_l445_2) begin
        ports_2_rx_decoder_state <= (! ports_2_rx_decoder_state);
      end
    end
    if(ports_2_rx_waitSync) begin
      ports_2_rx_decoder_state <= 1'b0;
    end
    if(ports_2_rx_decoder_output_valid) begin
      ports_2_rx_destuffer_counter <= (ports_2_rx_destuffer_counter + 3'b001);
      if(when_UsbHubPhy_l466_2) begin
        ports_2_rx_destuffer_counter <= 3'b000;
        if(ports_2_rx_decoder_output_payload) begin
          ports_2_rx_stuffingError <= 1'b1;
        end
      end
    end
    if(ports_2_rx_waitSync) begin
      ports_2_rx_destuffer_counter <= 3'b000;
    end
    if(ports_2_rx_history_updated) begin
      _zz_ports_2_rx_history_value_1 <= _zz_ports_2_rx_history_value;
    end
    if(ports_2_rx_history_updated) begin
      _zz_ports_2_rx_history_value_2 <= _zz_ports_2_rx_history_value_1;
    end
    if(ports_2_rx_history_updated) begin
      _zz_ports_2_rx_history_value_3 <= _zz_ports_2_rx_history_value_2;
    end
    if(ports_2_rx_history_updated) begin
      _zz_ports_2_rx_history_value_4 <= _zz_ports_2_rx_history_value_3;
    end
    if(ports_2_rx_history_updated) begin
      _zz_ports_2_rx_history_value_5 <= _zz_ports_2_rx_history_value_4;
    end
    if(ports_2_rx_history_updated) begin
      _zz_ports_2_rx_history_value_6 <= _zz_ports_2_rx_history_value_5;
    end
    if(ports_2_rx_history_updated) begin
      _zz_ports_2_rx_history_value_7 <= _zz_ports_2_rx_history_value_6;
    end
    if(ports_2_rx_packet_errorTimeout_inc) begin
      ports_2_rx_packet_errorTimeout_counter <= (ports_2_rx_packet_errorTimeout_counter + 12'h001);
    end
    if(ports_2_rx_packet_errorTimeout_clear) begin
      ports_2_rx_packet_errorTimeout_counter <= 12'h000;
    end
    ports_2_rx_disconnect_hitLast <= ports_2_rx_disconnect_hit;
    if(ports_2_fsm_timer_inc) begin
      ports_2_fsm_timer_counter <= (ports_2_fsm_timer_counter + 24'h000001);
    end
    if(ports_2_fsm_timer_clear) begin
      ports_2_fsm_timer_counter <= 24'h000000;
    end
    if(ports_3_filter_io_filtred_sample) begin
      if(when_UsbHubPhy_l445_3) begin
        ports_3_rx_decoder_state <= (! ports_3_rx_decoder_state);
      end
    end
    if(ports_3_rx_waitSync) begin
      ports_3_rx_decoder_state <= 1'b0;
    end
    if(ports_3_rx_decoder_output_valid) begin
      ports_3_rx_destuffer_counter <= (ports_3_rx_destuffer_counter + 3'b001);
      if(when_UsbHubPhy_l466_3) begin
        ports_3_rx_destuffer_counter <= 3'b000;
        if(ports_3_rx_decoder_output_payload) begin
          ports_3_rx_stuffingError <= 1'b1;
        end
      end
    end
    if(ports_3_rx_waitSync) begin
      ports_3_rx_destuffer_counter <= 3'b000;
    end
    if(ports_3_rx_history_updated) begin
      _zz_ports_3_rx_history_value_1 <= _zz_ports_3_rx_history_value;
    end
    if(ports_3_rx_history_updated) begin
      _zz_ports_3_rx_history_value_2 <= _zz_ports_3_rx_history_value_1;
    end
    if(ports_3_rx_history_updated) begin
      _zz_ports_3_rx_history_value_3 <= _zz_ports_3_rx_history_value_2;
    end
    if(ports_3_rx_history_updated) begin
      _zz_ports_3_rx_history_value_4 <= _zz_ports_3_rx_history_value_3;
    end
    if(ports_3_rx_history_updated) begin
      _zz_ports_3_rx_history_value_5 <= _zz_ports_3_rx_history_value_4;
    end
    if(ports_3_rx_history_updated) begin
      _zz_ports_3_rx_history_value_6 <= _zz_ports_3_rx_history_value_5;
    end
    if(ports_3_rx_history_updated) begin
      _zz_ports_3_rx_history_value_7 <= _zz_ports_3_rx_history_value_6;
    end
    if(ports_3_rx_packet_errorTimeout_inc) begin
      ports_3_rx_packet_errorTimeout_counter <= (ports_3_rx_packet_errorTimeout_counter + 12'h001);
    end
    if(ports_3_rx_packet_errorTimeout_clear) begin
      ports_3_rx_packet_errorTimeout_counter <= 12'h000;
    end
    ports_3_rx_disconnect_hitLast <= ports_3_rx_disconnect_hit;
    if(ports_3_fsm_timer_inc) begin
      ports_3_fsm_timer_counter <= (ports_3_fsm_timer_counter + 24'h000001);
    end
    if(ports_3_fsm_timer_clear) begin
      ports_3_fsm_timer_counter <= 24'h000000;
    end
    case(txShared_frame_stateReg)
      txShared_frame_enumDef_IDLE : begin
        txShared_frame_wasLowSpeed <= io_ctrl_lowSpeed;
      end
      txShared_frame_enumDef_TAKE_LINE : begin
      end
      txShared_frame_enumDef_PREAMBLE_SYNC : begin
      end
      txShared_frame_enumDef_PREAMBLE_PID : begin
      end
      txShared_frame_enumDef_PREAMBLE_DELAY : begin
      end
      txShared_frame_enumDef_SYNC : begin
      end
      txShared_frame_enumDef_DATA : begin
      end
      txShared_frame_enumDef_EOP_0 : begin
      end
      txShared_frame_enumDef_EOP_1 : begin
      end
      txShared_frame_enumDef_EOP_2 : begin
      end
      default : begin
      end
    endcase
    case(ports_0_rx_packet_stateReg)
      ports_0_rx_packet_enumDef_IDLE : begin
        ports_0_rx_packet_counter <= 3'b000;
        ports_0_rx_stuffingError <= 1'b0;
      end
      ports_0_rx_packet_enumDef_PACKET : begin
        if(ports_0_rx_destuffer_output_valid) begin
          ports_0_rx_packet_counter <= (ports_0_rx_packet_counter + 3'b001);
        end
      end
      ports_0_rx_packet_enumDef_ERRORED : begin
        ports_0_rx_packet_errorTimeout_p <= ports_0_filter_io_filtred_dp;
        ports_0_rx_packet_errorTimeout_n <= ports_0_filter_io_filtred_dm;
      end
      default : begin
      end
    endcase
    if(ports_0_rx_eop_hit) begin
      txShared_rxToTxDelay_lowSpeed <= io_ctrl_lowSpeed;
    end
    case(ports_0_fsm_stateReg)
      ports_0_fsm_enumDef_POWER_OFF : begin
      end
      ports_0_fsm_enumDef_DISCONNECTED : begin
      end
      ports_0_fsm_enumDef_DISABLED : begin
      end
      ports_0_fsm_enumDef_RESETTING : begin
      end
      ports_0_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_0_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_0_fsm_enumDef_ENABLED : begin
      end
      ports_0_fsm_enumDef_SUSPENDED : begin
      end
      ports_0_fsm_enumDef_RESUMING : begin
        if(ports_0_fsm_timer_RESUME_EOI) begin
          ports_0_fsm_lowSpeedEop <= 1'b1;
        end
      end
      ports_0_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_0_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_0_fsm_enumDef_RESTART_S : begin
      end
      ports_0_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
    if(!when_UsbHubPhy_l610) begin
      if(!ports_0_rx_disconnect_event) begin
        if(!io_ctrl_ports_0_disable_valid) begin
          if(io_ctrl_ports_0_reset_valid) begin
            if(when_UsbHubPhy_l617) begin
              if(when_UsbHubPhy_l618) begin
                ports_0_portLowSpeed <= (! ports_0_filter_io_filtred_d);
              end
            end
          end
        end
      end
    end
    case(ports_1_rx_packet_stateReg)
      ports_1_rx_packet_enumDef_IDLE : begin
        ports_1_rx_packet_counter <= 3'b000;
        ports_1_rx_stuffingError <= 1'b0;
      end
      ports_1_rx_packet_enumDef_PACKET : begin
        if(ports_1_rx_destuffer_output_valid) begin
          ports_1_rx_packet_counter <= (ports_1_rx_packet_counter + 3'b001);
        end
      end
      ports_1_rx_packet_enumDef_ERRORED : begin
        ports_1_rx_packet_errorTimeout_p <= ports_1_filter_io_filtred_dp;
        ports_1_rx_packet_errorTimeout_n <= ports_1_filter_io_filtred_dm;
      end
      default : begin
      end
    endcase
    if(ports_1_rx_eop_hit) begin
      txShared_rxToTxDelay_lowSpeed <= io_ctrl_lowSpeed;
    end
    case(ports_1_fsm_stateReg)
      ports_1_fsm_enumDef_POWER_OFF : begin
      end
      ports_1_fsm_enumDef_DISCONNECTED : begin
      end
      ports_1_fsm_enumDef_DISABLED : begin
      end
      ports_1_fsm_enumDef_RESETTING : begin
      end
      ports_1_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_1_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_1_fsm_enumDef_ENABLED : begin
      end
      ports_1_fsm_enumDef_SUSPENDED : begin
      end
      ports_1_fsm_enumDef_RESUMING : begin
        if(ports_1_fsm_timer_RESUME_EOI) begin
          ports_1_fsm_lowSpeedEop <= 1'b1;
        end
      end
      ports_1_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_1_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_1_fsm_enumDef_RESTART_S : begin
      end
      ports_1_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
    if(!when_UsbHubPhy_l610_1) begin
      if(!ports_1_rx_disconnect_event) begin
        if(!io_ctrl_ports_1_disable_valid) begin
          if(io_ctrl_ports_1_reset_valid) begin
            if(when_UsbHubPhy_l617_1) begin
              if(when_UsbHubPhy_l618_1) begin
                ports_1_portLowSpeed <= (! ports_1_filter_io_filtred_d);
              end
            end
          end
        end
      end
    end
    case(ports_2_rx_packet_stateReg)
      ports_2_rx_packet_enumDef_IDLE : begin
        ports_2_rx_packet_counter <= 3'b000;
        ports_2_rx_stuffingError <= 1'b0;
      end
      ports_2_rx_packet_enumDef_PACKET : begin
        if(ports_2_rx_destuffer_output_valid) begin
          ports_2_rx_packet_counter <= (ports_2_rx_packet_counter + 3'b001);
        end
      end
      ports_2_rx_packet_enumDef_ERRORED : begin
        ports_2_rx_packet_errorTimeout_p <= ports_2_filter_io_filtred_dp;
        ports_2_rx_packet_errorTimeout_n <= ports_2_filter_io_filtred_dm;
      end
      default : begin
      end
    endcase
    if(ports_2_rx_eop_hit) begin
      txShared_rxToTxDelay_lowSpeed <= io_ctrl_lowSpeed;
    end
    case(ports_2_fsm_stateReg)
      ports_2_fsm_enumDef_POWER_OFF : begin
      end
      ports_2_fsm_enumDef_DISCONNECTED : begin
      end
      ports_2_fsm_enumDef_DISABLED : begin
      end
      ports_2_fsm_enumDef_RESETTING : begin
      end
      ports_2_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_2_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_2_fsm_enumDef_ENABLED : begin
      end
      ports_2_fsm_enumDef_SUSPENDED : begin
      end
      ports_2_fsm_enumDef_RESUMING : begin
        if(ports_2_fsm_timer_RESUME_EOI) begin
          ports_2_fsm_lowSpeedEop <= 1'b1;
        end
      end
      ports_2_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_2_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_2_fsm_enumDef_RESTART_S : begin
      end
      ports_2_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
    if(!when_UsbHubPhy_l610_2) begin
      if(!ports_2_rx_disconnect_event) begin
        if(!io_ctrl_ports_2_disable_valid) begin
          if(io_ctrl_ports_2_reset_valid) begin
            if(when_UsbHubPhy_l617_2) begin
              if(when_UsbHubPhy_l618_2) begin
                ports_2_portLowSpeed <= (! ports_2_filter_io_filtred_d);
              end
            end
          end
        end
      end
    end
    case(ports_3_rx_packet_stateReg)
      ports_3_rx_packet_enumDef_IDLE : begin
        ports_3_rx_packet_counter <= 3'b000;
        ports_3_rx_stuffingError <= 1'b0;
      end
      ports_3_rx_packet_enumDef_PACKET : begin
        if(ports_3_rx_destuffer_output_valid) begin
          ports_3_rx_packet_counter <= (ports_3_rx_packet_counter + 3'b001);
        end
      end
      ports_3_rx_packet_enumDef_ERRORED : begin
        ports_3_rx_packet_errorTimeout_p <= ports_3_filter_io_filtred_dp;
        ports_3_rx_packet_errorTimeout_n <= ports_3_filter_io_filtred_dm;
      end
      default : begin
      end
    endcase
    if(ports_3_rx_eop_hit) begin
      txShared_rxToTxDelay_lowSpeed <= io_ctrl_lowSpeed;
    end
    case(ports_3_fsm_stateReg)
      ports_3_fsm_enumDef_POWER_OFF : begin
      end
      ports_3_fsm_enumDef_DISCONNECTED : begin
      end
      ports_3_fsm_enumDef_DISABLED : begin
      end
      ports_3_fsm_enumDef_RESETTING : begin
      end
      ports_3_fsm_enumDef_RESETTING_DELAY : begin
      end
      ports_3_fsm_enumDef_RESETTING_SYNC : begin
      end
      ports_3_fsm_enumDef_ENABLED : begin
      end
      ports_3_fsm_enumDef_SUSPENDED : begin
      end
      ports_3_fsm_enumDef_RESUMING : begin
        if(ports_3_fsm_timer_RESUME_EOI) begin
          ports_3_fsm_lowSpeedEop <= 1'b1;
        end
      end
      ports_3_fsm_enumDef_SEND_EOP_0 : begin
      end
      ports_3_fsm_enumDef_SEND_EOP_1 : begin
      end
      ports_3_fsm_enumDef_RESTART_S : begin
      end
      ports_3_fsm_enumDef_RESTART_E : begin
      end
      default : begin
      end
    endcase
    if(!when_UsbHubPhy_l610_3) begin
      if(!ports_3_rx_disconnect_event) begin
        if(!io_ctrl_ports_3_disable_valid) begin
          if(io_ctrl_ports_3_reset_valid) begin
            if(when_UsbHubPhy_l617_3) begin
              if(when_UsbHubPhy_l618_3) begin
                ports_3_portLowSpeed <= (! ports_3_filter_io_filtred_d);
              end
            end
          end
        end
      end
    end
  end

  always @(posedge phyCd_clk or posedge phyCd_reset) begin
    if(phyCd_reset) begin
      io_ctrl_tx_payload_first <= 1'b1;
    end else begin
      if(io_ctrl_tx_fire) begin
        io_ctrl_tx_payload_first <= io_ctrl_tx_payload_last;
      end
    end
  end


endmodule

module UsbOhci (
  input  wire          io_ctrl_cmd_valid,
  output wire          io_ctrl_cmd_ready,
  input  wire          io_ctrl_cmd_payload_last,
  input  wire [0:0]    io_ctrl_cmd_payload_fragment_opcode,
  input  wire [11:0]   io_ctrl_cmd_payload_fragment_address,
  input  wire [1:0]    io_ctrl_cmd_payload_fragment_length,
  input  wire [31:0]   io_ctrl_cmd_payload_fragment_data,
  input  wire [3:0]    io_ctrl_cmd_payload_fragment_mask,
  output wire          io_ctrl_rsp_valid,
  input  wire          io_ctrl_rsp_ready,
  output wire          io_ctrl_rsp_payload_last,
  output wire [0:0]    io_ctrl_rsp_payload_fragment_opcode,
  output wire [31:0]   io_ctrl_rsp_payload_fragment_data,
  output reg           io_phy_lowSpeed,
  output reg           io_phy_tx_valid,
  input  wire          io_phy_tx_ready,
  output reg           io_phy_tx_payload_last,
  output reg  [7:0]    io_phy_tx_payload_fragment,
  input  wire          io_phy_txEop,
  input  wire          io_phy_rx_flow_valid,
  input  wire          io_phy_rx_flow_payload_stuffingError,
  input  wire [7:0]    io_phy_rx_flow_payload_data,
  input  wire          io_phy_rx_active,
  output wire          io_phy_usbReset,
  output wire          io_phy_usbResume,
  input  wire          io_phy_overcurrent,
  input  wire          io_phy_tick,
  output wire          io_phy_ports_0_disable_valid,
  input  wire          io_phy_ports_0_disable_ready,
  output wire          io_phy_ports_0_removable,
  output wire          io_phy_ports_0_power,
  output wire          io_phy_ports_0_reset_valid,
  input  wire          io_phy_ports_0_reset_ready,
  output wire          io_phy_ports_0_suspend_valid,
  input  wire          io_phy_ports_0_suspend_ready,
  output wire          io_phy_ports_0_resume_valid,
  input  wire          io_phy_ports_0_resume_ready,
  input  wire          io_phy_ports_0_connect,
  input  wire          io_phy_ports_0_disconnect,
  input  wire          io_phy_ports_0_overcurrent,
  input  wire          io_phy_ports_0_remoteResume,
  input  wire          io_phy_ports_0_lowSpeed,
  output wire          io_phy_ports_1_disable_valid,
  input  wire          io_phy_ports_1_disable_ready,
  output wire          io_phy_ports_1_removable,
  output wire          io_phy_ports_1_power,
  output wire          io_phy_ports_1_reset_valid,
  input  wire          io_phy_ports_1_reset_ready,
  output wire          io_phy_ports_1_suspend_valid,
  input  wire          io_phy_ports_1_suspend_ready,
  output wire          io_phy_ports_1_resume_valid,
  input  wire          io_phy_ports_1_resume_ready,
  input  wire          io_phy_ports_1_connect,
  input  wire          io_phy_ports_1_disconnect,
  input  wire          io_phy_ports_1_overcurrent,
  input  wire          io_phy_ports_1_remoteResume,
  input  wire          io_phy_ports_1_lowSpeed,
  output wire          io_phy_ports_2_disable_valid,
  input  wire          io_phy_ports_2_disable_ready,
  output wire          io_phy_ports_2_removable,
  output wire          io_phy_ports_2_power,
  output wire          io_phy_ports_2_reset_valid,
  input  wire          io_phy_ports_2_reset_ready,
  output wire          io_phy_ports_2_suspend_valid,
  input  wire          io_phy_ports_2_suspend_ready,
  output wire          io_phy_ports_2_resume_valid,
  input  wire          io_phy_ports_2_resume_ready,
  input  wire          io_phy_ports_2_connect,
  input  wire          io_phy_ports_2_disconnect,
  input  wire          io_phy_ports_2_overcurrent,
  input  wire          io_phy_ports_2_remoteResume,
  input  wire          io_phy_ports_2_lowSpeed,
  output wire          io_phy_ports_3_disable_valid,
  input  wire          io_phy_ports_3_disable_ready,
  output wire          io_phy_ports_3_removable,
  output wire          io_phy_ports_3_power,
  output wire          io_phy_ports_3_reset_valid,
  input  wire          io_phy_ports_3_reset_ready,
  output wire          io_phy_ports_3_suspend_valid,
  input  wire          io_phy_ports_3_suspend_ready,
  output wire          io_phy_ports_3_resume_valid,
  input  wire          io_phy_ports_3_resume_ready,
  input  wire          io_phy_ports_3_connect,
  input  wire          io_phy_ports_3_disconnect,
  input  wire          io_phy_ports_3_overcurrent,
  input  wire          io_phy_ports_3_remoteResume,
  input  wire          io_phy_ports_3_lowSpeed,
  output wire          io_dma_cmd_valid,
  input  wire          io_dma_cmd_ready,
  output wire          io_dma_cmd_payload_last,
  output wire [0:0]    io_dma_cmd_payload_fragment_opcode,
  output wire [31:0]   io_dma_cmd_payload_fragment_address,
  output wire [5:0]    io_dma_cmd_payload_fragment_length,
  output wire [63:0]   io_dma_cmd_payload_fragment_data,
  output wire [7:0]    io_dma_cmd_payload_fragment_mask,
  input  wire          io_dma_rsp_valid,
  output wire          io_dma_rsp_ready,
  input  wire          io_dma_rsp_payload_last,
  input  wire [0:0]    io_dma_rsp_payload_fragment_opcode,
  input  wire [63:0]   io_dma_rsp_payload_fragment_data,
  output wire          io_interrupt,
  output wire          io_interruptBios,
  input  wire          clk,
  input  wire          reset
);
  localparam MainState_RESET = 2'd0;
  localparam MainState_RESUME = 2'd1;
  localparam MainState_OPERATIONAL = 2'd2;
  localparam MainState_SUSPEND = 2'd3;
  localparam FlowType_BULK = 2'd0;
  localparam FlowType_CONTROL = 2'd1;
  localparam FlowType_PERIODIC = 2'd2;
  localparam endpoint_Status_OK = 1'd0;
  localparam endpoint_Status_FRAME_TIME = 1'd1;
  localparam endpoint_enumDef_BOOT = 5'd0;
  localparam endpoint_enumDef_ED_READ_CMD = 5'd1;
  localparam endpoint_enumDef_ED_READ_RSP = 5'd2;
  localparam endpoint_enumDef_ED_ANALYSE = 5'd3;
  localparam endpoint_enumDef_TD_READ_CMD = 5'd4;
  localparam endpoint_enumDef_TD_READ_RSP = 5'd5;
  localparam endpoint_enumDef_TD_READ_DELAY = 5'd6;
  localparam endpoint_enumDef_TD_ANALYSE = 5'd7;
  localparam endpoint_enumDef_TD_CHECK_TIME = 5'd8;
  localparam endpoint_enumDef_BUFFER_READ = 5'd9;
  localparam endpoint_enumDef_TOKEN = 5'd10;
  localparam endpoint_enumDef_DATA_TX = 5'd11;
  localparam endpoint_enumDef_DATA_RX = 5'd12;
  localparam endpoint_enumDef_DATA_RX_VALIDATE = 5'd13;
  localparam endpoint_enumDef_ACK_RX = 5'd14;
  localparam endpoint_enumDef_ACK_TX_0 = 5'd15;
  localparam endpoint_enumDef_ACK_TX_1 = 5'd16;
  localparam endpoint_enumDef_ACK_TX_EOP = 5'd17;
  localparam endpoint_enumDef_DATA_RX_WAIT_DMA = 5'd18;
  localparam endpoint_enumDef_UPDATE_TD_PROCESS = 5'd19;
  localparam endpoint_enumDef_UPDATE_TD_CMD = 5'd20;
  localparam endpoint_enumDef_UPDATE_ED_CMD = 5'd21;
  localparam endpoint_enumDef_UPDATE_SYNC = 5'd22;
  localparam endpoint_enumDef_ABORD = 5'd23;
  localparam endpoint_dmaLogic_enumDef_BOOT = 3'd0;
  localparam endpoint_dmaLogic_enumDef_INIT = 3'd1;
  localparam endpoint_dmaLogic_enumDef_TO_USB = 3'd2;
  localparam endpoint_dmaLogic_enumDef_FROM_USB = 3'd3;
  localparam endpoint_dmaLogic_enumDef_VALIDATION = 3'd4;
  localparam endpoint_dmaLogic_enumDef_CALC_CMD = 3'd5;
  localparam endpoint_dmaLogic_enumDef_READ_CMD = 3'd6;
  localparam endpoint_dmaLogic_enumDef_WRITE_CMD = 3'd7;
  localparam token_enumDef_BOOT = 3'd0;
  localparam token_enumDef_INIT = 3'd1;
  localparam token_enumDef_PID = 3'd2;
  localparam token_enumDef_B1 = 3'd3;
  localparam token_enumDef_B2 = 3'd4;
  localparam token_enumDef_EOP = 3'd5;
  localparam dataTx_enumDef_BOOT = 3'd0;
  localparam dataTx_enumDef_PID = 3'd1;
  localparam dataTx_enumDef_DATA = 3'd2;
  localparam dataTx_enumDef_CRC_0 = 3'd3;
  localparam dataTx_enumDef_CRC_1 = 3'd4;
  localparam dataTx_enumDef_EOP = 3'd5;
  localparam dataRx_enumDef_BOOT = 2'd0;
  localparam dataRx_enumDef_IDLE = 2'd1;
  localparam dataRx_enumDef_PID = 2'd2;
  localparam dataRx_enumDef_DATA = 2'd3;
  localparam sof_enumDef_BOOT = 2'd0;
  localparam sof_enumDef_FRAME_TX = 2'd1;
  localparam sof_enumDef_FRAME_NUMBER_CMD = 2'd2;
  localparam sof_enumDef_FRAME_NUMBER_RSP = 2'd3;
  localparam operational_enumDef_BOOT = 3'd0;
  localparam operational_enumDef_SOF = 3'd1;
  localparam operational_enumDef_ARBITER = 3'd2;
  localparam operational_enumDef_END_POINT = 3'd3;
  localparam operational_enumDef_PERIODIC_HEAD_CMD = 3'd4;
  localparam operational_enumDef_PERIODIC_HEAD_RSP = 3'd5;
  localparam operational_enumDef_WAIT_SOF = 3'd6;
  localparam hc_enumDef_BOOT = 3'd0;
  localparam hc_enumDef_RESET = 3'd1;
  localparam hc_enumDef_RESUME = 3'd2;
  localparam hc_enumDef_OPERATIONAL = 3'd3;
  localparam hc_enumDef_SUSPEND = 3'd4;
  localparam hc_enumDef_ANY_TO_RESET = 3'd5;
  localparam hc_enumDef_ANY_TO_SUSPEND = 3'd6;

  reg                 fifo_io_push_valid;
  reg        [63:0]   fifo_io_push_payload;
  reg                 fifo_io_pop_ready;
  reg                 fifo_io_flush;
  reg                 token_crc5_io_flush;
  reg                 token_crc5_io_input_valid;
  reg                 dataTx_crc16_io_flush;
  reg                 dataRx_crc16_io_flush;
  reg                 dataRx_crc16_io_input_valid;
  wire                fifo_io_push_ready;
  wire                fifo_io_pop_valid;
  wire       [63:0]   fifo_io_pop_payload;
  wire       [8:0]    fifo_io_occupancy;
  wire       [8:0]    fifo_io_availability;
  wire       [4:0]    token_crc5_io_result;
  wire       [4:0]    token_crc5_io_resultNext;
  wire       [15:0]   dataTx_crc16_io_result;
  wire       [15:0]   dataTx_crc16_io_resultNext;
  wire       [15:0]   dataRx_crc16_io_result;
  wire       [15:0]   dataRx_crc16_io_resultNext;
  wire       [3:0]    _zz_dmaCtx_pendingCounter;
  wire       [3:0]    _zz_dmaCtx_pendingCounter_1;
  wire       [0:0]    _zz_dmaCtx_pendingCounter_2;
  wire       [3:0]    _zz_dmaCtx_pendingCounter_3;
  wire       [0:0]    _zz_dmaCtx_pendingCounter_4;
  reg        [31:0]   _zz_dmaRspMux_data;
  wire       [0:0]    _zz_reg_hcCommandStatus_startSoftReset;
  wire       [0:0]    _zz_reg_hcCommandStatus_CLF;
  wire       [0:0]    _zz_reg_hcCommandStatus_BLF;
  wire       [0:0]    _zz_reg_hcCommandStatus_OCR;
  wire       [0:0]    _zz_reg_hcInterrupt_MIE;
  wire       [0:0]    _zz_reg_hcInterrupt_MIE_1;
  wire       [0:0]    _zz_reg_hcInterrupt_SO_status;
  wire       [0:0]    _zz_reg_hcInterrupt_SO_enable;
  wire       [0:0]    _zz_reg_hcInterrupt_SO_enable_1;
  wire       [0:0]    _zz_reg_hcInterrupt_WDH_status;
  wire       [0:0]    _zz_reg_hcInterrupt_WDH_enable;
  wire       [0:0]    _zz_reg_hcInterrupt_WDH_enable_1;
  wire       [0:0]    _zz_reg_hcInterrupt_SF_status;
  wire       [0:0]    _zz_reg_hcInterrupt_SF_enable;
  wire       [0:0]    _zz_reg_hcInterrupt_SF_enable_1;
  wire       [0:0]    _zz_reg_hcInterrupt_RD_status;
  wire       [0:0]    _zz_reg_hcInterrupt_RD_enable;
  wire       [0:0]    _zz_reg_hcInterrupt_RD_enable_1;
  wire       [0:0]    _zz_reg_hcInterrupt_UE_status;
  wire       [0:0]    _zz_reg_hcInterrupt_UE_enable;
  wire       [0:0]    _zz_reg_hcInterrupt_UE_enable_1;
  wire       [0:0]    _zz_reg_hcInterrupt_FNO_status;
  wire       [0:0]    _zz_reg_hcInterrupt_FNO_enable;
  wire       [0:0]    _zz_reg_hcInterrupt_FNO_enable_1;
  wire       [0:0]    _zz_reg_hcInterrupt_RHSC_status;
  wire       [0:0]    _zz_reg_hcInterrupt_RHSC_enable;
  wire       [0:0]    _zz_reg_hcInterrupt_RHSC_enable_1;
  wire       [0:0]    _zz_reg_hcInterrupt_OC_status;
  wire       [0:0]    _zz_reg_hcInterrupt_OC_enable;
  wire       [0:0]    _zz_reg_hcInterrupt_OC_enable_1;
  wire       [13:0]   _zz_reg_hcLSThreshold_hit;
  wire       [0:0]    _zz_reg_hcRhStatus_CCIC;
  wire       [0:0]    _zz_reg_hcRhStatus_clearGlobalPower;
  wire       [0:0]    _zz_reg_hcRhStatus_setRemoteWakeupEnable;
  wire       [0:0]    _zz_reg_hcRhStatus_setGlobalPower;
  wire       [0:0]    _zz_reg_hcRhStatus_clearRemoteWakeupEnable;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_clearPortEnable;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_setPortEnable;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_setPortSuspend;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_clearSuspendStatus;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_setPortReset;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_setPortPower;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_clearPortPower;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_CSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_PESC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_PSSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_OCIC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_0_PRSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_clearPortEnable;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_setPortEnable;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_setPortSuspend;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_clearSuspendStatus;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_setPortReset;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_setPortPower;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_clearPortPower;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_CSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_PESC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_PSSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_OCIC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_1_PRSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_clearPortEnable;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_setPortEnable;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_setPortSuspend;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_clearSuspendStatus;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_setPortReset;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_setPortPower;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_clearPortPower;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_CSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_PESC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_PSSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_OCIC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_2_PRSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_clearPortEnable;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_setPortEnable;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_setPortSuspend;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_clearSuspendStatus;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_setPortReset;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_setPortPower;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_clearPortPower;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_CSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_PESC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_PSSC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_OCIC_clear;
  wire       [0:0]    _zz_reg_hcRhPortStatus_3_PRSC_clear;
  wire       [7:0]    _zz_rxTimer_ackTx;
  wire       [3:0]    _zz_rxTimer_ackTx_1;
  wire       [15:0]   _zz_endpoint_TD_isoOverrun;
  wire       [12:0]   _zz_endpoint_TD_firstOffset;
  wire       [11:0]   _zz_endpoint_TD_firstOffset_1;
  wire       [12:0]   _zz_endpoint_TD_lastOffset;
  wire       [12:0]   _zz_endpoint_TD_lastOffset_1;
  wire       [0:0]    _zz_endpoint_TD_lastOffset_2;
  wire       [13:0]   _zz_endpoint_transactionSizeMinusOne;
  wire       [13:0]   _zz_endpoint_dataDone;
  wire       [5:0]    _zz_endpoint_dmaLogic_lengthMax;
  wire       [13:0]   _zz_endpoint_dmaLogic_lengthCalc;
  wire       [13:0]   _zz_endpoint_dmaLogic_lengthCalc_1;
  wire       [13:0]   _zz_endpoint_dmaLogic_lengthCalc_2;
  wire       [6:0]    _zz_endpoint_dmaLogic_beatCount;
  wire       [6:0]    _zz_endpoint_dmaLogic_beatCount_1;
  wire       [2:0]    _zz_endpoint_dmaLogic_beatCount_2;
  wire       [6:0]    _zz_endpoint_dmaLogic_lengthBmb;
  wire       [2:0]    _zz_endpoint_dmaLogic_headMask;
  wire       [2:0]    _zz_endpoint_dmaLogic_headMask_1;
  wire                _zz_endpoint_dmaLogic_headMask_2;
  wire       [0:0]    _zz_endpoint_dmaLogic_headMask_3;
  wire       [0:0]    _zz_endpoint_dmaLogic_headMask_4;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_1;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_2;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_3;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_4;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_5;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_6;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_7;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_8;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_9;
  wire       [2:0]    _zz_endpoint_dmaLogic_lastMask_10;
  wire       [2:0]    _zz_endpoint_dmaLogic_lastMask_11;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_12;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_13;
  wire                _zz_endpoint_dmaLogic_lastMask_14;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_15;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_16;
  wire                _zz_endpoint_dmaLogic_lastMask_17;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_18;
  wire       [13:0]   _zz_endpoint_dmaLogic_lastMask_19;
  wire       [5:0]    _zz_endpoint_dmaLogic_beatLast;
  wire       [13:0]   _zz_endpoint_byteCountCalc;
  wire       [13:0]   _zz_endpoint_byteCountCalc_1;
  wire       [16:0]   _zz_endpoint_fsTimeCheck;
  wire       [16:0]   _zz_endpoint_fsTimeCheck_1;
  wire       [15:0]   _zz_token_data;
  wire       [4:0]    _zz_ioDma_cmd_payload_fragment_length;
  wire       [13:0]   _zz__zz_endpoint_lastAddress;
  wire       [13:0]   _zz__zz_endpoint_lastAddress_1;
  wire       [11:0]   _zz__zz_endpoint_lastAddress_2;
  wire       [13:0]   _zz_endpoint_lastAddress_1;
  wire       [13:0]   _zz_endpoint_lastAddress_2;
  wire       [13:0]   _zz_endpoint_lastAddress_3;
  wire       [13:0]   _zz_endpoint_lastAddress_4;
  wire       [13:0]   _zz_when_UsbOhci_l1331;
  wire       [1:0]    _zz_endpoint_TD_words_0;
  wire       [4:0]    _zz_ioDma_cmd_payload_fragment_length_1;
  wire       [2:0]    _zz_ioDma_cmd_payload_last;
  wire       [1:0]    _zz_ioDma_cmd_payload_last_1;
  wire       [11:0]   _zz__zz_ioDma_cmd_payload_fragment_data;
  wire       [13:0]   _zz__zz_ioDma_cmd_payload_fragment_data_1;
  wire       [13:0]   _zz__zz_ioDma_cmd_payload_fragment_data_2;
  wire       [13:0]   _zz__zz_ioDma_cmd_payload_fragment_data_3;
  reg        [7:0]    _zz_dataTx_data_payload_fragment;
  wire       [13:0]   _zz_when_UsbOhci_l1054;
  wire       [13:0]   _zz_endpoint_dmaLogic_overflow;
  wire       [13:0]   _zz_endpoint_lastAddress_5;
  wire       [13:0]   _zz_endpoint_lastAddress_6;
  wire       [13:0]   _zz_endpoint_lastAddress_7;
  wire       [10:0]   _zz_endpoint_dmaLogic_fromUsbCounter;
  wire       [0:0]    _zz_endpoint_dmaLogic_fromUsbCounter_1;
  wire       [13:0]   _zz_endpoint_currentAddress;
  wire       [13:0]   _zz_endpoint_currentAddress_1;
  wire       [13:0]   _zz_endpoint_currentAddress_2;
  wire       [13:0]   _zz_endpoint_currentAddress_3;
  wire       [31:0]   _zz_ioDma_cmd_payload_fragment_address;
  wire       [6:0]    _zz_ioDma_cmd_payload_fragment_address_1;
  reg                 unscheduleAll_valid;
  reg                 unscheduleAll_ready;
  reg                 ioDma_cmd_valid;
  wire                ioDma_cmd_ready;
  reg                 ioDma_cmd_payload_last;
  reg        [0:0]    ioDma_cmd_payload_fragment_opcode;
  reg        [31:0]   ioDma_cmd_payload_fragment_address;
  reg        [5:0]    ioDma_cmd_payload_fragment_length;
  reg        [63:0]   ioDma_cmd_payload_fragment_data;
  reg        [7:0]    ioDma_cmd_payload_fragment_mask;
  wire                ioDma_rsp_valid;
  wire                ioDma_rsp_ready;
  wire                ioDma_rsp_payload_last;
  wire       [0:0]    ioDma_rsp_payload_fragment_opcode;
  wire       [63:0]   ioDma_rsp_payload_fragment_data;
  reg        [3:0]    dmaCtx_pendingCounter;
  wire                ioDma_cmd_fire;
  wire                ioDma_rsp_fire;
  wire                dmaCtx_pendingFull;
  wire                dmaCtx_pendingEmpty;
  reg        [5:0]    dmaCtx_beatCounter;
  wire                when_UsbOhci_l157;
  wire                io_dma_cmd_fire;
  reg                 io_dma_cmd_payload_first;
  wire                _zz_io_dma_cmd_valid;
  wire       [31:0]   dmaRspMux_vec_0;
  wire       [31:0]   dmaRspMux_vec_1;
  wire       [0:0]    dmaRspMux_sel;
  wire       [31:0]   dmaRspMux_data;
  reg        [2:0]    dmaReadCtx_counter;
  reg        [2:0]    dmaWriteCtx_counter;
  reg                 ctrlHalt;
  wire                ctrl_readErrorFlag;
  wire                ctrl_writeErrorFlag;
  wire                ctrl_readHaltTrigger;
  reg                 ctrl_writeHaltTrigger;
  wire                ctrl_rsp_valid;
  wire                ctrl_rsp_ready;
  wire                ctrl_rsp_payload_last;
  reg        [0:0]    ctrl_rsp_payload_fragment_opcode;
  reg        [31:0]   ctrl_rsp_payload_fragment_data;
  wire                _zz_ctrl_rsp_ready;
  reg                 _zz_ctrl_rsp_ready_1;
  wire                _zz_io_ctrl_rsp_valid;
  reg                 _zz_io_ctrl_rsp_valid_1;
  reg                 _zz_io_ctrl_rsp_payload_last;
  reg        [0:0]    _zz_io_ctrl_rsp_payload_fragment_opcode;
  reg        [31:0]   _zz_io_ctrl_rsp_payload_fragment_data;
  wire                when_Stream_l369;
  wire                ctrl_askWrite;
  wire                ctrl_askRead;
  wire                io_ctrl_cmd_fire;
  wire                ctrl_doWrite;
  wire                ctrl_doRead;
  wire                when_BmbSlaveFactory_l33;
  wire                when_BmbSlaveFactory_l35;
  reg                 doUnschedule;
  reg                 doSoftReset;
  wire                when_UsbOhci_l236;
  wire       [4:0]    reg_hcRevision_REV;
  reg        [1:0]    reg_hcControl_CBSR;
  reg                 reg_hcControl_PLE;
  reg                 reg_hcControl_IE;
  reg                 reg_hcControl_CLE;
  reg                 reg_hcControl_BLE;
  reg        [1:0]    reg_hcControl_HCFS;
  reg                 reg_hcControl_IR;
  reg                 reg_hcControl_RWC;
  reg                 reg_hcControl_RWE;
  reg                 reg_hcControl_HCFSWrite_valid;
  wire       [1:0]    reg_hcControl_HCFSWrite_payload;
  reg                 reg_hcCommandStatus_startSoftReset;
  reg                 when_BusSlaveFactory_l377;
  wire                when_BusSlaveFactory_l379;
  reg                 reg_hcCommandStatus_CLF;
  reg                 when_BusSlaveFactory_l377_1;
  wire                when_BusSlaveFactory_l379_1;
  reg                 reg_hcCommandStatus_BLF;
  reg                 when_BusSlaveFactory_l377_2;
  wire                when_BusSlaveFactory_l379_2;
  reg                 reg_hcCommandStatus_OCR;
  reg                 when_BusSlaveFactory_l377_3;
  wire                when_BusSlaveFactory_l379_3;
  reg        [1:0]    reg_hcCommandStatus_SOC;
  reg                 reg_hcInterrupt_unmaskedPending;
  reg                 reg_hcInterrupt_MIE;
  reg                 when_BusSlaveFactory_l377_4;
  wire                when_BusSlaveFactory_l379_4;
  reg                 when_BusSlaveFactory_l341;
  wire                when_BusSlaveFactory_l347;
  reg                 reg_hcInterrupt_SO_status;
  reg                 when_BusSlaveFactory_l341_1;
  wire                when_BusSlaveFactory_l347_1;
  reg                 reg_hcInterrupt_SO_enable;
  reg                 when_BusSlaveFactory_l377_5;
  wire                when_BusSlaveFactory_l379_5;
  reg                 when_BusSlaveFactory_l341_2;
  wire                when_BusSlaveFactory_l347_2;
  wire                when_UsbOhci_l302;
  reg                 reg_hcInterrupt_WDH_status;
  reg                 when_BusSlaveFactory_l341_3;
  wire                when_BusSlaveFactory_l347_3;
  reg                 reg_hcInterrupt_WDH_enable;
  reg                 when_BusSlaveFactory_l377_6;
  wire                when_BusSlaveFactory_l379_6;
  reg                 when_BusSlaveFactory_l341_4;
  wire                when_BusSlaveFactory_l347_4;
  wire                when_UsbOhci_l302_1;
  reg                 reg_hcInterrupt_SF_status;
  reg                 when_BusSlaveFactory_l341_5;
  wire                when_BusSlaveFactory_l347_5;
  reg                 reg_hcInterrupt_SF_enable;
  reg                 when_BusSlaveFactory_l377_7;
  wire                when_BusSlaveFactory_l379_7;
  reg                 when_BusSlaveFactory_l341_6;
  wire                when_BusSlaveFactory_l347_6;
  wire                when_UsbOhci_l302_2;
  reg                 reg_hcInterrupt_RD_status;
  reg                 when_BusSlaveFactory_l341_7;
  wire                when_BusSlaveFactory_l347_7;
  reg                 reg_hcInterrupt_RD_enable;
  reg                 when_BusSlaveFactory_l377_8;
  wire                when_BusSlaveFactory_l379_8;
  reg                 when_BusSlaveFactory_l341_8;
  wire                when_BusSlaveFactory_l347_8;
  wire                when_UsbOhci_l302_3;
  reg                 reg_hcInterrupt_UE_status;
  reg                 when_BusSlaveFactory_l341_9;
  wire                when_BusSlaveFactory_l347_9;
  reg                 reg_hcInterrupt_UE_enable;
  reg                 when_BusSlaveFactory_l377_9;
  wire                when_BusSlaveFactory_l379_9;
  reg                 when_BusSlaveFactory_l341_10;
  wire                when_BusSlaveFactory_l347_10;
  wire                when_UsbOhci_l302_4;
  reg                 reg_hcInterrupt_FNO_status;
  reg                 when_BusSlaveFactory_l341_11;
  wire                when_BusSlaveFactory_l347_11;
  reg                 reg_hcInterrupt_FNO_enable;
  reg                 when_BusSlaveFactory_l377_10;
  wire                when_BusSlaveFactory_l379_10;
  reg                 when_BusSlaveFactory_l341_12;
  wire                when_BusSlaveFactory_l347_12;
  wire                when_UsbOhci_l302_5;
  reg                 reg_hcInterrupt_RHSC_status;
  reg                 when_BusSlaveFactory_l341_13;
  wire                when_BusSlaveFactory_l347_13;
  reg                 reg_hcInterrupt_RHSC_enable;
  reg                 when_BusSlaveFactory_l377_11;
  wire                when_BusSlaveFactory_l379_11;
  reg                 when_BusSlaveFactory_l341_14;
  wire                when_BusSlaveFactory_l347_14;
  wire                when_UsbOhci_l302_6;
  reg                 reg_hcInterrupt_OC_status;
  reg                 when_BusSlaveFactory_l341_15;
  wire                when_BusSlaveFactory_l347_15;
  reg                 reg_hcInterrupt_OC_enable;
  reg                 when_BusSlaveFactory_l377_12;
  wire                when_BusSlaveFactory_l379_12;
  reg                 when_BusSlaveFactory_l341_16;
  wire                when_BusSlaveFactory_l347_16;
  wire                reg_hcInterrupt_doIrq;
  wire       [31:0]   reg_hcHCCA_HCCA_address;
  reg        [23:0]   reg_hcHCCA_HCCA_reg;
  wire       [31:0]   reg_hcPeriodCurrentED_PCED_address;
  reg        [27:0]   reg_hcPeriodCurrentED_PCED_reg;
  wire                reg_hcPeriodCurrentED_isZero;
  wire       [31:0]   reg_hcControlHeadED_CHED_address;
  reg        [27:0]   reg_hcControlHeadED_CHED_reg;
  wire       [31:0]   reg_hcControlCurrentED_CCED_address;
  reg        [27:0]   reg_hcControlCurrentED_CCED_reg;
  wire                reg_hcControlCurrentED_isZero;
  wire       [31:0]   reg_hcBulkHeadED_BHED_address;
  reg        [27:0]   reg_hcBulkHeadED_BHED_reg;
  wire       [31:0]   reg_hcBulkCurrentED_BCED_address;
  reg        [27:0]   reg_hcBulkCurrentED_BCED_reg;
  wire                reg_hcBulkCurrentED_isZero;
  wire       [31:0]   reg_hcDoneHead_DH_address;
  reg        [27:0]   reg_hcDoneHead_DH_reg;
  reg        [13:0]   reg_hcFmInterval_FI;
  reg        [14:0]   reg_hcFmInterval_FSMPS;
  reg                 reg_hcFmInterval_FIT;
  reg        [13:0]   reg_hcFmRemaining_FR;
  reg                 reg_hcFmRemaining_FRT;
  reg        [15:0]   reg_hcFmNumber_FN;
  reg                 reg_hcFmNumber_overflow;
  wire       [15:0]   reg_hcFmNumber_FNp1;
  reg        [13:0]   reg_hcPeriodicStart_PS;
  reg        [11:0]   reg_hcLSThreshold_LST;
  wire                reg_hcLSThreshold_hit;
  wire       [7:0]    reg_hcRhDescriptorA_NDP;
  reg                 reg_hcRhDescriptorA_PSM;
  reg                 reg_hcRhDescriptorA_NPS;
  reg                 reg_hcRhDescriptorA_OCPM;
  reg                 reg_hcRhDescriptorA_NOCP;
  reg        [7:0]    reg_hcRhDescriptorA_POTPGT;
  reg        [3:0]    reg_hcRhDescriptorB_DR;
  reg        [3:0]    reg_hcRhDescriptorB_PPCM;
  reg                 reg_hcRhStatus_DRWE;
  reg                 reg_hcRhStatus_CCIC;
  reg                 when_BusSlaveFactory_l341_17;
  wire                when_BusSlaveFactory_l347_17;
  reg                 io_phy_overcurrent_regNext;
  wire                when_UsbOhci_l409;
  reg                 reg_hcRhStatus_clearGlobalPower;
  reg                 when_BusSlaveFactory_l377_13;
  wire                when_BusSlaveFactory_l379_13;
  reg                 reg_hcRhStatus_setRemoteWakeupEnable;
  reg                 when_BusSlaveFactory_l377_14;
  wire                when_BusSlaveFactory_l379_14;
  reg                 reg_hcRhStatus_setGlobalPower;
  reg                 when_BusSlaveFactory_l377_15;
  wire                when_BusSlaveFactory_l379_15;
  reg                 reg_hcRhStatus_clearRemoteWakeupEnable;
  reg                 when_BusSlaveFactory_l377_16;
  wire                when_BusSlaveFactory_l379_16;
  reg                 reg_hcRhPortStatus_0_clearPortEnable;
  reg                 when_BusSlaveFactory_l377_17;
  wire                when_BusSlaveFactory_l379_17;
  reg                 reg_hcRhPortStatus_0_setPortEnable;
  reg                 when_BusSlaveFactory_l377_18;
  wire                when_BusSlaveFactory_l379_18;
  reg                 reg_hcRhPortStatus_0_setPortSuspend;
  reg                 when_BusSlaveFactory_l377_19;
  wire                when_BusSlaveFactory_l379_19;
  reg                 reg_hcRhPortStatus_0_clearSuspendStatus;
  reg                 when_BusSlaveFactory_l377_20;
  wire                when_BusSlaveFactory_l379_20;
  reg                 reg_hcRhPortStatus_0_setPortReset;
  reg                 when_BusSlaveFactory_l377_21;
  wire                when_BusSlaveFactory_l379_21;
  reg                 reg_hcRhPortStatus_0_setPortPower;
  reg                 when_BusSlaveFactory_l377_22;
  wire                when_BusSlaveFactory_l379_22;
  reg                 reg_hcRhPortStatus_0_clearPortPower;
  reg                 when_BusSlaveFactory_l377_23;
  wire                when_BusSlaveFactory_l379_23;
  reg                 reg_hcRhPortStatus_0_resume;
  reg                 reg_hcRhPortStatus_0_reset;
  reg                 reg_hcRhPortStatus_0_suspend;
  reg                 reg_hcRhPortStatus_0_connected;
  reg                 reg_hcRhPortStatus_0_PSS;
  reg                 reg_hcRhPortStatus_0_PPS;
  wire                reg_hcRhPortStatus_0_CCS;
  reg                 reg_hcRhPortStatus_0_PES;
  wire                reg_hcRhPortStatus_0_CSC_set;
  reg                 reg_hcRhPortStatus_0_CSC_clear;
  reg                 reg_hcRhPortStatus_0_CSC_reg;
  reg                 when_BusSlaveFactory_l377_24;
  wire                when_BusSlaveFactory_l379_24;
  wire                reg_hcRhPortStatus_0_PESC_set;
  reg                 reg_hcRhPortStatus_0_PESC_clear;
  reg                 reg_hcRhPortStatus_0_PESC_reg;
  reg                 when_BusSlaveFactory_l377_25;
  wire                when_BusSlaveFactory_l379_25;
  wire                reg_hcRhPortStatus_0_PSSC_set;
  reg                 reg_hcRhPortStatus_0_PSSC_clear;
  reg                 reg_hcRhPortStatus_0_PSSC_reg;
  reg                 when_BusSlaveFactory_l377_26;
  wire                when_BusSlaveFactory_l379_26;
  wire                reg_hcRhPortStatus_0_OCIC_set;
  reg                 reg_hcRhPortStatus_0_OCIC_clear;
  reg                 reg_hcRhPortStatus_0_OCIC_reg;
  reg                 when_BusSlaveFactory_l377_27;
  wire                when_BusSlaveFactory_l379_27;
  wire                reg_hcRhPortStatus_0_PRSC_set;
  reg                 reg_hcRhPortStatus_0_PRSC_clear;
  reg                 reg_hcRhPortStatus_0_PRSC_reg;
  reg                 when_BusSlaveFactory_l377_28;
  wire                when_BusSlaveFactory_l379_28;
  wire                when_UsbOhci_l460;
  wire                when_UsbOhci_l460_1;
  wire                when_UsbOhci_l460_2;
  wire                when_UsbOhci_l461;
  wire                when_UsbOhci_l461_1;
  wire                when_UsbOhci_l462;
  wire                when_UsbOhci_l463;
  wire                when_UsbOhci_l464;
  wire                when_UsbOhci_l470;
  reg                 reg_hcRhPortStatus_0_CCS_regNext;
  wire                io_phy_ports_0_suspend_fire;
  wire                io_phy_ports_0_reset_fire;
  wire                io_phy_ports_0_resume_fire;
  reg                 reg_hcRhPortStatus_1_clearPortEnable;
  reg                 when_BusSlaveFactory_l377_29;
  wire                when_BusSlaveFactory_l379_29;
  reg                 reg_hcRhPortStatus_1_setPortEnable;
  reg                 when_BusSlaveFactory_l377_30;
  wire                when_BusSlaveFactory_l379_30;
  reg                 reg_hcRhPortStatus_1_setPortSuspend;
  reg                 when_BusSlaveFactory_l377_31;
  wire                when_BusSlaveFactory_l379_31;
  reg                 reg_hcRhPortStatus_1_clearSuspendStatus;
  reg                 when_BusSlaveFactory_l377_32;
  wire                when_BusSlaveFactory_l379_32;
  reg                 reg_hcRhPortStatus_1_setPortReset;
  reg                 when_BusSlaveFactory_l377_33;
  wire                when_BusSlaveFactory_l379_33;
  reg                 reg_hcRhPortStatus_1_setPortPower;
  reg                 when_BusSlaveFactory_l377_34;
  wire                when_BusSlaveFactory_l379_34;
  reg                 reg_hcRhPortStatus_1_clearPortPower;
  reg                 when_BusSlaveFactory_l377_35;
  wire                when_BusSlaveFactory_l379_35;
  reg                 reg_hcRhPortStatus_1_resume;
  reg                 reg_hcRhPortStatus_1_reset;
  reg                 reg_hcRhPortStatus_1_suspend;
  reg                 reg_hcRhPortStatus_1_connected;
  reg                 reg_hcRhPortStatus_1_PSS;
  reg                 reg_hcRhPortStatus_1_PPS;
  wire                reg_hcRhPortStatus_1_CCS;
  reg                 reg_hcRhPortStatus_1_PES;
  wire                reg_hcRhPortStatus_1_CSC_set;
  reg                 reg_hcRhPortStatus_1_CSC_clear;
  reg                 reg_hcRhPortStatus_1_CSC_reg;
  reg                 when_BusSlaveFactory_l377_36;
  wire                when_BusSlaveFactory_l379_36;
  wire                reg_hcRhPortStatus_1_PESC_set;
  reg                 reg_hcRhPortStatus_1_PESC_clear;
  reg                 reg_hcRhPortStatus_1_PESC_reg;
  reg                 when_BusSlaveFactory_l377_37;
  wire                when_BusSlaveFactory_l379_37;
  wire                reg_hcRhPortStatus_1_PSSC_set;
  reg                 reg_hcRhPortStatus_1_PSSC_clear;
  reg                 reg_hcRhPortStatus_1_PSSC_reg;
  reg                 when_BusSlaveFactory_l377_38;
  wire                when_BusSlaveFactory_l379_38;
  wire                reg_hcRhPortStatus_1_OCIC_set;
  reg                 reg_hcRhPortStatus_1_OCIC_clear;
  reg                 reg_hcRhPortStatus_1_OCIC_reg;
  reg                 when_BusSlaveFactory_l377_39;
  wire                when_BusSlaveFactory_l379_39;
  wire                reg_hcRhPortStatus_1_PRSC_set;
  reg                 reg_hcRhPortStatus_1_PRSC_clear;
  reg                 reg_hcRhPortStatus_1_PRSC_reg;
  reg                 when_BusSlaveFactory_l377_40;
  wire                when_BusSlaveFactory_l379_40;
  wire                when_UsbOhci_l460_3;
  wire                when_UsbOhci_l460_4;
  wire                when_UsbOhci_l460_5;
  wire                when_UsbOhci_l461_2;
  wire                when_UsbOhci_l461_3;
  wire                when_UsbOhci_l462_1;
  wire                when_UsbOhci_l463_1;
  wire                when_UsbOhci_l464_1;
  wire                when_UsbOhci_l470_1;
  reg                 reg_hcRhPortStatus_1_CCS_regNext;
  wire                io_phy_ports_1_suspend_fire;
  wire                io_phy_ports_1_reset_fire;
  wire                io_phy_ports_1_resume_fire;
  reg                 reg_hcRhPortStatus_2_clearPortEnable;
  reg                 when_BusSlaveFactory_l377_41;
  wire                when_BusSlaveFactory_l379_41;
  reg                 reg_hcRhPortStatus_2_setPortEnable;
  reg                 when_BusSlaveFactory_l377_42;
  wire                when_BusSlaveFactory_l379_42;
  reg                 reg_hcRhPortStatus_2_setPortSuspend;
  reg                 when_BusSlaveFactory_l377_43;
  wire                when_BusSlaveFactory_l379_43;
  reg                 reg_hcRhPortStatus_2_clearSuspendStatus;
  reg                 when_BusSlaveFactory_l377_44;
  wire                when_BusSlaveFactory_l379_44;
  reg                 reg_hcRhPortStatus_2_setPortReset;
  reg                 when_BusSlaveFactory_l377_45;
  wire                when_BusSlaveFactory_l379_45;
  reg                 reg_hcRhPortStatus_2_setPortPower;
  reg                 when_BusSlaveFactory_l377_46;
  wire                when_BusSlaveFactory_l379_46;
  reg                 reg_hcRhPortStatus_2_clearPortPower;
  reg                 when_BusSlaveFactory_l377_47;
  wire                when_BusSlaveFactory_l379_47;
  reg                 reg_hcRhPortStatus_2_resume;
  reg                 reg_hcRhPortStatus_2_reset;
  reg                 reg_hcRhPortStatus_2_suspend;
  reg                 reg_hcRhPortStatus_2_connected;
  reg                 reg_hcRhPortStatus_2_PSS;
  reg                 reg_hcRhPortStatus_2_PPS;
  wire                reg_hcRhPortStatus_2_CCS;
  reg                 reg_hcRhPortStatus_2_PES;
  wire                reg_hcRhPortStatus_2_CSC_set;
  reg                 reg_hcRhPortStatus_2_CSC_clear;
  reg                 reg_hcRhPortStatus_2_CSC_reg;
  reg                 when_BusSlaveFactory_l377_48;
  wire                when_BusSlaveFactory_l379_48;
  wire                reg_hcRhPortStatus_2_PESC_set;
  reg                 reg_hcRhPortStatus_2_PESC_clear;
  reg                 reg_hcRhPortStatus_2_PESC_reg;
  reg                 when_BusSlaveFactory_l377_49;
  wire                when_BusSlaveFactory_l379_49;
  wire                reg_hcRhPortStatus_2_PSSC_set;
  reg                 reg_hcRhPortStatus_2_PSSC_clear;
  reg                 reg_hcRhPortStatus_2_PSSC_reg;
  reg                 when_BusSlaveFactory_l377_50;
  wire                when_BusSlaveFactory_l379_50;
  wire                reg_hcRhPortStatus_2_OCIC_set;
  reg                 reg_hcRhPortStatus_2_OCIC_clear;
  reg                 reg_hcRhPortStatus_2_OCIC_reg;
  reg                 when_BusSlaveFactory_l377_51;
  wire                when_BusSlaveFactory_l379_51;
  wire                reg_hcRhPortStatus_2_PRSC_set;
  reg                 reg_hcRhPortStatus_2_PRSC_clear;
  reg                 reg_hcRhPortStatus_2_PRSC_reg;
  reg                 when_BusSlaveFactory_l377_52;
  wire                when_BusSlaveFactory_l379_52;
  wire                when_UsbOhci_l460_6;
  wire                when_UsbOhci_l460_7;
  wire                when_UsbOhci_l460_8;
  wire                when_UsbOhci_l461_4;
  wire                when_UsbOhci_l461_5;
  wire                when_UsbOhci_l462_2;
  wire                when_UsbOhci_l463_2;
  wire                when_UsbOhci_l464_2;
  wire                when_UsbOhci_l470_2;
  reg                 reg_hcRhPortStatus_2_CCS_regNext;
  wire                io_phy_ports_2_suspend_fire;
  wire                io_phy_ports_2_reset_fire;
  wire                io_phy_ports_2_resume_fire;
  reg                 reg_hcRhPortStatus_3_clearPortEnable;
  reg                 when_BusSlaveFactory_l377_53;
  wire                when_BusSlaveFactory_l379_53;
  reg                 reg_hcRhPortStatus_3_setPortEnable;
  reg                 when_BusSlaveFactory_l377_54;
  wire                when_BusSlaveFactory_l379_54;
  reg                 reg_hcRhPortStatus_3_setPortSuspend;
  reg                 when_BusSlaveFactory_l377_55;
  wire                when_BusSlaveFactory_l379_55;
  reg                 reg_hcRhPortStatus_3_clearSuspendStatus;
  reg                 when_BusSlaveFactory_l377_56;
  wire                when_BusSlaveFactory_l379_56;
  reg                 reg_hcRhPortStatus_3_setPortReset;
  reg                 when_BusSlaveFactory_l377_57;
  wire                when_BusSlaveFactory_l379_57;
  reg                 reg_hcRhPortStatus_3_setPortPower;
  reg                 when_BusSlaveFactory_l377_58;
  wire                when_BusSlaveFactory_l379_58;
  reg                 reg_hcRhPortStatus_3_clearPortPower;
  reg                 when_BusSlaveFactory_l377_59;
  wire                when_BusSlaveFactory_l379_59;
  reg                 reg_hcRhPortStatus_3_resume;
  reg                 reg_hcRhPortStatus_3_reset;
  reg                 reg_hcRhPortStatus_3_suspend;
  reg                 reg_hcRhPortStatus_3_connected;
  reg                 reg_hcRhPortStatus_3_PSS;
  reg                 reg_hcRhPortStatus_3_PPS;
  wire                reg_hcRhPortStatus_3_CCS;
  reg                 reg_hcRhPortStatus_3_PES;
  wire                reg_hcRhPortStatus_3_CSC_set;
  reg                 reg_hcRhPortStatus_3_CSC_clear;
  reg                 reg_hcRhPortStatus_3_CSC_reg;
  reg                 when_BusSlaveFactory_l377_60;
  wire                when_BusSlaveFactory_l379_60;
  wire                reg_hcRhPortStatus_3_PESC_set;
  reg                 reg_hcRhPortStatus_3_PESC_clear;
  reg                 reg_hcRhPortStatus_3_PESC_reg;
  reg                 when_BusSlaveFactory_l377_61;
  wire                when_BusSlaveFactory_l379_61;
  wire                reg_hcRhPortStatus_3_PSSC_set;
  reg                 reg_hcRhPortStatus_3_PSSC_clear;
  reg                 reg_hcRhPortStatus_3_PSSC_reg;
  reg                 when_BusSlaveFactory_l377_62;
  wire                when_BusSlaveFactory_l379_62;
  wire                reg_hcRhPortStatus_3_OCIC_set;
  reg                 reg_hcRhPortStatus_3_OCIC_clear;
  reg                 reg_hcRhPortStatus_3_OCIC_reg;
  reg                 when_BusSlaveFactory_l377_63;
  wire                when_BusSlaveFactory_l379_63;
  wire                reg_hcRhPortStatus_3_PRSC_set;
  reg                 reg_hcRhPortStatus_3_PRSC_clear;
  reg                 reg_hcRhPortStatus_3_PRSC_reg;
  reg                 when_BusSlaveFactory_l377_64;
  wire                when_BusSlaveFactory_l379_64;
  wire                when_UsbOhci_l460_9;
  wire                when_UsbOhci_l460_10;
  wire                when_UsbOhci_l460_11;
  wire                when_UsbOhci_l461_6;
  wire                when_UsbOhci_l461_7;
  wire                when_UsbOhci_l462_3;
  wire                when_UsbOhci_l463_3;
  wire                when_UsbOhci_l464_3;
  wire                when_UsbOhci_l470_3;
  reg                 reg_hcRhPortStatus_3_CCS_regNext;
  wire                io_phy_ports_3_suspend_fire;
  wire                io_phy_ports_3_reset_fire;
  wire                io_phy_ports_3_resume_fire;
  reg                 frame_run;
  reg                 frame_reload;
  wire                frame_overflow;
  reg                 frame_tick;
  wire                frame_section1;
  reg        [14:0]   frame_limitCounter;
  wire                frame_limitHit;
  reg        [2:0]    frame_decrementTimer;
  wire                frame_decrementTimerOverflow;
  wire                when_UsbOhci_l526;
  wire                when_UsbOhci_l528;
  wire                when_UsbOhci_l540;
  reg                 token_wantExit;
  reg                 token_wantStart;
  reg                 token_wantKill;
  reg        [3:0]    token_pid;
  reg        [10:0]   token_data;
  reg                 dataTx_wantExit;
  reg                 dataTx_wantStart;
  reg                 dataTx_wantKill;
  reg        [3:0]    dataTx_pid;
  reg                 dataTx_data_valid;
  reg                 dataTx_data_ready;
  reg                 dataTx_data_payload_last;
  reg        [7:0]    dataTx_data_payload_fragment;
  wire                dataTx_data_fire;
  wire                rxTimer_lowSpeed;
  reg        [7:0]    rxTimer_counter;
  reg                 rxTimer_clear;
  wire                rxTimer_rxTimeout;
  wire                rxTimer_ackTx;
  wire                rxPidOk;
  wire                _zz_1;
  wire       [7:0]    _zz_dataRx_pid;
  wire                when_Misc_l87;
  reg                 dataRx_wantExit;
  reg                 dataRx_wantStart;
  reg                 dataRx_wantKill;
  reg        [3:0]    dataRx_pid;
  reg                 dataRx_data_valid;
  wire       [7:0]    dataRx_data_payload;
  wire       [7:0]    dataRx_history_0;
  wire       [7:0]    dataRx_history_1;
  reg        [7:0]    _zz_dataRx_history_0;
  reg        [7:0]    _zz_dataRx_history_1;
  reg        [1:0]    dataRx_valids;
  reg                 dataRx_notResponding;
  reg                 dataRx_stuffingError;
  reg                 dataRx_pidError;
  reg                 dataRx_crcError;
  wire                dataRx_hasError;
  reg                 sof_wantExit;
  reg                 sof_wantStart;
  reg                 sof_wantKill;
  reg                 sof_doInterruptDelay;
  reg                 priority_bulk;
  reg        [1:0]    priority_counter;
  reg                 priority_tick;
  reg                 priority_skip;
  wire                when_UsbOhci_l663;
  reg        [2:0]    interruptDelay_counter;
  reg                 interruptDelay_tick;
  wire                interruptDelay_done;
  wire                interruptDelay_disabled;
  reg                 interruptDelay_disable;
  reg                 interruptDelay_load_valid;
  reg        [2:0]    interruptDelay_load_payload;
  wire                when_UsbOhci_l685;
  wire                when_UsbOhci_l689;
  reg                 endpoint_wantExit;
  reg                 endpoint_wantStart;
  reg                 endpoint_wantKill;
  reg        [1:0]    endpoint_flowType;
  reg        [0:0]    endpoint_status_1;
  reg                 endpoint_dataPhase;
  reg        [31:0]   endpoint_ED_address;
  reg        [31:0]   endpoint_ED_words_0;
  reg        [31:0]   endpoint_ED_words_1;
  reg        [31:0]   endpoint_ED_words_2;
  reg        [31:0]   endpoint_ED_words_3;
  wire       [6:0]    endpoint_ED_FA;
  wire       [3:0]    endpoint_ED_EN;
  wire       [1:0]    endpoint_ED_D;
  wire                endpoint_ED_S;
  wire                endpoint_ED_K;
  wire                endpoint_ED_F;
  wire       [10:0]   endpoint_ED_MPS;
  wire       [27:0]   endpoint_ED_tailP;
  wire                endpoint_ED_H;
  wire                endpoint_ED_C;
  wire       [27:0]   endpoint_ED_headP;
  wire       [27:0]   endpoint_ED_nextED;
  wire                endpoint_ED_tdEmpty;
  wire                endpoint_ED_isFs;
  wire                endpoint_ED_isoOut;
  wire                when_UsbOhci_l750;
  wire       [31:0]   endpoint_TD_address;
  reg        [31:0]   endpoint_TD_words_0;
  reg        [31:0]   endpoint_TD_words_1;
  reg        [31:0]   endpoint_TD_words_2;
  reg        [31:0]   endpoint_TD_words_3;
  wire       [3:0]    endpoint_TD_CC;
  wire       [1:0]    endpoint_TD_EC;
  wire       [1:0]    endpoint_TD_T;
  wire       [2:0]    endpoint_TD_DI;
  wire       [1:0]    endpoint_TD_DP;
  wire                endpoint_TD_R;
  wire       [31:0]   endpoint_TD_CBP;
  wire       [27:0]   endpoint_TD_nextTD;
  wire       [31:0]   endpoint_TD_BE;
  wire       [2:0]    endpoint_TD_FC;
  wire       [15:0]   endpoint_TD_SF;
  wire       [15:0]   endpoint_TD_isoRelativeFrameNumber;
  wire                endpoint_TD_tooEarly;
  wire       [2:0]    endpoint_TD_isoFrameNumber;
  wire                endpoint_TD_isoOverrun;
  reg                 endpoint_TD_isoOverrunReg;
  wire                endpoint_TD_isoLast;
  reg        [12:0]   endpoint_TD_isoBase;
  reg        [12:0]   endpoint_TD_isoBaseNext;
  reg                 endpoint_TD_isoZero;
  reg                 endpoint_TD_isoLastReg;
  reg                 endpoint_TD_tooEarlyReg;
  wire                endpoint_TD_isSinglePage;
  wire       [12:0]   endpoint_TD_firstOffset;
  reg        [12:0]   endpoint_TD_lastOffset;
  wire                endpoint_TD_allowRounding;
  reg                 endpoint_TD_retire;
  reg                 endpoint_TD_upateCBP;
  reg                 endpoint_TD_noUpdate;
  reg                 endpoint_TD_dataPhaseUpdate;
  wire       [1:0]    endpoint_TD_TNext;
  wire                endpoint_TD_dataPhaseNext;
  wire       [3:0]    endpoint_TD_dataPid;
  wire       [3:0]    endpoint_TD_dataPidWrong;
  reg                 endpoint_TD_clear;
  wire       [1:0]    endpoint_tockenType;
  wire                endpoint_isIn;
  reg                 endpoint_applyNextED;
  reg        [13:0]   endpoint_currentAddress;
  wire       [31:0]   endpoint_currentAddressFull;
  reg        [31:0]   _zz_endpoint_currentAddressBmb;
  wire       [31:0]   endpoint_currentAddressBmb;
  reg        [12:0]   endpoint_lastAddress;
  wire       [13:0]   endpoint_transactionSizeMinusOne;
  wire       [13:0]   endpoint_transactionSize;
  reg                 endpoint_zeroLength;
  wire                endpoint_dataDone;
  reg                 endpoint_dmaLogic_wantExit;
  reg                 endpoint_dmaLogic_wantStart;
  reg                 endpoint_dmaLogic_wantKill;
  reg                 endpoint_dmaLogic_validated;
  reg        [5:0]    endpoint_dmaLogic_length;
  wire       [5:0]    endpoint_dmaLogic_lengthMax;
  wire       [5:0]    endpoint_dmaLogic_lengthCalc;
  wire       [3:0]    endpoint_dmaLogic_beatCount;
  wire       [5:0]    endpoint_dmaLogic_lengthBmb;
  reg        [10:0]   endpoint_dmaLogic_fromUsbCounter;
  reg                 endpoint_dmaLogic_overflow;
  reg                 endpoint_dmaLogic_underflow;
  wire                endpoint_dmaLogic_underflowError;
  wire                when_UsbOhci_l938;
  reg        [12:0]   endpoint_dmaLogic_byteCtx_counter;
  wire                endpoint_dmaLogic_byteCtx_last;
  wire       [2:0]    endpoint_dmaLogic_byteCtx_sel;
  reg                 endpoint_dmaLogic_byteCtx_increment;
  wire       [7:0]    endpoint_dmaLogic_headMask;
  wire       [7:0]    endpoint_dmaLogic_lastMask;
  wire       [7:0]    endpoint_dmaLogic_fullMask;
  wire                endpoint_dmaLogic_beatLast;
  reg        [63:0]   endpoint_dmaLogic_buffer;
  reg                 endpoint_dmaLogic_push;
  wire                endpoint_dmaLogic_fsmStopped;
  wire       [13:0]   endpoint_byteCountCalc;
  wire                endpoint_fsTimeCheck;
  wire                endpoint_timeCheck;
  reg                 endpoint_ackRxFired;
  reg                 endpoint_ackRxActivated;
  reg                 endpoint_ackRxPidFailure;
  reg                 endpoint_ackRxStuffing;
  reg        [3:0]    endpoint_ackRxPid;
  wire       [31:0]   endpoint_tdUpdateAddress;
  reg                 operational_wantExit;
  reg                 operational_wantStart;
  reg                 operational_wantKill;
  reg                 operational_periodicHeadFetched;
  reg                 operational_periodicDone;
  reg                 operational_allowBulk;
  reg                 operational_allowControl;
  reg                 operational_allowPeriodic;
  reg                 operational_allowIsochronous;
  reg                 operational_askExit;
  wire                hc_wantExit;
  reg                 hc_wantStart;
  wire                hc_wantKill;
  reg                 hc_error;
  wire                hc_operationalIsDone;
  wire       [1:0]    _zz_reg_hcControl_HCFSWrite_payload;
  wire                when_BusSlaveFactory_l1021;
  wire                when_BusSlaveFactory_l1021_1;
  wire                when_BusSlaveFactory_l1021_2;
  wire                when_BusSlaveFactory_l1021_3;
  wire                when_BusSlaveFactory_l1021_4;
  wire                when_BusSlaveFactory_l1021_5;
  wire                when_BusSlaveFactory_l1021_6;
  wire                when_BusSlaveFactory_l1021_7;
  wire                when_BusSlaveFactory_l1021_8;
  wire                when_BusSlaveFactory_l1021_9;
  wire                when_BusSlaveFactory_l1021_10;
  wire                when_BusSlaveFactory_l1021_11;
  wire                when_BusSlaveFactory_l1021_12;
  wire                when_BusSlaveFactory_l1021_13;
  wire                when_BusSlaveFactory_l1021_14;
  wire                when_BusSlaveFactory_l1021_15;
  wire                when_BusSlaveFactory_l1021_16;
  wire                when_BusSlaveFactory_l1021_17;
  wire                when_BusSlaveFactory_l1021_18;
  wire                when_BusSlaveFactory_l1021_19;
  wire                when_BusSlaveFactory_l1021_20;
  wire                when_BusSlaveFactory_l1021_21;
  wire                when_BusSlaveFactory_l1021_22;
  wire                when_BusSlaveFactory_l1021_23;
  wire                when_BusSlaveFactory_l1021_24;
  wire                when_BusSlaveFactory_l1021_25;
  wire                when_BusSlaveFactory_l1021_26;
  wire                when_BusSlaveFactory_l1021_27;
  wire                when_BusSlaveFactory_l1021_28;
  wire                when_BusSlaveFactory_l1021_29;
  wire                when_BusSlaveFactory_l1021_30;
  wire                when_BusSlaveFactory_l1021_31;
  wire                when_BusSlaveFactory_l1021_32;
  wire                when_BusSlaveFactory_l1021_33;
  wire                when_BusSlaveFactory_l1021_34;
  wire                when_BusSlaveFactory_l1021_35;
  wire                when_BusSlaveFactory_l1021_36;
  wire                when_BusSlaveFactory_l1021_37;
  wire                when_BusSlaveFactory_l1021_38;
  wire                when_BusSlaveFactory_l1021_39;
  wire                when_BusSlaveFactory_l1021_40;
  wire                when_BusSlaveFactory_l1021_41;
  wire                when_BusSlaveFactory_l1021_42;
  wire                when_BusSlaveFactory_l1021_43;
  wire                when_BusSlaveFactory_l1021_44;
  wire                when_BusSlaveFactory_l1021_45;
  wire                when_BusSlaveFactory_l1021_46;
  reg                 _zz_when_UsbOhci_l253;
  wire                when_UsbOhci_l253;
  reg        [2:0]    token_stateReg;
  reg        [2:0]    token_stateNext;
  wire                when_StateMachine_l237;
  wire                unscheduleAll_fire;
  reg        [2:0]    dataTx_stateReg;
  reg        [2:0]    dataTx_stateNext;
  reg        [1:0]    dataRx_stateReg;
  reg        [1:0]    dataRx_stateNext;
  wire                when_Misc_l64;
  wire                when_Misc_l70;
  wire                when_Misc_l71;
  wire                when_Misc_l78;
  wire                when_StateMachine_l253;
  wire                when_Misc_l85;
  reg        [1:0]    sof_stateReg;
  reg        [1:0]    sof_stateNext;
  wire                when_UsbOhci_l206;
  wire                when_UsbOhci_l206_1;
  wire                when_UsbOhci_l626;
  wire                when_StateMachine_l237_1;
  reg        [4:0]    endpoint_stateReg;
  reg        [4:0]    endpoint_stateNext;
  wire                when_UsbOhci_l1128;
  wire                when_UsbOhci_l1311;
  wire                when_UsbOhci_l188;
  wire                when_UsbOhci_l188_1;
  wire                when_UsbOhci_l188_2;
  wire                when_UsbOhci_l188_3;
  wire                when_UsbOhci_l855;
  wire                when_UsbOhci_l861;
  wire                when_UsbOhci_l188_4;
  wire                when_UsbOhci_l188_5;
  wire                when_UsbOhci_l188_6;
  wire                when_UsbOhci_l188_7;
  wire                when_UsbOhci_l891;
  wire                when_UsbOhci_l188_8;
  wire                when_UsbOhci_l188_9;
  wire                when_UsbOhci_l891_1;
  wire                when_UsbOhci_l188_10;
  wire                when_UsbOhci_l188_11;
  wire                when_UsbOhci_l891_2;
  wire                when_UsbOhci_l188_12;
  wire                when_UsbOhci_l188_13;
  wire                when_UsbOhci_l891_3;
  wire                when_UsbOhci_l188_14;
  wire                when_UsbOhci_l188_15;
  wire                when_UsbOhci_l891_4;
  wire                when_UsbOhci_l188_16;
  wire                when_UsbOhci_l188_17;
  wire                when_UsbOhci_l891_5;
  wire                when_UsbOhci_l188_18;
  wire                when_UsbOhci_l188_19;
  wire                when_UsbOhci_l891_6;
  wire                when_UsbOhci_l188_20;
  wire                when_UsbOhci_l188_21;
  wire                when_UsbOhci_l891_7;
  wire                when_UsbOhci_l188_22;
  wire                when_UsbOhci_l898;
  wire       [13:0]   _zz_endpoint_lastAddress;
  wire                when_UsbOhci_l1118;
  reg                 when_UsbOhci_l1274;
  wire                when_UsbOhci_l1263;
  wire                when_UsbOhci_l1283;
  wire                when_UsbOhci_l1200;
  wire                when_UsbOhci_l1205;
  wire                when_UsbOhci_l1207;
  wire                when_UsbOhci_l1331;
  wire                when_UsbOhci_l1346;
  wire                when_UsbOhci_l206_2;
  wire                when_UsbOhci_l206_3;
  wire       [15:0]   _zz_ioDma_cmd_payload_fragment_data;
  wire                when_UsbOhci_l1378;
  wire                when_UsbOhci_l206_4;
  wire                when_UsbOhci_l1378_1;
  wire                when_UsbOhci_l206_5;
  wire                when_UsbOhci_l1378_2;
  wire                when_UsbOhci_l206_6;
  wire                when_UsbOhci_l1378_3;
  wire                when_UsbOhci_l206_7;
  wire                when_UsbOhci_l1378_4;
  wire                when_UsbOhci_l206_8;
  wire                when_UsbOhci_l1378_5;
  wire                when_UsbOhci_l206_9;
  wire                when_UsbOhci_l1378_6;
  wire                when_UsbOhci_l206_10;
  wire                when_UsbOhci_l1378_7;
  wire                when_UsbOhci_l206_11;
  wire                when_UsbOhci_l206_12;
  wire                when_UsbOhci_l206_13;
  wire                when_UsbOhci_l206_14;
  wire                when_UsbOhci_l1393;
  wire                when_UsbOhci_l206_15;
  wire                when_UsbOhci_l1408;
  wire                when_UsbOhci_l1415;
  wire                when_UsbOhci_l1418;
  wire                when_StateMachine_l237_2;
  wire                when_StateMachine_l253_1;
  wire                when_StateMachine_l253_2;
  wire                when_StateMachine_l253_3;
  wire                when_StateMachine_l253_4;
  reg        [2:0]    endpoint_dmaLogic_stateReg;
  reg        [2:0]    endpoint_dmaLogic_stateNext;
  wire                when_UsbOhci_l1025;
  wire                when_UsbOhci_l1054;
  wire       [7:0]    _zz_2;
  wire                when_UsbOhci_l1063;
  wire                when_UsbOhci_l1068;
  reg                 ioDma_cmd_payload_first;
  wire                when_StateMachine_l253_5;
  reg        [2:0]    operational_stateReg;
  reg        [2:0]    operational_stateNext;
  wire                when_UsbOhci_l1461;
  wire                when_UsbOhci_l1488;
  wire                when_UsbOhci_l1487;
  wire                when_StateMachine_l237_3;
  wire                when_StateMachine_l253_6;
  reg        [2:0]    hc_stateReg;
  reg        [2:0]    hc_stateNext;
  wire                when_UsbOhci_l1616;
  wire                when_UsbOhci_l1625;
  wire                when_UsbOhci_l1628;
  wire                when_UsbOhci_l1639;
  wire                when_UsbOhci_l1652;
  wire                when_StateMachine_l253_7;
  wire                when_StateMachine_l253_8;
  wire                when_StateMachine_l253_9;
  wire                when_UsbOhci_l1659;
  `ifndef SYNTHESIS
  reg [87:0] reg_hcControl_HCFS_string;
  reg [87:0] reg_hcControl_HCFSWrite_payload_string;
  reg [63:0] endpoint_flowType_string;
  reg [79:0] endpoint_status_1_string;
  reg [87:0] _zz_reg_hcControl_HCFSWrite_payload_string;
  reg [31:0] token_stateReg_string;
  reg [31:0] token_stateNext_string;
  reg [39:0] dataTx_stateReg_string;
  reg [39:0] dataTx_stateNext_string;
  reg [31:0] dataRx_stateReg_string;
  reg [31:0] dataRx_stateNext_string;
  reg [127:0] sof_stateReg_string;
  reg [127:0] sof_stateNext_string;
  reg [135:0] endpoint_stateReg_string;
  reg [135:0] endpoint_stateNext_string;
  reg [79:0] endpoint_dmaLogic_stateReg_string;
  reg [79:0] endpoint_dmaLogic_stateNext_string;
  reg [135:0] operational_stateReg_string;
  reg [135:0] operational_stateNext_string;
  reg [111:0] hc_stateReg_string;
  reg [111:0] hc_stateNext_string;
  `endif

  function [31:0] zz__zz_endpoint_currentAddressBmb(input dummy);
    begin
      zz__zz_endpoint_currentAddressBmb = 32'hffffffff;
      zz__zz_endpoint_currentAddressBmb[2 : 0] = 3'b000;
    end
  endfunction
  wire [31:0] _zz_3;

  assign _zz_dmaCtx_pendingCounter = (dmaCtx_pendingCounter + _zz_dmaCtx_pendingCounter_1);
  assign _zz_dmaCtx_pendingCounter_2 = (ioDma_cmd_fire && ioDma_cmd_payload_last);
  assign _zz_dmaCtx_pendingCounter_1 = {3'd0, _zz_dmaCtx_pendingCounter_2};
  assign _zz_dmaCtx_pendingCounter_4 = (ioDma_rsp_fire && ioDma_rsp_payload_last);
  assign _zz_dmaCtx_pendingCounter_3 = {3'd0, _zz_dmaCtx_pendingCounter_4};
  assign _zz_reg_hcCommandStatus_startSoftReset = 1'b1;
  assign _zz_reg_hcCommandStatus_CLF = 1'b1;
  assign _zz_reg_hcCommandStatus_BLF = 1'b1;
  assign _zz_reg_hcCommandStatus_OCR = 1'b1;
  assign _zz_reg_hcInterrupt_MIE = 1'b1;
  assign _zz_reg_hcInterrupt_MIE_1 = 1'b0;
  assign _zz_reg_hcInterrupt_SO_status = 1'b0;
  assign _zz_reg_hcInterrupt_SO_enable = 1'b1;
  assign _zz_reg_hcInterrupt_SO_enable_1 = 1'b0;
  assign _zz_reg_hcInterrupt_WDH_status = 1'b0;
  assign _zz_reg_hcInterrupt_WDH_enable = 1'b1;
  assign _zz_reg_hcInterrupt_WDH_enable_1 = 1'b0;
  assign _zz_reg_hcInterrupt_SF_status = 1'b0;
  assign _zz_reg_hcInterrupt_SF_enable = 1'b1;
  assign _zz_reg_hcInterrupt_SF_enable_1 = 1'b0;
  assign _zz_reg_hcInterrupt_RD_status = 1'b0;
  assign _zz_reg_hcInterrupt_RD_enable = 1'b1;
  assign _zz_reg_hcInterrupt_RD_enable_1 = 1'b0;
  assign _zz_reg_hcInterrupt_UE_status = 1'b0;
  assign _zz_reg_hcInterrupt_UE_enable = 1'b1;
  assign _zz_reg_hcInterrupt_UE_enable_1 = 1'b0;
  assign _zz_reg_hcInterrupt_FNO_status = 1'b0;
  assign _zz_reg_hcInterrupt_FNO_enable = 1'b1;
  assign _zz_reg_hcInterrupt_FNO_enable_1 = 1'b0;
  assign _zz_reg_hcInterrupt_RHSC_status = 1'b0;
  assign _zz_reg_hcInterrupt_RHSC_enable = 1'b1;
  assign _zz_reg_hcInterrupt_RHSC_enable_1 = 1'b0;
  assign _zz_reg_hcInterrupt_OC_status = 1'b0;
  assign _zz_reg_hcInterrupt_OC_enable = 1'b1;
  assign _zz_reg_hcInterrupt_OC_enable_1 = 1'b0;
  assign _zz_reg_hcLSThreshold_hit = {2'd0, reg_hcLSThreshold_LST};
  assign _zz_reg_hcRhStatus_CCIC = 1'b0;
  assign _zz_reg_hcRhStatus_clearGlobalPower = 1'b1;
  assign _zz_reg_hcRhStatus_setRemoteWakeupEnable = 1'b1;
  assign _zz_reg_hcRhStatus_setGlobalPower = 1'b1;
  assign _zz_reg_hcRhStatus_clearRemoteWakeupEnable = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_clearPortEnable = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_setPortEnable = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_setPortSuspend = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_clearSuspendStatus = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_setPortReset = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_setPortPower = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_clearPortPower = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_CSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_PESC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_PSSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_OCIC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_0_PRSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_clearPortEnable = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_setPortEnable = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_setPortSuspend = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_clearSuspendStatus = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_setPortReset = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_setPortPower = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_clearPortPower = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_CSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_PESC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_PSSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_OCIC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_1_PRSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_clearPortEnable = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_setPortEnable = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_setPortSuspend = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_clearSuspendStatus = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_setPortReset = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_setPortPower = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_clearPortPower = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_CSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_PESC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_PSSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_OCIC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_2_PRSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_clearPortEnable = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_setPortEnable = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_setPortSuspend = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_clearSuspendStatus = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_setPortReset = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_setPortPower = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_clearPortPower = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_CSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_PESC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_PSSC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_OCIC_clear = 1'b1;
  assign _zz_reg_hcRhPortStatus_3_PRSC_clear = 1'b1;
  assign _zz_rxTimer_ackTx_1 = (rxTimer_lowSpeed ? 4'b1111 : 4'b0001);
  assign _zz_rxTimer_ackTx = {4'd0, _zz_rxTimer_ackTx_1};
  assign _zz_endpoint_TD_isoOverrun = {13'd0, endpoint_TD_FC};
  assign _zz_endpoint_TD_firstOffset_1 = endpoint_TD_CBP[11 : 0];
  assign _zz_endpoint_TD_firstOffset = {1'd0, _zz_endpoint_TD_firstOffset_1};
  assign _zz_endpoint_TD_lastOffset = (endpoint_TD_isoBaseNext - _zz_endpoint_TD_lastOffset_1);
  assign _zz_endpoint_TD_lastOffset_2 = (! endpoint_TD_isoLast);
  assign _zz_endpoint_TD_lastOffset_1 = {12'd0, _zz_endpoint_TD_lastOffset_2};
  assign _zz_endpoint_transactionSizeMinusOne = {1'd0, endpoint_lastAddress};
  assign _zz_endpoint_dataDone = {1'd0, endpoint_lastAddress};
  assign _zz_endpoint_dmaLogic_lengthMax = endpoint_currentAddress[5:0];
  assign _zz_endpoint_dmaLogic_lengthCalc = ((endpoint_transactionSizeMinusOne < _zz_endpoint_dmaLogic_lengthCalc_1) ? endpoint_transactionSizeMinusOne : _zz_endpoint_dmaLogic_lengthCalc_2);
  assign _zz_endpoint_dmaLogic_lengthCalc_1 = {8'd0, endpoint_dmaLogic_lengthMax};
  assign _zz_endpoint_dmaLogic_lengthCalc_2 = {8'd0, endpoint_dmaLogic_lengthMax};
  assign _zz_endpoint_dmaLogic_beatCount = ({1'b0,endpoint_dmaLogic_length} + _zz_endpoint_dmaLogic_beatCount_1);
  assign _zz_endpoint_dmaLogic_beatCount_2 = endpoint_currentAddressFull[2 : 0];
  assign _zz_endpoint_dmaLogic_beatCount_1 = {4'd0, _zz_endpoint_dmaLogic_beatCount_2};
  assign _zz_endpoint_dmaLogic_lengthBmb = {endpoint_dmaLogic_beatCount,3'b111};
  assign _zz_endpoint_dmaLogic_lastMask = (endpoint_currentAddress + _zz_endpoint_dmaLogic_lastMask_1);
  assign _zz_endpoint_dmaLogic_lastMask_1 = {8'd0, endpoint_dmaLogic_length};
  assign _zz_endpoint_dmaLogic_lastMask_2 = (endpoint_currentAddress + _zz_endpoint_dmaLogic_lastMask_3);
  assign _zz_endpoint_dmaLogic_lastMask_3 = {8'd0, endpoint_dmaLogic_length};
  assign _zz_endpoint_dmaLogic_lastMask_4 = (endpoint_currentAddress + _zz_endpoint_dmaLogic_lastMask_5);
  assign _zz_endpoint_dmaLogic_lastMask_5 = {8'd0, endpoint_dmaLogic_length};
  assign _zz_endpoint_dmaLogic_lastMask_6 = (endpoint_currentAddress + _zz_endpoint_dmaLogic_lastMask_7);
  assign _zz_endpoint_dmaLogic_lastMask_7 = {8'd0, endpoint_dmaLogic_length};
  assign _zz_endpoint_dmaLogic_lastMask_8 = (endpoint_currentAddress + _zz_endpoint_dmaLogic_lastMask_9);
  assign _zz_endpoint_dmaLogic_lastMask_9 = {8'd0, endpoint_dmaLogic_length};
  assign _zz_endpoint_dmaLogic_lastMask_12 = (endpoint_currentAddress + _zz_endpoint_dmaLogic_lastMask_13);
  assign _zz_endpoint_dmaLogic_lastMask_13 = {8'd0, endpoint_dmaLogic_length};
  assign _zz_endpoint_dmaLogic_lastMask_15 = (endpoint_currentAddress + _zz_endpoint_dmaLogic_lastMask_16);
  assign _zz_endpoint_dmaLogic_lastMask_16 = {8'd0, endpoint_dmaLogic_length};
  assign _zz_endpoint_dmaLogic_lastMask_18 = (endpoint_currentAddress + _zz_endpoint_dmaLogic_lastMask_19);
  assign _zz_endpoint_dmaLogic_lastMask_19 = {8'd0, endpoint_dmaLogic_length};
  assign _zz_endpoint_dmaLogic_beatLast = {2'd0, endpoint_dmaLogic_beatCount};
  assign _zz_endpoint_byteCountCalc = (_zz_endpoint_byteCountCalc_1 - endpoint_currentAddress);
  assign _zz_endpoint_byteCountCalc_1 = {1'd0, endpoint_lastAddress};
  assign _zz_endpoint_fsTimeCheck = {2'd0, frame_limitCounter};
  assign _zz_endpoint_fsTimeCheck_1 = ({3'd0,endpoint_byteCountCalc} <<< 2'd3);
  assign _zz_token_data = reg_hcFmNumber_FN;
  assign _zz_ioDma_cmd_payload_fragment_length = (endpoint_ED_F ? 5'h1f : 5'h0f);
  assign _zz__zz_endpoint_lastAddress = ({1'b0,endpoint_TD_firstOffset} + _zz__zz_endpoint_lastAddress_1);
  assign _zz__zz_endpoint_lastAddress_2 = {1'b0,endpoint_ED_MPS};
  assign _zz__zz_endpoint_lastAddress_1 = {2'd0, _zz__zz_endpoint_lastAddress_2};
  assign _zz_endpoint_lastAddress_1 = (endpoint_ED_F ? _zz_endpoint_lastAddress_2 : ((_zz_endpoint_lastAddress_3 < _zz_endpoint_lastAddress) ? _zz_endpoint_lastAddress_4 : _zz_endpoint_lastAddress));
  assign _zz_endpoint_lastAddress_2 = {1'd0, endpoint_TD_lastOffset};
  assign _zz_endpoint_lastAddress_3 = {1'd0, endpoint_TD_lastOffset};
  assign _zz_endpoint_lastAddress_4 = {1'd0, endpoint_TD_lastOffset};
  assign _zz_when_UsbOhci_l1331 = {1'd0, endpoint_TD_lastOffset};
  assign _zz_endpoint_TD_words_0 = (endpoint_TD_EC + 2'b01);
  assign _zz_ioDma_cmd_payload_fragment_length_1 = (endpoint_ED_F ? 5'h1f : 5'h0f);
  assign _zz_ioDma_cmd_payload_last_1 = (endpoint_ED_F ? 2'b11 : 2'b01);
  assign _zz_ioDma_cmd_payload_last = {1'd0, _zz_ioDma_cmd_payload_last_1};
  assign _zz__zz_ioDma_cmd_payload_fragment_data_1 = (endpoint_ED_isoOut ? 14'h0000 : _zz__zz_ioDma_cmd_payload_fragment_data_2);
  assign _zz__zz_ioDma_cmd_payload_fragment_data = _zz__zz_ioDma_cmd_payload_fragment_data_1[11:0];
  assign _zz__zz_ioDma_cmd_payload_fragment_data_2 = (endpoint_currentAddress - _zz__zz_ioDma_cmd_payload_fragment_data_3);
  assign _zz__zz_ioDma_cmd_payload_fragment_data_3 = {1'd0, endpoint_TD_isoBase};
  assign _zz_when_UsbOhci_l1054 = {3'd0, endpoint_dmaLogic_fromUsbCounter};
  assign _zz_endpoint_dmaLogic_overflow = {3'd0, endpoint_dmaLogic_fromUsbCounter};
  assign _zz_endpoint_lastAddress_5 = (_zz_endpoint_lastAddress_6 - 14'h0001);
  assign _zz_endpoint_lastAddress_6 = (endpoint_currentAddress + _zz_endpoint_lastAddress_7);
  assign _zz_endpoint_lastAddress_7 = {3'd0, endpoint_dmaLogic_fromUsbCounter};
  assign _zz_endpoint_dmaLogic_fromUsbCounter_1 = (! endpoint_dmaLogic_fromUsbCounter[10]);
  assign _zz_endpoint_dmaLogic_fromUsbCounter = {10'd0, _zz_endpoint_dmaLogic_fromUsbCounter_1};
  assign _zz_endpoint_currentAddress = (endpoint_currentAddress + _zz_endpoint_currentAddress_1);
  assign _zz_endpoint_currentAddress_1 = {8'd0, endpoint_dmaLogic_length};
  assign _zz_endpoint_currentAddress_2 = (endpoint_currentAddress + _zz_endpoint_currentAddress_3);
  assign _zz_endpoint_currentAddress_3 = {8'd0, endpoint_dmaLogic_length};
  assign _zz_ioDma_cmd_payload_fragment_address_1 = ({2'd0,reg_hcFmNumber_FN[4 : 0]} <<< 2'd2);
  assign _zz_ioDma_cmd_payload_fragment_address = {25'd0, _zz_ioDma_cmd_payload_fragment_address_1};
  assign _zz_endpoint_dmaLogic_headMask = endpoint_currentAddress[2 : 0];
  assign _zz_endpoint_dmaLogic_headMask_1 = 3'b011;
  assign _zz_endpoint_dmaLogic_headMask_2 = (endpoint_currentAddress[2 : 0] <= 3'b010);
  assign _zz_endpoint_dmaLogic_headMask_3 = (endpoint_currentAddress[2 : 0] <= 3'b001);
  assign _zz_endpoint_dmaLogic_headMask_4 = (endpoint_currentAddress[2 : 0] <= 3'b000);
  assign _zz_endpoint_dmaLogic_lastMask_10 = 3'b010;
  assign _zz_endpoint_dmaLogic_lastMask_11 = _zz_endpoint_dmaLogic_lastMask_12[2 : 0];
  assign _zz_endpoint_dmaLogic_lastMask_14 = (3'b001 <= _zz_endpoint_dmaLogic_lastMask_15[2 : 0]);
  assign _zz_endpoint_dmaLogic_lastMask_17 = (3'b000 <= _zz_endpoint_dmaLogic_lastMask_18[2 : 0]);
  StreamFifo fifo (
    .io_push_valid   (fifo_io_push_valid        ), //i
    .io_push_ready   (fifo_io_push_ready        ), //o
    .io_push_payload (fifo_io_push_payload[63:0]), //i
    .io_pop_valid    (fifo_io_pop_valid         ), //o
    .io_pop_ready    (fifo_io_pop_ready         ), //i
    .io_pop_payload  (fifo_io_pop_payload[63:0] ), //o
    .io_flush        (fifo_io_flush             ), //i
    .io_occupancy    (fifo_io_occupancy[8:0]    ), //o
    .io_availability (fifo_io_availability[8:0] ), //o
    .clk             (clk                       ), //i
    .reset           (reset                     )  //i
  );
  Crc token_crc5 (
    .io_flush         (token_crc5_io_flush          ), //i
    .io_input_valid   (token_crc5_io_input_valid    ), //i
    .io_input_payload (token_data[10:0]             ), //i
    .io_result        (token_crc5_io_result[4:0]    ), //o
    .io_resultNext    (token_crc5_io_resultNext[4:0]), //o
    .clk              (clk                          ), //i
    .reset            (reset                        )  //i
  );
  Crc_1 dataTx_crc16 (
    .io_flush         (dataTx_crc16_io_flush            ), //i
    .io_input_valid   (dataTx_data_fire                 ), //i
    .io_input_payload (dataTx_data_payload_fragment[7:0]), //i
    .io_result        (dataTx_crc16_io_result[15:0]     ), //o
    .io_resultNext    (dataTx_crc16_io_resultNext[15:0] ), //o
    .clk              (clk                              ), //i
    .reset            (reset                            )  //i
  );
  Crc_2 dataRx_crc16 (
    .io_flush         (dataRx_crc16_io_flush           ), //i
    .io_input_valid   (dataRx_crc16_io_input_valid     ), //i
    .io_input_payload (_zz_dataRx_pid[7:0]             ), //i
    .io_result        (dataRx_crc16_io_result[15:0]    ), //o
    .io_resultNext    (dataRx_crc16_io_resultNext[15:0]), //o
    .clk              (clk                             ), //i
    .reset            (reset                           )  //i
  );
  always @(*) begin
    case(dmaRspMux_sel)
      1'b0 : _zz_dmaRspMux_data = dmaRspMux_vec_0;
      default : _zz_dmaRspMux_data = dmaRspMux_vec_1;
    endcase
  end

  always @(*) begin
    case(endpoint_dmaLogic_byteCtx_sel)
      3'b000 : _zz_dataTx_data_payload_fragment = fifo_io_pop_payload[7 : 0];
      3'b001 : _zz_dataTx_data_payload_fragment = fifo_io_pop_payload[15 : 8];
      3'b010 : _zz_dataTx_data_payload_fragment = fifo_io_pop_payload[23 : 16];
      3'b011 : _zz_dataTx_data_payload_fragment = fifo_io_pop_payload[31 : 24];
      3'b100 : _zz_dataTx_data_payload_fragment = fifo_io_pop_payload[39 : 32];
      3'b101 : _zz_dataTx_data_payload_fragment = fifo_io_pop_payload[47 : 40];
      3'b110 : _zz_dataTx_data_payload_fragment = fifo_io_pop_payload[55 : 48];
      default : _zz_dataTx_data_payload_fragment = fifo_io_pop_payload[63 : 56];
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(reg_hcControl_HCFS)
      MainState_RESET : reg_hcControl_HCFS_string = "RESET      ";
      MainState_RESUME : reg_hcControl_HCFS_string = "RESUME     ";
      MainState_OPERATIONAL : reg_hcControl_HCFS_string = "OPERATIONAL";
      MainState_SUSPEND : reg_hcControl_HCFS_string = "SUSPEND    ";
      default : reg_hcControl_HCFS_string = "???????????";
    endcase
  end
  always @(*) begin
    case(reg_hcControl_HCFSWrite_payload)
      MainState_RESET : reg_hcControl_HCFSWrite_payload_string = "RESET      ";
      MainState_RESUME : reg_hcControl_HCFSWrite_payload_string = "RESUME     ";
      MainState_OPERATIONAL : reg_hcControl_HCFSWrite_payload_string = "OPERATIONAL";
      MainState_SUSPEND : reg_hcControl_HCFSWrite_payload_string = "SUSPEND    ";
      default : reg_hcControl_HCFSWrite_payload_string = "???????????";
    endcase
  end
  always @(*) begin
    case(endpoint_flowType)
      FlowType_BULK : endpoint_flowType_string = "BULK    ";
      FlowType_CONTROL : endpoint_flowType_string = "CONTROL ";
      FlowType_PERIODIC : endpoint_flowType_string = "PERIODIC";
      default : endpoint_flowType_string = "????????";
    endcase
  end
  always @(*) begin
    case(endpoint_status_1)
      endpoint_Status_OK : endpoint_status_1_string = "OK        ";
      endpoint_Status_FRAME_TIME : endpoint_status_1_string = "FRAME_TIME";
      default : endpoint_status_1_string = "??????????";
    endcase
  end
  always @(*) begin
    case(_zz_reg_hcControl_HCFSWrite_payload)
      MainState_RESET : _zz_reg_hcControl_HCFSWrite_payload_string = "RESET      ";
      MainState_RESUME : _zz_reg_hcControl_HCFSWrite_payload_string = "RESUME     ";
      MainState_OPERATIONAL : _zz_reg_hcControl_HCFSWrite_payload_string = "OPERATIONAL";
      MainState_SUSPEND : _zz_reg_hcControl_HCFSWrite_payload_string = "SUSPEND    ";
      default : _zz_reg_hcControl_HCFSWrite_payload_string = "???????????";
    endcase
  end
  always @(*) begin
    case(token_stateReg)
      token_enumDef_BOOT : token_stateReg_string = "BOOT";
      token_enumDef_INIT : token_stateReg_string = "INIT";
      token_enumDef_PID : token_stateReg_string = "PID ";
      token_enumDef_B1 : token_stateReg_string = "B1  ";
      token_enumDef_B2 : token_stateReg_string = "B2  ";
      token_enumDef_EOP : token_stateReg_string = "EOP ";
      default : token_stateReg_string = "????";
    endcase
  end
  always @(*) begin
    case(token_stateNext)
      token_enumDef_BOOT : token_stateNext_string = "BOOT";
      token_enumDef_INIT : token_stateNext_string = "INIT";
      token_enumDef_PID : token_stateNext_string = "PID ";
      token_enumDef_B1 : token_stateNext_string = "B1  ";
      token_enumDef_B2 : token_stateNext_string = "B2  ";
      token_enumDef_EOP : token_stateNext_string = "EOP ";
      default : token_stateNext_string = "????";
    endcase
  end
  always @(*) begin
    case(dataTx_stateReg)
      dataTx_enumDef_BOOT : dataTx_stateReg_string = "BOOT ";
      dataTx_enumDef_PID : dataTx_stateReg_string = "PID  ";
      dataTx_enumDef_DATA : dataTx_stateReg_string = "DATA ";
      dataTx_enumDef_CRC_0 : dataTx_stateReg_string = "CRC_0";
      dataTx_enumDef_CRC_1 : dataTx_stateReg_string = "CRC_1";
      dataTx_enumDef_EOP : dataTx_stateReg_string = "EOP  ";
      default : dataTx_stateReg_string = "?????";
    endcase
  end
  always @(*) begin
    case(dataTx_stateNext)
      dataTx_enumDef_BOOT : dataTx_stateNext_string = "BOOT ";
      dataTx_enumDef_PID : dataTx_stateNext_string = "PID  ";
      dataTx_enumDef_DATA : dataTx_stateNext_string = "DATA ";
      dataTx_enumDef_CRC_0 : dataTx_stateNext_string = "CRC_0";
      dataTx_enumDef_CRC_1 : dataTx_stateNext_string = "CRC_1";
      dataTx_enumDef_EOP : dataTx_stateNext_string = "EOP  ";
      default : dataTx_stateNext_string = "?????";
    endcase
  end
  always @(*) begin
    case(dataRx_stateReg)
      dataRx_enumDef_BOOT : dataRx_stateReg_string = "BOOT";
      dataRx_enumDef_IDLE : dataRx_stateReg_string = "IDLE";
      dataRx_enumDef_PID : dataRx_stateReg_string = "PID ";
      dataRx_enumDef_DATA : dataRx_stateReg_string = "DATA";
      default : dataRx_stateReg_string = "????";
    endcase
  end
  always @(*) begin
    case(dataRx_stateNext)
      dataRx_enumDef_BOOT : dataRx_stateNext_string = "BOOT";
      dataRx_enumDef_IDLE : dataRx_stateNext_string = "IDLE";
      dataRx_enumDef_PID : dataRx_stateNext_string = "PID ";
      dataRx_enumDef_DATA : dataRx_stateNext_string = "DATA";
      default : dataRx_stateNext_string = "????";
    endcase
  end
  always @(*) begin
    case(sof_stateReg)
      sof_enumDef_BOOT : sof_stateReg_string = "BOOT            ";
      sof_enumDef_FRAME_TX : sof_stateReg_string = "FRAME_TX        ";
      sof_enumDef_FRAME_NUMBER_CMD : sof_stateReg_string = "FRAME_NUMBER_CMD";
      sof_enumDef_FRAME_NUMBER_RSP : sof_stateReg_string = "FRAME_NUMBER_RSP";
      default : sof_stateReg_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(sof_stateNext)
      sof_enumDef_BOOT : sof_stateNext_string = "BOOT            ";
      sof_enumDef_FRAME_TX : sof_stateNext_string = "FRAME_TX        ";
      sof_enumDef_FRAME_NUMBER_CMD : sof_stateNext_string = "FRAME_NUMBER_CMD";
      sof_enumDef_FRAME_NUMBER_RSP : sof_stateNext_string = "FRAME_NUMBER_RSP";
      default : sof_stateNext_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(endpoint_stateReg)
      endpoint_enumDef_BOOT : endpoint_stateReg_string = "BOOT             ";
      endpoint_enumDef_ED_READ_CMD : endpoint_stateReg_string = "ED_READ_CMD      ";
      endpoint_enumDef_ED_READ_RSP : endpoint_stateReg_string = "ED_READ_RSP      ";
      endpoint_enumDef_ED_ANALYSE : endpoint_stateReg_string = "ED_ANALYSE       ";
      endpoint_enumDef_TD_READ_CMD : endpoint_stateReg_string = "TD_READ_CMD      ";
      endpoint_enumDef_TD_READ_RSP : endpoint_stateReg_string = "TD_READ_RSP      ";
      endpoint_enumDef_TD_READ_DELAY : endpoint_stateReg_string = "TD_READ_DELAY    ";
      endpoint_enumDef_TD_ANALYSE : endpoint_stateReg_string = "TD_ANALYSE       ";
      endpoint_enumDef_TD_CHECK_TIME : endpoint_stateReg_string = "TD_CHECK_TIME    ";
      endpoint_enumDef_BUFFER_READ : endpoint_stateReg_string = "BUFFER_READ      ";
      endpoint_enumDef_TOKEN : endpoint_stateReg_string = "TOKEN            ";
      endpoint_enumDef_DATA_TX : endpoint_stateReg_string = "DATA_TX          ";
      endpoint_enumDef_DATA_RX : endpoint_stateReg_string = "DATA_RX          ";
      endpoint_enumDef_DATA_RX_VALIDATE : endpoint_stateReg_string = "DATA_RX_VALIDATE ";
      endpoint_enumDef_ACK_RX : endpoint_stateReg_string = "ACK_RX           ";
      endpoint_enumDef_ACK_TX_0 : endpoint_stateReg_string = "ACK_TX_0         ";
      endpoint_enumDef_ACK_TX_1 : endpoint_stateReg_string = "ACK_TX_1         ";
      endpoint_enumDef_ACK_TX_EOP : endpoint_stateReg_string = "ACK_TX_EOP       ";
      endpoint_enumDef_DATA_RX_WAIT_DMA : endpoint_stateReg_string = "DATA_RX_WAIT_DMA ";
      endpoint_enumDef_UPDATE_TD_PROCESS : endpoint_stateReg_string = "UPDATE_TD_PROCESS";
      endpoint_enumDef_UPDATE_TD_CMD : endpoint_stateReg_string = "UPDATE_TD_CMD    ";
      endpoint_enumDef_UPDATE_ED_CMD : endpoint_stateReg_string = "UPDATE_ED_CMD    ";
      endpoint_enumDef_UPDATE_SYNC : endpoint_stateReg_string = "UPDATE_SYNC      ";
      endpoint_enumDef_ABORD : endpoint_stateReg_string = "ABORD            ";
      default : endpoint_stateReg_string = "?????????????????";
    endcase
  end
  always @(*) begin
    case(endpoint_stateNext)
      endpoint_enumDef_BOOT : endpoint_stateNext_string = "BOOT             ";
      endpoint_enumDef_ED_READ_CMD : endpoint_stateNext_string = "ED_READ_CMD      ";
      endpoint_enumDef_ED_READ_RSP : endpoint_stateNext_string = "ED_READ_RSP      ";
      endpoint_enumDef_ED_ANALYSE : endpoint_stateNext_string = "ED_ANALYSE       ";
      endpoint_enumDef_TD_READ_CMD : endpoint_stateNext_string = "TD_READ_CMD      ";
      endpoint_enumDef_TD_READ_RSP : endpoint_stateNext_string = "TD_READ_RSP      ";
      endpoint_enumDef_TD_READ_DELAY : endpoint_stateNext_string = "TD_READ_DELAY    ";
      endpoint_enumDef_TD_ANALYSE : endpoint_stateNext_string = "TD_ANALYSE       ";
      endpoint_enumDef_TD_CHECK_TIME : endpoint_stateNext_string = "TD_CHECK_TIME    ";
      endpoint_enumDef_BUFFER_READ : endpoint_stateNext_string = "BUFFER_READ      ";
      endpoint_enumDef_TOKEN : endpoint_stateNext_string = "TOKEN            ";
      endpoint_enumDef_DATA_TX : endpoint_stateNext_string = "DATA_TX          ";
      endpoint_enumDef_DATA_RX : endpoint_stateNext_string = "DATA_RX          ";
      endpoint_enumDef_DATA_RX_VALIDATE : endpoint_stateNext_string = "DATA_RX_VALIDATE ";
      endpoint_enumDef_ACK_RX : endpoint_stateNext_string = "ACK_RX           ";
      endpoint_enumDef_ACK_TX_0 : endpoint_stateNext_string = "ACK_TX_0         ";
      endpoint_enumDef_ACK_TX_1 : endpoint_stateNext_string = "ACK_TX_1         ";
      endpoint_enumDef_ACK_TX_EOP : endpoint_stateNext_string = "ACK_TX_EOP       ";
      endpoint_enumDef_DATA_RX_WAIT_DMA : endpoint_stateNext_string = "DATA_RX_WAIT_DMA ";
      endpoint_enumDef_UPDATE_TD_PROCESS : endpoint_stateNext_string = "UPDATE_TD_PROCESS";
      endpoint_enumDef_UPDATE_TD_CMD : endpoint_stateNext_string = "UPDATE_TD_CMD    ";
      endpoint_enumDef_UPDATE_ED_CMD : endpoint_stateNext_string = "UPDATE_ED_CMD    ";
      endpoint_enumDef_UPDATE_SYNC : endpoint_stateNext_string = "UPDATE_SYNC      ";
      endpoint_enumDef_ABORD : endpoint_stateNext_string = "ABORD            ";
      default : endpoint_stateNext_string = "?????????????????";
    endcase
  end
  always @(*) begin
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_BOOT : endpoint_dmaLogic_stateReg_string = "BOOT      ";
      endpoint_dmaLogic_enumDef_INIT : endpoint_dmaLogic_stateReg_string = "INIT      ";
      endpoint_dmaLogic_enumDef_TO_USB : endpoint_dmaLogic_stateReg_string = "TO_USB    ";
      endpoint_dmaLogic_enumDef_FROM_USB : endpoint_dmaLogic_stateReg_string = "FROM_USB  ";
      endpoint_dmaLogic_enumDef_VALIDATION : endpoint_dmaLogic_stateReg_string = "VALIDATION";
      endpoint_dmaLogic_enumDef_CALC_CMD : endpoint_dmaLogic_stateReg_string = "CALC_CMD  ";
      endpoint_dmaLogic_enumDef_READ_CMD : endpoint_dmaLogic_stateReg_string = "READ_CMD  ";
      endpoint_dmaLogic_enumDef_WRITE_CMD : endpoint_dmaLogic_stateReg_string = "WRITE_CMD ";
      default : endpoint_dmaLogic_stateReg_string = "??????????";
    endcase
  end
  always @(*) begin
    case(endpoint_dmaLogic_stateNext)
      endpoint_dmaLogic_enumDef_BOOT : endpoint_dmaLogic_stateNext_string = "BOOT      ";
      endpoint_dmaLogic_enumDef_INIT : endpoint_dmaLogic_stateNext_string = "INIT      ";
      endpoint_dmaLogic_enumDef_TO_USB : endpoint_dmaLogic_stateNext_string = "TO_USB    ";
      endpoint_dmaLogic_enumDef_FROM_USB : endpoint_dmaLogic_stateNext_string = "FROM_USB  ";
      endpoint_dmaLogic_enumDef_VALIDATION : endpoint_dmaLogic_stateNext_string = "VALIDATION";
      endpoint_dmaLogic_enumDef_CALC_CMD : endpoint_dmaLogic_stateNext_string = "CALC_CMD  ";
      endpoint_dmaLogic_enumDef_READ_CMD : endpoint_dmaLogic_stateNext_string = "READ_CMD  ";
      endpoint_dmaLogic_enumDef_WRITE_CMD : endpoint_dmaLogic_stateNext_string = "WRITE_CMD ";
      default : endpoint_dmaLogic_stateNext_string = "??????????";
    endcase
  end
  always @(*) begin
    case(operational_stateReg)
      operational_enumDef_BOOT : operational_stateReg_string = "BOOT             ";
      operational_enumDef_SOF : operational_stateReg_string = "SOF              ";
      operational_enumDef_ARBITER : operational_stateReg_string = "ARBITER          ";
      operational_enumDef_END_POINT : operational_stateReg_string = "END_POINT        ";
      operational_enumDef_PERIODIC_HEAD_CMD : operational_stateReg_string = "PERIODIC_HEAD_CMD";
      operational_enumDef_PERIODIC_HEAD_RSP : operational_stateReg_string = "PERIODIC_HEAD_RSP";
      operational_enumDef_WAIT_SOF : operational_stateReg_string = "WAIT_SOF         ";
      default : operational_stateReg_string = "?????????????????";
    endcase
  end
  always @(*) begin
    case(operational_stateNext)
      operational_enumDef_BOOT : operational_stateNext_string = "BOOT             ";
      operational_enumDef_SOF : operational_stateNext_string = "SOF              ";
      operational_enumDef_ARBITER : operational_stateNext_string = "ARBITER          ";
      operational_enumDef_END_POINT : operational_stateNext_string = "END_POINT        ";
      operational_enumDef_PERIODIC_HEAD_CMD : operational_stateNext_string = "PERIODIC_HEAD_CMD";
      operational_enumDef_PERIODIC_HEAD_RSP : operational_stateNext_string = "PERIODIC_HEAD_RSP";
      operational_enumDef_WAIT_SOF : operational_stateNext_string = "WAIT_SOF         ";
      default : operational_stateNext_string = "?????????????????";
    endcase
  end
  always @(*) begin
    case(hc_stateReg)
      hc_enumDef_BOOT : hc_stateReg_string = "BOOT          ";
      hc_enumDef_RESET : hc_stateReg_string = "RESET         ";
      hc_enumDef_RESUME : hc_stateReg_string = "RESUME        ";
      hc_enumDef_OPERATIONAL : hc_stateReg_string = "OPERATIONAL   ";
      hc_enumDef_SUSPEND : hc_stateReg_string = "SUSPEND       ";
      hc_enumDef_ANY_TO_RESET : hc_stateReg_string = "ANY_TO_RESET  ";
      hc_enumDef_ANY_TO_SUSPEND : hc_stateReg_string = "ANY_TO_SUSPEND";
      default : hc_stateReg_string = "??????????????";
    endcase
  end
  always @(*) begin
    case(hc_stateNext)
      hc_enumDef_BOOT : hc_stateNext_string = "BOOT          ";
      hc_enumDef_RESET : hc_stateNext_string = "RESET         ";
      hc_enumDef_RESUME : hc_stateNext_string = "RESUME        ";
      hc_enumDef_OPERATIONAL : hc_stateNext_string = "OPERATIONAL   ";
      hc_enumDef_SUSPEND : hc_stateNext_string = "SUSPEND       ";
      hc_enumDef_ANY_TO_RESET : hc_stateNext_string = "ANY_TO_RESET  ";
      hc_enumDef_ANY_TO_SUSPEND : hc_stateNext_string = "ANY_TO_SUSPEND";
      default : hc_stateNext_string = "??????????????";
    endcase
  end
  `endif

  always @(*) begin
    io_phy_lowSpeed = 1'b0;
    if(when_UsbOhci_l750) begin
      io_phy_lowSpeed = endpoint_ED_S;
    end
  end

  always @(*) begin
    unscheduleAll_valid = 1'b0;
    if(doUnschedule) begin
      unscheduleAll_valid = 1'b1;
    end
  end

  always @(*) begin
    unscheduleAll_ready = 1'b1;
    if(when_UsbOhci_l157) begin
      unscheduleAll_ready = 1'b0;
    end
  end

  assign ioDma_cmd_fire = (ioDma_cmd_valid && ioDma_cmd_ready);
  assign ioDma_rsp_fire = (ioDma_rsp_valid && ioDma_rsp_ready);
  assign dmaCtx_pendingFull = dmaCtx_pendingCounter[3];
  assign dmaCtx_pendingEmpty = (dmaCtx_pendingCounter == 4'b0000);
  assign when_UsbOhci_l157 = (! dmaCtx_pendingEmpty);
  assign io_dma_cmd_fire = (io_dma_cmd_valid && io_dma_cmd_ready);
  assign _zz_io_dma_cmd_valid = (! (dmaCtx_pendingFull || (unscheduleAll_valid && io_dma_cmd_payload_first)));
  assign ioDma_cmd_ready = (io_dma_cmd_ready && _zz_io_dma_cmd_valid);
  assign io_dma_cmd_valid = (ioDma_cmd_valid && _zz_io_dma_cmd_valid);
  assign io_dma_cmd_payload_last = ioDma_cmd_payload_last;
  assign io_dma_cmd_payload_fragment_opcode = ioDma_cmd_payload_fragment_opcode;
  assign io_dma_cmd_payload_fragment_address = ioDma_cmd_payload_fragment_address;
  assign io_dma_cmd_payload_fragment_length = ioDma_cmd_payload_fragment_length;
  assign io_dma_cmd_payload_fragment_data = ioDma_cmd_payload_fragment_data;
  assign io_dma_cmd_payload_fragment_mask = ioDma_cmd_payload_fragment_mask;
  assign ioDma_rsp_valid = io_dma_rsp_valid;
  assign io_dma_rsp_ready = ioDma_rsp_ready;
  assign ioDma_rsp_payload_last = io_dma_rsp_payload_last;
  assign ioDma_rsp_payload_fragment_opcode = io_dma_rsp_payload_fragment_opcode;
  assign ioDma_rsp_payload_fragment_data = io_dma_rsp_payload_fragment_data;
  always @(*) begin
    ioDma_cmd_valid = 1'b0;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
        ioDma_cmd_valid = 1'b1;
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
        ioDma_cmd_valid = 1'b1;
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
        ioDma_cmd_valid = 1'b1;
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
        ioDma_cmd_valid = 1'b1;
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
        ioDma_cmd_valid = 1'b1;
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
        ioDma_cmd_valid = 1'b1;
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        ioDma_cmd_valid = 1'b1;
      end
      default : begin
      end
    endcase
    case(operational_stateReg)
      operational_enumDef_SOF : begin
      end
      operational_enumDef_ARBITER : begin
      end
      operational_enumDef_END_POINT : begin
      end
      operational_enumDef_PERIODIC_HEAD_CMD : begin
        ioDma_cmd_valid = 1'b1;
      end
      operational_enumDef_PERIODIC_HEAD_RSP : begin
      end
      operational_enumDef_WAIT_SOF : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ioDma_cmd_payload_last = 1'bx;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
        ioDma_cmd_payload_last = (dmaWriteCtx_counter == 3'b000);
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
        ioDma_cmd_payload_last = 1'b1;
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
        ioDma_cmd_payload_last = 1'b1;
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
        ioDma_cmd_payload_last = (dmaWriteCtx_counter == _zz_ioDma_cmd_payload_last);
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
        ioDma_cmd_payload_last = (dmaWriteCtx_counter == 3'b001);
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
        ioDma_cmd_payload_last = 1'b1;
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        ioDma_cmd_payload_last = endpoint_dmaLogic_beatLast;
      end
      default : begin
      end
    endcase
    case(operational_stateReg)
      operational_enumDef_SOF : begin
      end
      operational_enumDef_ARBITER : begin
      end
      operational_enumDef_END_POINT : begin
      end
      operational_enumDef_PERIODIC_HEAD_CMD : begin
        ioDma_cmd_payload_last = 1'b1;
      end
      operational_enumDef_PERIODIC_HEAD_RSP : begin
      end
      operational_enumDef_WAIT_SOF : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ioDma_cmd_payload_fragment_opcode = 1'bx;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
        ioDma_cmd_payload_fragment_opcode = 1'b1;
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
        ioDma_cmd_payload_fragment_opcode = 1'b0;
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
        ioDma_cmd_payload_fragment_opcode = 1'b0;
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
        ioDma_cmd_payload_fragment_opcode = 1'b1;
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
        ioDma_cmd_payload_fragment_opcode = 1'b1;
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
        ioDma_cmd_payload_fragment_opcode = 1'b0;
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        ioDma_cmd_payload_fragment_opcode = 1'b1;
      end
      default : begin
      end
    endcase
    case(operational_stateReg)
      operational_enumDef_SOF : begin
      end
      operational_enumDef_ARBITER : begin
      end
      operational_enumDef_END_POINT : begin
      end
      operational_enumDef_PERIODIC_HEAD_CMD : begin
        ioDma_cmd_payload_fragment_opcode = 1'b0;
      end
      operational_enumDef_PERIODIC_HEAD_RSP : begin
      end
      operational_enumDef_WAIT_SOF : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ioDma_cmd_payload_fragment_address = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
        ioDma_cmd_payload_fragment_address = (reg_hcHCCA_HCCA_address | 32'h00000080);
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
        ioDma_cmd_payload_fragment_address = endpoint_ED_address;
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
        ioDma_cmd_payload_fragment_address = endpoint_TD_address;
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
        ioDma_cmd_payload_fragment_address = endpoint_TD_address;
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
        ioDma_cmd_payload_fragment_address = endpoint_ED_address;
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
        ioDma_cmd_payload_fragment_address = endpoint_currentAddressBmb;
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        ioDma_cmd_payload_fragment_address = endpoint_currentAddressBmb;
      end
      default : begin
      end
    endcase
    case(operational_stateReg)
      operational_enumDef_SOF : begin
      end
      operational_enumDef_ARBITER : begin
      end
      operational_enumDef_END_POINT : begin
      end
      operational_enumDef_PERIODIC_HEAD_CMD : begin
        ioDma_cmd_payload_fragment_address = (reg_hcHCCA_HCCA_address | _zz_ioDma_cmd_payload_fragment_address);
      end
      operational_enumDef_PERIODIC_HEAD_RSP : begin
      end
      operational_enumDef_WAIT_SOF : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ioDma_cmd_payload_fragment_length = 6'bxxxxxx;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
        ioDma_cmd_payload_fragment_length = 6'h07;
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
        ioDma_cmd_payload_fragment_length = 6'h0f;
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
        ioDma_cmd_payload_fragment_length = {1'd0, _zz_ioDma_cmd_payload_fragment_length};
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
        ioDma_cmd_payload_fragment_length = {1'd0, _zz_ioDma_cmd_payload_fragment_length_1};
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
        ioDma_cmd_payload_fragment_length = 6'h0f;
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
        ioDma_cmd_payload_fragment_length = endpoint_dmaLogic_lengthBmb;
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        ioDma_cmd_payload_fragment_length = endpoint_dmaLogic_lengthBmb;
      end
      default : begin
      end
    endcase
    case(operational_stateReg)
      operational_enumDef_SOF : begin
      end
      operational_enumDef_ARBITER : begin
      end
      operational_enumDef_END_POINT : begin
      end
      operational_enumDef_PERIODIC_HEAD_CMD : begin
        ioDma_cmd_payload_fragment_length = 6'h03;
      end
      operational_enumDef_PERIODIC_HEAD_RSP : begin
      end
      operational_enumDef_WAIT_SOF : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ioDma_cmd_payload_fragment_data = 64'h0000000000000000;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
        if(when_UsbOhci_l206) begin
          ioDma_cmd_payload_fragment_data[31 : 0] = {16'h0000,reg_hcFmNumber_FN};
        end
        if(sof_doInterruptDelay) begin
          if(when_UsbOhci_l206_1) begin
            ioDma_cmd_payload_fragment_data[63 : 32] = {reg_hcDoneHead_DH_address[31 : 1],reg_hcInterrupt_unmaskedPending};
          end
        end
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
        if(endpoint_ED_F) begin
          if(endpoint_TD_isoOverrunReg) begin
            if(when_UsbOhci_l206_2) begin
              ioDma_cmd_payload_fragment_data[31 : 24] = {{4'b1000,endpoint_TD_words_0[27]},endpoint_TD_FC};
            end
          end else begin
            if(endpoint_TD_isoLastReg) begin
              if(when_UsbOhci_l206_3) begin
                ioDma_cmd_payload_fragment_data[31 : 24] = {{4'b0000,endpoint_TD_words_0[27]},endpoint_TD_FC};
              end
            end
            if(when_UsbOhci_l1378) begin
              if(when_UsbOhci_l206_4) begin
                ioDma_cmd_payload_fragment_data[15 : 0] = _zz_ioDma_cmd_payload_fragment_data;
              end
            end
            if(when_UsbOhci_l1378_1) begin
              if(when_UsbOhci_l206_5) begin
                ioDma_cmd_payload_fragment_data[31 : 16] = _zz_ioDma_cmd_payload_fragment_data;
              end
            end
            if(when_UsbOhci_l1378_2) begin
              if(when_UsbOhci_l206_6) begin
                ioDma_cmd_payload_fragment_data[47 : 32] = _zz_ioDma_cmd_payload_fragment_data;
              end
            end
            if(when_UsbOhci_l1378_3) begin
              if(when_UsbOhci_l206_7) begin
                ioDma_cmd_payload_fragment_data[63 : 48] = _zz_ioDma_cmd_payload_fragment_data;
              end
            end
            if(when_UsbOhci_l1378_4) begin
              if(when_UsbOhci_l206_8) begin
                ioDma_cmd_payload_fragment_data[15 : 0] = _zz_ioDma_cmd_payload_fragment_data;
              end
            end
            if(when_UsbOhci_l1378_5) begin
              if(when_UsbOhci_l206_9) begin
                ioDma_cmd_payload_fragment_data[31 : 16] = _zz_ioDma_cmd_payload_fragment_data;
              end
            end
            if(when_UsbOhci_l1378_6) begin
              if(when_UsbOhci_l206_10) begin
                ioDma_cmd_payload_fragment_data[47 : 32] = _zz_ioDma_cmd_payload_fragment_data;
              end
            end
            if(when_UsbOhci_l1378_7) begin
              if(when_UsbOhci_l206_11) begin
                ioDma_cmd_payload_fragment_data[63 : 48] = _zz_ioDma_cmd_payload_fragment_data;
              end
            end
          end
        end else begin
          if(when_UsbOhci_l206_12) begin
            ioDma_cmd_payload_fragment_data[31 : 24] = {{endpoint_TD_CC,endpoint_TD_EC},endpoint_TD_TNext};
          end
          if(endpoint_TD_upateCBP) begin
            if(when_UsbOhci_l206_13) begin
              ioDma_cmd_payload_fragment_data[63 : 32] = endpoint_tdUpdateAddress;
            end
          end
        end
        if(endpoint_TD_retire) begin
          if(when_UsbOhci_l206_14) begin
            ioDma_cmd_payload_fragment_data[31 : 0] = reg_hcDoneHead_DH_address;
          end
        end
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
        if(endpoint_TD_retire) begin
          if(when_UsbOhci_l206_15) begin
            ioDma_cmd_payload_fragment_data[31 : 0] = {{{endpoint_TD_nextTD,2'b00},endpoint_TD_dataPhaseNext},endpoint_ED_H};
          end
        end
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        ioDma_cmd_payload_fragment_data = fifo_io_pop_payload;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ioDma_cmd_payload_fragment_mask = 8'h00;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
        if(when_UsbOhci_l206) begin
          ioDma_cmd_payload_fragment_mask[3 : 0] = 4'b1111;
        end
        if(sof_doInterruptDelay) begin
          if(when_UsbOhci_l206_1) begin
            ioDma_cmd_payload_fragment_mask[7 : 4] = 4'b1111;
          end
        end
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
        if(endpoint_ED_F) begin
          if(endpoint_TD_isoOverrunReg) begin
            if(when_UsbOhci_l206_2) begin
              ioDma_cmd_payload_fragment_mask[3 : 3] = 1'b1;
            end
          end else begin
            if(endpoint_TD_isoLastReg) begin
              if(when_UsbOhci_l206_3) begin
                ioDma_cmd_payload_fragment_mask[3 : 3] = 1'b1;
              end
            end
            if(when_UsbOhci_l1378) begin
              if(when_UsbOhci_l206_4) begin
                ioDma_cmd_payload_fragment_mask[1 : 0] = 2'b11;
              end
            end
            if(when_UsbOhci_l1378_1) begin
              if(when_UsbOhci_l206_5) begin
                ioDma_cmd_payload_fragment_mask[3 : 2] = 2'b11;
              end
            end
            if(when_UsbOhci_l1378_2) begin
              if(when_UsbOhci_l206_6) begin
                ioDma_cmd_payload_fragment_mask[5 : 4] = 2'b11;
              end
            end
            if(when_UsbOhci_l1378_3) begin
              if(when_UsbOhci_l206_7) begin
                ioDma_cmd_payload_fragment_mask[7 : 6] = 2'b11;
              end
            end
            if(when_UsbOhci_l1378_4) begin
              if(when_UsbOhci_l206_8) begin
                ioDma_cmd_payload_fragment_mask[1 : 0] = 2'b11;
              end
            end
            if(when_UsbOhci_l1378_5) begin
              if(when_UsbOhci_l206_9) begin
                ioDma_cmd_payload_fragment_mask[3 : 2] = 2'b11;
              end
            end
            if(when_UsbOhci_l1378_6) begin
              if(when_UsbOhci_l206_10) begin
                ioDma_cmd_payload_fragment_mask[5 : 4] = 2'b11;
              end
            end
            if(when_UsbOhci_l1378_7) begin
              if(when_UsbOhci_l206_11) begin
                ioDma_cmd_payload_fragment_mask[7 : 6] = 2'b11;
              end
            end
          end
        end else begin
          if(when_UsbOhci_l206_12) begin
            ioDma_cmd_payload_fragment_mask[3 : 3] = 1'b1;
          end
          if(endpoint_TD_upateCBP) begin
            if(when_UsbOhci_l206_13) begin
              ioDma_cmd_payload_fragment_mask[7 : 4] = 4'b1111;
            end
          end
        end
        if(endpoint_TD_retire) begin
          if(when_UsbOhci_l206_14) begin
            ioDma_cmd_payload_fragment_mask[3 : 0] = 4'b1111;
          end
        end
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
        if(endpoint_TD_retire) begin
          if(when_UsbOhci_l206_15) begin
            ioDma_cmd_payload_fragment_mask[3 : 0] = 4'b1111;
          end
        end
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        ioDma_cmd_payload_fragment_mask = ((endpoint_dmaLogic_fullMask & (ioDma_cmd_payload_first ? endpoint_dmaLogic_headMask : endpoint_dmaLogic_fullMask)) & (ioDma_cmd_payload_last ? endpoint_dmaLogic_lastMask : endpoint_dmaLogic_fullMask));
      end
      default : begin
      end
    endcase
  end

  assign ioDma_rsp_ready = 1'b1;
  assign dmaRspMux_vec_0 = ioDma_rsp_payload_fragment_data[31 : 0];
  assign dmaRspMux_vec_1 = ioDma_rsp_payload_fragment_data[63 : 32];
  assign dmaRspMux_data = _zz_dmaRspMux_data;
  always @(*) begin
    fifo_io_push_valid = 1'b0;
    if(when_UsbOhci_l938) begin
      fifo_io_push_valid = 1'b1;
    end
    if(endpoint_dmaLogic_push) begin
      fifo_io_push_valid = 1'b1;
    end
  end

  always @(*) begin
    fifo_io_push_payload = 64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    if(when_UsbOhci_l938) begin
      fifo_io_push_payload = ioDma_rsp_payload_fragment_data;
    end
    if(endpoint_dmaLogic_push) begin
      fifo_io_push_payload = endpoint_dmaLogic_buffer;
    end
  end

  always @(*) begin
    fifo_io_pop_ready = 1'b0;
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
        if(dataTx_data_ready) begin
          if(when_UsbOhci_l1025) begin
            fifo_io_pop_ready = 1'b1;
          end
        end
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        if(ioDma_cmd_ready) begin
          fifo_io_pop_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    fifo_io_flush = 1'b0;
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
        fifo_io_flush = 1'b1;
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_phy_tx_valid = 1'b0;
    case(token_stateReg)
      token_enumDef_INIT : begin
      end
      token_enumDef_PID : begin
        io_phy_tx_valid = 1'b1;
      end
      token_enumDef_B1 : begin
        io_phy_tx_valid = 1'b1;
      end
      token_enumDef_B2 : begin
        io_phy_tx_valid = 1'b1;
      end
      token_enumDef_EOP : begin
      end
      default : begin
      end
    endcase
    case(dataTx_stateReg)
      dataTx_enumDef_PID : begin
        io_phy_tx_valid = 1'b1;
      end
      dataTx_enumDef_DATA : begin
        io_phy_tx_valid = 1'b1;
      end
      dataTx_enumDef_CRC_0 : begin
        io_phy_tx_valid = 1'b1;
      end
      dataTx_enumDef_CRC_1 : begin
        io_phy_tx_valid = 1'b1;
      end
      dataTx_enumDef_EOP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
        io_phy_tx_valid = 1'b1;
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_phy_tx_payload_fragment = 8'bxxxxxxxx;
    case(token_stateReg)
      token_enumDef_INIT : begin
      end
      token_enumDef_PID : begin
        io_phy_tx_payload_fragment = {(~ token_pid),token_pid};
      end
      token_enumDef_B1 : begin
        io_phy_tx_payload_fragment = token_data[7 : 0];
      end
      token_enumDef_B2 : begin
        io_phy_tx_payload_fragment = {token_crc5_io_result,token_data[10 : 8]};
      end
      token_enumDef_EOP : begin
      end
      default : begin
      end
    endcase
    case(dataTx_stateReg)
      dataTx_enumDef_PID : begin
        io_phy_tx_payload_fragment = {(~ dataTx_pid),dataTx_pid};
      end
      dataTx_enumDef_DATA : begin
        io_phy_tx_payload_fragment = dataTx_data_payload_fragment;
      end
      dataTx_enumDef_CRC_0 : begin
        io_phy_tx_payload_fragment = dataTx_crc16_io_result[7 : 0];
      end
      dataTx_enumDef_CRC_1 : begin
        io_phy_tx_payload_fragment = dataTx_crc16_io_result[15 : 8];
      end
      dataTx_enumDef_EOP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
        io_phy_tx_payload_fragment = 8'hd2;
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_phy_tx_payload_last = 1'bx;
    case(token_stateReg)
      token_enumDef_INIT : begin
      end
      token_enumDef_PID : begin
        io_phy_tx_payload_last = 1'b0;
      end
      token_enumDef_B1 : begin
        io_phy_tx_payload_last = 1'b0;
      end
      token_enumDef_B2 : begin
        io_phy_tx_payload_last = 1'b1;
      end
      token_enumDef_EOP : begin
      end
      default : begin
      end
    endcase
    case(dataTx_stateReg)
      dataTx_enumDef_PID : begin
        io_phy_tx_payload_last = 1'b0;
      end
      dataTx_enumDef_DATA : begin
        io_phy_tx_payload_last = 1'b0;
      end
      dataTx_enumDef_CRC_0 : begin
        io_phy_tx_payload_last = 1'b0;
      end
      dataTx_enumDef_CRC_1 : begin
        io_phy_tx_payload_last = 1'b1;
      end
      dataTx_enumDef_EOP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
        io_phy_tx_payload_last = 1'b1;
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ctrlHalt = 1'b0;
    case(hc_stateReg)
      hc_enumDef_RESET : begin
      end
      hc_enumDef_RESUME : begin
      end
      hc_enumDef_OPERATIONAL : begin
      end
      hc_enumDef_SUSPEND : begin
      end
      hc_enumDef_ANY_TO_RESET : begin
        ctrlHalt = 1'b1;
      end
      hc_enumDef_ANY_TO_SUSPEND : begin
        ctrlHalt = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign ctrl_readErrorFlag = 1'b0;
  assign ctrl_writeErrorFlag = 1'b0;
  assign ctrl_readHaltTrigger = 1'b0;
  always @(*) begin
    ctrl_writeHaltTrigger = 1'b0;
    if(ctrlHalt) begin
      ctrl_writeHaltTrigger = 1'b1;
    end
  end

  assign _zz_ctrl_rsp_ready = (! (ctrl_readHaltTrigger || ctrl_writeHaltTrigger));
  assign ctrl_rsp_ready = (_zz_ctrl_rsp_ready_1 && _zz_ctrl_rsp_ready);
  always @(*) begin
    _zz_ctrl_rsp_ready_1 = io_ctrl_rsp_ready;
    if(when_Stream_l369) begin
      _zz_ctrl_rsp_ready_1 = 1'b1;
    end
  end

  assign when_Stream_l369 = (! _zz_io_ctrl_rsp_valid);
  assign _zz_io_ctrl_rsp_valid = _zz_io_ctrl_rsp_valid_1;
  assign io_ctrl_rsp_valid = _zz_io_ctrl_rsp_valid;
  assign io_ctrl_rsp_payload_last = _zz_io_ctrl_rsp_payload_last;
  assign io_ctrl_rsp_payload_fragment_opcode = _zz_io_ctrl_rsp_payload_fragment_opcode;
  assign io_ctrl_rsp_payload_fragment_data = _zz_io_ctrl_rsp_payload_fragment_data;
  assign ctrl_askWrite = (io_ctrl_cmd_valid && (io_ctrl_cmd_payload_fragment_opcode == 1'b1));
  assign ctrl_askRead = (io_ctrl_cmd_valid && (io_ctrl_cmd_payload_fragment_opcode == 1'b0));
  assign io_ctrl_cmd_fire = (io_ctrl_cmd_valid && io_ctrl_cmd_ready);
  assign ctrl_doWrite = (io_ctrl_cmd_fire && (io_ctrl_cmd_payload_fragment_opcode == 1'b1));
  assign ctrl_doRead = (io_ctrl_cmd_fire && (io_ctrl_cmd_payload_fragment_opcode == 1'b0));
  assign ctrl_rsp_valid = io_ctrl_cmd_valid;
  assign io_ctrl_cmd_ready = ctrl_rsp_ready;
  assign ctrl_rsp_payload_last = 1'b1;
  assign when_BmbSlaveFactory_l33 = (ctrl_doWrite && ctrl_writeErrorFlag);
  always @(*) begin
    if(when_BmbSlaveFactory_l33) begin
      ctrl_rsp_payload_fragment_opcode = 1'b1;
    end else begin
      if(when_BmbSlaveFactory_l35) begin
        ctrl_rsp_payload_fragment_opcode = 1'b1;
      end else begin
        ctrl_rsp_payload_fragment_opcode = 1'b0;
      end
    end
  end

  assign when_BmbSlaveFactory_l35 = (ctrl_doRead && ctrl_readErrorFlag);
  always @(*) begin
    ctrl_rsp_payload_fragment_data = 32'h00000000;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h000 : begin
        ctrl_rsp_payload_fragment_data[4 : 0] = reg_hcRevision_REV;
      end
      12'h004 : begin
        ctrl_rsp_payload_fragment_data[1 : 0] = reg_hcControl_CBSR;
        ctrl_rsp_payload_fragment_data[2 : 2] = reg_hcControl_PLE;
        ctrl_rsp_payload_fragment_data[3 : 3] = reg_hcControl_IE;
        ctrl_rsp_payload_fragment_data[4 : 4] = reg_hcControl_CLE;
        ctrl_rsp_payload_fragment_data[5 : 5] = reg_hcControl_BLE;
        ctrl_rsp_payload_fragment_data[7 : 6] = reg_hcControl_HCFS;
        ctrl_rsp_payload_fragment_data[8 : 8] = reg_hcControl_IR;
        ctrl_rsp_payload_fragment_data[9 : 9] = reg_hcControl_RWC;
        ctrl_rsp_payload_fragment_data[10 : 10] = reg_hcControl_RWE;
      end
      12'h008 : begin
        ctrl_rsp_payload_fragment_data[0 : 0] = doSoftReset;
        ctrl_rsp_payload_fragment_data[1 : 1] = reg_hcCommandStatus_CLF;
        ctrl_rsp_payload_fragment_data[2 : 2] = reg_hcCommandStatus_BLF;
        ctrl_rsp_payload_fragment_data[3 : 3] = reg_hcCommandStatus_OCR;
        ctrl_rsp_payload_fragment_data[17 : 16] = reg_hcCommandStatus_SOC;
      end
      12'h010 : begin
        ctrl_rsp_payload_fragment_data[31 : 31] = reg_hcInterrupt_MIE;
        ctrl_rsp_payload_fragment_data[0 : 0] = reg_hcInterrupt_SO_enable;
        ctrl_rsp_payload_fragment_data[1 : 1] = reg_hcInterrupt_WDH_enable;
        ctrl_rsp_payload_fragment_data[2 : 2] = reg_hcInterrupt_SF_enable;
        ctrl_rsp_payload_fragment_data[3 : 3] = reg_hcInterrupt_RD_enable;
        ctrl_rsp_payload_fragment_data[4 : 4] = reg_hcInterrupt_UE_enable;
        ctrl_rsp_payload_fragment_data[5 : 5] = reg_hcInterrupt_FNO_enable;
        ctrl_rsp_payload_fragment_data[6 : 6] = reg_hcInterrupt_RHSC_enable;
        ctrl_rsp_payload_fragment_data[30 : 30] = reg_hcInterrupt_OC_enable;
      end
      12'h014 : begin
        ctrl_rsp_payload_fragment_data[31 : 31] = reg_hcInterrupt_MIE;
        ctrl_rsp_payload_fragment_data[0 : 0] = reg_hcInterrupt_SO_enable;
        ctrl_rsp_payload_fragment_data[1 : 1] = reg_hcInterrupt_WDH_enable;
        ctrl_rsp_payload_fragment_data[2 : 2] = reg_hcInterrupt_SF_enable;
        ctrl_rsp_payload_fragment_data[3 : 3] = reg_hcInterrupt_RD_enable;
        ctrl_rsp_payload_fragment_data[4 : 4] = reg_hcInterrupt_UE_enable;
        ctrl_rsp_payload_fragment_data[5 : 5] = reg_hcInterrupt_FNO_enable;
        ctrl_rsp_payload_fragment_data[6 : 6] = reg_hcInterrupt_RHSC_enable;
        ctrl_rsp_payload_fragment_data[30 : 30] = reg_hcInterrupt_OC_enable;
      end
      12'h00c : begin
        ctrl_rsp_payload_fragment_data[0 : 0] = reg_hcInterrupt_SO_status;
        ctrl_rsp_payload_fragment_data[1 : 1] = reg_hcInterrupt_WDH_status;
        ctrl_rsp_payload_fragment_data[2 : 2] = reg_hcInterrupt_SF_status;
        ctrl_rsp_payload_fragment_data[3 : 3] = reg_hcInterrupt_RD_status;
        ctrl_rsp_payload_fragment_data[4 : 4] = reg_hcInterrupt_UE_status;
        ctrl_rsp_payload_fragment_data[5 : 5] = reg_hcInterrupt_FNO_status;
        ctrl_rsp_payload_fragment_data[6 : 6] = reg_hcInterrupt_RHSC_status;
        ctrl_rsp_payload_fragment_data[30 : 30] = reg_hcInterrupt_OC_status;
      end
      12'h018 : begin
        ctrl_rsp_payload_fragment_data[31 : 8] = reg_hcHCCA_HCCA_reg;
      end
      12'h01c : begin
        ctrl_rsp_payload_fragment_data[31 : 4] = reg_hcPeriodCurrentED_PCED_reg;
      end
      12'h020 : begin
        ctrl_rsp_payload_fragment_data[31 : 4] = reg_hcControlHeadED_CHED_reg;
      end
      12'h024 : begin
        ctrl_rsp_payload_fragment_data[31 : 4] = reg_hcControlCurrentED_CCED_reg;
      end
      12'h028 : begin
        ctrl_rsp_payload_fragment_data[31 : 4] = reg_hcBulkHeadED_BHED_reg;
      end
      12'h02c : begin
        ctrl_rsp_payload_fragment_data[31 : 4] = reg_hcBulkCurrentED_BCED_reg;
      end
      12'h030 : begin
        ctrl_rsp_payload_fragment_data[31 : 4] = reg_hcDoneHead_DH_reg;
      end
      12'h034 : begin
        ctrl_rsp_payload_fragment_data[13 : 0] = reg_hcFmInterval_FI;
        ctrl_rsp_payload_fragment_data[30 : 16] = reg_hcFmInterval_FSMPS;
        ctrl_rsp_payload_fragment_data[31 : 31] = reg_hcFmInterval_FIT;
      end
      12'h038 : begin
        ctrl_rsp_payload_fragment_data[13 : 0] = reg_hcFmRemaining_FR;
        ctrl_rsp_payload_fragment_data[31 : 31] = reg_hcFmRemaining_FRT;
      end
      12'h03c : begin
        ctrl_rsp_payload_fragment_data[15 : 0] = reg_hcFmNumber_FN;
      end
      12'h040 : begin
        ctrl_rsp_payload_fragment_data[13 : 0] = reg_hcPeriodicStart_PS;
      end
      12'h044 : begin
        ctrl_rsp_payload_fragment_data[11 : 0] = reg_hcLSThreshold_LST;
      end
      12'h048 : begin
        ctrl_rsp_payload_fragment_data[7 : 0] = reg_hcRhDescriptorA_NDP;
        ctrl_rsp_payload_fragment_data[8 : 8] = reg_hcRhDescriptorA_PSM;
        ctrl_rsp_payload_fragment_data[9 : 9] = reg_hcRhDescriptorA_NPS;
        ctrl_rsp_payload_fragment_data[11 : 11] = reg_hcRhDescriptorA_OCPM;
        ctrl_rsp_payload_fragment_data[12 : 12] = reg_hcRhDescriptorA_NOCP;
        ctrl_rsp_payload_fragment_data[31 : 24] = reg_hcRhDescriptorA_POTPGT;
      end
      12'h04c : begin
        ctrl_rsp_payload_fragment_data[4 : 1] = reg_hcRhDescriptorB_DR;
        ctrl_rsp_payload_fragment_data[20 : 17] = reg_hcRhDescriptorB_PPCM;
      end
      12'h050 : begin
        ctrl_rsp_payload_fragment_data[1 : 1] = io_phy_overcurrent;
        ctrl_rsp_payload_fragment_data[15 : 15] = reg_hcRhStatus_DRWE;
        ctrl_rsp_payload_fragment_data[17 : 17] = reg_hcRhStatus_CCIC;
      end
      12'h054 : begin
        ctrl_rsp_payload_fragment_data[2 : 2] = reg_hcRhPortStatus_0_PSS;
        ctrl_rsp_payload_fragment_data[8 : 8] = reg_hcRhPortStatus_0_PPS;
        ctrl_rsp_payload_fragment_data[0 : 0] = reg_hcRhPortStatus_0_CCS;
        ctrl_rsp_payload_fragment_data[1 : 1] = reg_hcRhPortStatus_0_PES;
        ctrl_rsp_payload_fragment_data[3 : 3] = io_phy_ports_0_overcurrent;
        ctrl_rsp_payload_fragment_data[4 : 4] = reg_hcRhPortStatus_0_reset;
        ctrl_rsp_payload_fragment_data[9 : 9] = io_phy_ports_0_lowSpeed;
        ctrl_rsp_payload_fragment_data[16 : 16] = reg_hcRhPortStatus_0_CSC_reg;
        ctrl_rsp_payload_fragment_data[17 : 17] = reg_hcRhPortStatus_0_PESC_reg;
        ctrl_rsp_payload_fragment_data[18 : 18] = reg_hcRhPortStatus_0_PSSC_reg;
        ctrl_rsp_payload_fragment_data[19 : 19] = reg_hcRhPortStatus_0_OCIC_reg;
        ctrl_rsp_payload_fragment_data[20 : 20] = reg_hcRhPortStatus_0_PRSC_reg;
      end
      12'h058 : begin
        ctrl_rsp_payload_fragment_data[2 : 2] = reg_hcRhPortStatus_1_PSS;
        ctrl_rsp_payload_fragment_data[8 : 8] = reg_hcRhPortStatus_1_PPS;
        ctrl_rsp_payload_fragment_data[0 : 0] = reg_hcRhPortStatus_1_CCS;
        ctrl_rsp_payload_fragment_data[1 : 1] = reg_hcRhPortStatus_1_PES;
        ctrl_rsp_payload_fragment_data[3 : 3] = io_phy_ports_1_overcurrent;
        ctrl_rsp_payload_fragment_data[4 : 4] = reg_hcRhPortStatus_1_reset;
        ctrl_rsp_payload_fragment_data[9 : 9] = io_phy_ports_1_lowSpeed;
        ctrl_rsp_payload_fragment_data[16 : 16] = reg_hcRhPortStatus_1_CSC_reg;
        ctrl_rsp_payload_fragment_data[17 : 17] = reg_hcRhPortStatus_1_PESC_reg;
        ctrl_rsp_payload_fragment_data[18 : 18] = reg_hcRhPortStatus_1_PSSC_reg;
        ctrl_rsp_payload_fragment_data[19 : 19] = reg_hcRhPortStatus_1_OCIC_reg;
        ctrl_rsp_payload_fragment_data[20 : 20] = reg_hcRhPortStatus_1_PRSC_reg;
      end
      12'h05c : begin
        ctrl_rsp_payload_fragment_data[2 : 2] = reg_hcRhPortStatus_2_PSS;
        ctrl_rsp_payload_fragment_data[8 : 8] = reg_hcRhPortStatus_2_PPS;
        ctrl_rsp_payload_fragment_data[0 : 0] = reg_hcRhPortStatus_2_CCS;
        ctrl_rsp_payload_fragment_data[1 : 1] = reg_hcRhPortStatus_2_PES;
        ctrl_rsp_payload_fragment_data[3 : 3] = io_phy_ports_2_overcurrent;
        ctrl_rsp_payload_fragment_data[4 : 4] = reg_hcRhPortStatus_2_reset;
        ctrl_rsp_payload_fragment_data[9 : 9] = io_phy_ports_2_lowSpeed;
        ctrl_rsp_payload_fragment_data[16 : 16] = reg_hcRhPortStatus_2_CSC_reg;
        ctrl_rsp_payload_fragment_data[17 : 17] = reg_hcRhPortStatus_2_PESC_reg;
        ctrl_rsp_payload_fragment_data[18 : 18] = reg_hcRhPortStatus_2_PSSC_reg;
        ctrl_rsp_payload_fragment_data[19 : 19] = reg_hcRhPortStatus_2_OCIC_reg;
        ctrl_rsp_payload_fragment_data[20 : 20] = reg_hcRhPortStatus_2_PRSC_reg;
      end
      12'h060 : begin
        ctrl_rsp_payload_fragment_data[2 : 2] = reg_hcRhPortStatus_3_PSS;
        ctrl_rsp_payload_fragment_data[8 : 8] = reg_hcRhPortStatus_3_PPS;
        ctrl_rsp_payload_fragment_data[0 : 0] = reg_hcRhPortStatus_3_CCS;
        ctrl_rsp_payload_fragment_data[1 : 1] = reg_hcRhPortStatus_3_PES;
        ctrl_rsp_payload_fragment_data[3 : 3] = io_phy_ports_3_overcurrent;
        ctrl_rsp_payload_fragment_data[4 : 4] = reg_hcRhPortStatus_3_reset;
        ctrl_rsp_payload_fragment_data[9 : 9] = io_phy_ports_3_lowSpeed;
        ctrl_rsp_payload_fragment_data[16 : 16] = reg_hcRhPortStatus_3_CSC_reg;
        ctrl_rsp_payload_fragment_data[17 : 17] = reg_hcRhPortStatus_3_PESC_reg;
        ctrl_rsp_payload_fragment_data[18 : 18] = reg_hcRhPortStatus_3_PSSC_reg;
        ctrl_rsp_payload_fragment_data[19 : 19] = reg_hcRhPortStatus_3_OCIC_reg;
        ctrl_rsp_payload_fragment_data[20 : 20] = reg_hcRhPortStatus_3_PRSC_reg;
      end
      default : begin
      end
    endcase
  end

  assign when_UsbOhci_l236 = (! doUnschedule);
  assign reg_hcRevision_REV = 5'h10;
  always @(*) begin
    reg_hcControl_HCFSWrite_valid = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h004 : begin
        if(ctrl_doWrite) begin
          reg_hcControl_HCFSWrite_valid = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    reg_hcCommandStatus_startSoftReset = 1'b0;
    if(when_BusSlaveFactory_l377) begin
      if(when_BusSlaveFactory_l379) begin
        reg_hcCommandStatus_startSoftReset = _zz_reg_hcCommandStatus_startSoftReset[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h008 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379 = io_ctrl_cmd_payload_fragment_data[0];
  always @(*) begin
    when_BusSlaveFactory_l377_1 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h008 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_1 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_1 = io_ctrl_cmd_payload_fragment_data[1];
  always @(*) begin
    when_BusSlaveFactory_l377_2 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h008 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_2 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_2 = io_ctrl_cmd_payload_fragment_data[2];
  always @(*) begin
    when_BusSlaveFactory_l377_3 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h008 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_3 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_3 = io_ctrl_cmd_payload_fragment_data[3];
  always @(*) begin
    reg_hcInterrupt_unmaskedPending = 1'b0;
    if(when_UsbOhci_l302) begin
      reg_hcInterrupt_unmaskedPending = 1'b1;
    end
    if(when_UsbOhci_l302_1) begin
      reg_hcInterrupt_unmaskedPending = 1'b1;
    end
    if(when_UsbOhci_l302_2) begin
      reg_hcInterrupt_unmaskedPending = 1'b1;
    end
    if(when_UsbOhci_l302_3) begin
      reg_hcInterrupt_unmaskedPending = 1'b1;
    end
    if(when_UsbOhci_l302_4) begin
      reg_hcInterrupt_unmaskedPending = 1'b1;
    end
    if(when_UsbOhci_l302_5) begin
      reg_hcInterrupt_unmaskedPending = 1'b1;
    end
    if(when_UsbOhci_l302_6) begin
      reg_hcInterrupt_unmaskedPending = 1'b1;
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_4 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h010 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_4 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_4 = io_ctrl_cmd_payload_fragment_data[31];
  always @(*) begin
    when_BusSlaveFactory_l341 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h014 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347 = io_ctrl_cmd_payload_fragment_data[31];
  always @(*) begin
    when_BusSlaveFactory_l341_1 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h00c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_1 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_1 = io_ctrl_cmd_payload_fragment_data[0];
  always @(*) begin
    when_BusSlaveFactory_l377_5 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h010 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_5 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_5 = io_ctrl_cmd_payload_fragment_data[0];
  always @(*) begin
    when_BusSlaveFactory_l341_2 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h014 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_2 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_2 = io_ctrl_cmd_payload_fragment_data[0];
  assign when_UsbOhci_l302 = (reg_hcInterrupt_SO_status && reg_hcInterrupt_SO_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_3 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h00c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_3 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_3 = io_ctrl_cmd_payload_fragment_data[1];
  always @(*) begin
    when_BusSlaveFactory_l377_6 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h010 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_6 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_6 = io_ctrl_cmd_payload_fragment_data[1];
  always @(*) begin
    when_BusSlaveFactory_l341_4 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h014 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_4 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_4 = io_ctrl_cmd_payload_fragment_data[1];
  assign when_UsbOhci_l302_1 = (reg_hcInterrupt_WDH_status && reg_hcInterrupt_WDH_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_5 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h00c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_5 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_5 = io_ctrl_cmd_payload_fragment_data[2];
  always @(*) begin
    when_BusSlaveFactory_l377_7 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h010 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_7 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_7 = io_ctrl_cmd_payload_fragment_data[2];
  always @(*) begin
    when_BusSlaveFactory_l341_6 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h014 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_6 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_6 = io_ctrl_cmd_payload_fragment_data[2];
  assign when_UsbOhci_l302_2 = (reg_hcInterrupt_SF_status && reg_hcInterrupt_SF_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_7 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h00c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_7 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_7 = io_ctrl_cmd_payload_fragment_data[3];
  always @(*) begin
    when_BusSlaveFactory_l377_8 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h010 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_8 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_8 = io_ctrl_cmd_payload_fragment_data[3];
  always @(*) begin
    when_BusSlaveFactory_l341_8 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h014 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_8 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_8 = io_ctrl_cmd_payload_fragment_data[3];
  assign when_UsbOhci_l302_3 = (reg_hcInterrupt_RD_status && reg_hcInterrupt_RD_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_9 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h00c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_9 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_9 = io_ctrl_cmd_payload_fragment_data[4];
  always @(*) begin
    when_BusSlaveFactory_l377_9 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h010 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_9 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_9 = io_ctrl_cmd_payload_fragment_data[4];
  always @(*) begin
    when_BusSlaveFactory_l341_10 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h014 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_10 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_10 = io_ctrl_cmd_payload_fragment_data[4];
  assign when_UsbOhci_l302_4 = (reg_hcInterrupt_UE_status && reg_hcInterrupt_UE_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_11 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h00c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_11 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_11 = io_ctrl_cmd_payload_fragment_data[5];
  always @(*) begin
    when_BusSlaveFactory_l377_10 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h010 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_10 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_10 = io_ctrl_cmd_payload_fragment_data[5];
  always @(*) begin
    when_BusSlaveFactory_l341_12 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h014 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_12 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_12 = io_ctrl_cmd_payload_fragment_data[5];
  assign when_UsbOhci_l302_5 = (reg_hcInterrupt_FNO_status && reg_hcInterrupt_FNO_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_13 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h00c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_13 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_13 = io_ctrl_cmd_payload_fragment_data[6];
  always @(*) begin
    when_BusSlaveFactory_l377_11 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h010 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_11 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_11 = io_ctrl_cmd_payload_fragment_data[6];
  always @(*) begin
    when_BusSlaveFactory_l341_14 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h014 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_14 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_14 = io_ctrl_cmd_payload_fragment_data[6];
  assign when_UsbOhci_l302_6 = (reg_hcInterrupt_RHSC_status && reg_hcInterrupt_RHSC_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_15 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h00c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_15 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_15 = io_ctrl_cmd_payload_fragment_data[30];
  always @(*) begin
    when_BusSlaveFactory_l377_12 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h010 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_12 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_12 = io_ctrl_cmd_payload_fragment_data[30];
  always @(*) begin
    when_BusSlaveFactory_l341_16 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h014 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_16 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_16 = io_ctrl_cmd_payload_fragment_data[30];
  assign reg_hcInterrupt_doIrq = (reg_hcInterrupt_unmaskedPending && reg_hcInterrupt_MIE);
  assign io_interrupt = (reg_hcInterrupt_doIrq && (! reg_hcControl_IR));
  assign io_interruptBios = ((reg_hcInterrupt_doIrq && reg_hcControl_IR) || (reg_hcInterrupt_OC_status && reg_hcInterrupt_OC_enable));
  assign reg_hcHCCA_HCCA_address = {reg_hcHCCA_HCCA_reg,8'h00};
  assign reg_hcPeriodCurrentED_PCED_address = {reg_hcPeriodCurrentED_PCED_reg,4'b0000};
  assign reg_hcPeriodCurrentED_isZero = (reg_hcPeriodCurrentED_PCED_reg == 28'h0000000);
  assign reg_hcControlHeadED_CHED_address = {reg_hcControlHeadED_CHED_reg,4'b0000};
  assign reg_hcControlCurrentED_CCED_address = {reg_hcControlCurrentED_CCED_reg,4'b0000};
  assign reg_hcControlCurrentED_isZero = (reg_hcControlCurrentED_CCED_reg == 28'h0000000);
  assign reg_hcBulkHeadED_BHED_address = {reg_hcBulkHeadED_BHED_reg,4'b0000};
  assign reg_hcBulkCurrentED_BCED_address = {reg_hcBulkCurrentED_BCED_reg,4'b0000};
  assign reg_hcBulkCurrentED_isZero = (reg_hcBulkCurrentED_BCED_reg == 28'h0000000);
  assign reg_hcDoneHead_DH_address = {reg_hcDoneHead_DH_reg,4'b0000};
  assign reg_hcFmNumber_FNp1 = (reg_hcFmNumber_FN + 16'h0001);
  assign reg_hcLSThreshold_hit = (reg_hcFmRemaining_FR < _zz_reg_hcLSThreshold_hit);
  assign reg_hcRhDescriptorA_NDP = 8'h04;
  always @(*) begin
    when_BusSlaveFactory_l341_17 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h050 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l341_17 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_17 = io_ctrl_cmd_payload_fragment_data[17];
  assign when_UsbOhci_l409 = (io_phy_overcurrent ^ io_phy_overcurrent_regNext);
  always @(*) begin
    reg_hcRhStatus_clearGlobalPower = 1'b0;
    if(when_BusSlaveFactory_l377_13) begin
      if(when_BusSlaveFactory_l379_13) begin
        reg_hcRhStatus_clearGlobalPower = _zz_reg_hcRhStatus_clearGlobalPower[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_13 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h050 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_13 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_13 = io_ctrl_cmd_payload_fragment_data[0];
  always @(*) begin
    reg_hcRhStatus_setRemoteWakeupEnable = 1'b0;
    if(when_BusSlaveFactory_l377_14) begin
      if(when_BusSlaveFactory_l379_14) begin
        reg_hcRhStatus_setRemoteWakeupEnable = _zz_reg_hcRhStatus_setRemoteWakeupEnable[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_14 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h050 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_14 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_14 = io_ctrl_cmd_payload_fragment_data[15];
  always @(*) begin
    reg_hcRhStatus_setGlobalPower = 1'b0;
    if(when_BusSlaveFactory_l377_15) begin
      if(when_BusSlaveFactory_l379_15) begin
        reg_hcRhStatus_setGlobalPower = _zz_reg_hcRhStatus_setGlobalPower[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_15 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h050 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_15 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_15 = io_ctrl_cmd_payload_fragment_data[16];
  always @(*) begin
    reg_hcRhStatus_clearRemoteWakeupEnable = 1'b0;
    if(when_BusSlaveFactory_l377_16) begin
      if(when_BusSlaveFactory_l379_16) begin
        reg_hcRhStatus_clearRemoteWakeupEnable = _zz_reg_hcRhStatus_clearRemoteWakeupEnable[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_16 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h050 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_16 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_16 = io_ctrl_cmd_payload_fragment_data[31];
  always @(*) begin
    reg_hcRhPortStatus_0_clearPortEnable = 1'b0;
    if(when_BusSlaveFactory_l377_17) begin
      if(when_BusSlaveFactory_l379_17) begin
        reg_hcRhPortStatus_0_clearPortEnable = _zz_reg_hcRhPortStatus_0_clearPortEnable[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_17 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_17 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_17 = io_ctrl_cmd_payload_fragment_data[0];
  always @(*) begin
    reg_hcRhPortStatus_0_setPortEnable = 1'b0;
    if(when_BusSlaveFactory_l377_18) begin
      if(when_BusSlaveFactory_l379_18) begin
        reg_hcRhPortStatus_0_setPortEnable = _zz_reg_hcRhPortStatus_0_setPortEnable[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_18 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_18 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_18 = io_ctrl_cmd_payload_fragment_data[1];
  always @(*) begin
    reg_hcRhPortStatus_0_setPortSuspend = 1'b0;
    if(when_BusSlaveFactory_l377_19) begin
      if(when_BusSlaveFactory_l379_19) begin
        reg_hcRhPortStatus_0_setPortSuspend = _zz_reg_hcRhPortStatus_0_setPortSuspend[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_19 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_19 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_19 = io_ctrl_cmd_payload_fragment_data[2];
  always @(*) begin
    reg_hcRhPortStatus_0_clearSuspendStatus = 1'b0;
    if(when_BusSlaveFactory_l377_20) begin
      if(when_BusSlaveFactory_l379_20) begin
        reg_hcRhPortStatus_0_clearSuspendStatus = _zz_reg_hcRhPortStatus_0_clearSuspendStatus[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_20 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_20 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_20 = io_ctrl_cmd_payload_fragment_data[3];
  always @(*) begin
    reg_hcRhPortStatus_0_setPortReset = 1'b0;
    if(when_BusSlaveFactory_l377_21) begin
      if(when_BusSlaveFactory_l379_21) begin
        reg_hcRhPortStatus_0_setPortReset = _zz_reg_hcRhPortStatus_0_setPortReset[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_21 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_21 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_21 = io_ctrl_cmd_payload_fragment_data[4];
  always @(*) begin
    reg_hcRhPortStatus_0_setPortPower = 1'b0;
    if(when_BusSlaveFactory_l377_22) begin
      if(when_BusSlaveFactory_l379_22) begin
        reg_hcRhPortStatus_0_setPortPower = _zz_reg_hcRhPortStatus_0_setPortPower[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_22 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_22 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_22 = io_ctrl_cmd_payload_fragment_data[8];
  always @(*) begin
    reg_hcRhPortStatus_0_clearPortPower = 1'b0;
    if(when_BusSlaveFactory_l377_23) begin
      if(when_BusSlaveFactory_l379_23) begin
        reg_hcRhPortStatus_0_clearPortPower = _zz_reg_hcRhPortStatus_0_clearPortPower[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_23 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_23 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_23 = io_ctrl_cmd_payload_fragment_data[9];
  assign reg_hcRhPortStatus_0_CCS = ((reg_hcRhPortStatus_0_connected || reg_hcRhDescriptorB_DR[0]) && reg_hcRhPortStatus_0_PPS);
  always @(*) begin
    reg_hcRhPortStatus_0_CSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_24) begin
      if(when_BusSlaveFactory_l379_24) begin
        reg_hcRhPortStatus_0_CSC_clear = _zz_reg_hcRhPortStatus_0_CSC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_24 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_24 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_24 = io_ctrl_cmd_payload_fragment_data[16];
  always @(*) begin
    reg_hcRhPortStatus_0_PESC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_25) begin
      if(when_BusSlaveFactory_l379_25) begin
        reg_hcRhPortStatus_0_PESC_clear = _zz_reg_hcRhPortStatus_0_PESC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_25 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_25 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_25 = io_ctrl_cmd_payload_fragment_data[17];
  always @(*) begin
    reg_hcRhPortStatus_0_PSSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_26) begin
      if(when_BusSlaveFactory_l379_26) begin
        reg_hcRhPortStatus_0_PSSC_clear = _zz_reg_hcRhPortStatus_0_PSSC_clear[0];
      end
    end
    if(reg_hcRhPortStatus_0_PRSC_set) begin
      reg_hcRhPortStatus_0_PSSC_clear = 1'b1;
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_26 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_26 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_26 = io_ctrl_cmd_payload_fragment_data[18];
  always @(*) begin
    reg_hcRhPortStatus_0_OCIC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_27) begin
      if(when_BusSlaveFactory_l379_27) begin
        reg_hcRhPortStatus_0_OCIC_clear = _zz_reg_hcRhPortStatus_0_OCIC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_27 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_27 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_27 = io_ctrl_cmd_payload_fragment_data[19];
  always @(*) begin
    reg_hcRhPortStatus_0_PRSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_28) begin
      if(when_BusSlaveFactory_l379_28) begin
        reg_hcRhPortStatus_0_PRSC_clear = _zz_reg_hcRhPortStatus_0_PRSC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_28 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_28 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_28 = io_ctrl_cmd_payload_fragment_data[20];
  assign when_UsbOhci_l460 = ((reg_hcRhPortStatus_0_clearPortEnable || reg_hcRhPortStatus_0_PESC_set) || (! reg_hcRhPortStatus_0_PPS));
  assign when_UsbOhci_l460_1 = (reg_hcRhPortStatus_0_PRSC_set || reg_hcRhPortStatus_0_PSSC_set);
  assign when_UsbOhci_l460_2 = (reg_hcRhPortStatus_0_setPortEnable && reg_hcRhPortStatus_0_CCS);
  assign when_UsbOhci_l461 = (((reg_hcRhPortStatus_0_PSSC_set || reg_hcRhPortStatus_0_PRSC_set) || (! reg_hcRhPortStatus_0_PPS)) || (reg_hcControl_HCFS == MainState_RESUME));
  assign when_UsbOhci_l461_1 = (reg_hcRhPortStatus_0_setPortSuspend && reg_hcRhPortStatus_0_CCS);
  assign when_UsbOhci_l462 = (reg_hcRhPortStatus_0_setPortSuspend && reg_hcRhPortStatus_0_CCS);
  assign when_UsbOhci_l463 = (reg_hcRhPortStatus_0_clearSuspendStatus && reg_hcRhPortStatus_0_PSS);
  assign when_UsbOhci_l464 = (reg_hcRhPortStatus_0_setPortReset && reg_hcRhPortStatus_0_CCS);
  assign when_UsbOhci_l470 = reg_hcRhDescriptorB_PPCM[0];
  assign reg_hcRhPortStatus_0_CSC_set = ((((reg_hcRhPortStatus_0_CCS ^ reg_hcRhPortStatus_0_CCS_regNext) || (reg_hcRhPortStatus_0_setPortEnable && (! reg_hcRhPortStatus_0_CCS))) || (reg_hcRhPortStatus_0_setPortSuspend && (! reg_hcRhPortStatus_0_CCS))) || (reg_hcRhPortStatus_0_setPortReset && (! reg_hcRhPortStatus_0_CCS)));
  assign reg_hcRhPortStatus_0_PESC_set = io_phy_ports_0_overcurrent;
  assign io_phy_ports_0_suspend_fire = (io_phy_ports_0_suspend_valid && io_phy_ports_0_suspend_ready);
  assign reg_hcRhPortStatus_0_PSSC_set = (io_phy_ports_0_suspend_fire || io_phy_ports_0_remoteResume);
  assign reg_hcRhPortStatus_0_OCIC_set = io_phy_ports_0_overcurrent;
  assign io_phy_ports_0_reset_fire = (io_phy_ports_0_reset_valid && io_phy_ports_0_reset_ready);
  assign reg_hcRhPortStatus_0_PRSC_set = io_phy_ports_0_reset_fire;
  assign io_phy_ports_0_disable_valid = reg_hcRhPortStatus_0_clearPortEnable;
  assign io_phy_ports_0_removable = reg_hcRhDescriptorB_DR[0];
  assign io_phy_ports_0_power = reg_hcRhPortStatus_0_PPS;
  assign io_phy_ports_0_resume_valid = reg_hcRhPortStatus_0_resume;
  assign io_phy_ports_0_resume_fire = (io_phy_ports_0_resume_valid && io_phy_ports_0_resume_ready);
  assign io_phy_ports_0_reset_valid = reg_hcRhPortStatus_0_reset;
  assign io_phy_ports_0_suspend_valid = reg_hcRhPortStatus_0_suspend;
  always @(*) begin
    reg_hcRhPortStatus_1_clearPortEnable = 1'b0;
    if(when_BusSlaveFactory_l377_29) begin
      if(when_BusSlaveFactory_l379_29) begin
        reg_hcRhPortStatus_1_clearPortEnable = _zz_reg_hcRhPortStatus_1_clearPortEnable[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_29 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_29 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_29 = io_ctrl_cmd_payload_fragment_data[0];
  always @(*) begin
    reg_hcRhPortStatus_1_setPortEnable = 1'b0;
    if(when_BusSlaveFactory_l377_30) begin
      if(when_BusSlaveFactory_l379_30) begin
        reg_hcRhPortStatus_1_setPortEnable = _zz_reg_hcRhPortStatus_1_setPortEnable[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_30 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_30 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_30 = io_ctrl_cmd_payload_fragment_data[1];
  always @(*) begin
    reg_hcRhPortStatus_1_setPortSuspend = 1'b0;
    if(when_BusSlaveFactory_l377_31) begin
      if(when_BusSlaveFactory_l379_31) begin
        reg_hcRhPortStatus_1_setPortSuspend = _zz_reg_hcRhPortStatus_1_setPortSuspend[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_31 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_31 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_31 = io_ctrl_cmd_payload_fragment_data[2];
  always @(*) begin
    reg_hcRhPortStatus_1_clearSuspendStatus = 1'b0;
    if(when_BusSlaveFactory_l377_32) begin
      if(when_BusSlaveFactory_l379_32) begin
        reg_hcRhPortStatus_1_clearSuspendStatus = _zz_reg_hcRhPortStatus_1_clearSuspendStatus[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_32 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_32 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_32 = io_ctrl_cmd_payload_fragment_data[3];
  always @(*) begin
    reg_hcRhPortStatus_1_setPortReset = 1'b0;
    if(when_BusSlaveFactory_l377_33) begin
      if(when_BusSlaveFactory_l379_33) begin
        reg_hcRhPortStatus_1_setPortReset = _zz_reg_hcRhPortStatus_1_setPortReset[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_33 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_33 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_33 = io_ctrl_cmd_payload_fragment_data[4];
  always @(*) begin
    reg_hcRhPortStatus_1_setPortPower = 1'b0;
    if(when_BusSlaveFactory_l377_34) begin
      if(when_BusSlaveFactory_l379_34) begin
        reg_hcRhPortStatus_1_setPortPower = _zz_reg_hcRhPortStatus_1_setPortPower[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_34 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_34 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_34 = io_ctrl_cmd_payload_fragment_data[8];
  always @(*) begin
    reg_hcRhPortStatus_1_clearPortPower = 1'b0;
    if(when_BusSlaveFactory_l377_35) begin
      if(when_BusSlaveFactory_l379_35) begin
        reg_hcRhPortStatus_1_clearPortPower = _zz_reg_hcRhPortStatus_1_clearPortPower[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_35 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_35 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_35 = io_ctrl_cmd_payload_fragment_data[9];
  assign reg_hcRhPortStatus_1_CCS = ((reg_hcRhPortStatus_1_connected || reg_hcRhDescriptorB_DR[1]) && reg_hcRhPortStatus_1_PPS);
  always @(*) begin
    reg_hcRhPortStatus_1_CSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_36) begin
      if(when_BusSlaveFactory_l379_36) begin
        reg_hcRhPortStatus_1_CSC_clear = _zz_reg_hcRhPortStatus_1_CSC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_36 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_36 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_36 = io_ctrl_cmd_payload_fragment_data[16];
  always @(*) begin
    reg_hcRhPortStatus_1_PESC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_37) begin
      if(when_BusSlaveFactory_l379_37) begin
        reg_hcRhPortStatus_1_PESC_clear = _zz_reg_hcRhPortStatus_1_PESC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_37 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_37 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_37 = io_ctrl_cmd_payload_fragment_data[17];
  always @(*) begin
    reg_hcRhPortStatus_1_PSSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_38) begin
      if(when_BusSlaveFactory_l379_38) begin
        reg_hcRhPortStatus_1_PSSC_clear = _zz_reg_hcRhPortStatus_1_PSSC_clear[0];
      end
    end
    if(reg_hcRhPortStatus_1_PRSC_set) begin
      reg_hcRhPortStatus_1_PSSC_clear = 1'b1;
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_38 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_38 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_38 = io_ctrl_cmd_payload_fragment_data[18];
  always @(*) begin
    reg_hcRhPortStatus_1_OCIC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_39) begin
      if(when_BusSlaveFactory_l379_39) begin
        reg_hcRhPortStatus_1_OCIC_clear = _zz_reg_hcRhPortStatus_1_OCIC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_39 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_39 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_39 = io_ctrl_cmd_payload_fragment_data[19];
  always @(*) begin
    reg_hcRhPortStatus_1_PRSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_40) begin
      if(when_BusSlaveFactory_l379_40) begin
        reg_hcRhPortStatus_1_PRSC_clear = _zz_reg_hcRhPortStatus_1_PRSC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_40 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_40 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_40 = io_ctrl_cmd_payload_fragment_data[20];
  assign when_UsbOhci_l460_3 = ((reg_hcRhPortStatus_1_clearPortEnable || reg_hcRhPortStatus_1_PESC_set) || (! reg_hcRhPortStatus_1_PPS));
  assign when_UsbOhci_l460_4 = (reg_hcRhPortStatus_1_PRSC_set || reg_hcRhPortStatus_1_PSSC_set);
  assign when_UsbOhci_l460_5 = (reg_hcRhPortStatus_1_setPortEnable && reg_hcRhPortStatus_1_CCS);
  assign when_UsbOhci_l461_2 = (((reg_hcRhPortStatus_1_PSSC_set || reg_hcRhPortStatus_1_PRSC_set) || (! reg_hcRhPortStatus_1_PPS)) || (reg_hcControl_HCFS == MainState_RESUME));
  assign when_UsbOhci_l461_3 = (reg_hcRhPortStatus_1_setPortSuspend && reg_hcRhPortStatus_1_CCS);
  assign when_UsbOhci_l462_1 = (reg_hcRhPortStatus_1_setPortSuspend && reg_hcRhPortStatus_1_CCS);
  assign when_UsbOhci_l463_1 = (reg_hcRhPortStatus_1_clearSuspendStatus && reg_hcRhPortStatus_1_PSS);
  assign when_UsbOhci_l464_1 = (reg_hcRhPortStatus_1_setPortReset && reg_hcRhPortStatus_1_CCS);
  assign when_UsbOhci_l470_1 = reg_hcRhDescriptorB_PPCM[1];
  assign reg_hcRhPortStatus_1_CSC_set = ((((reg_hcRhPortStatus_1_CCS ^ reg_hcRhPortStatus_1_CCS_regNext) || (reg_hcRhPortStatus_1_setPortEnable && (! reg_hcRhPortStatus_1_CCS))) || (reg_hcRhPortStatus_1_setPortSuspend && (! reg_hcRhPortStatus_1_CCS))) || (reg_hcRhPortStatus_1_setPortReset && (! reg_hcRhPortStatus_1_CCS)));
  assign reg_hcRhPortStatus_1_PESC_set = io_phy_ports_1_overcurrent;
  assign io_phy_ports_1_suspend_fire = (io_phy_ports_1_suspend_valid && io_phy_ports_1_suspend_ready);
  assign reg_hcRhPortStatus_1_PSSC_set = (io_phy_ports_1_suspend_fire || io_phy_ports_1_remoteResume);
  assign reg_hcRhPortStatus_1_OCIC_set = io_phy_ports_1_overcurrent;
  assign io_phy_ports_1_reset_fire = (io_phy_ports_1_reset_valid && io_phy_ports_1_reset_ready);
  assign reg_hcRhPortStatus_1_PRSC_set = io_phy_ports_1_reset_fire;
  assign io_phy_ports_1_disable_valid = reg_hcRhPortStatus_1_clearPortEnable;
  assign io_phy_ports_1_removable = reg_hcRhDescriptorB_DR[1];
  assign io_phy_ports_1_power = reg_hcRhPortStatus_1_PPS;
  assign io_phy_ports_1_resume_valid = reg_hcRhPortStatus_1_resume;
  assign io_phy_ports_1_resume_fire = (io_phy_ports_1_resume_valid && io_phy_ports_1_resume_ready);
  assign io_phy_ports_1_reset_valid = reg_hcRhPortStatus_1_reset;
  assign io_phy_ports_1_suspend_valid = reg_hcRhPortStatus_1_suspend;
  always @(*) begin
    reg_hcRhPortStatus_2_clearPortEnable = 1'b0;
    if(when_BusSlaveFactory_l377_41) begin
      if(when_BusSlaveFactory_l379_41) begin
        reg_hcRhPortStatus_2_clearPortEnable = _zz_reg_hcRhPortStatus_2_clearPortEnable[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_41 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_41 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_41 = io_ctrl_cmd_payload_fragment_data[0];
  always @(*) begin
    reg_hcRhPortStatus_2_setPortEnable = 1'b0;
    if(when_BusSlaveFactory_l377_42) begin
      if(when_BusSlaveFactory_l379_42) begin
        reg_hcRhPortStatus_2_setPortEnable = _zz_reg_hcRhPortStatus_2_setPortEnable[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_42 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_42 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_42 = io_ctrl_cmd_payload_fragment_data[1];
  always @(*) begin
    reg_hcRhPortStatus_2_setPortSuspend = 1'b0;
    if(when_BusSlaveFactory_l377_43) begin
      if(when_BusSlaveFactory_l379_43) begin
        reg_hcRhPortStatus_2_setPortSuspend = _zz_reg_hcRhPortStatus_2_setPortSuspend[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_43 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_43 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_43 = io_ctrl_cmd_payload_fragment_data[2];
  always @(*) begin
    reg_hcRhPortStatus_2_clearSuspendStatus = 1'b0;
    if(when_BusSlaveFactory_l377_44) begin
      if(when_BusSlaveFactory_l379_44) begin
        reg_hcRhPortStatus_2_clearSuspendStatus = _zz_reg_hcRhPortStatus_2_clearSuspendStatus[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_44 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_44 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_44 = io_ctrl_cmd_payload_fragment_data[3];
  always @(*) begin
    reg_hcRhPortStatus_2_setPortReset = 1'b0;
    if(when_BusSlaveFactory_l377_45) begin
      if(when_BusSlaveFactory_l379_45) begin
        reg_hcRhPortStatus_2_setPortReset = _zz_reg_hcRhPortStatus_2_setPortReset[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_45 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_45 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_45 = io_ctrl_cmd_payload_fragment_data[4];
  always @(*) begin
    reg_hcRhPortStatus_2_setPortPower = 1'b0;
    if(when_BusSlaveFactory_l377_46) begin
      if(when_BusSlaveFactory_l379_46) begin
        reg_hcRhPortStatus_2_setPortPower = _zz_reg_hcRhPortStatus_2_setPortPower[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_46 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_46 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_46 = io_ctrl_cmd_payload_fragment_data[8];
  always @(*) begin
    reg_hcRhPortStatus_2_clearPortPower = 1'b0;
    if(when_BusSlaveFactory_l377_47) begin
      if(when_BusSlaveFactory_l379_47) begin
        reg_hcRhPortStatus_2_clearPortPower = _zz_reg_hcRhPortStatus_2_clearPortPower[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_47 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_47 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_47 = io_ctrl_cmd_payload_fragment_data[9];
  assign reg_hcRhPortStatus_2_CCS = ((reg_hcRhPortStatus_2_connected || reg_hcRhDescriptorB_DR[2]) && reg_hcRhPortStatus_2_PPS);
  always @(*) begin
    reg_hcRhPortStatus_2_CSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_48) begin
      if(when_BusSlaveFactory_l379_48) begin
        reg_hcRhPortStatus_2_CSC_clear = _zz_reg_hcRhPortStatus_2_CSC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_48 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_48 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_48 = io_ctrl_cmd_payload_fragment_data[16];
  always @(*) begin
    reg_hcRhPortStatus_2_PESC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_49) begin
      if(when_BusSlaveFactory_l379_49) begin
        reg_hcRhPortStatus_2_PESC_clear = _zz_reg_hcRhPortStatus_2_PESC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_49 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_49 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_49 = io_ctrl_cmd_payload_fragment_data[17];
  always @(*) begin
    reg_hcRhPortStatus_2_PSSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_50) begin
      if(when_BusSlaveFactory_l379_50) begin
        reg_hcRhPortStatus_2_PSSC_clear = _zz_reg_hcRhPortStatus_2_PSSC_clear[0];
      end
    end
    if(reg_hcRhPortStatus_2_PRSC_set) begin
      reg_hcRhPortStatus_2_PSSC_clear = 1'b1;
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_50 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_50 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_50 = io_ctrl_cmd_payload_fragment_data[18];
  always @(*) begin
    reg_hcRhPortStatus_2_OCIC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_51) begin
      if(when_BusSlaveFactory_l379_51) begin
        reg_hcRhPortStatus_2_OCIC_clear = _zz_reg_hcRhPortStatus_2_OCIC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_51 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_51 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_51 = io_ctrl_cmd_payload_fragment_data[19];
  always @(*) begin
    reg_hcRhPortStatus_2_PRSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_52) begin
      if(when_BusSlaveFactory_l379_52) begin
        reg_hcRhPortStatus_2_PRSC_clear = _zz_reg_hcRhPortStatus_2_PRSC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_52 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h05c : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_52 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_52 = io_ctrl_cmd_payload_fragment_data[20];
  assign when_UsbOhci_l460_6 = ((reg_hcRhPortStatus_2_clearPortEnable || reg_hcRhPortStatus_2_PESC_set) || (! reg_hcRhPortStatus_2_PPS));
  assign when_UsbOhci_l460_7 = (reg_hcRhPortStatus_2_PRSC_set || reg_hcRhPortStatus_2_PSSC_set);
  assign when_UsbOhci_l460_8 = (reg_hcRhPortStatus_2_setPortEnable && reg_hcRhPortStatus_2_CCS);
  assign when_UsbOhci_l461_4 = (((reg_hcRhPortStatus_2_PSSC_set || reg_hcRhPortStatus_2_PRSC_set) || (! reg_hcRhPortStatus_2_PPS)) || (reg_hcControl_HCFS == MainState_RESUME));
  assign when_UsbOhci_l461_5 = (reg_hcRhPortStatus_2_setPortSuspend && reg_hcRhPortStatus_2_CCS);
  assign when_UsbOhci_l462_2 = (reg_hcRhPortStatus_2_setPortSuspend && reg_hcRhPortStatus_2_CCS);
  assign when_UsbOhci_l463_2 = (reg_hcRhPortStatus_2_clearSuspendStatus && reg_hcRhPortStatus_2_PSS);
  assign when_UsbOhci_l464_2 = (reg_hcRhPortStatus_2_setPortReset && reg_hcRhPortStatus_2_CCS);
  assign when_UsbOhci_l470_2 = reg_hcRhDescriptorB_PPCM[2];
  assign reg_hcRhPortStatus_2_CSC_set = ((((reg_hcRhPortStatus_2_CCS ^ reg_hcRhPortStatus_2_CCS_regNext) || (reg_hcRhPortStatus_2_setPortEnable && (! reg_hcRhPortStatus_2_CCS))) || (reg_hcRhPortStatus_2_setPortSuspend && (! reg_hcRhPortStatus_2_CCS))) || (reg_hcRhPortStatus_2_setPortReset && (! reg_hcRhPortStatus_2_CCS)));
  assign reg_hcRhPortStatus_2_PESC_set = io_phy_ports_2_overcurrent;
  assign io_phy_ports_2_suspend_fire = (io_phy_ports_2_suspend_valid && io_phy_ports_2_suspend_ready);
  assign reg_hcRhPortStatus_2_PSSC_set = (io_phy_ports_2_suspend_fire || io_phy_ports_2_remoteResume);
  assign reg_hcRhPortStatus_2_OCIC_set = io_phy_ports_2_overcurrent;
  assign io_phy_ports_2_reset_fire = (io_phy_ports_2_reset_valid && io_phy_ports_2_reset_ready);
  assign reg_hcRhPortStatus_2_PRSC_set = io_phy_ports_2_reset_fire;
  assign io_phy_ports_2_disable_valid = reg_hcRhPortStatus_2_clearPortEnable;
  assign io_phy_ports_2_removable = reg_hcRhDescriptorB_DR[2];
  assign io_phy_ports_2_power = reg_hcRhPortStatus_2_PPS;
  assign io_phy_ports_2_resume_valid = reg_hcRhPortStatus_2_resume;
  assign io_phy_ports_2_resume_fire = (io_phy_ports_2_resume_valid && io_phy_ports_2_resume_ready);
  assign io_phy_ports_2_reset_valid = reg_hcRhPortStatus_2_reset;
  assign io_phy_ports_2_suspend_valid = reg_hcRhPortStatus_2_suspend;
  always @(*) begin
    reg_hcRhPortStatus_3_clearPortEnable = 1'b0;
    if(when_BusSlaveFactory_l377_53) begin
      if(when_BusSlaveFactory_l379_53) begin
        reg_hcRhPortStatus_3_clearPortEnable = _zz_reg_hcRhPortStatus_3_clearPortEnable[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_53 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_53 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_53 = io_ctrl_cmd_payload_fragment_data[0];
  always @(*) begin
    reg_hcRhPortStatus_3_setPortEnable = 1'b0;
    if(when_BusSlaveFactory_l377_54) begin
      if(when_BusSlaveFactory_l379_54) begin
        reg_hcRhPortStatus_3_setPortEnable = _zz_reg_hcRhPortStatus_3_setPortEnable[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_54 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_54 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_54 = io_ctrl_cmd_payload_fragment_data[1];
  always @(*) begin
    reg_hcRhPortStatus_3_setPortSuspend = 1'b0;
    if(when_BusSlaveFactory_l377_55) begin
      if(when_BusSlaveFactory_l379_55) begin
        reg_hcRhPortStatus_3_setPortSuspend = _zz_reg_hcRhPortStatus_3_setPortSuspend[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_55 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_55 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_55 = io_ctrl_cmd_payload_fragment_data[2];
  always @(*) begin
    reg_hcRhPortStatus_3_clearSuspendStatus = 1'b0;
    if(when_BusSlaveFactory_l377_56) begin
      if(when_BusSlaveFactory_l379_56) begin
        reg_hcRhPortStatus_3_clearSuspendStatus = _zz_reg_hcRhPortStatus_3_clearSuspendStatus[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_56 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_56 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_56 = io_ctrl_cmd_payload_fragment_data[3];
  always @(*) begin
    reg_hcRhPortStatus_3_setPortReset = 1'b0;
    if(when_BusSlaveFactory_l377_57) begin
      if(when_BusSlaveFactory_l379_57) begin
        reg_hcRhPortStatus_3_setPortReset = _zz_reg_hcRhPortStatus_3_setPortReset[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_57 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_57 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_57 = io_ctrl_cmd_payload_fragment_data[4];
  always @(*) begin
    reg_hcRhPortStatus_3_setPortPower = 1'b0;
    if(when_BusSlaveFactory_l377_58) begin
      if(when_BusSlaveFactory_l379_58) begin
        reg_hcRhPortStatus_3_setPortPower = _zz_reg_hcRhPortStatus_3_setPortPower[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_58 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_58 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_58 = io_ctrl_cmd_payload_fragment_data[8];
  always @(*) begin
    reg_hcRhPortStatus_3_clearPortPower = 1'b0;
    if(when_BusSlaveFactory_l377_59) begin
      if(when_BusSlaveFactory_l379_59) begin
        reg_hcRhPortStatus_3_clearPortPower = _zz_reg_hcRhPortStatus_3_clearPortPower[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_59 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_59 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_59 = io_ctrl_cmd_payload_fragment_data[9];
  assign reg_hcRhPortStatus_3_CCS = ((reg_hcRhPortStatus_3_connected || reg_hcRhDescriptorB_DR[3]) && reg_hcRhPortStatus_3_PPS);
  always @(*) begin
    reg_hcRhPortStatus_3_CSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_60) begin
      if(when_BusSlaveFactory_l379_60) begin
        reg_hcRhPortStatus_3_CSC_clear = _zz_reg_hcRhPortStatus_3_CSC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_60 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_60 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_60 = io_ctrl_cmd_payload_fragment_data[16];
  always @(*) begin
    reg_hcRhPortStatus_3_PESC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_61) begin
      if(when_BusSlaveFactory_l379_61) begin
        reg_hcRhPortStatus_3_PESC_clear = _zz_reg_hcRhPortStatus_3_PESC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_61 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_61 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_61 = io_ctrl_cmd_payload_fragment_data[17];
  always @(*) begin
    reg_hcRhPortStatus_3_PSSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_62) begin
      if(when_BusSlaveFactory_l379_62) begin
        reg_hcRhPortStatus_3_PSSC_clear = _zz_reg_hcRhPortStatus_3_PSSC_clear[0];
      end
    end
    if(reg_hcRhPortStatus_3_PRSC_set) begin
      reg_hcRhPortStatus_3_PSSC_clear = 1'b1;
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_62 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_62 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_62 = io_ctrl_cmd_payload_fragment_data[18];
  always @(*) begin
    reg_hcRhPortStatus_3_OCIC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_63) begin
      if(when_BusSlaveFactory_l379_63) begin
        reg_hcRhPortStatus_3_OCIC_clear = _zz_reg_hcRhPortStatus_3_OCIC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_63 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_63 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_63 = io_ctrl_cmd_payload_fragment_data[19];
  always @(*) begin
    reg_hcRhPortStatus_3_PRSC_clear = 1'b0;
    if(when_BusSlaveFactory_l377_64) begin
      if(when_BusSlaveFactory_l379_64) begin
        reg_hcRhPortStatus_3_PRSC_clear = _zz_reg_hcRhPortStatus_3_PRSC_clear[0];
      end
    end
  end

  always @(*) begin
    when_BusSlaveFactory_l377_64 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h060 : begin
        if(ctrl_doWrite) begin
          when_BusSlaveFactory_l377_64 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_64 = io_ctrl_cmd_payload_fragment_data[20];
  assign when_UsbOhci_l460_9 = ((reg_hcRhPortStatus_3_clearPortEnable || reg_hcRhPortStatus_3_PESC_set) || (! reg_hcRhPortStatus_3_PPS));
  assign when_UsbOhci_l460_10 = (reg_hcRhPortStatus_3_PRSC_set || reg_hcRhPortStatus_3_PSSC_set);
  assign when_UsbOhci_l460_11 = (reg_hcRhPortStatus_3_setPortEnable && reg_hcRhPortStatus_3_CCS);
  assign when_UsbOhci_l461_6 = (((reg_hcRhPortStatus_3_PSSC_set || reg_hcRhPortStatus_3_PRSC_set) || (! reg_hcRhPortStatus_3_PPS)) || (reg_hcControl_HCFS == MainState_RESUME));
  assign when_UsbOhci_l461_7 = (reg_hcRhPortStatus_3_setPortSuspend && reg_hcRhPortStatus_3_CCS);
  assign when_UsbOhci_l462_3 = (reg_hcRhPortStatus_3_setPortSuspend && reg_hcRhPortStatus_3_CCS);
  assign when_UsbOhci_l463_3 = (reg_hcRhPortStatus_3_clearSuspendStatus && reg_hcRhPortStatus_3_PSS);
  assign when_UsbOhci_l464_3 = (reg_hcRhPortStatus_3_setPortReset && reg_hcRhPortStatus_3_CCS);
  assign when_UsbOhci_l470_3 = reg_hcRhDescriptorB_PPCM[3];
  assign reg_hcRhPortStatus_3_CSC_set = ((((reg_hcRhPortStatus_3_CCS ^ reg_hcRhPortStatus_3_CCS_regNext) || (reg_hcRhPortStatus_3_setPortEnable && (! reg_hcRhPortStatus_3_CCS))) || (reg_hcRhPortStatus_3_setPortSuspend && (! reg_hcRhPortStatus_3_CCS))) || (reg_hcRhPortStatus_3_setPortReset && (! reg_hcRhPortStatus_3_CCS)));
  assign reg_hcRhPortStatus_3_PESC_set = io_phy_ports_3_overcurrent;
  assign io_phy_ports_3_suspend_fire = (io_phy_ports_3_suspend_valid && io_phy_ports_3_suspend_ready);
  assign reg_hcRhPortStatus_3_PSSC_set = (io_phy_ports_3_suspend_fire || io_phy_ports_3_remoteResume);
  assign reg_hcRhPortStatus_3_OCIC_set = io_phy_ports_3_overcurrent;
  assign io_phy_ports_3_reset_fire = (io_phy_ports_3_reset_valid && io_phy_ports_3_reset_ready);
  assign reg_hcRhPortStatus_3_PRSC_set = io_phy_ports_3_reset_fire;
  assign io_phy_ports_3_disable_valid = reg_hcRhPortStatus_3_clearPortEnable;
  assign io_phy_ports_3_removable = reg_hcRhDescriptorB_DR[3];
  assign io_phy_ports_3_power = reg_hcRhPortStatus_3_PPS;
  assign io_phy_ports_3_resume_valid = reg_hcRhPortStatus_3_resume;
  assign io_phy_ports_3_resume_fire = (io_phy_ports_3_resume_valid && io_phy_ports_3_resume_ready);
  assign io_phy_ports_3_reset_valid = reg_hcRhPortStatus_3_reset;
  assign io_phy_ports_3_suspend_valid = reg_hcRhPortStatus_3_suspend;
  always @(*) begin
    frame_run = 1'b0;
    case(hc_stateReg)
      hc_enumDef_RESET : begin
      end
      hc_enumDef_RESUME : begin
      end
      hc_enumDef_OPERATIONAL : begin
        frame_run = 1'b1;
      end
      hc_enumDef_SUSPEND : begin
      end
      hc_enumDef_ANY_TO_RESET : begin
      end
      hc_enumDef_ANY_TO_SUSPEND : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    frame_reload = 1'b0;
    if(when_UsbOhci_l526) begin
      if(frame_overflow) begin
        frame_reload = 1'b1;
      end
    end
    if(when_StateMachine_l253_7) begin
      frame_reload = 1'b1;
    end
  end

  assign frame_overflow = (reg_hcFmRemaining_FR == 14'h0000);
  always @(*) begin
    frame_tick = 1'b0;
    if(when_UsbOhci_l526) begin
      if(frame_overflow) begin
        frame_tick = 1'b1;
      end
    end
  end

  assign frame_section1 = (reg_hcPeriodicStart_PS < reg_hcFmRemaining_FR);
  assign frame_limitHit = (frame_limitCounter == 15'h0000);
  assign frame_decrementTimerOverflow = (frame_decrementTimer == 3'b110);
  assign when_UsbOhci_l526 = (frame_run && io_phy_tick);
  assign when_UsbOhci_l528 = ((! frame_limitHit) && (! frame_decrementTimerOverflow));
  assign when_UsbOhci_l540 = (reg_hcFmNumber_FNp1[15] ^ reg_hcFmNumber_FN[15]);
  always @(*) begin
    token_wantExit = 1'b0;
    case(token_stateReg)
      token_enumDef_INIT : begin
      end
      token_enumDef_PID : begin
      end
      token_enumDef_B1 : begin
      end
      token_enumDef_B2 : begin
      end
      token_enumDef_EOP : begin
        if(io_phy_txEop) begin
          token_wantExit = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    token_wantStart = 1'b0;
    if(when_StateMachine_l237_1) begin
      token_wantStart = 1'b1;
    end
    if(when_StateMachine_l253_1) begin
      token_wantStart = 1'b1;
    end
  end

  always @(*) begin
    token_wantKill = 1'b0;
    if(unscheduleAll_fire) begin
      token_wantKill = 1'b1;
    end
  end

  always @(*) begin
    token_pid = 4'bxxxx;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
        token_pid = 4'b0101;
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
        case(endpoint_tockenType)
          2'b00 : begin
            token_pid = 4'b1101;
          end
          2'b01 : begin
            token_pid = 4'b0001;
          end
          2'b10 : begin
            token_pid = 4'b1001;
          end
          default : begin
          end
        endcase
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    token_data = 11'bxxxxxxxxxxx;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
        token_data = _zz_token_data[10:0];
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
        token_data = {endpoint_ED_EN,endpoint_ED_FA};
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    token_crc5_io_flush = 1'b0;
    if(when_StateMachine_l237) begin
      token_crc5_io_flush = 1'b1;
    end
  end

  always @(*) begin
    token_crc5_io_input_valid = 1'b0;
    case(token_stateReg)
      token_enumDef_INIT : begin
        token_crc5_io_input_valid = 1'b1;
      end
      token_enumDef_PID : begin
      end
      token_enumDef_B1 : begin
      end
      token_enumDef_B2 : begin
      end
      token_enumDef_EOP : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    dataTx_wantExit = 1'b0;
    case(dataTx_stateReg)
      dataTx_enumDef_PID : begin
      end
      dataTx_enumDef_DATA : begin
      end
      dataTx_enumDef_CRC_0 : begin
      end
      dataTx_enumDef_CRC_1 : begin
      end
      dataTx_enumDef_EOP : begin
        if(io_phy_txEop) begin
          dataTx_wantExit = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    dataTx_wantStart = 1'b0;
    if(when_StateMachine_l253_2) begin
      dataTx_wantStart = 1'b1;
    end
  end

  always @(*) begin
    dataTx_wantKill = 1'b0;
    if(unscheduleAll_fire) begin
      dataTx_wantKill = 1'b1;
    end
  end

  always @(*) begin
    dataTx_pid = 4'bxxxx;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
        dataTx_pid = {endpoint_dataPhase,3'b011};
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    dataTx_data_valid = 1'b0;
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
        dataTx_data_valid = 1'b1;
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    dataTx_data_payload_last = 1'bx;
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
        dataTx_data_payload_last = endpoint_dmaLogic_byteCtx_last;
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    dataTx_data_payload_fragment = 8'bxxxxxxxx;
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
        dataTx_data_payload_fragment = _zz_dataTx_data_payload_fragment;
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    dataTx_data_ready = 1'b0;
    case(dataTx_stateReg)
      dataTx_enumDef_PID : begin
      end
      dataTx_enumDef_DATA : begin
        if(io_phy_tx_ready) begin
          dataTx_data_ready = 1'b1;
        end
      end
      dataTx_enumDef_CRC_0 : begin
      end
      dataTx_enumDef_CRC_1 : begin
      end
      dataTx_enumDef_EOP : begin
      end
      default : begin
      end
    endcase
  end

  assign dataTx_data_fire = (dataTx_data_valid && dataTx_data_ready);
  always @(*) begin
    dataTx_crc16_io_flush = 1'b0;
    case(dataTx_stateReg)
      dataTx_enumDef_PID : begin
        dataTx_crc16_io_flush = 1'b1;
      end
      dataTx_enumDef_DATA : begin
      end
      dataTx_enumDef_CRC_0 : begin
      end
      dataTx_enumDef_CRC_1 : begin
      end
      dataTx_enumDef_EOP : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    rxTimer_clear = 1'b0;
    if(io_phy_rx_active) begin
      rxTimer_clear = 1'b1;
    end
    if(when_StateMachine_l253) begin
      rxTimer_clear = 1'b1;
    end
    if(when_StateMachine_l253_4) begin
      rxTimer_clear = 1'b1;
    end
  end

  assign rxTimer_rxTimeout = (rxTimer_counter == (rxTimer_lowSpeed ? 8'hbf : 8'h17));
  assign rxTimer_ackTx = (rxTimer_counter == _zz_rxTimer_ackTx);
  assign rxPidOk = (io_phy_rx_flow_payload_data[3 : 0] == (~ io_phy_rx_flow_payload_data[7 : 4]));
  assign _zz_1 = io_phy_rx_flow_valid;
  assign _zz_dataRx_pid = io_phy_rx_flow_payload_data;
  assign when_Misc_l87 = (io_phy_rx_flow_valid && io_phy_rx_flow_payload_stuffingError);
  always @(*) begin
    dataRx_wantExit = 1'b0;
    case(dataRx_stateReg)
      dataRx_enumDef_IDLE : begin
        if(!io_phy_rx_active) begin
          if(rxTimer_rxTimeout) begin
            dataRx_wantExit = 1'b1;
          end
        end
      end
      dataRx_enumDef_PID : begin
        if(!_zz_1) begin
          if(when_Misc_l64) begin
            dataRx_wantExit = 1'b1;
          end
        end
      end
      dataRx_enumDef_DATA : begin
        if(when_Misc_l70) begin
          dataRx_wantExit = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    dataRx_wantStart = 1'b0;
    if(when_StateMachine_l253_3) begin
      dataRx_wantStart = 1'b1;
    end
  end

  always @(*) begin
    dataRx_wantKill = 1'b0;
    if(unscheduleAll_fire) begin
      dataRx_wantKill = 1'b1;
    end
  end

  assign dataRx_history_0 = _zz_dataRx_history_0;
  assign dataRx_history_1 = _zz_dataRx_history_1;
  assign dataRx_hasError = (|{dataRx_crcError,{dataRx_pidError,{dataRx_stuffingError,dataRx_notResponding}}});
  always @(*) begin
    dataRx_data_valid = 1'b0;
    case(dataRx_stateReg)
      dataRx_enumDef_IDLE : begin
      end
      dataRx_enumDef_PID : begin
      end
      dataRx_enumDef_DATA : begin
        if(!when_Misc_l70) begin
          if(_zz_1) begin
            if(when_Misc_l78) begin
              dataRx_data_valid = 1'b1;
            end
          end
        end
      end
      default : begin
      end
    endcase
  end

  assign dataRx_data_payload = dataRx_history_1;
  always @(*) begin
    dataRx_crc16_io_input_valid = 1'b0;
    case(dataRx_stateReg)
      dataRx_enumDef_IDLE : begin
      end
      dataRx_enumDef_PID : begin
      end
      dataRx_enumDef_DATA : begin
        if(!when_Misc_l70) begin
          if(_zz_1) begin
            dataRx_crc16_io_input_valid = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    dataRx_crc16_io_flush = 1'b0;
    case(dataRx_stateReg)
      dataRx_enumDef_IDLE : begin
      end
      dataRx_enumDef_PID : begin
        dataRx_crc16_io_flush = 1'b1;
      end
      dataRx_enumDef_DATA : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    sof_wantExit = 1'b0;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
        if(ioDma_rsp_valid) begin
          sof_wantExit = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    sof_wantStart = 1'b0;
    if(when_StateMachine_l253_6) begin
      sof_wantStart = 1'b1;
    end
  end

  always @(*) begin
    sof_wantKill = 1'b0;
    if(unscheduleAll_fire) begin
      sof_wantKill = 1'b1;
    end
  end

  always @(*) begin
    priority_tick = 1'b0;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
        if(dmaCtx_pendingEmpty) begin
          if(when_UsbOhci_l1418) begin
            priority_tick = 1'b1;
          end
        end
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    priority_skip = 1'b0;
    if(priority_tick) begin
      if(when_UsbOhci_l663) begin
        priority_skip = 1'b1;
      end
    end
    case(operational_stateReg)
      operational_enumDef_SOF : begin
      end
      operational_enumDef_ARBITER : begin
        if(!operational_askExit) begin
          if(!frame_limitHit) begin
            if(!when_UsbOhci_l1487) begin
              priority_skip = 1'b1;
              if(priority_bulk) begin
                if(operational_allowBulk) begin
                  if(reg_hcBulkCurrentED_isZero) begin
                    if(reg_hcCommandStatus_BLF) begin
                      priority_skip = 1'b0;
                    end
                  end else begin
                    priority_skip = 1'b0;
                  end
                end
              end else begin
                if(operational_allowControl) begin
                  if(reg_hcControlCurrentED_isZero) begin
                    if(reg_hcCommandStatus_CLF) begin
                      priority_skip = 1'b0;
                    end
                  end else begin
                    priority_skip = 1'b0;
                  end
                end
              end
            end
          end
        end
      end
      operational_enumDef_END_POINT : begin
      end
      operational_enumDef_PERIODIC_HEAD_CMD : begin
      end
      operational_enumDef_PERIODIC_HEAD_RSP : begin
      end
      operational_enumDef_WAIT_SOF : begin
      end
      default : begin
      end
    endcase
  end

  assign when_UsbOhci_l663 = (priority_bulk || (priority_counter == reg_hcControl_CBSR));
  always @(*) begin
    interruptDelay_tick = 1'b0;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
        if(ioDma_rsp_valid) begin
          interruptDelay_tick = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign interruptDelay_done = (interruptDelay_counter == 3'b000);
  assign interruptDelay_disabled = (interruptDelay_counter == 3'b111);
  always @(*) begin
    interruptDelay_disable = 1'b0;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
        if(ioDma_rsp_valid) begin
          if(sof_doInterruptDelay) begin
            interruptDelay_disable = 1'b1;
          end
        end
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l237_3) begin
      interruptDelay_disable = 1'b1;
    end
  end

  always @(*) begin
    interruptDelay_load_valid = 1'b0;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
        if(dmaCtx_pendingEmpty) begin
          if(endpoint_TD_retire) begin
            interruptDelay_load_valid = 1'b1;
          end
        end
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    interruptDelay_load_payload = 3'bxxx;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
        if(dmaCtx_pendingEmpty) begin
          if(endpoint_TD_retire) begin
            interruptDelay_load_payload = endpoint_TD_DI;
          end
        end
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  assign when_UsbOhci_l685 = ((interruptDelay_tick && (! interruptDelay_done)) && (! interruptDelay_disabled));
  assign when_UsbOhci_l689 = (interruptDelay_load_valid && (interruptDelay_load_payload < interruptDelay_counter));
  always @(*) begin
    endpoint_wantExit = 1'b0;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
        if(when_UsbOhci_l861) begin
          endpoint_wantExit = 1'b1;
        end
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
        if(dmaCtx_pendingEmpty) begin
          endpoint_wantExit = 1'b1;
        end
      end
      endpoint_enumDef_ABORD : begin
        endpoint_wantExit = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    endpoint_wantStart = 1'b0;
    case(operational_stateReg)
      operational_enumDef_SOF : begin
      end
      operational_enumDef_ARBITER : begin
        if(!operational_askExit) begin
          if(!frame_limitHit) begin
            if(when_UsbOhci_l1487) begin
              if(!when_UsbOhci_l1488) begin
                if(!reg_hcPeriodCurrentED_isZero) begin
                  endpoint_wantStart = 1'b1;
                end
              end
            end else begin
              if(priority_bulk) begin
                if(operational_allowBulk) begin
                  if(!reg_hcBulkCurrentED_isZero) begin
                    endpoint_wantStart = 1'b1;
                  end
                end
              end else begin
                if(operational_allowControl) begin
                  if(!reg_hcControlCurrentED_isZero) begin
                    endpoint_wantStart = 1'b1;
                  end
                end
              end
            end
          end
        end
      end
      operational_enumDef_END_POINT : begin
      end
      operational_enumDef_PERIODIC_HEAD_CMD : begin
      end
      operational_enumDef_PERIODIC_HEAD_RSP : begin
      end
      operational_enumDef_WAIT_SOF : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    endpoint_wantKill = 1'b0;
    if(unscheduleAll_fire) begin
      endpoint_wantKill = 1'b1;
    end
  end

  assign endpoint_ED_FA = endpoint_ED_words_0[6 : 0];
  assign endpoint_ED_EN = endpoint_ED_words_0[10 : 7];
  assign endpoint_ED_D = endpoint_ED_words_0[12 : 11];
  assign endpoint_ED_S = endpoint_ED_words_0[13];
  assign endpoint_ED_K = endpoint_ED_words_0[14];
  assign endpoint_ED_F = endpoint_ED_words_0[15];
  assign endpoint_ED_MPS = endpoint_ED_words_0[26 : 16];
  assign endpoint_ED_tailP = endpoint_ED_words_1[31 : 4];
  assign endpoint_ED_H = endpoint_ED_words_2[0];
  assign endpoint_ED_C = endpoint_ED_words_2[1];
  assign endpoint_ED_headP = endpoint_ED_words_2[31 : 4];
  assign endpoint_ED_nextED = endpoint_ED_words_3[31 : 4];
  assign endpoint_ED_tdEmpty = (endpoint_ED_tailP == endpoint_ED_headP);
  assign endpoint_ED_isFs = (! endpoint_ED_S);
  assign endpoint_ED_isoOut = endpoint_ED_D[0];
  assign when_UsbOhci_l750 = (! (endpoint_stateReg == endpoint_enumDef_BOOT));
  assign rxTimer_lowSpeed = endpoint_ED_S;
  assign endpoint_TD_address = ({4'd0,endpoint_ED_headP} <<< 3'd4);
  assign endpoint_TD_CC = endpoint_TD_words_0[31 : 28];
  assign endpoint_TD_EC = endpoint_TD_words_0[27 : 26];
  assign endpoint_TD_T = endpoint_TD_words_0[25 : 24];
  assign endpoint_TD_DI = endpoint_TD_words_0[23 : 21];
  assign endpoint_TD_DP = endpoint_TD_words_0[20 : 19];
  assign endpoint_TD_R = endpoint_TD_words_0[18];
  assign endpoint_TD_CBP = endpoint_TD_words_1[31 : 0];
  assign endpoint_TD_nextTD = endpoint_TD_words_2[31 : 4];
  assign endpoint_TD_BE = endpoint_TD_words_3[31 : 0];
  assign endpoint_TD_FC = endpoint_TD_words_0[26 : 24];
  assign endpoint_TD_SF = endpoint_TD_words_0[15 : 0];
  assign endpoint_TD_isoRelativeFrameNumber = (reg_hcFmNumber_FN - endpoint_TD_SF);
  assign endpoint_TD_tooEarly = endpoint_TD_isoRelativeFrameNumber[15];
  assign endpoint_TD_isoFrameNumber = endpoint_TD_isoRelativeFrameNumber[2 : 0];
  assign endpoint_TD_isoOverrun = ((! endpoint_TD_tooEarly) && (_zz_endpoint_TD_isoOverrun < endpoint_TD_isoRelativeFrameNumber));
  assign endpoint_TD_isoLast = (((! endpoint_TD_isoOverrun) && (! endpoint_TD_tooEarly)) && (endpoint_TD_isoFrameNumber == endpoint_TD_FC));
  assign endpoint_TD_isSinglePage = (endpoint_TD_CBP[31 : 12] == endpoint_TD_BE[31 : 12]);
  assign endpoint_TD_firstOffset = (endpoint_ED_F ? endpoint_TD_isoBase : _zz_endpoint_TD_firstOffset);
  assign endpoint_TD_allowRounding = ((! endpoint_ED_F) && endpoint_TD_R);
  assign endpoint_TD_TNext = (endpoint_TD_dataPhaseUpdate ? {1'b1,(! endpoint_dataPhase)} : endpoint_TD_T);
  assign endpoint_TD_dataPhaseNext = (endpoint_dataPhase ^ endpoint_TD_dataPhaseUpdate);
  assign endpoint_TD_dataPid = (endpoint_dataPhase ? 4'b1011 : 4'b0011);
  assign endpoint_TD_dataPidWrong = (endpoint_dataPhase ? 4'b0011 : 4'b1011);
  always @(*) begin
    endpoint_TD_clear = 1'b0;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
        endpoint_TD_clear = 1'b1;
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  assign endpoint_tockenType = ((endpoint_ED_D[0] != endpoint_ED_D[1]) ? endpoint_ED_D : endpoint_TD_DP);
  assign endpoint_isIn = (endpoint_tockenType == 2'b10);
  always @(*) begin
    endpoint_applyNextED = 1'b0;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
        if(when_UsbOhci_l861) begin
          endpoint_applyNextED = 1'b1;
        end
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
        if(dmaCtx_pendingEmpty) begin
          if(when_UsbOhci_l1415) begin
            endpoint_applyNextED = 1'b1;
          end
        end
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  assign endpoint_currentAddressFull = {(endpoint_currentAddress[12] ? endpoint_TD_BE[31 : 12] : endpoint_TD_CBP[31 : 12]),endpoint_currentAddress[11 : 0]};
  assign _zz_3 = zz__zz_endpoint_currentAddressBmb(1'b0);
  always @(*) _zz_endpoint_currentAddressBmb = _zz_3;
  assign endpoint_currentAddressBmb = (endpoint_currentAddressFull & _zz_endpoint_currentAddressBmb);
  assign endpoint_transactionSizeMinusOne = (_zz_endpoint_transactionSizeMinusOne - endpoint_currentAddress);
  assign endpoint_transactionSize = (endpoint_transactionSizeMinusOne + 14'h0001);
  assign endpoint_dataDone = (endpoint_zeroLength || (_zz_endpoint_dataDone < endpoint_currentAddress));
  always @(*) begin
    endpoint_dmaLogic_wantExit = 1'b0;
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
        if(dataTx_data_ready) begin
          if(endpoint_dmaLogic_byteCtx_last) begin
            endpoint_dmaLogic_wantExit = 1'b1;
          end
        end
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
        if(when_UsbOhci_l1068) begin
          endpoint_dmaLogic_wantExit = 1'b1;
        end
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
        if(endpoint_dataDone) begin
          if(endpoint_isIn) begin
            endpoint_dmaLogic_wantExit = 1'b1;
          end
        end
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    endpoint_dmaLogic_wantStart = 1'b0;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
        if(!endpoint_timeCheck) begin
          if(!when_UsbOhci_l1118) begin
            endpoint_dmaLogic_wantStart = 1'b1;
          end
        end
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_3) begin
      endpoint_dmaLogic_wantStart = 1'b1;
    end
  end

  always @(*) begin
    endpoint_dmaLogic_wantKill = 1'b0;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
        if(when_UsbOhci_l1128) begin
          if(endpoint_timeCheck) begin
            endpoint_dmaLogic_wantKill = 1'b1;
          end
        end
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
    if(unscheduleAll_fire) begin
      endpoint_dmaLogic_wantKill = 1'b1;
    end
  end

  always @(*) begin
    endpoint_dmaLogic_validated = 1'b0;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
      end
      endpoint_enumDef_BUFFER_READ : begin
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
        endpoint_dmaLogic_validated = 1'b1;
      end
      endpoint_enumDef_ACK_RX : begin
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
  end

  assign endpoint_dmaLogic_lengthMax = (~ _zz_endpoint_dmaLogic_lengthMax);
  assign endpoint_dmaLogic_lengthCalc = _zz_endpoint_dmaLogic_lengthCalc[5:0];
  assign endpoint_dmaLogic_beatCount = _zz_endpoint_dmaLogic_beatCount[6 : 3];
  assign endpoint_dmaLogic_lengthBmb = _zz_endpoint_dmaLogic_lengthBmb[5:0];
  assign endpoint_dmaLogic_underflowError = (endpoint_dmaLogic_underflow && (! endpoint_TD_allowRounding));
  assign when_UsbOhci_l938 = (((! (endpoint_dmaLogic_stateReg == endpoint_dmaLogic_enumDef_BOOT)) && (! endpoint_isIn)) && ioDma_rsp_valid);
  assign endpoint_dmaLogic_byteCtx_last = (endpoint_dmaLogic_byteCtx_counter == endpoint_lastAddress);
  assign endpoint_dmaLogic_byteCtx_sel = endpoint_dmaLogic_byteCtx_counter[2:0];
  always @(*) begin
    endpoint_dmaLogic_byteCtx_increment = 1'b0;
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
        if(dataTx_data_ready) begin
          endpoint_dmaLogic_byteCtx_increment = 1'b1;
        end
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
        if(dataRx_data_valid) begin
          endpoint_dmaLogic_byteCtx_increment = 1'b1;
        end
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
      end
      default : begin
      end
    endcase
  end

  assign endpoint_dmaLogic_headMask = {(endpoint_currentAddress[2 : 0] <= 3'b111),{(endpoint_currentAddress[2 : 0] <= 3'b110),{(endpoint_currentAddress[2 : 0] <= 3'b101),{(endpoint_currentAddress[2 : 0] <= 3'b100),{(_zz_endpoint_dmaLogic_headMask <= _zz_endpoint_dmaLogic_headMask_1),{_zz_endpoint_dmaLogic_headMask_2,{_zz_endpoint_dmaLogic_headMask_3,_zz_endpoint_dmaLogic_headMask_4}}}}}}};
  assign endpoint_dmaLogic_lastMask = {(3'b111 <= _zz_endpoint_dmaLogic_lastMask[2 : 0]),{(3'b110 <= _zz_endpoint_dmaLogic_lastMask_2[2 : 0]),{(3'b101 <= _zz_endpoint_dmaLogic_lastMask_4[2 : 0]),{(3'b100 <= _zz_endpoint_dmaLogic_lastMask_6[2 : 0]),{(3'b011 <= _zz_endpoint_dmaLogic_lastMask_8[2 : 0]),{(_zz_endpoint_dmaLogic_lastMask_10 <= _zz_endpoint_dmaLogic_lastMask_11),{_zz_endpoint_dmaLogic_lastMask_14,_zz_endpoint_dmaLogic_lastMask_17}}}}}}};
  assign endpoint_dmaLogic_fullMask = 8'hff;
  assign endpoint_dmaLogic_beatLast = (dmaCtx_beatCounter == _zz_endpoint_dmaLogic_beatLast);
  assign endpoint_byteCountCalc = (_zz_endpoint_byteCountCalc + 14'h0001);
  assign endpoint_fsTimeCheck = (endpoint_zeroLength ? (frame_limitCounter == 15'h0000) : (_zz_endpoint_fsTimeCheck <= _zz_endpoint_fsTimeCheck_1));
  assign endpoint_timeCheck = ((endpoint_ED_isFs && endpoint_fsTimeCheck) || (endpoint_ED_S && reg_hcLSThreshold_hit));
  assign endpoint_tdUpdateAddress = ((endpoint_TD_retire && (! ((endpoint_isIn && ((endpoint_TD_CC == 4'b0000) || (endpoint_TD_CC == 4'b1001))) && endpoint_dmaLogic_underflow))) ? 32'h00000000 : endpoint_currentAddressFull);
  always @(*) begin
    operational_wantExit = 1'b0;
    case(operational_stateReg)
      operational_enumDef_SOF : begin
      end
      operational_enumDef_ARBITER : begin
        if(operational_askExit) begin
          operational_wantExit = 1'b1;
        end
      end
      operational_enumDef_END_POINT : begin
      end
      operational_enumDef_PERIODIC_HEAD_CMD : begin
      end
      operational_enumDef_PERIODIC_HEAD_RSP : begin
      end
      operational_enumDef_WAIT_SOF : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    operational_wantStart = 1'b0;
    if(when_StateMachine_l253_7) begin
      operational_wantStart = 1'b1;
    end
  end

  always @(*) begin
    operational_wantKill = 1'b0;
    if(unscheduleAll_fire) begin
      operational_wantKill = 1'b1;
    end
  end

  always @(*) begin
    operational_askExit = 1'b0;
    case(hc_stateReg)
      hc_enumDef_RESET : begin
      end
      hc_enumDef_RESUME : begin
      end
      hc_enumDef_OPERATIONAL : begin
      end
      hc_enumDef_SUSPEND : begin
      end
      hc_enumDef_ANY_TO_RESET : begin
      end
      hc_enumDef_ANY_TO_SUSPEND : begin
        operational_askExit = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign dmaRspMux_sel = reg_hcFmNumber_FN[0:0];
  assign hc_wantExit = 1'b0;
  always @(*) begin
    hc_wantStart = 1'b0;
    case(hc_stateReg)
      hc_enumDef_RESET : begin
      end
      hc_enumDef_RESUME : begin
      end
      hc_enumDef_OPERATIONAL : begin
      end
      hc_enumDef_SUSPEND : begin
      end
      hc_enumDef_ANY_TO_RESET : begin
      end
      hc_enumDef_ANY_TO_SUSPEND : begin
      end
      default : begin
        hc_wantStart = 1'b1;
      end
    endcase
  end

  assign hc_wantKill = 1'b0;
  always @(*) begin
    reg_hcControl_HCFS = MainState_RESET;
    case(hc_stateReg)
      hc_enumDef_RESET : begin
      end
      hc_enumDef_RESUME : begin
        reg_hcControl_HCFS = MainState_RESUME;
      end
      hc_enumDef_OPERATIONAL : begin
        reg_hcControl_HCFS = MainState_OPERATIONAL;
      end
      hc_enumDef_SUSPEND : begin
        reg_hcControl_HCFS = MainState_SUSPEND;
      end
      hc_enumDef_ANY_TO_RESET : begin
        reg_hcControl_HCFS = MainState_RESET;
      end
      hc_enumDef_ANY_TO_SUSPEND : begin
        reg_hcControl_HCFS = MainState_SUSPEND;
      end
      default : begin
      end
    endcase
  end

  assign io_phy_usbReset = (reg_hcControl_HCFS == MainState_RESET);
  assign io_phy_usbResume = (reg_hcControl_HCFS == MainState_RESUME);
  always @(*) begin
    hc_error = 1'b0;
    case(hc_stateReg)
      hc_enumDef_RESET : begin
        if(reg_hcControl_HCFSWrite_valid) begin
          case(reg_hcControl_HCFSWrite_payload)
            MainState_OPERATIONAL : begin
            end
            default : begin
              hc_error = 1'b1;
            end
          endcase
        end
      end
      hc_enumDef_RESUME : begin
      end
      hc_enumDef_OPERATIONAL : begin
      end
      hc_enumDef_SUSPEND : begin
      end
      hc_enumDef_ANY_TO_RESET : begin
      end
      hc_enumDef_ANY_TO_SUSPEND : begin
      end
      default : begin
      end
    endcase
  end

  assign _zz_reg_hcControl_HCFSWrite_payload = io_ctrl_cmd_payload_fragment_data[7 : 6];
  assign reg_hcControl_HCFSWrite_payload = _zz_reg_hcControl_HCFSWrite_payload;
  assign when_BusSlaveFactory_l1021 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_1 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_2 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_3 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_4 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_5 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_6 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_7 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_8 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_9 = io_ctrl_cmd_payload_fragment_mask[2];
  assign when_BusSlaveFactory_l1021_10 = io_ctrl_cmd_payload_fragment_mask[3];
  assign when_BusSlaveFactory_l1021_11 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_12 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_13 = io_ctrl_cmd_payload_fragment_mask[2];
  assign when_BusSlaveFactory_l1021_14 = io_ctrl_cmd_payload_fragment_mask[3];
  assign when_BusSlaveFactory_l1021_15 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_16 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_17 = io_ctrl_cmd_payload_fragment_mask[2];
  assign when_BusSlaveFactory_l1021_18 = io_ctrl_cmd_payload_fragment_mask[3];
  assign when_BusSlaveFactory_l1021_19 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_20 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_21 = io_ctrl_cmd_payload_fragment_mask[2];
  assign when_BusSlaveFactory_l1021_22 = io_ctrl_cmd_payload_fragment_mask[3];
  assign when_BusSlaveFactory_l1021_23 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_24 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_25 = io_ctrl_cmd_payload_fragment_mask[2];
  assign when_BusSlaveFactory_l1021_26 = io_ctrl_cmd_payload_fragment_mask[3];
  assign when_BusSlaveFactory_l1021_27 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_28 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_29 = io_ctrl_cmd_payload_fragment_mask[2];
  assign when_BusSlaveFactory_l1021_30 = io_ctrl_cmd_payload_fragment_mask[3];
  assign when_BusSlaveFactory_l1021_31 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_32 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_33 = io_ctrl_cmd_payload_fragment_mask[2];
  assign when_BusSlaveFactory_l1021_34 = io_ctrl_cmd_payload_fragment_mask[3];
  assign when_BusSlaveFactory_l1021_35 = io_ctrl_cmd_payload_fragment_mask[3];
  assign when_BusSlaveFactory_l1021_36 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_37 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_38 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_39 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_40 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_41 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_42 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_43 = io_ctrl_cmd_payload_fragment_mask[1];
  assign when_BusSlaveFactory_l1021_44 = io_ctrl_cmd_payload_fragment_mask[3];
  assign when_BusSlaveFactory_l1021_45 = io_ctrl_cmd_payload_fragment_mask[0];
  assign when_BusSlaveFactory_l1021_46 = io_ctrl_cmd_payload_fragment_mask[2];
  assign when_UsbOhci_l253 = (doSoftReset || _zz_when_UsbOhci_l253);
  always @(*) begin
    token_stateNext = token_stateReg;
    case(token_stateReg)
      token_enumDef_INIT : begin
        token_stateNext = token_enumDef_PID;
      end
      token_enumDef_PID : begin
        if(io_phy_tx_ready) begin
          token_stateNext = token_enumDef_B1;
        end
      end
      token_enumDef_B1 : begin
        if(io_phy_tx_ready) begin
          token_stateNext = token_enumDef_B2;
        end
      end
      token_enumDef_B2 : begin
        if(io_phy_tx_ready) begin
          token_stateNext = token_enumDef_EOP;
        end
      end
      token_enumDef_EOP : begin
        if(io_phy_txEop) begin
          token_stateNext = token_enumDef_BOOT;
        end
      end
      default : begin
      end
    endcase
    if(token_wantStart) begin
      token_stateNext = token_enumDef_INIT;
    end
    if(token_wantKill) begin
      token_stateNext = token_enumDef_BOOT;
    end
  end

  assign when_StateMachine_l237 = ((token_stateReg == token_enumDef_BOOT) && (! (token_stateNext == token_enumDef_BOOT)));
  assign unscheduleAll_fire = (unscheduleAll_valid && unscheduleAll_ready);
  always @(*) begin
    dataTx_stateNext = dataTx_stateReg;
    case(dataTx_stateReg)
      dataTx_enumDef_PID : begin
        if(io_phy_tx_ready) begin
          if(dataTx_data_valid) begin
            dataTx_stateNext = dataTx_enumDef_DATA;
          end else begin
            dataTx_stateNext = dataTx_enumDef_CRC_0;
          end
        end
      end
      dataTx_enumDef_DATA : begin
        if(io_phy_tx_ready) begin
          if(dataTx_data_payload_last) begin
            dataTx_stateNext = dataTx_enumDef_CRC_0;
          end
        end
      end
      dataTx_enumDef_CRC_0 : begin
        if(io_phy_tx_ready) begin
          dataTx_stateNext = dataTx_enumDef_CRC_1;
        end
      end
      dataTx_enumDef_CRC_1 : begin
        if(io_phy_tx_ready) begin
          dataTx_stateNext = dataTx_enumDef_EOP;
        end
      end
      dataTx_enumDef_EOP : begin
        if(io_phy_txEop) begin
          dataTx_stateNext = dataTx_enumDef_BOOT;
        end
      end
      default : begin
      end
    endcase
    if(dataTx_wantStart) begin
      dataTx_stateNext = dataTx_enumDef_PID;
    end
    if(dataTx_wantKill) begin
      dataTx_stateNext = dataTx_enumDef_BOOT;
    end
  end

  always @(*) begin
    dataRx_stateNext = dataRx_stateReg;
    case(dataRx_stateReg)
      dataRx_enumDef_IDLE : begin
        if(io_phy_rx_active) begin
          dataRx_stateNext = dataRx_enumDef_PID;
        end else begin
          if(rxTimer_rxTimeout) begin
            dataRx_stateNext = dataRx_enumDef_BOOT;
          end
        end
      end
      dataRx_enumDef_PID : begin
        if(_zz_1) begin
          dataRx_stateNext = dataRx_enumDef_DATA;
        end else begin
          if(when_Misc_l64) begin
            dataRx_stateNext = dataRx_enumDef_BOOT;
          end
        end
      end
      dataRx_enumDef_DATA : begin
        if(when_Misc_l70) begin
          dataRx_stateNext = dataRx_enumDef_BOOT;
        end
      end
      default : begin
      end
    endcase
    if(dataRx_wantStart) begin
      dataRx_stateNext = dataRx_enumDef_IDLE;
    end
    if(dataRx_wantKill) begin
      dataRx_stateNext = dataRx_enumDef_BOOT;
    end
  end

  assign when_Misc_l64 = (! io_phy_rx_active);
  assign when_Misc_l70 = (! io_phy_rx_active);
  assign when_Misc_l71 = ((! (&dataRx_valids)) || (dataRx_crc16_io_result != 16'h800d));
  assign when_Misc_l78 = (&dataRx_valids);
  assign when_StateMachine_l253 = ((! (dataRx_stateReg == dataRx_enumDef_IDLE)) && (dataRx_stateNext == dataRx_enumDef_IDLE));
  assign when_Misc_l85 = (! (dataRx_stateReg == dataRx_enumDef_BOOT));
  always @(*) begin
    sof_stateNext = sof_stateReg;
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
        if(token_wantExit) begin
          sof_stateNext = sof_enumDef_FRAME_NUMBER_CMD;
        end
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
        if(when_UsbOhci_l626) begin
          sof_stateNext = sof_enumDef_FRAME_NUMBER_RSP;
        end
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
        if(ioDma_rsp_valid) begin
          sof_stateNext = sof_enumDef_BOOT;
        end
      end
      default : begin
      end
    endcase
    if(sof_wantStart) begin
      sof_stateNext = sof_enumDef_FRAME_TX;
    end
    if(sof_wantKill) begin
      sof_stateNext = sof_enumDef_BOOT;
    end
  end

  assign when_UsbOhci_l206 = (dmaWriteCtx_counter == 3'b000);
  assign when_UsbOhci_l206_1 = (dmaWriteCtx_counter == 3'b000);
  assign when_UsbOhci_l626 = (ioDma_cmd_ready && ioDma_cmd_payload_last);
  assign when_StateMachine_l237_1 = ((sof_stateReg == sof_enumDef_BOOT) && (! (sof_stateNext == sof_enumDef_BOOT)));
  always @(*) begin
    endpoint_stateNext = endpoint_stateReg;
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
        if(ioDma_cmd_ready) begin
          endpoint_stateNext = endpoint_enumDef_ED_READ_RSP;
        end
      end
      endpoint_enumDef_ED_READ_RSP : begin
        if(when_UsbOhci_l855) begin
          endpoint_stateNext = endpoint_enumDef_ED_ANALYSE;
        end
      end
      endpoint_enumDef_ED_ANALYSE : begin
        if(when_UsbOhci_l861) begin
          endpoint_stateNext = endpoint_enumDef_BOOT;
        end else begin
          endpoint_stateNext = endpoint_enumDef_TD_READ_CMD;
        end
      end
      endpoint_enumDef_TD_READ_CMD : begin
        if(ioDma_cmd_ready) begin
          endpoint_stateNext = endpoint_enumDef_TD_READ_RSP;
        end
      end
      endpoint_enumDef_TD_READ_RSP : begin
        if(when_UsbOhci_l898) begin
          endpoint_stateNext = endpoint_enumDef_TD_READ_DELAY;
        end
      end
      endpoint_enumDef_TD_READ_DELAY : begin
        endpoint_stateNext = endpoint_enumDef_TD_ANALYSE;
      end
      endpoint_enumDef_TD_ANALYSE : begin
        endpoint_stateNext = endpoint_enumDef_TD_CHECK_TIME;
        if(endpoint_ED_F) begin
          if(endpoint_TD_tooEarlyReg) begin
            endpoint_stateNext = endpoint_enumDef_UPDATE_SYNC;
          end
          if(endpoint_TD_isoOverrunReg) begin
            endpoint_stateNext = endpoint_enumDef_UPDATE_TD_CMD;
          end
        end
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
        if(endpoint_timeCheck) begin
          endpoint_stateNext = endpoint_enumDef_ABORD;
        end else begin
          if(when_UsbOhci_l1118) begin
            endpoint_stateNext = endpoint_enumDef_TOKEN;
          end else begin
            endpoint_stateNext = endpoint_enumDef_BUFFER_READ;
          end
        end
      end
      endpoint_enumDef_BUFFER_READ : begin
        if(when_UsbOhci_l1128) begin
          endpoint_stateNext = endpoint_enumDef_TOKEN;
          if(endpoint_timeCheck) begin
            endpoint_stateNext = endpoint_enumDef_ABORD;
          end
        end
      end
      endpoint_enumDef_TOKEN : begin
        if(token_wantExit) begin
          if(endpoint_isIn) begin
            endpoint_stateNext = endpoint_enumDef_DATA_RX;
          end else begin
            endpoint_stateNext = endpoint_enumDef_DATA_TX;
          end
        end
      end
      endpoint_enumDef_DATA_TX : begin
        if(dataTx_wantExit) begin
          if(endpoint_ED_F) begin
            endpoint_stateNext = endpoint_enumDef_UPDATE_TD_PROCESS;
          end else begin
            endpoint_stateNext = endpoint_enumDef_ACK_RX;
          end
        end
      end
      endpoint_enumDef_DATA_RX : begin
        if(dataRx_wantExit) begin
          endpoint_stateNext = endpoint_enumDef_DATA_RX_VALIDATE;
        end
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
        endpoint_stateNext = endpoint_enumDef_DATA_RX_WAIT_DMA;
        if(!dataRx_notResponding) begin
          if(!dataRx_stuffingError) begin
            if(!dataRx_pidError) begin
              if(!endpoint_ED_F) begin
                case(dataRx_pid)
                  4'b1010 : begin
                  end
                  4'b1110 : begin
                  end
                  4'b0011, 4'b1011 : begin
                    if(when_UsbOhci_l1263) begin
                      endpoint_stateNext = endpoint_enumDef_ACK_TX_0;
                    end
                  end
                  default : begin
                  end
                endcase
              end
              if(when_UsbOhci_l1274) begin
                if(!dataRx_crcError) begin
                  if(when_UsbOhci_l1283) begin
                    endpoint_stateNext = endpoint_enumDef_ACK_TX_0;
                  end
                end
              end
            end
          end
        end
      end
      endpoint_enumDef_ACK_RX : begin
        if(when_UsbOhci_l1205) begin
          endpoint_stateNext = endpoint_enumDef_UPDATE_TD_PROCESS;
          if(!when_UsbOhci_l1207) begin
            if(!endpoint_ackRxStuffing) begin
              if(!endpoint_ackRxPidFailure) begin
                case(endpoint_ackRxPid)
                  4'b0010 : begin
                  end
                  4'b1010 : begin
                    endpoint_stateNext = endpoint_enumDef_UPDATE_SYNC;
                  end
                  4'b1110 : begin
                  end
                  default : begin
                  end
                endcase
              end
            end
          end
        end
        if(rxTimer_rxTimeout) begin
          endpoint_stateNext = endpoint_enumDef_UPDATE_TD_PROCESS;
        end
      end
      endpoint_enumDef_ACK_TX_0 : begin
        if(rxTimer_ackTx) begin
          endpoint_stateNext = endpoint_enumDef_ACK_TX_1;
        end
      end
      endpoint_enumDef_ACK_TX_1 : begin
        if(io_phy_tx_ready) begin
          endpoint_stateNext = endpoint_enumDef_ACK_TX_EOP;
        end
      end
      endpoint_enumDef_ACK_TX_EOP : begin
        if(io_phy_txEop) begin
          endpoint_stateNext = endpoint_enumDef_DATA_RX_WAIT_DMA;
        end
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
        if(when_UsbOhci_l1311) begin
          endpoint_stateNext = endpoint_enumDef_UPDATE_TD_PROCESS;
        end
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
        endpoint_stateNext = endpoint_enumDef_UPDATE_TD_CMD;
        if(!endpoint_ED_F) begin
          if(endpoint_TD_noUpdate) begin
            endpoint_stateNext = endpoint_enumDef_UPDATE_SYNC;
          end
        end
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
        if(when_UsbOhci_l1393) begin
          endpoint_stateNext = endpoint_enumDef_UPDATE_ED_CMD;
        end
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
        if(when_UsbOhci_l1408) begin
          endpoint_stateNext = endpoint_enumDef_UPDATE_SYNC;
        end
      end
      endpoint_enumDef_UPDATE_SYNC : begin
        if(dmaCtx_pendingEmpty) begin
          endpoint_stateNext = endpoint_enumDef_BOOT;
        end
      end
      endpoint_enumDef_ABORD : begin
        endpoint_stateNext = endpoint_enumDef_BOOT;
      end
      default : begin
      end
    endcase
    if(endpoint_wantStart) begin
      endpoint_stateNext = endpoint_enumDef_ED_READ_CMD;
    end
    if(endpoint_wantKill) begin
      endpoint_stateNext = endpoint_enumDef_BOOT;
    end
  end

  assign when_UsbOhci_l188 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b000));
  assign when_UsbOhci_l188_1 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b000));
  assign when_UsbOhci_l188_2 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b001));
  assign when_UsbOhci_l188_3 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b001));
  assign when_UsbOhci_l855 = (ioDma_rsp_valid && ioDma_rsp_payload_last);
  assign when_UsbOhci_l861 = ((endpoint_ED_H || endpoint_ED_K) || endpoint_ED_tdEmpty);
  assign when_UsbOhci_l188_4 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b000));
  assign when_UsbOhci_l188_5 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b000));
  assign when_UsbOhci_l188_6 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b001));
  assign when_UsbOhci_l188_7 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b001));
  assign when_UsbOhci_l891 = (endpoint_TD_isoFrameNumber == 3'b000);
  assign when_UsbOhci_l188_8 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b010));
  assign when_UsbOhci_l188_9 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b010));
  assign when_UsbOhci_l891_1 = (endpoint_TD_isoFrameNumber == 3'b001);
  assign when_UsbOhci_l188_10 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b010));
  assign when_UsbOhci_l188_11 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b010));
  assign when_UsbOhci_l891_2 = (endpoint_TD_isoFrameNumber == 3'b010);
  assign when_UsbOhci_l188_12 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b010));
  assign when_UsbOhci_l188_13 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b010));
  assign when_UsbOhci_l891_3 = (endpoint_TD_isoFrameNumber == 3'b011);
  assign when_UsbOhci_l188_14 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b010));
  assign when_UsbOhci_l188_15 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b011));
  assign when_UsbOhci_l891_4 = (endpoint_TD_isoFrameNumber == 3'b100);
  assign when_UsbOhci_l188_16 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b011));
  assign when_UsbOhci_l188_17 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b011));
  assign when_UsbOhci_l891_5 = (endpoint_TD_isoFrameNumber == 3'b101);
  assign when_UsbOhci_l188_18 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b011));
  assign when_UsbOhci_l188_19 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b011));
  assign when_UsbOhci_l891_6 = (endpoint_TD_isoFrameNumber == 3'b110);
  assign when_UsbOhci_l188_20 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b011));
  assign when_UsbOhci_l188_21 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b011));
  assign when_UsbOhci_l891_7 = (endpoint_TD_isoFrameNumber == 3'b111);
  assign when_UsbOhci_l188_22 = (ioDma_rsp_valid && (dmaReadCtx_counter == 3'b011));
  assign when_UsbOhci_l898 = (ioDma_rsp_fire && ioDma_rsp_payload_last);
  assign _zz_endpoint_lastAddress = (_zz__zz_endpoint_lastAddress - 14'h0001);
  assign when_UsbOhci_l1118 = (endpoint_isIn || endpoint_zeroLength);
  always @(*) begin
    when_UsbOhci_l1274 = 1'b0;
    if(endpoint_ED_F) begin
      case(dataRx_pid)
        4'b1110, 4'b1010 : begin
        end
        4'b0011, 4'b1011 : begin
          when_UsbOhci_l1274 = 1'b1;
        end
        default : begin
        end
      endcase
    end else begin
      case(dataRx_pid)
        4'b1010 : begin
        end
        4'b1110 : begin
        end
        4'b0011, 4'b1011 : begin
          if(!when_UsbOhci_l1263) begin
            when_UsbOhci_l1274 = 1'b1;
          end
        end
        default : begin
        end
      endcase
    end
  end

  assign when_UsbOhci_l1263 = (dataRx_pid == endpoint_TD_dataPidWrong);
  assign when_UsbOhci_l1283 = (! endpoint_ED_F);
  assign when_UsbOhci_l1200 = ((! rxPidOk) || endpoint_ackRxFired);
  assign when_UsbOhci_l1205 = ((! io_phy_rx_active) && endpoint_ackRxActivated);
  assign when_UsbOhci_l1207 = (! endpoint_ackRxFired);
  assign when_UsbOhci_l1331 = ((endpoint_dmaLogic_underflow || (_zz_when_UsbOhci_l1331 < endpoint_currentAddress)) || endpoint_zeroLength);
  assign when_UsbOhci_l1346 = (endpoint_TD_EC != 2'b10);
  assign when_UsbOhci_l206_2 = (dmaWriteCtx_counter == 3'b000);
  assign when_UsbOhci_l206_3 = (dmaWriteCtx_counter == 3'b000);
  assign _zz_ioDma_cmd_payload_fragment_data = {endpoint_TD_CC,_zz__zz_ioDma_cmd_payload_fragment_data};
  assign when_UsbOhci_l1378 = (endpoint_TD_isoFrameNumber == 3'b000);
  assign when_UsbOhci_l206_4 = (dmaWriteCtx_counter == 3'b010);
  assign when_UsbOhci_l1378_1 = (endpoint_TD_isoFrameNumber == 3'b001);
  assign when_UsbOhci_l206_5 = (dmaWriteCtx_counter == 3'b010);
  assign when_UsbOhci_l1378_2 = (endpoint_TD_isoFrameNumber == 3'b010);
  assign when_UsbOhci_l206_6 = (dmaWriteCtx_counter == 3'b010);
  assign when_UsbOhci_l1378_3 = (endpoint_TD_isoFrameNumber == 3'b011);
  assign when_UsbOhci_l206_7 = (dmaWriteCtx_counter == 3'b010);
  assign when_UsbOhci_l1378_4 = (endpoint_TD_isoFrameNumber == 3'b100);
  assign when_UsbOhci_l206_8 = (dmaWriteCtx_counter == 3'b011);
  assign when_UsbOhci_l1378_5 = (endpoint_TD_isoFrameNumber == 3'b101);
  assign when_UsbOhci_l206_9 = (dmaWriteCtx_counter == 3'b011);
  assign when_UsbOhci_l1378_6 = (endpoint_TD_isoFrameNumber == 3'b110);
  assign when_UsbOhci_l206_10 = (dmaWriteCtx_counter == 3'b011);
  assign when_UsbOhci_l1378_7 = (endpoint_TD_isoFrameNumber == 3'b111);
  assign when_UsbOhci_l206_11 = (dmaWriteCtx_counter == 3'b011);
  assign when_UsbOhci_l206_12 = (dmaWriteCtx_counter == 3'b000);
  assign when_UsbOhci_l206_13 = (dmaWriteCtx_counter == 3'b000);
  assign when_UsbOhci_l206_14 = (dmaWriteCtx_counter == 3'b001);
  assign when_UsbOhci_l1393 = (ioDma_cmd_ready && ioDma_cmd_payload_last);
  assign when_UsbOhci_l206_15 = (dmaWriteCtx_counter == 3'b001);
  assign when_UsbOhci_l1408 = (ioDma_cmd_ready && ioDma_cmd_payload_last);
  assign when_UsbOhci_l1415 = (! (endpoint_ED_F && endpoint_TD_isoOverrunReg));
  assign when_UsbOhci_l1418 = (endpoint_flowType != FlowType_PERIODIC);
  assign when_StateMachine_l237_2 = ((endpoint_stateReg == endpoint_enumDef_BOOT) && (! (endpoint_stateNext == endpoint_enumDef_BOOT)));
  assign when_StateMachine_l253_1 = ((! (endpoint_stateReg == endpoint_enumDef_TOKEN)) && (endpoint_stateNext == endpoint_enumDef_TOKEN));
  assign when_StateMachine_l253_2 = ((! (endpoint_stateReg == endpoint_enumDef_DATA_TX)) && (endpoint_stateNext == endpoint_enumDef_DATA_TX));
  assign when_StateMachine_l253_3 = ((! (endpoint_stateReg == endpoint_enumDef_DATA_RX)) && (endpoint_stateNext == endpoint_enumDef_DATA_RX));
  assign when_StateMachine_l253_4 = ((! (endpoint_stateReg == endpoint_enumDef_ACK_RX)) && (endpoint_stateNext == endpoint_enumDef_ACK_RX));
  always @(*) begin
    endpoint_dmaLogic_stateNext = endpoint_dmaLogic_stateReg;
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
        if(endpoint_isIn) begin
          endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_FROM_USB;
        end else begin
          endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_CALC_CMD;
        end
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
        if(dataTx_data_ready) begin
          if(endpoint_dmaLogic_byteCtx_last) begin
            endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_BOOT;
          end
        end
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
        if(dataRx_wantExit) begin
          endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_VALIDATION;
        end
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
        if(when_UsbOhci_l1068) begin
          endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_BOOT;
        end else begin
          if(endpoint_dmaLogic_validated) begin
            endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_CALC_CMD;
          end
        end
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
        if(endpoint_dataDone) begin
          if(endpoint_isIn) begin
            endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_BOOT;
          end else begin
            if(dmaCtx_pendingEmpty) begin
              endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_TO_USB;
            end
          end
        end else begin
          if(endpoint_isIn) begin
            endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_WRITE_CMD;
          end else begin
            endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_READ_CMD;
          end
        end
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
        if(ioDma_cmd_ready) begin
          endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_CALC_CMD;
        end
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        if(ioDma_cmd_ready) begin
          if(endpoint_dmaLogic_beatLast) begin
            endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_CALC_CMD;
          end
        end
      end
      default : begin
      end
    endcase
    if(endpoint_dmaLogic_wantStart) begin
      endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_INIT;
    end
    if(endpoint_dmaLogic_wantKill) begin
      endpoint_dmaLogic_stateNext = endpoint_dmaLogic_enumDef_BOOT;
    end
  end

  assign when_UsbOhci_l1025 = (&endpoint_dmaLogic_byteCtx_sel);
  assign when_UsbOhci_l1054 = (_zz_when_UsbOhci_l1054 < endpoint_transactionSize);
  assign _zz_2 = ({7'd0,1'b1} <<< endpoint_dmaLogic_byteCtx_sel);
  assign when_UsbOhci_l1063 = (&endpoint_dmaLogic_byteCtx_sel);
  assign when_UsbOhci_l1068 = (endpoint_dmaLogic_fromUsbCounter == 11'h000);
  assign when_StateMachine_l253_5 = ((! (endpoint_dmaLogic_stateReg == endpoint_dmaLogic_enumDef_FROM_USB)) && (endpoint_dmaLogic_stateNext == endpoint_dmaLogic_enumDef_FROM_USB));
  assign endpoint_dmaLogic_fsmStopped = (endpoint_dmaLogic_stateReg == endpoint_dmaLogic_enumDef_BOOT);
  assign when_UsbOhci_l1128 = (endpoint_dmaLogic_stateReg == endpoint_dmaLogic_enumDef_TO_USB);
  assign when_UsbOhci_l1311 = (endpoint_dmaLogic_stateReg == endpoint_dmaLogic_enumDef_BOOT);
  always @(*) begin
    operational_stateNext = operational_stateReg;
    case(operational_stateReg)
      operational_enumDef_SOF : begin
        if(sof_wantExit) begin
          operational_stateNext = operational_enumDef_ARBITER;
        end
      end
      operational_enumDef_ARBITER : begin
        if(operational_askExit) begin
          operational_stateNext = operational_enumDef_BOOT;
        end else begin
          if(frame_limitHit) begin
            operational_stateNext = operational_enumDef_WAIT_SOF;
          end else begin
            if(when_UsbOhci_l1487) begin
              if(when_UsbOhci_l1488) begin
                operational_stateNext = operational_enumDef_PERIODIC_HEAD_CMD;
              end else begin
                if(!reg_hcPeriodCurrentED_isZero) begin
                  operational_stateNext = operational_enumDef_END_POINT;
                end
              end
            end else begin
              if(priority_bulk) begin
                if(operational_allowBulk) begin
                  if(!reg_hcBulkCurrentED_isZero) begin
                    operational_stateNext = operational_enumDef_END_POINT;
                  end
                end
              end else begin
                if(operational_allowControl) begin
                  if(!reg_hcControlCurrentED_isZero) begin
                    operational_stateNext = operational_enumDef_END_POINT;
                  end
                end
              end
            end
          end
        end
      end
      operational_enumDef_END_POINT : begin
        if(endpoint_wantExit) begin
          case(endpoint_status_1)
            endpoint_Status_OK : begin
              operational_stateNext = operational_enumDef_ARBITER;
            end
            default : begin
              operational_stateNext = operational_enumDef_WAIT_SOF;
            end
          endcase
        end
      end
      operational_enumDef_PERIODIC_HEAD_CMD : begin
        if(ioDma_cmd_ready) begin
          operational_stateNext = operational_enumDef_PERIODIC_HEAD_RSP;
        end
      end
      operational_enumDef_PERIODIC_HEAD_RSP : begin
        if(ioDma_rsp_valid) begin
          operational_stateNext = operational_enumDef_ARBITER;
        end
      end
      operational_enumDef_WAIT_SOF : begin
        if(frame_tick) begin
          operational_stateNext = operational_enumDef_SOF;
        end
      end
      default : begin
      end
    endcase
    if(operational_wantStart) begin
      operational_stateNext = operational_enumDef_WAIT_SOF;
    end
    if(operational_wantKill) begin
      operational_stateNext = operational_enumDef_BOOT;
    end
  end

  assign when_UsbOhci_l1461 = (operational_allowPeriodic && (! operational_periodicDone));
  assign when_UsbOhci_l1488 = (! operational_periodicHeadFetched);
  assign when_UsbOhci_l1487 = ((operational_allowPeriodic && (! operational_periodicDone)) && (! frame_section1));
  assign when_StateMachine_l237_3 = ((operational_stateReg == operational_enumDef_BOOT) && (! (operational_stateNext == operational_enumDef_BOOT)));
  assign when_StateMachine_l253_6 = ((! (operational_stateReg == operational_enumDef_SOF)) && (operational_stateNext == operational_enumDef_SOF));
  assign hc_operationalIsDone = (operational_stateReg == operational_enumDef_BOOT);
  always @(*) begin
    hc_stateNext = hc_stateReg;
    case(hc_stateReg)
      hc_enumDef_RESET : begin
        if(reg_hcControl_HCFSWrite_valid) begin
          case(reg_hcControl_HCFSWrite_payload)
            MainState_OPERATIONAL : begin
              hc_stateNext = hc_enumDef_OPERATIONAL;
            end
            default : begin
            end
          endcase
        end
      end
      hc_enumDef_RESUME : begin
        if(when_UsbOhci_l1616) begin
          hc_stateNext = hc_enumDef_OPERATIONAL;
        end
      end
      hc_enumDef_OPERATIONAL : begin
      end
      hc_enumDef_SUSPEND : begin
        if(when_UsbOhci_l1625) begin
          hc_stateNext = hc_enumDef_RESUME;
        end else begin
          if(when_UsbOhci_l1628) begin
            hc_stateNext = hc_enumDef_OPERATIONAL;
          end
        end
      end
      hc_enumDef_ANY_TO_RESET : begin
        if(when_UsbOhci_l1639) begin
          hc_stateNext = hc_enumDef_RESET;
        end
      end
      hc_enumDef_ANY_TO_SUSPEND : begin
        if(when_UsbOhci_l1652) begin
          hc_stateNext = hc_enumDef_SUSPEND;
        end
      end
      default : begin
      end
    endcase
    if(when_UsbOhci_l1659) begin
      hc_stateNext = hc_enumDef_ANY_TO_RESET;
    end
    if(reg_hcCommandStatus_startSoftReset) begin
      hc_stateNext = hc_enumDef_ANY_TO_SUSPEND;
    end
    if(hc_wantStart) begin
      hc_stateNext = hc_enumDef_RESET;
    end
    if(hc_wantKill) begin
      hc_stateNext = hc_enumDef_BOOT;
    end
  end

  assign when_UsbOhci_l1616 = (reg_hcControl_HCFSWrite_valid && (reg_hcControl_HCFSWrite_payload == MainState_OPERATIONAL));
  assign when_UsbOhci_l1625 = (reg_hcRhStatus_DRWE && (|{reg_hcRhPortStatus_3_CSC_reg,{reg_hcRhPortStatus_2_CSC_reg,{reg_hcRhPortStatus_1_CSC_reg,reg_hcRhPortStatus_0_CSC_reg}}}));
  assign when_UsbOhci_l1628 = (reg_hcControl_HCFSWrite_valid && (reg_hcControl_HCFSWrite_payload == MainState_OPERATIONAL));
  assign when_UsbOhci_l1639 = (! doUnschedule);
  assign when_UsbOhci_l1652 = (((! doUnschedule) && (! doSoftReset)) && hc_operationalIsDone);
  assign when_StateMachine_l253_7 = ((! (hc_stateReg == hc_enumDef_OPERATIONAL)) && (hc_stateNext == hc_enumDef_OPERATIONAL));
  assign when_StateMachine_l253_8 = ((! (hc_stateReg == hc_enumDef_ANY_TO_RESET)) && (hc_stateNext == hc_enumDef_ANY_TO_RESET));
  assign when_StateMachine_l253_9 = ((! (hc_stateReg == hc_enumDef_ANY_TO_SUSPEND)) && (hc_stateNext == hc_enumDef_ANY_TO_SUSPEND));
  assign when_UsbOhci_l1659 = (reg_hcControl_HCFSWrite_valid && (reg_hcControl_HCFSWrite_payload == MainState_RESET));
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      dmaCtx_pendingCounter <= 4'b0000;
      dmaCtx_beatCounter <= 6'h00;
      io_dma_cmd_payload_first <= 1'b1;
      dmaReadCtx_counter <= 3'b000;
      dmaWriteCtx_counter <= 3'b000;
      _zz_io_ctrl_rsp_valid_1 <= 1'b0;
      doUnschedule <= 1'b0;
      doSoftReset <= 1'b0;
      reg_hcControl_IR <= 1'b0;
      reg_hcControl_RWC <= 1'b0;
      reg_hcFmNumber_overflow <= 1'b0;
      reg_hcPeriodicStart_PS <= 14'h0000;
      io_phy_overcurrent_regNext <= 1'b0;
      reg_hcRhPortStatus_0_connected <= 1'b0;
      reg_hcRhPortStatus_0_CCS_regNext <= 1'b0;
      reg_hcRhPortStatus_1_connected <= 1'b0;
      reg_hcRhPortStatus_1_CCS_regNext <= 1'b0;
      reg_hcRhPortStatus_2_connected <= 1'b0;
      reg_hcRhPortStatus_2_CCS_regNext <= 1'b0;
      reg_hcRhPortStatus_3_connected <= 1'b0;
      reg_hcRhPortStatus_3_CCS_regNext <= 1'b0;
      interruptDelay_counter <= 3'b111;
      endpoint_dmaLogic_push <= 1'b0;
      _zz_when_UsbOhci_l253 <= 1'b1;
      token_stateReg <= token_enumDef_BOOT;
      dataTx_stateReg <= dataTx_enumDef_BOOT;
      dataRx_stateReg <= dataRx_enumDef_BOOT;
      sof_stateReg <= sof_enumDef_BOOT;
      endpoint_stateReg <= endpoint_enumDef_BOOT;
      endpoint_dmaLogic_stateReg <= endpoint_dmaLogic_enumDef_BOOT;
      operational_stateReg <= operational_enumDef_BOOT;
      hc_stateReg <= hc_enumDef_BOOT;
    end else begin
      dmaCtx_pendingCounter <= (_zz_dmaCtx_pendingCounter - _zz_dmaCtx_pendingCounter_3);
      if(ioDma_cmd_fire) begin
        dmaCtx_beatCounter <= (dmaCtx_beatCounter + 6'h01);
        if(io_dma_cmd_payload_last) begin
          dmaCtx_beatCounter <= 6'h00;
        end
      end
      if(io_dma_cmd_fire) begin
        io_dma_cmd_payload_first <= io_dma_cmd_payload_last;
      end
      if(ioDma_rsp_fire) begin
        dmaReadCtx_counter <= (dmaReadCtx_counter + 3'b001);
        if(ioDma_rsp_payload_last) begin
          dmaReadCtx_counter <= 3'b000;
        end
      end
      if(ioDma_cmd_fire) begin
        dmaWriteCtx_counter <= (dmaWriteCtx_counter + 3'b001);
        if(ioDma_cmd_payload_last) begin
          dmaWriteCtx_counter <= 3'b000;
        end
      end
      if(_zz_ctrl_rsp_ready_1) begin
        _zz_io_ctrl_rsp_valid_1 <= (ctrl_rsp_valid && _zz_ctrl_rsp_ready);
      end
      if(unscheduleAll_ready) begin
        doUnschedule <= 1'b0;
      end
      if(when_UsbOhci_l236) begin
        doSoftReset <= 1'b0;
      end
      io_phy_overcurrent_regNext <= io_phy_overcurrent;
      if(io_phy_ports_0_connect) begin
        reg_hcRhPortStatus_0_connected <= 1'b1;
      end
      if(io_phy_ports_0_disconnect) begin
        reg_hcRhPortStatus_0_connected <= 1'b0;
      end
      reg_hcRhPortStatus_0_CCS_regNext <= reg_hcRhPortStatus_0_CCS;
      if(io_phy_ports_1_connect) begin
        reg_hcRhPortStatus_1_connected <= 1'b1;
      end
      if(io_phy_ports_1_disconnect) begin
        reg_hcRhPortStatus_1_connected <= 1'b0;
      end
      reg_hcRhPortStatus_1_CCS_regNext <= reg_hcRhPortStatus_1_CCS;
      if(io_phy_ports_2_connect) begin
        reg_hcRhPortStatus_2_connected <= 1'b1;
      end
      if(io_phy_ports_2_disconnect) begin
        reg_hcRhPortStatus_2_connected <= 1'b0;
      end
      reg_hcRhPortStatus_2_CCS_regNext <= reg_hcRhPortStatus_2_CCS;
      if(io_phy_ports_3_connect) begin
        reg_hcRhPortStatus_3_connected <= 1'b1;
      end
      if(io_phy_ports_3_disconnect) begin
        reg_hcRhPortStatus_3_connected <= 1'b0;
      end
      reg_hcRhPortStatus_3_CCS_regNext <= reg_hcRhPortStatus_3_CCS;
      if(frame_reload) begin
        if(when_UsbOhci_l540) begin
          reg_hcFmNumber_overflow <= 1'b1;
        end
      end
      if(when_UsbOhci_l685) begin
        interruptDelay_counter <= (interruptDelay_counter - 3'b001);
      end
      if(when_UsbOhci_l689) begin
        interruptDelay_counter <= interruptDelay_load_payload;
      end
      if(interruptDelay_disable) begin
        interruptDelay_counter <= 3'b111;
      end
      endpoint_dmaLogic_push <= 1'b0;
      case(io_ctrl_cmd_payload_fragment_address)
        12'h004 : begin
          if(ctrl_doWrite) begin
            if(when_BusSlaveFactory_l1021_5) begin
              reg_hcControl_IR <= io_ctrl_cmd_payload_fragment_data[8];
            end
            if(when_BusSlaveFactory_l1021_6) begin
              reg_hcControl_RWC <= io_ctrl_cmd_payload_fragment_data[9];
            end
          end
        end
        12'h040 : begin
          if(ctrl_doWrite) begin
            if(when_BusSlaveFactory_l1021_36) begin
              reg_hcPeriodicStart_PS[7 : 0] <= io_ctrl_cmd_payload_fragment_data[7 : 0];
            end
            if(when_BusSlaveFactory_l1021_37) begin
              reg_hcPeriodicStart_PS[13 : 8] <= io_ctrl_cmd_payload_fragment_data[13 : 8];
            end
          end
        end
        default : begin
        end
      endcase
      _zz_when_UsbOhci_l253 <= 1'b0;
      token_stateReg <= token_stateNext;
      dataTx_stateReg <= dataTx_stateNext;
      dataRx_stateReg <= dataRx_stateNext;
      sof_stateReg <= sof_stateNext;
      case(sof_stateReg)
        sof_enumDef_FRAME_TX : begin
        end
        sof_enumDef_FRAME_NUMBER_CMD : begin
        end
        sof_enumDef_FRAME_NUMBER_RSP : begin
          if(ioDma_rsp_valid) begin
            reg_hcFmNumber_overflow <= 1'b0;
          end
        end
        default : begin
        end
      endcase
      endpoint_stateReg <= endpoint_stateNext;
      endpoint_dmaLogic_stateReg <= endpoint_dmaLogic_stateNext;
      case(endpoint_dmaLogic_stateReg)
        endpoint_dmaLogic_enumDef_INIT : begin
        end
        endpoint_dmaLogic_enumDef_TO_USB : begin
        end
        endpoint_dmaLogic_enumDef_FROM_USB : begin
          if(dataRx_wantExit) begin
            endpoint_dmaLogic_push <= (|endpoint_dmaLogic_byteCtx_sel);
          end
          if(dataRx_data_valid) begin
            if(when_UsbOhci_l1063) begin
              endpoint_dmaLogic_push <= 1'b1;
            end
          end
        end
        endpoint_dmaLogic_enumDef_VALIDATION : begin
        end
        endpoint_dmaLogic_enumDef_CALC_CMD : begin
        end
        endpoint_dmaLogic_enumDef_READ_CMD : begin
        end
        endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        end
        default : begin
        end
      endcase
      operational_stateReg <= operational_stateNext;
      hc_stateReg <= hc_stateNext;
      if(when_StateMachine_l253_8) begin
        doUnschedule <= 1'b1;
      end
      if(when_StateMachine_l253_9) begin
        doUnschedule <= 1'b1;
      end
      if(reg_hcCommandStatus_startSoftReset) begin
        doSoftReset <= 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if(_zz_ctrl_rsp_ready_1) begin
      _zz_io_ctrl_rsp_payload_last <= ctrl_rsp_payload_last;
      _zz_io_ctrl_rsp_payload_fragment_opcode <= ctrl_rsp_payload_fragment_opcode;
      _zz_io_ctrl_rsp_payload_fragment_data <= ctrl_rsp_payload_fragment_data;
    end
    if(when_BusSlaveFactory_l377_1) begin
      if(when_BusSlaveFactory_l379_1) begin
        reg_hcCommandStatus_CLF <= _zz_reg_hcCommandStatus_CLF[0];
      end
    end
    if(when_BusSlaveFactory_l377_2) begin
      if(when_BusSlaveFactory_l379_2) begin
        reg_hcCommandStatus_BLF <= _zz_reg_hcCommandStatus_BLF[0];
      end
    end
    if(when_BusSlaveFactory_l377_3) begin
      if(when_BusSlaveFactory_l379_3) begin
        reg_hcCommandStatus_OCR <= _zz_reg_hcCommandStatus_OCR[0];
      end
    end
    if(when_BusSlaveFactory_l377_4) begin
      if(when_BusSlaveFactory_l379_4) begin
        reg_hcInterrupt_MIE <= _zz_reg_hcInterrupt_MIE[0];
      end
    end
    if(when_BusSlaveFactory_l341) begin
      if(when_BusSlaveFactory_l347) begin
        reg_hcInterrupt_MIE <= _zz_reg_hcInterrupt_MIE_1[0];
      end
    end
    if(when_BusSlaveFactory_l341_1) begin
      if(when_BusSlaveFactory_l347_1) begin
        reg_hcInterrupt_SO_status <= _zz_reg_hcInterrupt_SO_status[0];
      end
    end
    if(when_BusSlaveFactory_l377_5) begin
      if(when_BusSlaveFactory_l379_5) begin
        reg_hcInterrupt_SO_enable <= _zz_reg_hcInterrupt_SO_enable[0];
      end
    end
    if(when_BusSlaveFactory_l341_2) begin
      if(when_BusSlaveFactory_l347_2) begin
        reg_hcInterrupt_SO_enable <= _zz_reg_hcInterrupt_SO_enable_1[0];
      end
    end
    if(when_BusSlaveFactory_l341_3) begin
      if(when_BusSlaveFactory_l347_3) begin
        reg_hcInterrupt_WDH_status <= _zz_reg_hcInterrupt_WDH_status[0];
      end
    end
    if(when_BusSlaveFactory_l377_6) begin
      if(when_BusSlaveFactory_l379_6) begin
        reg_hcInterrupt_WDH_enable <= _zz_reg_hcInterrupt_WDH_enable[0];
      end
    end
    if(when_BusSlaveFactory_l341_4) begin
      if(when_BusSlaveFactory_l347_4) begin
        reg_hcInterrupt_WDH_enable <= _zz_reg_hcInterrupt_WDH_enable_1[0];
      end
    end
    if(when_BusSlaveFactory_l341_5) begin
      if(when_BusSlaveFactory_l347_5) begin
        reg_hcInterrupt_SF_status <= _zz_reg_hcInterrupt_SF_status[0];
      end
    end
    if(when_BusSlaveFactory_l377_7) begin
      if(when_BusSlaveFactory_l379_7) begin
        reg_hcInterrupt_SF_enable <= _zz_reg_hcInterrupt_SF_enable[0];
      end
    end
    if(when_BusSlaveFactory_l341_6) begin
      if(when_BusSlaveFactory_l347_6) begin
        reg_hcInterrupt_SF_enable <= _zz_reg_hcInterrupt_SF_enable_1[0];
      end
    end
    if(when_BusSlaveFactory_l341_7) begin
      if(when_BusSlaveFactory_l347_7) begin
        reg_hcInterrupt_RD_status <= _zz_reg_hcInterrupt_RD_status[0];
      end
    end
    if(when_BusSlaveFactory_l377_8) begin
      if(when_BusSlaveFactory_l379_8) begin
        reg_hcInterrupt_RD_enable <= _zz_reg_hcInterrupt_RD_enable[0];
      end
    end
    if(when_BusSlaveFactory_l341_8) begin
      if(when_BusSlaveFactory_l347_8) begin
        reg_hcInterrupt_RD_enable <= _zz_reg_hcInterrupt_RD_enable_1[0];
      end
    end
    if(when_BusSlaveFactory_l341_9) begin
      if(when_BusSlaveFactory_l347_9) begin
        reg_hcInterrupt_UE_status <= _zz_reg_hcInterrupt_UE_status[0];
      end
    end
    if(when_BusSlaveFactory_l377_9) begin
      if(when_BusSlaveFactory_l379_9) begin
        reg_hcInterrupt_UE_enable <= _zz_reg_hcInterrupt_UE_enable[0];
      end
    end
    if(when_BusSlaveFactory_l341_10) begin
      if(when_BusSlaveFactory_l347_10) begin
        reg_hcInterrupt_UE_enable <= _zz_reg_hcInterrupt_UE_enable_1[0];
      end
    end
    if(when_BusSlaveFactory_l341_11) begin
      if(when_BusSlaveFactory_l347_11) begin
        reg_hcInterrupt_FNO_status <= _zz_reg_hcInterrupt_FNO_status[0];
      end
    end
    if(when_BusSlaveFactory_l377_10) begin
      if(when_BusSlaveFactory_l379_10) begin
        reg_hcInterrupt_FNO_enable <= _zz_reg_hcInterrupt_FNO_enable[0];
      end
    end
    if(when_BusSlaveFactory_l341_12) begin
      if(when_BusSlaveFactory_l347_12) begin
        reg_hcInterrupt_FNO_enable <= _zz_reg_hcInterrupt_FNO_enable_1[0];
      end
    end
    if(when_BusSlaveFactory_l341_13) begin
      if(when_BusSlaveFactory_l347_13) begin
        reg_hcInterrupt_RHSC_status <= _zz_reg_hcInterrupt_RHSC_status[0];
      end
    end
    if(when_BusSlaveFactory_l377_11) begin
      if(when_BusSlaveFactory_l379_11) begin
        reg_hcInterrupt_RHSC_enable <= _zz_reg_hcInterrupt_RHSC_enable[0];
      end
    end
    if(when_BusSlaveFactory_l341_14) begin
      if(when_BusSlaveFactory_l347_14) begin
        reg_hcInterrupt_RHSC_enable <= _zz_reg_hcInterrupt_RHSC_enable_1[0];
      end
    end
    if(when_BusSlaveFactory_l341_15) begin
      if(when_BusSlaveFactory_l347_15) begin
        reg_hcInterrupt_OC_status <= _zz_reg_hcInterrupt_OC_status[0];
      end
    end
    if(when_BusSlaveFactory_l377_12) begin
      if(when_BusSlaveFactory_l379_12) begin
        reg_hcInterrupt_OC_enable <= _zz_reg_hcInterrupt_OC_enable[0];
      end
    end
    if(when_BusSlaveFactory_l341_16) begin
      if(when_BusSlaveFactory_l347_16) begin
        reg_hcInterrupt_OC_enable <= _zz_reg_hcInterrupt_OC_enable_1[0];
      end
    end
    if(reg_hcCommandStatus_OCR) begin
      reg_hcInterrupt_OC_status <= 1'b1;
    end
    if(when_BusSlaveFactory_l341_17) begin
      if(when_BusSlaveFactory_l347_17) begin
        reg_hcRhStatus_CCIC <= _zz_reg_hcRhStatus_CCIC[0];
      end
    end
    if(when_UsbOhci_l409) begin
      reg_hcRhStatus_CCIC <= 1'b1;
    end
    if(reg_hcRhStatus_setRemoteWakeupEnable) begin
      reg_hcRhStatus_DRWE <= 1'b1;
    end
    if(reg_hcRhStatus_clearRemoteWakeupEnable) begin
      reg_hcRhStatus_DRWE <= 1'b0;
    end
    if(reg_hcRhPortStatus_0_CSC_clear) begin
      reg_hcRhPortStatus_0_CSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_0_CSC_set) begin
      reg_hcRhPortStatus_0_CSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_0_CSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_0_PESC_clear) begin
      reg_hcRhPortStatus_0_PESC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_0_PESC_set) begin
      reg_hcRhPortStatus_0_PESC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_0_PESC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_0_PSSC_clear) begin
      reg_hcRhPortStatus_0_PSSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_0_PSSC_set) begin
      reg_hcRhPortStatus_0_PSSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_0_PSSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_0_OCIC_clear) begin
      reg_hcRhPortStatus_0_OCIC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_0_OCIC_set) begin
      reg_hcRhPortStatus_0_OCIC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_0_OCIC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_0_PRSC_clear) begin
      reg_hcRhPortStatus_0_PRSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_0_PRSC_set) begin
      reg_hcRhPortStatus_0_PRSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_0_PRSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(when_UsbOhci_l460) begin
      reg_hcRhPortStatus_0_PES <= 1'b0;
    end
    if(when_UsbOhci_l460_1) begin
      reg_hcRhPortStatus_0_PES <= 1'b1;
    end
    if(when_UsbOhci_l460_2) begin
      reg_hcRhPortStatus_0_PES <= 1'b1;
    end
    if(when_UsbOhci_l461) begin
      reg_hcRhPortStatus_0_PSS <= 1'b0;
    end
    if(when_UsbOhci_l461_1) begin
      reg_hcRhPortStatus_0_PSS <= 1'b1;
    end
    if(when_UsbOhci_l462) begin
      reg_hcRhPortStatus_0_suspend <= 1'b1;
    end
    if(when_UsbOhci_l463) begin
      reg_hcRhPortStatus_0_resume <= 1'b1;
    end
    if(when_UsbOhci_l464) begin
      reg_hcRhPortStatus_0_reset <= 1'b1;
    end
    if(reg_hcRhDescriptorA_NPS) begin
      reg_hcRhPortStatus_0_PPS <= 1'b1;
    end else begin
      if(reg_hcRhDescriptorA_PSM) begin
        if(when_UsbOhci_l470) begin
          if(reg_hcRhPortStatus_0_clearPortPower) begin
            reg_hcRhPortStatus_0_PPS <= 1'b0;
          end
          if(reg_hcRhPortStatus_0_setPortPower) begin
            reg_hcRhPortStatus_0_PPS <= 1'b1;
          end
        end else begin
          if(reg_hcRhStatus_clearGlobalPower) begin
            reg_hcRhPortStatus_0_PPS <= 1'b0;
          end
          if(reg_hcRhStatus_setGlobalPower) begin
            reg_hcRhPortStatus_0_PPS <= 1'b1;
          end
        end
      end else begin
        if(reg_hcRhStatus_clearGlobalPower) begin
          reg_hcRhPortStatus_0_PPS <= 1'b0;
        end
        if(reg_hcRhStatus_setGlobalPower) begin
          reg_hcRhPortStatus_0_PPS <= 1'b1;
        end
      end
    end
    if(io_phy_ports_0_resume_fire) begin
      reg_hcRhPortStatus_0_resume <= 1'b0;
    end
    if(io_phy_ports_0_reset_fire) begin
      reg_hcRhPortStatus_0_reset <= 1'b0;
    end
    if(io_phy_ports_0_suspend_fire) begin
      reg_hcRhPortStatus_0_suspend <= 1'b0;
    end
    if(reg_hcRhPortStatus_1_CSC_clear) begin
      reg_hcRhPortStatus_1_CSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_1_CSC_set) begin
      reg_hcRhPortStatus_1_CSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_1_CSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_1_PESC_clear) begin
      reg_hcRhPortStatus_1_PESC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_1_PESC_set) begin
      reg_hcRhPortStatus_1_PESC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_1_PESC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_1_PSSC_clear) begin
      reg_hcRhPortStatus_1_PSSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_1_PSSC_set) begin
      reg_hcRhPortStatus_1_PSSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_1_PSSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_1_OCIC_clear) begin
      reg_hcRhPortStatus_1_OCIC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_1_OCIC_set) begin
      reg_hcRhPortStatus_1_OCIC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_1_OCIC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_1_PRSC_clear) begin
      reg_hcRhPortStatus_1_PRSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_1_PRSC_set) begin
      reg_hcRhPortStatus_1_PRSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_1_PRSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(when_UsbOhci_l460_3) begin
      reg_hcRhPortStatus_1_PES <= 1'b0;
    end
    if(when_UsbOhci_l460_4) begin
      reg_hcRhPortStatus_1_PES <= 1'b1;
    end
    if(when_UsbOhci_l460_5) begin
      reg_hcRhPortStatus_1_PES <= 1'b1;
    end
    if(when_UsbOhci_l461_2) begin
      reg_hcRhPortStatus_1_PSS <= 1'b0;
    end
    if(when_UsbOhci_l461_3) begin
      reg_hcRhPortStatus_1_PSS <= 1'b1;
    end
    if(when_UsbOhci_l462_1) begin
      reg_hcRhPortStatus_1_suspend <= 1'b1;
    end
    if(when_UsbOhci_l463_1) begin
      reg_hcRhPortStatus_1_resume <= 1'b1;
    end
    if(when_UsbOhci_l464_1) begin
      reg_hcRhPortStatus_1_reset <= 1'b1;
    end
    if(reg_hcRhDescriptorA_NPS) begin
      reg_hcRhPortStatus_1_PPS <= 1'b1;
    end else begin
      if(reg_hcRhDescriptorA_PSM) begin
        if(when_UsbOhci_l470_1) begin
          if(reg_hcRhPortStatus_1_clearPortPower) begin
            reg_hcRhPortStatus_1_PPS <= 1'b0;
          end
          if(reg_hcRhPortStatus_1_setPortPower) begin
            reg_hcRhPortStatus_1_PPS <= 1'b1;
          end
        end else begin
          if(reg_hcRhStatus_clearGlobalPower) begin
            reg_hcRhPortStatus_1_PPS <= 1'b0;
          end
          if(reg_hcRhStatus_setGlobalPower) begin
            reg_hcRhPortStatus_1_PPS <= 1'b1;
          end
        end
      end else begin
        if(reg_hcRhStatus_clearGlobalPower) begin
          reg_hcRhPortStatus_1_PPS <= 1'b0;
        end
        if(reg_hcRhStatus_setGlobalPower) begin
          reg_hcRhPortStatus_1_PPS <= 1'b1;
        end
      end
    end
    if(io_phy_ports_1_resume_fire) begin
      reg_hcRhPortStatus_1_resume <= 1'b0;
    end
    if(io_phy_ports_1_reset_fire) begin
      reg_hcRhPortStatus_1_reset <= 1'b0;
    end
    if(io_phy_ports_1_suspend_fire) begin
      reg_hcRhPortStatus_1_suspend <= 1'b0;
    end
    if(reg_hcRhPortStatus_2_CSC_clear) begin
      reg_hcRhPortStatus_2_CSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_2_CSC_set) begin
      reg_hcRhPortStatus_2_CSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_2_CSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_2_PESC_clear) begin
      reg_hcRhPortStatus_2_PESC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_2_PESC_set) begin
      reg_hcRhPortStatus_2_PESC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_2_PESC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_2_PSSC_clear) begin
      reg_hcRhPortStatus_2_PSSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_2_PSSC_set) begin
      reg_hcRhPortStatus_2_PSSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_2_PSSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_2_OCIC_clear) begin
      reg_hcRhPortStatus_2_OCIC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_2_OCIC_set) begin
      reg_hcRhPortStatus_2_OCIC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_2_OCIC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_2_PRSC_clear) begin
      reg_hcRhPortStatus_2_PRSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_2_PRSC_set) begin
      reg_hcRhPortStatus_2_PRSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_2_PRSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(when_UsbOhci_l460_6) begin
      reg_hcRhPortStatus_2_PES <= 1'b0;
    end
    if(when_UsbOhci_l460_7) begin
      reg_hcRhPortStatus_2_PES <= 1'b1;
    end
    if(when_UsbOhci_l460_8) begin
      reg_hcRhPortStatus_2_PES <= 1'b1;
    end
    if(when_UsbOhci_l461_4) begin
      reg_hcRhPortStatus_2_PSS <= 1'b0;
    end
    if(when_UsbOhci_l461_5) begin
      reg_hcRhPortStatus_2_PSS <= 1'b1;
    end
    if(when_UsbOhci_l462_2) begin
      reg_hcRhPortStatus_2_suspend <= 1'b1;
    end
    if(when_UsbOhci_l463_2) begin
      reg_hcRhPortStatus_2_resume <= 1'b1;
    end
    if(when_UsbOhci_l464_2) begin
      reg_hcRhPortStatus_2_reset <= 1'b1;
    end
    if(reg_hcRhDescriptorA_NPS) begin
      reg_hcRhPortStatus_2_PPS <= 1'b1;
    end else begin
      if(reg_hcRhDescriptorA_PSM) begin
        if(when_UsbOhci_l470_2) begin
          if(reg_hcRhPortStatus_2_clearPortPower) begin
            reg_hcRhPortStatus_2_PPS <= 1'b0;
          end
          if(reg_hcRhPortStatus_2_setPortPower) begin
            reg_hcRhPortStatus_2_PPS <= 1'b1;
          end
        end else begin
          if(reg_hcRhStatus_clearGlobalPower) begin
            reg_hcRhPortStatus_2_PPS <= 1'b0;
          end
          if(reg_hcRhStatus_setGlobalPower) begin
            reg_hcRhPortStatus_2_PPS <= 1'b1;
          end
        end
      end else begin
        if(reg_hcRhStatus_clearGlobalPower) begin
          reg_hcRhPortStatus_2_PPS <= 1'b0;
        end
        if(reg_hcRhStatus_setGlobalPower) begin
          reg_hcRhPortStatus_2_PPS <= 1'b1;
        end
      end
    end
    if(io_phy_ports_2_resume_fire) begin
      reg_hcRhPortStatus_2_resume <= 1'b0;
    end
    if(io_phy_ports_2_reset_fire) begin
      reg_hcRhPortStatus_2_reset <= 1'b0;
    end
    if(io_phy_ports_2_suspend_fire) begin
      reg_hcRhPortStatus_2_suspend <= 1'b0;
    end
    if(reg_hcRhPortStatus_3_CSC_clear) begin
      reg_hcRhPortStatus_3_CSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_3_CSC_set) begin
      reg_hcRhPortStatus_3_CSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_3_CSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_3_PESC_clear) begin
      reg_hcRhPortStatus_3_PESC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_3_PESC_set) begin
      reg_hcRhPortStatus_3_PESC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_3_PESC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_3_PSSC_clear) begin
      reg_hcRhPortStatus_3_PSSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_3_PSSC_set) begin
      reg_hcRhPortStatus_3_PSSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_3_PSSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_3_OCIC_clear) begin
      reg_hcRhPortStatus_3_OCIC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_3_OCIC_set) begin
      reg_hcRhPortStatus_3_OCIC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_3_OCIC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(reg_hcRhPortStatus_3_PRSC_clear) begin
      reg_hcRhPortStatus_3_PRSC_reg <= 1'b0;
    end
    if(reg_hcRhPortStatus_3_PRSC_set) begin
      reg_hcRhPortStatus_3_PRSC_reg <= 1'b1;
    end
    if(reg_hcRhPortStatus_3_PRSC_set) begin
      reg_hcInterrupt_RHSC_status <= 1'b1;
    end
    if(when_UsbOhci_l460_9) begin
      reg_hcRhPortStatus_3_PES <= 1'b0;
    end
    if(when_UsbOhci_l460_10) begin
      reg_hcRhPortStatus_3_PES <= 1'b1;
    end
    if(when_UsbOhci_l460_11) begin
      reg_hcRhPortStatus_3_PES <= 1'b1;
    end
    if(when_UsbOhci_l461_6) begin
      reg_hcRhPortStatus_3_PSS <= 1'b0;
    end
    if(when_UsbOhci_l461_7) begin
      reg_hcRhPortStatus_3_PSS <= 1'b1;
    end
    if(when_UsbOhci_l462_3) begin
      reg_hcRhPortStatus_3_suspend <= 1'b1;
    end
    if(when_UsbOhci_l463_3) begin
      reg_hcRhPortStatus_3_resume <= 1'b1;
    end
    if(when_UsbOhci_l464_3) begin
      reg_hcRhPortStatus_3_reset <= 1'b1;
    end
    if(reg_hcRhDescriptorA_NPS) begin
      reg_hcRhPortStatus_3_PPS <= 1'b1;
    end else begin
      if(reg_hcRhDescriptorA_PSM) begin
        if(when_UsbOhci_l470_3) begin
          if(reg_hcRhPortStatus_3_clearPortPower) begin
            reg_hcRhPortStatus_3_PPS <= 1'b0;
          end
          if(reg_hcRhPortStatus_3_setPortPower) begin
            reg_hcRhPortStatus_3_PPS <= 1'b1;
          end
        end else begin
          if(reg_hcRhStatus_clearGlobalPower) begin
            reg_hcRhPortStatus_3_PPS <= 1'b0;
          end
          if(reg_hcRhStatus_setGlobalPower) begin
            reg_hcRhPortStatus_3_PPS <= 1'b1;
          end
        end
      end else begin
        if(reg_hcRhStatus_clearGlobalPower) begin
          reg_hcRhPortStatus_3_PPS <= 1'b0;
        end
        if(reg_hcRhStatus_setGlobalPower) begin
          reg_hcRhPortStatus_3_PPS <= 1'b1;
        end
      end
    end
    if(io_phy_ports_3_resume_fire) begin
      reg_hcRhPortStatus_3_resume <= 1'b0;
    end
    if(io_phy_ports_3_reset_fire) begin
      reg_hcRhPortStatus_3_reset <= 1'b0;
    end
    if(io_phy_ports_3_suspend_fire) begin
      reg_hcRhPortStatus_3_suspend <= 1'b0;
    end
    frame_decrementTimer <= (frame_decrementTimer + 3'b001);
    if(frame_decrementTimerOverflow) begin
      frame_decrementTimer <= 3'b000;
    end
    if(when_UsbOhci_l526) begin
      reg_hcFmRemaining_FR <= (reg_hcFmRemaining_FR - 14'h0001);
      if(when_UsbOhci_l528) begin
        frame_limitCounter <= (frame_limitCounter - 15'h0001);
      end
    end
    if(frame_reload) begin
      reg_hcFmRemaining_FR <= reg_hcFmInterval_FI;
      reg_hcFmRemaining_FRT <= reg_hcFmInterval_FIT;
      reg_hcFmNumber_FN <= reg_hcFmNumber_FNp1;
      frame_limitCounter <= reg_hcFmInterval_FSMPS;
      frame_decrementTimer <= 3'b000;
    end
    if(io_phy_tick) begin
      rxTimer_counter <= (rxTimer_counter + 8'h01);
    end
    if(rxTimer_clear) begin
      rxTimer_counter <= 8'h00;
    end
    if(_zz_1) begin
      _zz_dataRx_history_0 <= _zz_dataRx_pid;
    end
    if(_zz_1) begin
      _zz_dataRx_history_1 <= _zz_dataRx_history_0;
    end
    if(priority_tick) begin
      priority_counter <= (priority_counter + 2'b01);
    end
    if(priority_skip) begin
      priority_bulk <= (! priority_bulk);
      priority_counter <= 2'b00;
    end
    endpoint_TD_isoOverrunReg <= endpoint_TD_isoOverrun;
    endpoint_TD_isoZero <= (endpoint_TD_isoLast ? (endpoint_TD_isoBaseNext < endpoint_TD_isoBase) : (endpoint_TD_isoBase == endpoint_TD_isoBaseNext));
    endpoint_TD_isoLastReg <= endpoint_TD_isoLast;
    endpoint_TD_tooEarlyReg <= endpoint_TD_tooEarly;
    endpoint_TD_lastOffset <= (endpoint_ED_F ? _zz_endpoint_TD_lastOffset : {(! endpoint_TD_isSinglePage),endpoint_TD_BE[11 : 0]});
    if(endpoint_TD_clear) begin
      endpoint_TD_retire <= 1'b0;
      endpoint_TD_dataPhaseUpdate <= 1'b0;
      endpoint_TD_upateCBP <= 1'b0;
      endpoint_TD_noUpdate <= 1'b0;
    end
    if(endpoint_applyNextED) begin
      case(endpoint_flowType)
        FlowType_BULK : begin
          reg_hcBulkCurrentED_BCED_reg <= endpoint_ED_nextED;
        end
        FlowType_CONTROL : begin
          reg_hcControlCurrentED_CCED_reg <= endpoint_ED_nextED;
        end
        default : begin
          reg_hcPeriodCurrentED_PCED_reg <= endpoint_ED_nextED;
        end
      endcase
    end
    if(endpoint_dmaLogic_byteCtx_increment) begin
      endpoint_dmaLogic_byteCtx_counter <= (endpoint_dmaLogic_byteCtx_counter + 13'h0001);
    end
    case(io_ctrl_cmd_payload_fragment_address)
      12'h004 : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021) begin
            reg_hcControl_CBSR[1 : 0] <= io_ctrl_cmd_payload_fragment_data[1 : 0];
          end
          if(when_BusSlaveFactory_l1021_1) begin
            reg_hcControl_PLE <= io_ctrl_cmd_payload_fragment_data[2];
          end
          if(when_BusSlaveFactory_l1021_2) begin
            reg_hcControl_IE <= io_ctrl_cmd_payload_fragment_data[3];
          end
          if(when_BusSlaveFactory_l1021_3) begin
            reg_hcControl_CLE <= io_ctrl_cmd_payload_fragment_data[4];
          end
          if(when_BusSlaveFactory_l1021_4) begin
            reg_hcControl_BLE <= io_ctrl_cmd_payload_fragment_data[5];
          end
          if(when_BusSlaveFactory_l1021_7) begin
            reg_hcControl_RWE <= io_ctrl_cmd_payload_fragment_data[10];
          end
        end
      end
      12'h018 : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021_8) begin
            reg_hcHCCA_HCCA_reg[7 : 0] <= io_ctrl_cmd_payload_fragment_data[15 : 8];
          end
          if(when_BusSlaveFactory_l1021_9) begin
            reg_hcHCCA_HCCA_reg[15 : 8] <= io_ctrl_cmd_payload_fragment_data[23 : 16];
          end
          if(when_BusSlaveFactory_l1021_10) begin
            reg_hcHCCA_HCCA_reg[23 : 16] <= io_ctrl_cmd_payload_fragment_data[31 : 24];
          end
        end
      end
      12'h020 : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021_11) begin
            reg_hcControlHeadED_CHED_reg[3 : 0] <= io_ctrl_cmd_payload_fragment_data[7 : 4];
          end
          if(when_BusSlaveFactory_l1021_12) begin
            reg_hcControlHeadED_CHED_reg[11 : 4] <= io_ctrl_cmd_payload_fragment_data[15 : 8];
          end
          if(when_BusSlaveFactory_l1021_13) begin
            reg_hcControlHeadED_CHED_reg[19 : 12] <= io_ctrl_cmd_payload_fragment_data[23 : 16];
          end
          if(when_BusSlaveFactory_l1021_14) begin
            reg_hcControlHeadED_CHED_reg[27 : 20] <= io_ctrl_cmd_payload_fragment_data[31 : 24];
          end
        end
      end
      12'h024 : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021_15) begin
            reg_hcControlCurrentED_CCED_reg[3 : 0] <= io_ctrl_cmd_payload_fragment_data[7 : 4];
          end
          if(when_BusSlaveFactory_l1021_16) begin
            reg_hcControlCurrentED_CCED_reg[11 : 4] <= io_ctrl_cmd_payload_fragment_data[15 : 8];
          end
          if(when_BusSlaveFactory_l1021_17) begin
            reg_hcControlCurrentED_CCED_reg[19 : 12] <= io_ctrl_cmd_payload_fragment_data[23 : 16];
          end
          if(when_BusSlaveFactory_l1021_18) begin
            reg_hcControlCurrentED_CCED_reg[27 : 20] <= io_ctrl_cmd_payload_fragment_data[31 : 24];
          end
        end
      end
      12'h028 : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021_19) begin
            reg_hcBulkHeadED_BHED_reg[3 : 0] <= io_ctrl_cmd_payload_fragment_data[7 : 4];
          end
          if(when_BusSlaveFactory_l1021_20) begin
            reg_hcBulkHeadED_BHED_reg[11 : 4] <= io_ctrl_cmd_payload_fragment_data[15 : 8];
          end
          if(when_BusSlaveFactory_l1021_21) begin
            reg_hcBulkHeadED_BHED_reg[19 : 12] <= io_ctrl_cmd_payload_fragment_data[23 : 16];
          end
          if(when_BusSlaveFactory_l1021_22) begin
            reg_hcBulkHeadED_BHED_reg[27 : 20] <= io_ctrl_cmd_payload_fragment_data[31 : 24];
          end
        end
      end
      12'h02c : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021_23) begin
            reg_hcBulkCurrentED_BCED_reg[3 : 0] <= io_ctrl_cmd_payload_fragment_data[7 : 4];
          end
          if(when_BusSlaveFactory_l1021_24) begin
            reg_hcBulkCurrentED_BCED_reg[11 : 4] <= io_ctrl_cmd_payload_fragment_data[15 : 8];
          end
          if(when_BusSlaveFactory_l1021_25) begin
            reg_hcBulkCurrentED_BCED_reg[19 : 12] <= io_ctrl_cmd_payload_fragment_data[23 : 16];
          end
          if(when_BusSlaveFactory_l1021_26) begin
            reg_hcBulkCurrentED_BCED_reg[27 : 20] <= io_ctrl_cmd_payload_fragment_data[31 : 24];
          end
        end
      end
      12'h030 : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021_27) begin
            reg_hcDoneHead_DH_reg[3 : 0] <= io_ctrl_cmd_payload_fragment_data[7 : 4];
          end
          if(when_BusSlaveFactory_l1021_28) begin
            reg_hcDoneHead_DH_reg[11 : 4] <= io_ctrl_cmd_payload_fragment_data[15 : 8];
          end
          if(when_BusSlaveFactory_l1021_29) begin
            reg_hcDoneHead_DH_reg[19 : 12] <= io_ctrl_cmd_payload_fragment_data[23 : 16];
          end
          if(when_BusSlaveFactory_l1021_30) begin
            reg_hcDoneHead_DH_reg[27 : 20] <= io_ctrl_cmd_payload_fragment_data[31 : 24];
          end
        end
      end
      12'h034 : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021_31) begin
            reg_hcFmInterval_FI[7 : 0] <= io_ctrl_cmd_payload_fragment_data[7 : 0];
          end
          if(when_BusSlaveFactory_l1021_32) begin
            reg_hcFmInterval_FI[13 : 8] <= io_ctrl_cmd_payload_fragment_data[13 : 8];
          end
          if(when_BusSlaveFactory_l1021_33) begin
            reg_hcFmInterval_FSMPS[7 : 0] <= io_ctrl_cmd_payload_fragment_data[23 : 16];
          end
          if(when_BusSlaveFactory_l1021_34) begin
            reg_hcFmInterval_FSMPS[14 : 8] <= io_ctrl_cmd_payload_fragment_data[30 : 24];
          end
          if(when_BusSlaveFactory_l1021_35) begin
            reg_hcFmInterval_FIT <= io_ctrl_cmd_payload_fragment_data[31];
          end
        end
      end
      12'h044 : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021_38) begin
            reg_hcLSThreshold_LST[7 : 0] <= io_ctrl_cmd_payload_fragment_data[7 : 0];
          end
          if(when_BusSlaveFactory_l1021_39) begin
            reg_hcLSThreshold_LST[11 : 8] <= io_ctrl_cmd_payload_fragment_data[11 : 8];
          end
        end
      end
      12'h048 : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021_40) begin
            reg_hcRhDescriptorA_PSM <= io_ctrl_cmd_payload_fragment_data[8];
          end
          if(when_BusSlaveFactory_l1021_41) begin
            reg_hcRhDescriptorA_NPS <= io_ctrl_cmd_payload_fragment_data[9];
          end
          if(when_BusSlaveFactory_l1021_42) begin
            reg_hcRhDescriptorA_OCPM <= io_ctrl_cmd_payload_fragment_data[11];
          end
          if(when_BusSlaveFactory_l1021_43) begin
            reg_hcRhDescriptorA_NOCP <= io_ctrl_cmd_payload_fragment_data[12];
          end
          if(when_BusSlaveFactory_l1021_44) begin
            reg_hcRhDescriptorA_POTPGT[7 : 0] <= io_ctrl_cmd_payload_fragment_data[31 : 24];
          end
        end
      end
      12'h04c : begin
        if(ctrl_doWrite) begin
          if(when_BusSlaveFactory_l1021_45) begin
            reg_hcRhDescriptorB_DR[3 : 0] <= io_ctrl_cmd_payload_fragment_data[4 : 1];
          end
          if(when_BusSlaveFactory_l1021_46) begin
            reg_hcRhDescriptorB_PPCM[3 : 0] <= io_ctrl_cmd_payload_fragment_data[20 : 17];
          end
        end
      end
      default : begin
      end
    endcase
    if(when_UsbOhci_l253) begin
      reg_hcControl_CBSR <= 2'b00;
      reg_hcControl_PLE <= 1'b0;
      reg_hcControl_IE <= 1'b0;
      reg_hcControl_CLE <= 1'b0;
      reg_hcControl_BLE <= 1'b0;
      reg_hcControl_RWE <= 1'b0;
      reg_hcCommandStatus_CLF <= 1'b0;
      reg_hcCommandStatus_BLF <= 1'b0;
      reg_hcCommandStatus_OCR <= 1'b0;
      reg_hcCommandStatus_SOC <= 2'b00;
      reg_hcInterrupt_MIE <= 1'b0;
      reg_hcInterrupt_SO_status <= 1'b0;
      reg_hcInterrupt_SO_enable <= 1'b0;
      reg_hcInterrupt_WDH_status <= 1'b0;
      reg_hcInterrupt_WDH_enable <= 1'b0;
      reg_hcInterrupt_SF_status <= 1'b0;
      reg_hcInterrupt_SF_enable <= 1'b0;
      reg_hcInterrupt_RD_status <= 1'b0;
      reg_hcInterrupt_RD_enable <= 1'b0;
      reg_hcInterrupt_UE_status <= 1'b0;
      reg_hcInterrupt_UE_enable <= 1'b0;
      reg_hcInterrupt_FNO_status <= 1'b0;
      reg_hcInterrupt_FNO_enable <= 1'b0;
      reg_hcInterrupt_RHSC_status <= 1'b0;
      reg_hcInterrupt_RHSC_enable <= 1'b0;
      reg_hcInterrupt_OC_status <= 1'b0;
      reg_hcInterrupt_OC_enable <= 1'b0;
      reg_hcHCCA_HCCA_reg <= 24'h000000;
      reg_hcPeriodCurrentED_PCED_reg <= 28'h0000000;
      reg_hcControlHeadED_CHED_reg <= 28'h0000000;
      reg_hcControlCurrentED_CCED_reg <= 28'h0000000;
      reg_hcBulkHeadED_BHED_reg <= 28'h0000000;
      reg_hcBulkCurrentED_BCED_reg <= 28'h0000000;
      reg_hcDoneHead_DH_reg <= 28'h0000000;
      reg_hcFmInterval_FI <= 14'h2edf;
      reg_hcFmInterval_FIT <= 1'b0;
      reg_hcFmRemaining_FR <= 14'h0000;
      reg_hcFmRemaining_FRT <= 1'b0;
      reg_hcFmNumber_FN <= 16'h0000;
      reg_hcLSThreshold_LST <= 12'h628;
      reg_hcRhDescriptorA_PSM <= 1'b1;
      reg_hcRhDescriptorA_NPS <= 1'b1;
      reg_hcRhDescriptorA_OCPM <= 1'b1;
      reg_hcRhDescriptorA_NOCP <= 1'b1;
      reg_hcRhDescriptorA_POTPGT <= 8'h0a;
      reg_hcRhDescriptorB_DR <= {1'b0,{1'b0,{1'b0,1'b0}}};
      reg_hcRhDescriptorB_PPCM <= {1'b1,{1'b1,{1'b1,1'b1}}};
      reg_hcRhStatus_DRWE <= 1'b0;
      reg_hcRhStatus_CCIC <= 1'b0;
      reg_hcRhPortStatus_0_resume <= 1'b0;
      reg_hcRhPortStatus_0_reset <= 1'b0;
      reg_hcRhPortStatus_0_suspend <= 1'b0;
      reg_hcRhPortStatus_0_PSS <= 1'b0;
      reg_hcRhPortStatus_0_PPS <= 1'b0;
      reg_hcRhPortStatus_0_PES <= 1'b0;
      reg_hcRhPortStatus_0_CSC_reg <= 1'b0;
      reg_hcRhPortStatus_0_PESC_reg <= 1'b0;
      reg_hcRhPortStatus_0_PSSC_reg <= 1'b0;
      reg_hcRhPortStatus_0_OCIC_reg <= 1'b0;
      reg_hcRhPortStatus_0_PRSC_reg <= 1'b0;
      reg_hcRhPortStatus_1_resume <= 1'b0;
      reg_hcRhPortStatus_1_reset <= 1'b0;
      reg_hcRhPortStatus_1_suspend <= 1'b0;
      reg_hcRhPortStatus_1_PSS <= 1'b0;
      reg_hcRhPortStatus_1_PPS <= 1'b0;
      reg_hcRhPortStatus_1_PES <= 1'b0;
      reg_hcRhPortStatus_1_CSC_reg <= 1'b0;
      reg_hcRhPortStatus_1_PESC_reg <= 1'b0;
      reg_hcRhPortStatus_1_PSSC_reg <= 1'b0;
      reg_hcRhPortStatus_1_OCIC_reg <= 1'b0;
      reg_hcRhPortStatus_1_PRSC_reg <= 1'b0;
      reg_hcRhPortStatus_2_resume <= 1'b0;
      reg_hcRhPortStatus_2_reset <= 1'b0;
      reg_hcRhPortStatus_2_suspend <= 1'b0;
      reg_hcRhPortStatus_2_PSS <= 1'b0;
      reg_hcRhPortStatus_2_PPS <= 1'b0;
      reg_hcRhPortStatus_2_PES <= 1'b0;
      reg_hcRhPortStatus_2_CSC_reg <= 1'b0;
      reg_hcRhPortStatus_2_PESC_reg <= 1'b0;
      reg_hcRhPortStatus_2_PSSC_reg <= 1'b0;
      reg_hcRhPortStatus_2_OCIC_reg <= 1'b0;
      reg_hcRhPortStatus_2_PRSC_reg <= 1'b0;
      reg_hcRhPortStatus_3_resume <= 1'b0;
      reg_hcRhPortStatus_3_reset <= 1'b0;
      reg_hcRhPortStatus_3_suspend <= 1'b0;
      reg_hcRhPortStatus_3_PSS <= 1'b0;
      reg_hcRhPortStatus_3_PPS <= 1'b0;
      reg_hcRhPortStatus_3_PES <= 1'b0;
      reg_hcRhPortStatus_3_CSC_reg <= 1'b0;
      reg_hcRhPortStatus_3_PESC_reg <= 1'b0;
      reg_hcRhPortStatus_3_PSSC_reg <= 1'b0;
      reg_hcRhPortStatus_3_OCIC_reg <= 1'b0;
      reg_hcRhPortStatus_3_PRSC_reg <= 1'b0;
    end
    case(dataRx_stateReg)
      dataRx_enumDef_IDLE : begin
        if(!io_phy_rx_active) begin
          if(rxTimer_rxTimeout) begin
            dataRx_notResponding <= 1'b1;
          end
        end
      end
      dataRx_enumDef_PID : begin
        dataRx_valids <= 2'b00;
        dataRx_pidError <= 1'b1;
        if(_zz_1) begin
          dataRx_pid <= _zz_dataRx_pid[3 : 0];
          dataRx_pidError <= (_zz_dataRx_pid[3 : 0] != (~ _zz_dataRx_pid[7 : 4]));
        end
      end
      dataRx_enumDef_DATA : begin
        if(when_Misc_l70) begin
          if(when_Misc_l71) begin
            dataRx_crcError <= 1'b1;
          end
        end else begin
          if(_zz_1) begin
            dataRx_valids <= {dataRx_valids[0],1'b1};
          end
        end
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253) begin
      dataRx_notResponding <= 1'b0;
      dataRx_stuffingError <= 1'b0;
      dataRx_pidError <= 1'b0;
      dataRx_crcError <= 1'b0;
    end
    if(when_Misc_l85) begin
      if(_zz_1) begin
        if(when_Misc_l87) begin
          dataRx_stuffingError <= 1'b1;
        end
      end
    end
    case(sof_stateReg)
      sof_enumDef_FRAME_TX : begin
        sof_doInterruptDelay <= (interruptDelay_done && (! reg_hcInterrupt_WDH_status));
      end
      sof_enumDef_FRAME_NUMBER_CMD : begin
      end
      sof_enumDef_FRAME_NUMBER_RSP : begin
        if(ioDma_rsp_valid) begin
          reg_hcInterrupt_SF_status <= 1'b1;
          if(reg_hcFmNumber_overflow) begin
            reg_hcInterrupt_FNO_status <= 1'b1;
          end
          if(sof_doInterruptDelay) begin
            reg_hcInterrupt_WDH_status <= 1'b1;
            reg_hcDoneHead_DH_reg <= 28'h0000000;
          end
        end
      end
      default : begin
      end
    endcase
    case(endpoint_stateReg)
      endpoint_enumDef_ED_READ_CMD : begin
      end
      endpoint_enumDef_ED_READ_RSP : begin
        if(when_UsbOhci_l188) begin
          endpoint_ED_words_0 <= dmaRspMux_vec_0[31 : 0];
        end
        if(when_UsbOhci_l188_1) begin
          endpoint_ED_words_1 <= dmaRspMux_vec_1[31 : 0];
        end
        if(when_UsbOhci_l188_2) begin
          endpoint_ED_words_2 <= dmaRspMux_vec_0[31 : 0];
        end
        if(when_UsbOhci_l188_3) begin
          endpoint_ED_words_3 <= dmaRspMux_vec_1[31 : 0];
        end
      end
      endpoint_enumDef_ED_ANALYSE : begin
      end
      endpoint_enumDef_TD_READ_CMD : begin
      end
      endpoint_enumDef_TD_READ_RSP : begin
        if(when_UsbOhci_l188_4) begin
          endpoint_TD_words_0 <= dmaRspMux_vec_0[31 : 0];
        end
        if(when_UsbOhci_l188_5) begin
          endpoint_TD_words_1 <= dmaRspMux_vec_1[31 : 0];
        end
        if(when_UsbOhci_l188_6) begin
          endpoint_TD_words_2 <= dmaRspMux_vec_0[31 : 0];
        end
        if(when_UsbOhci_l188_7) begin
          endpoint_TD_words_3 <= dmaRspMux_vec_1[31 : 0];
        end
        if(when_UsbOhci_l891) begin
          if(when_UsbOhci_l188_8) begin
            endpoint_TD_isoBase <= dmaRspMux_vec_0[12 : 0];
          end
          if(when_UsbOhci_l188_9) begin
            endpoint_TD_isoBaseNext <= dmaRspMux_vec_0[28 : 16];
          end
        end
        if(when_UsbOhci_l891_1) begin
          if(when_UsbOhci_l188_10) begin
            endpoint_TD_isoBase <= dmaRspMux_vec_0[28 : 16];
          end
          if(when_UsbOhci_l188_11) begin
            endpoint_TD_isoBaseNext <= dmaRspMux_vec_1[12 : 0];
          end
        end
        if(when_UsbOhci_l891_2) begin
          if(when_UsbOhci_l188_12) begin
            endpoint_TD_isoBase <= dmaRspMux_vec_1[12 : 0];
          end
          if(when_UsbOhci_l188_13) begin
            endpoint_TD_isoBaseNext <= dmaRspMux_vec_1[28 : 16];
          end
        end
        if(when_UsbOhci_l891_3) begin
          if(when_UsbOhci_l188_14) begin
            endpoint_TD_isoBase <= dmaRspMux_vec_1[28 : 16];
          end
          if(when_UsbOhci_l188_15) begin
            endpoint_TD_isoBaseNext <= dmaRspMux_vec_0[12 : 0];
          end
        end
        if(when_UsbOhci_l891_4) begin
          if(when_UsbOhci_l188_16) begin
            endpoint_TD_isoBase <= dmaRspMux_vec_0[12 : 0];
          end
          if(when_UsbOhci_l188_17) begin
            endpoint_TD_isoBaseNext <= dmaRspMux_vec_0[28 : 16];
          end
        end
        if(when_UsbOhci_l891_5) begin
          if(when_UsbOhci_l188_18) begin
            endpoint_TD_isoBase <= dmaRspMux_vec_0[28 : 16];
          end
          if(when_UsbOhci_l188_19) begin
            endpoint_TD_isoBaseNext <= dmaRspMux_vec_1[12 : 0];
          end
        end
        if(when_UsbOhci_l891_6) begin
          if(when_UsbOhci_l188_20) begin
            endpoint_TD_isoBase <= dmaRspMux_vec_1[12 : 0];
          end
          if(when_UsbOhci_l188_21) begin
            endpoint_TD_isoBaseNext <= dmaRspMux_vec_1[28 : 16];
          end
        end
        if(when_UsbOhci_l891_7) begin
          if(when_UsbOhci_l188_22) begin
            endpoint_TD_isoBase <= dmaRspMux_vec_1[28 : 16];
          end
        end
        if(endpoint_TD_isoLast) begin
          endpoint_TD_isoBaseNext <= {(! endpoint_TD_isSinglePage),endpoint_TD_BE[11 : 0]};
        end
      end
      endpoint_enumDef_TD_READ_DELAY : begin
      end
      endpoint_enumDef_TD_ANALYSE : begin
        case(endpoint_flowType)
          FlowType_CONTROL : begin
            reg_hcCommandStatus_CLF <= 1'b1;
          end
          FlowType_BULK : begin
            reg_hcCommandStatus_BLF <= 1'b1;
          end
          default : begin
          end
        endcase
        endpoint_dmaLogic_byteCtx_counter <= endpoint_TD_firstOffset;
        endpoint_currentAddress <= {1'd0, endpoint_TD_firstOffset};
        endpoint_lastAddress <= _zz_endpoint_lastAddress_1[12:0];
        endpoint_zeroLength <= (endpoint_ED_F ? endpoint_TD_isoZero : (endpoint_TD_CBP == 32'h00000000));
        endpoint_dataPhase <= (endpoint_ED_F ? 1'b0 : (endpoint_TD_T[1] ? endpoint_TD_T[0] : endpoint_ED_C));
        if(endpoint_ED_F) begin
          if(endpoint_TD_isoOverrunReg) begin
            endpoint_TD_retire <= 1'b1;
          end
        end
      end
      endpoint_enumDef_TD_CHECK_TIME : begin
        if(endpoint_timeCheck) begin
          endpoint_status_1 <= endpoint_Status_FRAME_TIME;
        end
      end
      endpoint_enumDef_BUFFER_READ : begin
        if(when_UsbOhci_l1128) begin
          if(endpoint_timeCheck) begin
            endpoint_status_1 <= endpoint_Status_FRAME_TIME;
          end
        end
      end
      endpoint_enumDef_TOKEN : begin
      end
      endpoint_enumDef_DATA_TX : begin
        if(dataTx_wantExit) begin
          if(endpoint_ED_F) begin
            endpoint_TD_words_0[31 : 28] <= 4'b0000;
          end
        end
      end
      endpoint_enumDef_DATA_RX : begin
      end
      endpoint_enumDef_DATA_RX_VALIDATE : begin
        endpoint_TD_words_0[31 : 28] <= 4'b0000;
        if(dataRx_notResponding) begin
          endpoint_TD_words_0[31 : 28] <= 4'b0101;
        end else begin
          if(dataRx_stuffingError) begin
            endpoint_TD_words_0[31 : 28] <= 4'b0010;
          end else begin
            if(dataRx_pidError) begin
              endpoint_TD_words_0[31 : 28] <= 4'b0110;
            end else begin
              if(endpoint_ED_F) begin
                case(dataRx_pid)
                  4'b1110, 4'b1010 : begin
                    endpoint_TD_words_0[31 : 28] <= 4'b0100;
                  end
                  4'b0011, 4'b1011 : begin
                  end
                  default : begin
                    endpoint_TD_words_0[31 : 28] <= 4'b0111;
                  end
                endcase
              end else begin
                case(dataRx_pid)
                  4'b1010 : begin
                    endpoint_TD_noUpdate <= 1'b1;
                  end
                  4'b1110 : begin
                    endpoint_TD_words_0[31 : 28] <= 4'b0100;
                  end
                  4'b0011, 4'b1011 : begin
                    if(when_UsbOhci_l1263) begin
                      endpoint_TD_words_0[31 : 28] <= 4'b0011;
                    end
                  end
                  default : begin
                    endpoint_TD_words_0[31 : 28] <= 4'b0111;
                  end
                endcase
              end
              if(when_UsbOhci_l1274) begin
                if(dataRx_crcError) begin
                  endpoint_TD_words_0[31 : 28] <= 4'b0001;
                end else begin
                  if(endpoint_dmaLogic_underflowError) begin
                    endpoint_TD_words_0[31 : 28] <= 4'b1001;
                  end else begin
                    if(endpoint_dmaLogic_overflow) begin
                      endpoint_TD_words_0[31 : 28] <= 4'b1000;
                    end
                  end
                end
              end
            end
          end
        end
      end
      endpoint_enumDef_ACK_RX : begin
        if(io_phy_rx_flow_valid) begin
          endpoint_ackRxFired <= 1'b1;
          endpoint_ackRxPid <= io_phy_rx_flow_payload_data[3 : 0];
          if(io_phy_rx_flow_payload_stuffingError) begin
            endpoint_ackRxStuffing <= 1'b1;
          end
          if(when_UsbOhci_l1200) begin
            endpoint_ackRxPidFailure <= 1'b1;
          end
        end
        if(io_phy_rx_active) begin
          endpoint_ackRxActivated <= 1'b1;
        end
        if(when_UsbOhci_l1205) begin
          if(when_UsbOhci_l1207) begin
            endpoint_TD_words_0[31 : 28] <= 4'b0110;
          end else begin
            if(endpoint_ackRxStuffing) begin
              endpoint_TD_words_0[31 : 28] <= 4'b0010;
            end else begin
              if(endpoint_ackRxPidFailure) begin
                endpoint_TD_words_0[31 : 28] <= 4'b0110;
              end else begin
                case(endpoint_ackRxPid)
                  4'b0010 : begin
                    endpoint_TD_words_0[31 : 28] <= 4'b0000;
                  end
                  4'b1010 : begin
                  end
                  4'b1110 : begin
                    endpoint_TD_words_0[31 : 28] <= 4'b0100;
                  end
                  default : begin
                    endpoint_TD_words_0[31 : 28] <= 4'b0111;
                  end
                endcase
              end
            end
          end
        end
        if(rxTimer_rxTimeout) begin
          endpoint_TD_words_0[31 : 28] <= 4'b0101;
        end
      end
      endpoint_enumDef_ACK_TX_0 : begin
      end
      endpoint_enumDef_ACK_TX_1 : begin
      end
      endpoint_enumDef_ACK_TX_EOP : begin
      end
      endpoint_enumDef_DATA_RX_WAIT_DMA : begin
      end
      endpoint_enumDef_UPDATE_TD_PROCESS : begin
        if(endpoint_ED_F) begin
          if(endpoint_TD_isoLastReg) begin
            endpoint_TD_retire <= 1'b1;
          end
        end else begin
          endpoint_TD_words_0[27 : 26] <= 2'b00;
          case(endpoint_TD_CC)
            4'b0000 : begin
              if(when_UsbOhci_l1331) begin
                endpoint_TD_retire <= 1'b1;
              end
              endpoint_TD_dataPhaseUpdate <= 1'b1;
              endpoint_TD_upateCBP <= 1'b1;
            end
            4'b1001 : begin
              endpoint_TD_retire <= 1'b1;
              endpoint_TD_dataPhaseUpdate <= 1'b1;
              endpoint_TD_upateCBP <= 1'b1;
            end
            4'b1000 : begin
              endpoint_TD_retire <= 1'b1;
              endpoint_TD_dataPhaseUpdate <= 1'b1;
            end
            4'b0010, 4'b0001, 4'b0110, 4'b0101, 4'b0111, 4'b0011 : begin
              endpoint_TD_words_0[27 : 26] <= _zz_endpoint_TD_words_0;
              if(when_UsbOhci_l1346) begin
                endpoint_TD_words_0[31 : 28] <= 4'b0000;
              end else begin
                endpoint_TD_retire <= 1'b1;
              end
            end
            default : begin
              endpoint_TD_retire <= 1'b1;
            end
          endcase
          if(endpoint_TD_noUpdate) begin
            endpoint_TD_retire <= 1'b0;
          end
        end
      end
      endpoint_enumDef_UPDATE_TD_CMD : begin
        endpoint_ED_words_2[0] <= ((! endpoint_ED_F) && (endpoint_TD_CC != 4'b0000));
      end
      endpoint_enumDef_UPDATE_ED_CMD : begin
      end
      endpoint_enumDef_UPDATE_SYNC : begin
        if(dmaCtx_pendingEmpty) begin
          if(endpoint_TD_retire) begin
            reg_hcDoneHead_DH_reg <= endpoint_ED_headP;
          end
        end
      end
      endpoint_enumDef_ABORD : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l237_2) begin
      endpoint_status_1 <= endpoint_Status_OK;
    end
    if(when_StateMachine_l253_4) begin
      endpoint_ackRxFired <= 1'b0;
      endpoint_ackRxActivated <= 1'b0;
      endpoint_ackRxPidFailure <= 1'b0;
      endpoint_ackRxStuffing <= 1'b0;
    end
    case(endpoint_dmaLogic_stateReg)
      endpoint_dmaLogic_enumDef_INIT : begin
        endpoint_dmaLogic_underflow <= 1'b0;
        endpoint_dmaLogic_overflow <= 1'b0;
      end
      endpoint_dmaLogic_enumDef_TO_USB : begin
      end
      endpoint_dmaLogic_enumDef_FROM_USB : begin
        if(dataRx_wantExit) begin
          endpoint_dmaLogic_underflow <= when_UsbOhci_l1054;
          endpoint_dmaLogic_overflow <= ((! when_UsbOhci_l1054) && (_zz_endpoint_dmaLogic_overflow != endpoint_transactionSize));
          if(endpoint_zeroLength) begin
            endpoint_dmaLogic_underflow <= 1'b0;
            endpoint_dmaLogic_overflow <= (endpoint_dmaLogic_fromUsbCounter != 11'h000);
          end
          if(when_UsbOhci_l1054) begin
            endpoint_lastAddress <= _zz_endpoint_lastAddress_5[12:0];
          end
        end
        if(dataRx_data_valid) begin
          endpoint_dmaLogic_fromUsbCounter <= (endpoint_dmaLogic_fromUsbCounter + _zz_endpoint_dmaLogic_fromUsbCounter);
          if(_zz_2[0]) begin
            endpoint_dmaLogic_buffer[7 : 0] <= dataRx_data_payload;
          end
          if(_zz_2[1]) begin
            endpoint_dmaLogic_buffer[15 : 8] <= dataRx_data_payload;
          end
          if(_zz_2[2]) begin
            endpoint_dmaLogic_buffer[23 : 16] <= dataRx_data_payload;
          end
          if(_zz_2[3]) begin
            endpoint_dmaLogic_buffer[31 : 24] <= dataRx_data_payload;
          end
          if(_zz_2[4]) begin
            endpoint_dmaLogic_buffer[39 : 32] <= dataRx_data_payload;
          end
          if(_zz_2[5]) begin
            endpoint_dmaLogic_buffer[47 : 40] <= dataRx_data_payload;
          end
          if(_zz_2[6]) begin
            endpoint_dmaLogic_buffer[55 : 48] <= dataRx_data_payload;
          end
          if(_zz_2[7]) begin
            endpoint_dmaLogic_buffer[63 : 56] <= dataRx_data_payload;
          end
        end
      end
      endpoint_dmaLogic_enumDef_VALIDATION : begin
      end
      endpoint_dmaLogic_enumDef_CALC_CMD : begin
        endpoint_dmaLogic_length <= endpoint_dmaLogic_lengthCalc;
      end
      endpoint_dmaLogic_enumDef_READ_CMD : begin
        if(ioDma_cmd_ready) begin
          endpoint_currentAddress <= (_zz_endpoint_currentAddress + 14'h0001);
        end
      end
      endpoint_dmaLogic_enumDef_WRITE_CMD : begin
        if(ioDma_cmd_ready) begin
          if(endpoint_dmaLogic_beatLast) begin
            endpoint_currentAddress <= (_zz_endpoint_currentAddress_2 + 14'h0001);
          end
        end
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253_5) begin
      endpoint_dmaLogic_fromUsbCounter <= 11'h000;
    end
    case(operational_stateReg)
      operational_enumDef_SOF : begin
        if(sof_wantExit) begin
          if(when_UsbOhci_l1461) begin
            reg_hcInterrupt_SO_status <= 1'b1;
            reg_hcCommandStatus_SOC <= (reg_hcCommandStatus_SOC + 2'b01);
          end
          operational_allowBulk <= reg_hcControl_BLE;
          operational_allowControl <= reg_hcControl_CLE;
          operational_allowPeriodic <= reg_hcControl_PLE;
          operational_allowIsochronous <= reg_hcControl_IE;
          operational_periodicDone <= 1'b0;
          operational_periodicHeadFetched <= 1'b0;
          priority_bulk <= 1'b0;
          priority_counter <= 2'b00;
        end
      end
      operational_enumDef_ARBITER : begin
        if(reg_hcControl_BLE) begin
          operational_allowBulk <= 1'b1;
        end
        if(reg_hcControl_CLE) begin
          operational_allowControl <= 1'b1;
        end
        if(!operational_askExit) begin
          if(!frame_limitHit) begin
            if(when_UsbOhci_l1487) begin
              if(!when_UsbOhci_l1488) begin
                if(reg_hcPeriodCurrentED_isZero) begin
                  operational_periodicDone <= 1'b1;
                end else begin
                  endpoint_flowType <= FlowType_PERIODIC;
                  endpoint_ED_address <= reg_hcPeriodCurrentED_PCED_address;
                end
              end
            end else begin
              if(priority_bulk) begin
                if(operational_allowBulk) begin
                  if(reg_hcBulkCurrentED_isZero) begin
                    if(reg_hcCommandStatus_BLF) begin
                      reg_hcBulkCurrentED_BCED_reg <= reg_hcBulkHeadED_BHED_reg;
                      reg_hcCommandStatus_BLF <= 1'b0;
                    end
                  end else begin
                    endpoint_flowType <= FlowType_BULK;
                    endpoint_ED_address <= reg_hcBulkCurrentED_BCED_address;
                  end
                end
              end else begin
                if(operational_allowControl) begin
                  if(reg_hcControlCurrentED_isZero) begin
                    if(reg_hcCommandStatus_CLF) begin
                      reg_hcControlCurrentED_CCED_reg <= reg_hcControlHeadED_CHED_reg;
                      reg_hcCommandStatus_CLF <= 1'b0;
                    end
                  end else begin
                    endpoint_flowType <= FlowType_CONTROL;
                    endpoint_ED_address <= reg_hcControlCurrentED_CCED_address;
                  end
                end
              end
            end
          end
        end
      end
      operational_enumDef_END_POINT : begin
      end
      operational_enumDef_PERIODIC_HEAD_CMD : begin
      end
      operational_enumDef_PERIODIC_HEAD_RSP : begin
        if(ioDma_rsp_valid) begin
          operational_periodicHeadFetched <= 1'b1;
          reg_hcPeriodCurrentED_PCED_reg <= dmaRspMux_data[31 : 4];
        end
      end
      operational_enumDef_WAIT_SOF : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l237_3) begin
      operational_allowPeriodic <= 1'b0;
    end
    case(hc_stateReg)
      hc_enumDef_RESET : begin
      end
      hc_enumDef_RESUME : begin
      end
      hc_enumDef_OPERATIONAL : begin
      end
      hc_enumDef_SUSPEND : begin
        if(when_UsbOhci_l1625) begin
          reg_hcInterrupt_RD_status <= 1'b1;
        end
      end
      hc_enumDef_ANY_TO_RESET : begin
      end
      hc_enumDef_ANY_TO_SUSPEND : begin
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      ioDma_cmd_payload_first <= 1'b1;
    end else begin
      if(ioDma_cmd_fire) begin
        ioDma_cmd_payload_first <= ioDma_cmd_payload_last;
      end
    end
  end


endmodule

//StreamCCByToggle_16 replaced by StreamCCByToggle_1

//StreamCCByToggle_15 replaced by StreamCCByToggle_1

//StreamCCByToggle_14 replaced by StreamCCByToggle_1

//StreamCCByToggle_13 replaced by StreamCCByToggle_1

//PulseCCByToggle_13 replaced by PulseCCByToggle_1

//PulseCCByToggle_12 replaced by PulseCCByToggle_1

//PulseCCByToggle_11 replaced by PulseCCByToggle_1

//BufferCC_20 replaced by BufferCC_3

//BufferCC_19 replaced by BufferCC_3

//BufferCC_18 replaced by BufferCC

//BufferCC_17 replaced by BufferCC

//StreamCCByToggle_12 replaced by StreamCCByToggle_1

//StreamCCByToggle_11 replaced by StreamCCByToggle_1

//StreamCCByToggle_10 replaced by StreamCCByToggle_1

//StreamCCByToggle_9 replaced by StreamCCByToggle_1

//PulseCCByToggle_10 replaced by PulseCCByToggle_1

//PulseCCByToggle_9 replaced by PulseCCByToggle_1

//PulseCCByToggle_8 replaced by PulseCCByToggle_1

//BufferCC_16 replaced by BufferCC_3

//BufferCC_15 replaced by BufferCC_3

//BufferCC_14 replaced by BufferCC

//BufferCC_13 replaced by BufferCC

//StreamCCByToggle_8 replaced by StreamCCByToggle_1

//StreamCCByToggle_7 replaced by StreamCCByToggle_1

//StreamCCByToggle_6 replaced by StreamCCByToggle_1

//StreamCCByToggle_5 replaced by StreamCCByToggle_1

//PulseCCByToggle_7 replaced by PulseCCByToggle_1

//PulseCCByToggle_6 replaced by PulseCCByToggle_1

//PulseCCByToggle_5 replaced by PulseCCByToggle_1

//BufferCC_12 replaced by BufferCC_3

//BufferCC_11 replaced by BufferCC_3

//BufferCC_10 replaced by BufferCC

//BufferCC_9 replaced by BufferCC

//StreamCCByToggle_4 replaced by StreamCCByToggle_1

//StreamCCByToggle_3 replaced by StreamCCByToggle_1

//StreamCCByToggle_2 replaced by StreamCCByToggle_1

module StreamCCByToggle_1 (
  input  wire          io_input_valid,
  output wire          io_input_ready,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  input  wire          clk,
  input  wire          reset,
  input  wire          phyCd_clk,
  input  wire          reset_syncronized
);

  wire                outHitSignal_buffercc_io_dataOut;
  wire                pushArea_target_buffercc_io_dataOut;
  wire                outHitSignal;
  wire                pushArea_hit;
  wire                pushArea_accept;
  reg                 pushArea_target;
  reg                 _zz_io_input_ready;
  wire                popArea_stream_valid;
  wire                popArea_stream_ready;
  wire                popArea_target;
  wire                popArea_stream_fire;
  reg                 popArea_hit;

  BufferCC_69 outHitSignal_buffercc (
    .io_dataIn  (outHitSignal                    ), //i
    .io_dataOut (outHitSignal_buffercc_io_dataOut), //o
    .clk        (clk                             ), //i
    .reset      (reset                           )  //i
  );
  BufferCC_71 pushArea_target_buffercc (
    .io_dataIn         (pushArea_target                    ), //i
    .io_dataOut        (pushArea_target_buffercc_io_dataOut), //o
    .phyCd_clk         (phyCd_clk                          ), //i
    .reset_syncronized (reset_syncronized                  )  //i
  );
  assign pushArea_hit = outHitSignal_buffercc_io_dataOut;
  assign pushArea_accept = ((! _zz_io_input_ready) && io_input_valid);
  assign io_input_ready = (_zz_io_input_ready && (pushArea_hit == pushArea_target));
  assign popArea_target = pushArea_target_buffercc_io_dataOut;
  assign popArea_stream_fire = (popArea_stream_valid && popArea_stream_ready);
  assign outHitSignal = popArea_hit;
  assign popArea_stream_valid = (popArea_target != popArea_hit);
  assign io_output_valid = popArea_stream_valid;
  assign popArea_stream_ready = io_output_ready;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      pushArea_target <= 1'b0;
      _zz_io_input_ready <= 1'b0;
    end else begin
      if(pushArea_accept) begin
        pushArea_target <= (! pushArea_target);
      end
      if(pushArea_accept) begin
        _zz_io_input_ready <= 1'b1;
      end
      if(io_input_ready) begin
        _zz_io_input_ready <= 1'b0;
      end
    end
  end

  always @(posedge phyCd_clk or posedge reset_syncronized) begin
    if(reset_syncronized) begin
      popArea_hit <= 1'b0;
    end else begin
      if(popArea_stream_fire) begin
        popArea_hit <= popArea_target;
      end
    end
  end


endmodule

//PulseCCByToggle_4 replaced by PulseCCByToggle_1

//PulseCCByToggle_3 replaced by PulseCCByToggle_1

//PulseCCByToggle_2 replaced by PulseCCByToggle_1

//BufferCC_8 replaced by BufferCC_3

//BufferCC_7 replaced by BufferCC_3

//BufferCC_6 replaced by BufferCC

//BufferCC_5 replaced by BufferCC

module PulseCCByToggle_1 (
  input  wire          io_pulseIn,
  output wire          io_pulseOut,
  input  wire          phyCd_clk,
  input  wire          phyCd_reset,
  input  wire          clk,
  input  wire          phyCd_reset_syncronized
);

  wire                inArea_target_buffercc_io_dataOut;
  reg                 inArea_target;
  wire                outArea_target;
  reg                 outArea_target_regNext;

  BufferCC_68 inArea_target_buffercc (
    .io_dataIn               (inArea_target                    ), //i
    .io_dataOut              (inArea_target_buffercc_io_dataOut), //o
    .clk                     (clk                              ), //i
    .phyCd_reset_syncronized (phyCd_reset_syncronized          )  //i
  );
  assign outArea_target = inArea_target_buffercc_io_dataOut;
  assign io_pulseOut = (outArea_target ^ outArea_target_regNext);
  always @(posedge phyCd_clk or posedge phyCd_reset) begin
    if(phyCd_reset) begin
      inArea_target <= 1'b0;
    end else begin
      if(io_pulseIn) begin
        inArea_target <= (! inArea_target);
      end
    end
  end

  always @(posedge clk or posedge phyCd_reset_syncronized) begin
    if(phyCd_reset_syncronized) begin
      outArea_target_regNext <= 1'b0;
    end else begin
      outArea_target_regNext <= outArea_target;
    end
  end


endmodule

//BufferCC_4 replaced by BufferCC_3

module FlowCCByToggle (
  input  wire          io_input_valid,
  input  wire          io_input_payload_stuffingError,
  input  wire [7:0]    io_input_payload_data,
  output wire          io_output_valid,
  output wire          io_output_payload_stuffingError,
  output wire [7:0]    io_output_payload_data,
  input  wire          phyCd_clk,
  input  wire          phyCd_reset,
  input  wire          clk,
  input  wire          phyCd_reset_syncronized
);

  wire                inputArea_target_buffercc_io_dataOut;
  reg                 inputArea_target;
  reg                 inputArea_data_stuffingError;
  reg        [7:0]    inputArea_data_data;
  wire                outputArea_target;
  reg                 outputArea_hit;
  wire                outputArea_flow_valid;
  wire                outputArea_flow_payload_stuffingError;
  wire       [7:0]    outputArea_flow_payload_data;
  reg                 outputArea_flow_m2sPipe_valid;
  (* async_reg = "true" *) reg                 outputArea_flow_m2sPipe_payload_stuffingError;
  (* async_reg = "true" *) reg        [7:0]    outputArea_flow_m2sPipe_payload_data;

  BufferCC_68 inputArea_target_buffercc (
    .io_dataIn               (inputArea_target                    ), //i
    .io_dataOut              (inputArea_target_buffercc_io_dataOut), //o
    .clk                     (clk                                 ), //i
    .phyCd_reset_syncronized (phyCd_reset_syncronized             )  //i
  );
  assign outputArea_target = inputArea_target_buffercc_io_dataOut;
  assign outputArea_flow_valid = (outputArea_target != outputArea_hit);
  assign outputArea_flow_payload_stuffingError = inputArea_data_stuffingError;
  assign outputArea_flow_payload_data = inputArea_data_data;
  assign io_output_valid = outputArea_flow_m2sPipe_valid;
  assign io_output_payload_stuffingError = outputArea_flow_m2sPipe_payload_stuffingError;
  assign io_output_payload_data = outputArea_flow_m2sPipe_payload_data;
  always @(posedge phyCd_clk or posedge phyCd_reset) begin
    if(phyCd_reset) begin
      inputArea_target <= 1'b0;
    end else begin
      if(io_input_valid) begin
        inputArea_target <= (! inputArea_target);
      end
    end
  end

  always @(posedge phyCd_clk) begin
    if(io_input_valid) begin
      inputArea_data_stuffingError <= io_input_payload_stuffingError;
      inputArea_data_data <= io_input_payload_data;
    end
  end

  always @(posedge clk or posedge phyCd_reset_syncronized) begin
    if(phyCd_reset_syncronized) begin
      outputArea_flow_m2sPipe_valid <= 1'b0;
      outputArea_hit <= 1'b0;
    end else begin
      outputArea_hit <= outputArea_target;
      outputArea_flow_m2sPipe_valid <= outputArea_flow_valid;
    end
  end

  always @(posedge clk) begin
    if(outputArea_flow_valid) begin
      outputArea_flow_m2sPipe_payload_stuffingError <= outputArea_flow_payload_stuffingError;
      outputArea_flow_m2sPipe_payload_data <= outputArea_flow_payload_data;
    end
  end


endmodule

module PulseCCByToggle (
  input  wire          io_pulseIn,
  output wire          io_pulseOut,
  input  wire          phyCd_clk,
  input  wire          phyCd_reset,
  input  wire          clk,
  output wire          phyCd_reset_syncronized_1
);

  wire                bufferCC_72_io_dataIn;
  wire                bufferCC_72_io_dataOut;
  wire                inArea_target_buffercc_io_dataOut;
  reg                 inArea_target;
  wire                phyCd_reset_syncronized;
  wire                outArea_target;
  reg                 outArea_target_regNext;

  BufferCC_67 bufferCC_72 (
    .io_dataIn   (bufferCC_72_io_dataIn ), //i
    .io_dataOut  (bufferCC_72_io_dataOut), //o
    .clk         (clk                   ), //i
    .phyCd_reset (phyCd_reset           )  //i
  );
  BufferCC_68 inArea_target_buffercc (
    .io_dataIn               (inArea_target                    ), //i
    .io_dataOut              (inArea_target_buffercc_io_dataOut), //o
    .clk                     (clk                              ), //i
    .phyCd_reset_syncronized (phyCd_reset_syncronized          )  //i
  );
  assign bufferCC_72_io_dataIn = (1'b0 ^ 1'b0);
  assign phyCd_reset_syncronized = bufferCC_72_io_dataOut;
  assign outArea_target = inArea_target_buffercc_io_dataOut;
  assign io_pulseOut = (outArea_target ^ outArea_target_regNext);
  assign phyCd_reset_syncronized_1 = phyCd_reset_syncronized;
  always @(posedge phyCd_clk or posedge phyCd_reset) begin
    if(phyCd_reset) begin
      inArea_target <= 1'b0;
    end else begin
      if(io_pulseIn) begin
        inArea_target <= (! inArea_target);
      end
    end
  end

  always @(posedge clk or posedge phyCd_reset_syncronized) begin
    if(phyCd_reset_syncronized) begin
      outArea_target_regNext <= 1'b0;
    end else begin
      outArea_target_regNext <= outArea_target;
    end
  end


endmodule

module StreamCCByToggle (
  input  wire          io_input_valid,
  output wire          io_input_ready,
  input  wire          io_input_payload_last,
  input  wire [7:0]    io_input_payload_fragment,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire          io_output_payload_last,
  output wire [7:0]    io_output_payload_fragment,
  input  wire          clk,
  input  wire          reset,
  input  wire          phyCd_clk,
  output wire          reset_syncronized_1
);

  wire                bufferCC_72_io_dataIn;
  wire                outHitSignal_buffercc_io_dataOut;
  wire                bufferCC_72_io_dataOut;
  wire                pushArea_target_buffercc_io_dataOut;
  wire                outHitSignal;
  wire                pushArea_hit;
  wire                pushArea_accept;
  reg                 pushArea_target;
  reg                 pushArea_data_last;
  reg        [7:0]    pushArea_data_fragment;
  wire                io_input_fire;
  wire                reset_syncronized;
  wire                popArea_stream_valid;
  reg                 popArea_stream_ready;
  wire                popArea_stream_payload_last;
  wire       [7:0]    popArea_stream_payload_fragment;
  wire                popArea_target;
  wire                popArea_stream_fire;
  reg                 popArea_hit;
  wire                popArea_stream_m2sPipe_valid;
  wire                popArea_stream_m2sPipe_ready;
  wire                popArea_stream_m2sPipe_payload_last;
  wire       [7:0]    popArea_stream_m2sPipe_payload_fragment;
  reg                 popArea_stream_rValid;
  (* async_reg = "true" *) reg                 popArea_stream_rData_last;
  (* async_reg = "true" *) reg        [7:0]    popArea_stream_rData_fragment;
  wire                when_Stream_l369;

  BufferCC_69 outHitSignal_buffercc (
    .io_dataIn  (outHitSignal                    ), //i
    .io_dataOut (outHitSignal_buffercc_io_dataOut), //o
    .clk        (clk                             ), //i
    .reset      (reset                           )  //i
  );
  BufferCC_70 bufferCC_72 (
    .io_dataIn  (bufferCC_72_io_dataIn ), //i
    .io_dataOut (bufferCC_72_io_dataOut), //o
    .phyCd_clk  (phyCd_clk             ), //i
    .reset      (reset                 )  //i
  );
  BufferCC_71 pushArea_target_buffercc (
    .io_dataIn         (pushArea_target                    ), //i
    .io_dataOut        (pushArea_target_buffercc_io_dataOut), //o
    .phyCd_clk         (phyCd_clk                          ), //i
    .reset_syncronized (reset_syncronized                  )  //i
  );
  assign pushArea_hit = outHitSignal_buffercc_io_dataOut;
  assign io_input_fire = (io_input_valid && io_input_ready);
  assign pushArea_accept = io_input_fire;
  assign io_input_ready = (pushArea_hit == pushArea_target);
  assign bufferCC_72_io_dataIn = (1'b0 ^ 1'b0);
  assign reset_syncronized = bufferCC_72_io_dataOut;
  assign popArea_target = pushArea_target_buffercc_io_dataOut;
  assign popArea_stream_fire = (popArea_stream_valid && popArea_stream_ready);
  assign outHitSignal = popArea_hit;
  assign popArea_stream_valid = (popArea_target != popArea_hit);
  assign popArea_stream_payload_last = pushArea_data_last;
  assign popArea_stream_payload_fragment = pushArea_data_fragment;
  always @(*) begin
    popArea_stream_ready = popArea_stream_m2sPipe_ready;
    if(when_Stream_l369) begin
      popArea_stream_ready = 1'b1;
    end
  end

  assign when_Stream_l369 = (! popArea_stream_m2sPipe_valid);
  assign popArea_stream_m2sPipe_valid = popArea_stream_rValid;
  assign popArea_stream_m2sPipe_payload_last = popArea_stream_rData_last;
  assign popArea_stream_m2sPipe_payload_fragment = popArea_stream_rData_fragment;
  assign io_output_valid = popArea_stream_m2sPipe_valid;
  assign popArea_stream_m2sPipe_ready = io_output_ready;
  assign io_output_payload_last = popArea_stream_m2sPipe_payload_last;
  assign io_output_payload_fragment = popArea_stream_m2sPipe_payload_fragment;
  assign reset_syncronized_1 = reset_syncronized;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      pushArea_target <= 1'b0;
    end else begin
      if(pushArea_accept) begin
        pushArea_target <= (! pushArea_target);
      end
    end
  end

  always @(posedge clk) begin
    if(pushArea_accept) begin
      pushArea_data_last <= io_input_payload_last;
      pushArea_data_fragment <= io_input_payload_fragment;
    end
  end

  always @(posedge phyCd_clk or posedge reset_syncronized) begin
    if(reset_syncronized) begin
      popArea_hit <= 1'b0;
      popArea_stream_rValid <= 1'b0;
    end else begin
      if(popArea_stream_fire) begin
        popArea_hit <= popArea_target;
      end
      if(popArea_stream_ready) begin
        popArea_stream_rValid <= popArea_stream_valid;
      end
    end
  end

  always @(posedge phyCd_clk) begin
    if(popArea_stream_fire) begin
      popArea_stream_rData_last <= popArea_stream_payload_last;
      popArea_stream_rData_fragment <= popArea_stream_payload_fragment;
    end
  end


endmodule

module BufferCC_3 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk,
  input  wire          reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

//BufferCC_2 replaced by BufferCC

//BufferCC_1 replaced by BufferCC

module BufferCC (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          phyCd_clk,
  input  wire          phyCd_reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge phyCd_clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

//UsbLsFsPhyFilter_3 replaced by UsbLsFsPhyFilter

//UsbLsFsPhyFilter_2 replaced by UsbLsFsPhyFilter

//UsbLsFsPhyFilter_1 replaced by UsbLsFsPhyFilter

module UsbLsFsPhyFilter (
  input  wire          io_lowSpeed,
  input  wire          io_usb_dp,
  input  wire          io_usb_dm,
  output wire          io_filtred_dp,
  output wire          io_filtred_dm,
  output wire          io_filtred_d,
  output wire          io_filtred_se0,
  output wire          io_filtred_sample,
  input  wire          phyCd_clk,
  input  wire          phyCd_reset
);

  wire       [4:0]    _zz_timer_sampleDo;
  reg                 timer_clear;
  reg        [4:0]    timer_counter;
  wire       [4:0]    timer_counterLimit;
  wire                when_UsbHubPhy_l93;
  wire       [3:0]    timer_sampleAt;
  wire                timer_sampleDo;
  reg                 io_usb_dp_regNext;
  reg                 io_usb_dm_regNext;
  wire                when_UsbHubPhy_l100;

  assign _zz_timer_sampleDo = {1'd0, timer_sampleAt};
  always @(*) begin
    timer_clear = 1'b0;
    if(when_UsbHubPhy_l100) begin
      timer_clear = 1'b1;
    end
  end

  assign timer_counterLimit = (io_lowSpeed ? 5'h1f : 5'h03);
  assign when_UsbHubPhy_l93 = ((timer_counter == timer_counterLimit) || timer_clear);
  assign timer_sampleAt = (io_lowSpeed ? 4'b1110 : 4'b0000);
  assign timer_sampleDo = ((timer_counter == _zz_timer_sampleDo) && (! timer_clear));
  assign when_UsbHubPhy_l100 = ((io_usb_dp ^ io_usb_dp_regNext) || (io_usb_dm ^ io_usb_dm_regNext));
  assign io_filtred_dp = io_usb_dp;
  assign io_filtred_dm = io_usb_dm;
  assign io_filtred_d = io_usb_dp;
  assign io_filtred_sample = timer_sampleDo;
  assign io_filtred_se0 = ((! io_usb_dp) && (! io_usb_dm));
  always @(posedge phyCd_clk) begin
    timer_counter <= (timer_counter + 5'h01);
    if(when_UsbHubPhy_l93) begin
      timer_counter <= 5'h00;
    end
    io_usb_dp_regNext <= io_usb_dp;
    io_usb_dm_regNext <= io_usb_dm;
  end


endmodule

module Crc_2 (
  input  wire          io_flush,
  input  wire          io_input_valid,
  input  wire [7:0]    io_input_payload,
  output wire [15:0]   io_result,
  output wire [15:0]   io_resultNext,
  input  wire          clk,
  input  wire          reset
);

  wire       [15:0]   _zz_acc_1;
  wire       [15:0]   _zz_acc_2;
  wire       [15:0]   _zz_acc_3;
  wire       [15:0]   _zz_acc_4;
  wire       [15:0]   _zz_acc_5;
  wire       [15:0]   _zz_acc_6;
  wire       [15:0]   _zz_acc_7;
  wire       [15:0]   _zz_acc_8;
  reg        [15:0]   acc_8;
  reg        [15:0]   acc_7;
  reg        [15:0]   acc_6;
  reg        [15:0]   acc_5;
  reg        [15:0]   acc_4;
  reg        [15:0]   acc_3;
  reg        [15:0]   acc_2;
  reg        [15:0]   acc_1;
  reg        [15:0]   state;
  wire       [15:0]   acc;
  wire       [15:0]   stateXor;
  wire       [15:0]   accXor;

  assign _zz_acc_1 = (acc <<< 1);
  assign _zz_acc_2 = (acc_1 <<< 1);
  assign _zz_acc_3 = (acc_2 <<< 1);
  assign _zz_acc_4 = (acc_3 <<< 1);
  assign _zz_acc_5 = (acc_4 <<< 1);
  assign _zz_acc_6 = (acc_5 <<< 1);
  assign _zz_acc_7 = (acc_6 <<< 1);
  assign _zz_acc_8 = (acc_7 <<< 1);
  always @(*) begin
    acc_8 = acc_7;
    acc_8 = (_zz_acc_8 ^ ((io_input_payload[7] ^ acc_7[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_7 = acc_6;
    acc_7 = (_zz_acc_7 ^ ((io_input_payload[6] ^ acc_6[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_6 = acc_5;
    acc_6 = (_zz_acc_6 ^ ((io_input_payload[5] ^ acc_5[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_5 = acc_4;
    acc_5 = (_zz_acc_5 ^ ((io_input_payload[4] ^ acc_4[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_4 = acc_3;
    acc_4 = (_zz_acc_4 ^ ((io_input_payload[3] ^ acc_3[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_3 = acc_2;
    acc_3 = (_zz_acc_3 ^ ((io_input_payload[2] ^ acc_2[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_2 = acc_1;
    acc_2 = (_zz_acc_2 ^ ((io_input_payload[1] ^ acc_1[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_1 = acc;
    acc_1 = (_zz_acc_1 ^ ((io_input_payload[0] ^ acc[15]) ? 16'h8005 : 16'h0000));
  end

  assign acc = state;
  assign stateXor = (state ^ 16'h0000);
  assign accXor = (acc_8 ^ 16'h0000);
  assign io_result = stateXor;
  assign io_resultNext = accXor;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      state <= 16'hffff;
    end else begin
      if(io_input_valid) begin
        state <= acc_8;
      end
      if(io_flush) begin
        state <= 16'hffff;
      end
    end
  end


endmodule

module Crc_1 (
  input  wire          io_flush,
  input  wire          io_input_valid,
  input  wire [7:0]    io_input_payload,
  output wire [15:0]   io_result,
  output wire [15:0]   io_resultNext,
  input  wire          clk,
  input  wire          reset
);

  wire       [15:0]   _zz_acc_1;
  wire       [15:0]   _zz_acc_2;
  wire       [15:0]   _zz_acc_3;
  wire       [15:0]   _zz_acc_4;
  wire       [15:0]   _zz_acc_5;
  wire       [15:0]   _zz_acc_6;
  wire       [15:0]   _zz_acc_7;
  wire       [15:0]   _zz_acc_8;
  wire                _zz_io_result;
  wire       [0:0]    _zz_io_result_1;
  wire       [6:0]    _zz_io_result_2;
  wire                _zz_io_resultNext;
  wire       [0:0]    _zz_io_resultNext_1;
  wire       [6:0]    _zz_io_resultNext_2;
  reg        [15:0]   acc_8;
  reg        [15:0]   acc_7;
  reg        [15:0]   acc_6;
  reg        [15:0]   acc_5;
  reg        [15:0]   acc_4;
  reg        [15:0]   acc_3;
  reg        [15:0]   acc_2;
  reg        [15:0]   acc_1;
  reg        [15:0]   state;
  wire       [15:0]   acc;
  wire       [15:0]   stateXor;
  wire       [15:0]   accXor;

  assign _zz_acc_1 = (acc <<< 1);
  assign _zz_acc_2 = (acc_1 <<< 1);
  assign _zz_acc_3 = (acc_2 <<< 1);
  assign _zz_acc_4 = (acc_3 <<< 1);
  assign _zz_acc_5 = (acc_4 <<< 1);
  assign _zz_acc_6 = (acc_5 <<< 1);
  assign _zz_acc_7 = (acc_6 <<< 1);
  assign _zz_acc_8 = (acc_7 <<< 1);
  assign _zz_io_result = stateXor[7];
  assign _zz_io_result_1 = stateXor[8];
  assign _zz_io_result_2 = {stateXor[9],{stateXor[10],{stateXor[11],{stateXor[12],{stateXor[13],{stateXor[14],stateXor[15]}}}}}};
  assign _zz_io_resultNext = accXor[7];
  assign _zz_io_resultNext_1 = accXor[8];
  assign _zz_io_resultNext_2 = {accXor[9],{accXor[10],{accXor[11],{accXor[12],{accXor[13],{accXor[14],accXor[15]}}}}}};
  always @(*) begin
    acc_8 = acc_7;
    acc_8 = (_zz_acc_8 ^ ((io_input_payload[7] ^ acc_7[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_7 = acc_6;
    acc_7 = (_zz_acc_7 ^ ((io_input_payload[6] ^ acc_6[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_6 = acc_5;
    acc_6 = (_zz_acc_6 ^ ((io_input_payload[5] ^ acc_5[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_5 = acc_4;
    acc_5 = (_zz_acc_5 ^ ((io_input_payload[4] ^ acc_4[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_4 = acc_3;
    acc_4 = (_zz_acc_4 ^ ((io_input_payload[3] ^ acc_3[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_3 = acc_2;
    acc_3 = (_zz_acc_3 ^ ((io_input_payload[2] ^ acc_2[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_2 = acc_1;
    acc_2 = (_zz_acc_2 ^ ((io_input_payload[1] ^ acc_1[15]) ? 16'h8005 : 16'h0000));
  end

  always @(*) begin
    acc_1 = acc;
    acc_1 = (_zz_acc_1 ^ ((io_input_payload[0] ^ acc[15]) ? 16'h8005 : 16'h0000));
  end

  assign acc = state;
  assign stateXor = (state ^ 16'hffff);
  assign accXor = (acc_8 ^ 16'hffff);
  assign io_result = {stateXor[0],{stateXor[1],{stateXor[2],{stateXor[3],{stateXor[4],{stateXor[5],{stateXor[6],{_zz_io_result,{_zz_io_result_1,_zz_io_result_2}}}}}}}}};
  assign io_resultNext = {accXor[0],{accXor[1],{accXor[2],{accXor[3],{accXor[4],{accXor[5],{accXor[6],{_zz_io_resultNext,{_zz_io_resultNext_1,_zz_io_resultNext_2}}}}}}}}};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      state <= 16'hffff;
    end else begin
      if(io_input_valid) begin
        state <= acc_8;
      end
      if(io_flush) begin
        state <= 16'hffff;
      end
    end
  end


endmodule

module Crc (
  input  wire          io_flush,
  input  wire          io_input_valid,
  input  wire [10:0]   io_input_payload,
  output wire [4:0]    io_result,
  output wire [4:0]    io_resultNext,
  input  wire          clk,
  input  wire          reset
);

  wire       [4:0]    _zz_acc_1;
  wire       [4:0]    _zz_acc_2;
  wire       [4:0]    _zz_acc_3;
  wire       [4:0]    _zz_acc_4;
  wire       [4:0]    _zz_acc_5;
  wire       [4:0]    _zz_acc_6;
  wire       [4:0]    _zz_acc_7;
  wire       [4:0]    _zz_acc_8;
  wire       [4:0]    _zz_acc_9;
  wire       [4:0]    _zz_acc_10;
  wire       [4:0]    _zz_acc_11;
  reg        [4:0]    acc_11;
  reg        [4:0]    acc_10;
  reg        [4:0]    acc_9;
  reg        [4:0]    acc_8;
  reg        [4:0]    acc_7;
  reg        [4:0]    acc_6;
  reg        [4:0]    acc_5;
  reg        [4:0]    acc_4;
  reg        [4:0]    acc_3;
  reg        [4:0]    acc_2;
  reg        [4:0]    acc_1;
  reg        [4:0]    state;
  wire       [4:0]    acc;
  wire       [4:0]    stateXor;
  wire       [4:0]    accXor;

  assign _zz_acc_1 = (acc <<< 1);
  assign _zz_acc_2 = (acc_1 <<< 1);
  assign _zz_acc_3 = (acc_2 <<< 1);
  assign _zz_acc_4 = (acc_3 <<< 1);
  assign _zz_acc_5 = (acc_4 <<< 1);
  assign _zz_acc_6 = (acc_5 <<< 1);
  assign _zz_acc_7 = (acc_6 <<< 1);
  assign _zz_acc_8 = (acc_7 <<< 1);
  assign _zz_acc_9 = (acc_8 <<< 1);
  assign _zz_acc_10 = (acc_9 <<< 1);
  assign _zz_acc_11 = (acc_10 <<< 1);
  always @(*) begin
    acc_11 = acc_10;
    acc_11 = (_zz_acc_11 ^ ((io_input_payload[10] ^ acc_10[4]) ? 5'h05 : 5'h00));
  end

  always @(*) begin
    acc_10 = acc_9;
    acc_10 = (_zz_acc_10 ^ ((io_input_payload[9] ^ acc_9[4]) ? 5'h05 : 5'h00));
  end

  always @(*) begin
    acc_9 = acc_8;
    acc_9 = (_zz_acc_9 ^ ((io_input_payload[8] ^ acc_8[4]) ? 5'h05 : 5'h00));
  end

  always @(*) begin
    acc_8 = acc_7;
    acc_8 = (_zz_acc_8 ^ ((io_input_payload[7] ^ acc_7[4]) ? 5'h05 : 5'h00));
  end

  always @(*) begin
    acc_7 = acc_6;
    acc_7 = (_zz_acc_7 ^ ((io_input_payload[6] ^ acc_6[4]) ? 5'h05 : 5'h00));
  end

  always @(*) begin
    acc_6 = acc_5;
    acc_6 = (_zz_acc_6 ^ ((io_input_payload[5] ^ acc_5[4]) ? 5'h05 : 5'h00));
  end

  always @(*) begin
    acc_5 = acc_4;
    acc_5 = (_zz_acc_5 ^ ((io_input_payload[4] ^ acc_4[4]) ? 5'h05 : 5'h00));
  end

  always @(*) begin
    acc_4 = acc_3;
    acc_4 = (_zz_acc_4 ^ ((io_input_payload[3] ^ acc_3[4]) ? 5'h05 : 5'h00));
  end

  always @(*) begin
    acc_3 = acc_2;
    acc_3 = (_zz_acc_3 ^ ((io_input_payload[2] ^ acc_2[4]) ? 5'h05 : 5'h00));
  end

  always @(*) begin
    acc_2 = acc_1;
    acc_2 = (_zz_acc_2 ^ ((io_input_payload[1] ^ acc_1[4]) ? 5'h05 : 5'h00));
  end

  always @(*) begin
    acc_1 = acc;
    acc_1 = (_zz_acc_1 ^ ((io_input_payload[0] ^ acc[4]) ? 5'h05 : 5'h00));
  end

  assign acc = state;
  assign stateXor = (state ^ 5'h1f);
  assign accXor = (acc_11 ^ 5'h1f);
  assign io_result = {stateXor[0],{stateXor[1],{stateXor[2],{stateXor[3],stateXor[4]}}}};
  assign io_resultNext = {accXor[0],{accXor[1],{accXor[2],{accXor[3],accXor[4]}}}};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      state <= 5'h1f;
    end else begin
      if(io_input_valid) begin
        state <= acc_11;
      end
      if(io_flush) begin
        state <= 5'h1f;
      end
    end
  end


endmodule

module StreamFifo (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [63:0]   io_push_payload,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [63:0]   io_pop_payload,
  input  wire          io_flush,
  output wire [8:0]    io_occupancy,
  output wire [8:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  reg        [63:0]   _zz_logic_ram_port1;
  reg                 _zz_1;
  wire                logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [8:0]    logic_ptr_push;
  reg        [8:0]    logic_ptr_pop;
  wire       [8:0]    logic_ptr_occupancy;
  wire       [8:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1205;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [7:0]    logic_push_onRam_write_payload_address;
  wire       [63:0]   logic_push_onRam_write_payload_data;
  wire                logic_pop_addressGen_valid;
  reg                 logic_pop_addressGen_ready;
  wire       [7:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire                logic_pop_sync_readArbitation_valid;
  wire                logic_pop_sync_readArbitation_ready;
  wire       [7:0]    logic_pop_sync_readArbitation_payload;
  reg                 logic_pop_addressGen_rValid;
  reg        [7:0]    logic_pop_addressGen_rData;
  wire                when_Stream_l369;
  wire                logic_pop_sync_readPort_cmd_valid;
  wire       [7:0]    logic_pop_sync_readPort_cmd_payload;
  wire       [63:0]   logic_pop_sync_readPort_rsp;
  wire                logic_pop_sync_readArbitation_translated_valid;
  wire                logic_pop_sync_readArbitation_translated_ready;
  wire       [63:0]   logic_pop_sync_readArbitation_translated_payload;
  wire                logic_pop_sync_readArbitation_fire;
  reg        [8:0]    logic_pop_sync_popReg;
  reg [63:0] logic_ram [0:255];

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= logic_push_onRam_write_payload_data;
    end
  end

  always @(posedge clk) begin
    if(logic_pop_sync_readPort_cmd_valid) begin
      _zz_logic_ram_port1 <= logic_ram[logic_pop_sync_readPort_cmd_payload];
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1205 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign logic_ptr_doPush = io_push_fire;
  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[7:0];
  assign logic_push_onRam_write_payload_data = io_push_payload;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[7:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  always @(*) begin
    logic_pop_addressGen_ready = logic_pop_sync_readArbitation_ready;
    if(when_Stream_l369) begin
      logic_pop_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l369 = (! logic_pop_sync_readArbitation_valid);
  assign logic_pop_sync_readArbitation_valid = logic_pop_addressGen_rValid;
  assign logic_pop_sync_readArbitation_payload = logic_pop_addressGen_rData;
  assign logic_pop_sync_readPort_rsp = _zz_logic_ram_port1;
  assign logic_pop_sync_readPort_cmd_valid = logic_pop_addressGen_fire;
  assign logic_pop_sync_readPort_cmd_payload = logic_pop_addressGen_payload;
  assign logic_pop_sync_readArbitation_translated_valid = logic_pop_sync_readArbitation_valid;
  assign logic_pop_sync_readArbitation_ready = logic_pop_sync_readArbitation_translated_ready;
  assign logic_pop_sync_readArbitation_translated_payload = logic_pop_sync_readPort_rsp;
  assign io_pop_valid = logic_pop_sync_readArbitation_translated_valid;
  assign logic_pop_sync_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload = logic_pop_sync_readArbitation_translated_payload;
  assign logic_pop_sync_readArbitation_fire = (logic_pop_sync_readArbitation_valid && logic_pop_sync_readArbitation_ready);
  assign logic_ptr_popOnIo = logic_pop_sync_popReg;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (9'h100 - logic_ptr_occupancy);
  assign logic_ptr_full = 1'b0;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_ptr_push <= 9'h000;
      logic_ptr_pop <= 9'h000;
      logic_ptr_wentUp <= 1'b0;
      logic_pop_addressGen_rValid <= 1'b0;
      logic_pop_sync_popReg <= 9'h000;
    end else begin
      if(when_Stream_l1205) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 9'h001);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 9'h001);
      end
      if(io_flush) begin
        logic_ptr_push <= 9'h000;
        logic_ptr_pop <= 9'h000;
      end
      if(logic_pop_addressGen_ready) begin
        logic_pop_addressGen_rValid <= logic_pop_addressGen_valid;
      end
      if(io_flush) begin
        logic_pop_addressGen_rValid <= 1'b0;
      end
      if(logic_pop_sync_readArbitation_fire) begin
        logic_pop_sync_popReg <= logic_ptr_pop;
      end
      if(io_flush) begin
        logic_pop_sync_popReg <= 9'h000;
      end
    end
  end

  always @(posedge clk) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule

//BufferCC_22 replaced by BufferCC_71

//BufferCC_21 replaced by BufferCC_69

//BufferCC_24 replaced by BufferCC_71

//BufferCC_23 replaced by BufferCC_69

//BufferCC_26 replaced by BufferCC_71

//BufferCC_25 replaced by BufferCC_69

//BufferCC_28 replaced by BufferCC_71

//BufferCC_27 replaced by BufferCC_69

//BufferCC_29 replaced by BufferCC_68

//BufferCC_30 replaced by BufferCC_68

//BufferCC_31 replaced by BufferCC_68

//BufferCC_33 replaced by BufferCC_71

//BufferCC_32 replaced by BufferCC_69

//BufferCC_35 replaced by BufferCC_71

//BufferCC_34 replaced by BufferCC_69

//BufferCC_37 replaced by BufferCC_71

//BufferCC_36 replaced by BufferCC_69

//BufferCC_39 replaced by BufferCC_71

//BufferCC_38 replaced by BufferCC_69

//BufferCC_40 replaced by BufferCC_68

//BufferCC_41 replaced by BufferCC_68

//BufferCC_42 replaced by BufferCC_68

//BufferCC_44 replaced by BufferCC_71

//BufferCC_43 replaced by BufferCC_69

//BufferCC_46 replaced by BufferCC_71

//BufferCC_45 replaced by BufferCC_69

//BufferCC_48 replaced by BufferCC_71

//BufferCC_47 replaced by BufferCC_69

//BufferCC_50 replaced by BufferCC_71

//BufferCC_49 replaced by BufferCC_69

//BufferCC_51 replaced by BufferCC_68

//BufferCC_52 replaced by BufferCC_68

//BufferCC_53 replaced by BufferCC_68

//BufferCC_55 replaced by BufferCC_71

//BufferCC_54 replaced by BufferCC_69

//BufferCC_57 replaced by BufferCC_71

//BufferCC_56 replaced by BufferCC_69

//BufferCC_59 replaced by BufferCC_71

//BufferCC_58 replaced by BufferCC_69

//BufferCC_61 replaced by BufferCC_71

//BufferCC_60 replaced by BufferCC_69

//BufferCC_62 replaced by BufferCC_68

//BufferCC_63 replaced by BufferCC_68

//BufferCC_64 replaced by BufferCC_68

//BufferCC_65 replaced by BufferCC_68

//BufferCC_66 replaced by BufferCC_68

module BufferCC_68 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk,
  input  wire          phyCd_reset_syncronized
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk or posedge phyCd_reset_syncronized) begin
    if(phyCd_reset_syncronized) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_67 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk,
  input  wire          phyCd_reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk or posedge phyCd_reset) begin
    if(phyCd_reset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_71 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          phyCd_clk,
  input  wire          reset_syncronized
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge phyCd_clk or posedge reset_syncronized) begin
    if(reset_syncronized) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_70 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          phyCd_clk,
  input  wire          reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge phyCd_clk or posedge reset) begin
    if(reset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module BufferCC_69 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk,
  input  wire          reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule
