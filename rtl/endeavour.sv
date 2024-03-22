module Endeavour(
  input clk100mhz,
  input [2:0] keys,
  output [2:0] leds,
  input uart_rx,
  output uart_tx,
  // DDR1 SDRAM
  inout  [15:0] DDR_DQ,
  inout  [1:0]  DDR_DQS,
  output [12:0] DDR_A,
  output [1:0]  DDR_BA,
  output [3:0]  DDR_nCS,
  output        DDR_CK,
  output        DDR_nCK,
  output        DDR_CKE,
  output        DDR_nWE,
  output        DDR_nCAS,
  output        DDR_nRAS,
  output [1:0]  DDR_DM,
  /*DVI_D.I dvi_interface,
  SDCARD.I sdcard_interface,
  ETH.I ethernet_interface,
  SOUND.I sound_interface,*/
  // USB
  inout usb_dev_dm,
  inout usb_dev_dp,
  inout usb_host1_dm,
  inout usb_host1_dp,
  inout usb_host2_dm,
  inout usb_host2_dp
);
  
  wire clk, ram_dqs_clk;
  reg reset = 1;
  
  PLL pll(.inclk0(clk100mhz), .c0(clk), .c1(ram_dqs_clk));

  parameter SIMULATION = 0;
  defparam uart_ctrl.SIMULATION = SIMULATION;

  reg [SIMULATION ? 3 : 15:0] reset_counter = '0;

  always @(posedge clk) begin
    if (keys[0]) begin
      reset_counter <= '0;
      reset <= 1;
    end else begin
      // reset_counter adds a delay about 0.6-0.7ms to prevent reset button jitter
      // and to give time for PLL to stabilize frequency. In simulation delay is reduced.
      reset_counter <= reset_counter + 1'b1;
      if (&reset_counter) reset <= 0;
    end
  end
  
  reg [2:0] leds_normalized = '0;
  assign leds = leds_normalized ^ 3'b011;
  wire [2:0] keys_normalized = keys ^ 3'b110;
  
  wire apb_sel;
  wire apb_enable;
  wire apb_write;
  wire [9:0] apb_addr;
  wire [31:0] apb_wdata;
  wire [31:0] apb_rdata;

  wire sel_gpio = apb_sel & (apb_addr[9:4] == 6'h0);    // 0x100000 -> {26'b0, leds, keys}
  wire sel_uart = apb_sel & (apb_addr[9:4] == 6'h1);    // 0x100010 -> uart receiver, 0x100014 -> uart transmitter, 0x100018 -> uart divisor
 
  reg selbuf_gpio, selbuf_uart;
  always @(posedge clk) begin
    selbuf_gpio <= sel_gpio;
    selbuf_uart <= sel_uart;
  end
 
  wire [31:0] uart_rdata;
  UART uart_ctrl(
    .clk(clk), .reset(reset),
    .rx(uart_rx), .tx(uart_tx),
    .sel_receiver(sel_uart & (apb_addr[3:2] == 2'b0)),
    .sel_transmitter(sel_uart & apb_addr[2]),
    .sel_divisor(sel_uart & apb_addr[3]),
    .apb_enable(apb_enable),
    .apb_write(apb_write),
    .apb_wdata(apb_wdata),
    .apb_rdata(uart_rdata)
  );

  assign apb_rdata = selbuf_gpio ? {26'b0, leds_normalized, keys_normalized} : uart_rdata;
                     //selbuf_uart ? uart_rdata;

  always @(posedge clk) begin
    if (reset)
      leds_normalized <= 3'b0;
    else if (selbuf_gpio & apb_write & apb_enable)
      leds_normalized <= apb_wdata[5:3];
  end

  wire          axi4_ram_arw_valid;
  wire          axi4_ram_arw_ready;
  wire [27:0]   axi4_ram_arw_payload_addr;
  wire [0:0]    axi4_ram_arw_payload_id;
  wire [7:0]    axi4_ram_arw_payload_len;
  wire [2:0]    axi4_ram_arw_payload_size;
  wire [1:0]    axi4_ram_arw_payload_burst;
  wire          axi4_ram_arw_payload_write;
  wire          axi4_ram_w_valid;
  wire          axi4_ram_w_ready;
  wire [31:0]   axi4_ram_w_payload_data;
  wire [3:0]    axi4_ram_w_payload_strb;
  wire          axi4_ram_w_payload_last;
  wire          axi4_ram_b_valid;
  wire          axi4_ram_b_ready;
  wire          axi4_ram_r_valid;
  wire          axi4_ram_r_ready;
  wire [31:0]   axi4_ram_r_payload_data;
  wire          axi4_ram_r_payload_last;
  reg     axi4_ram_payload_id;

  always @(posedge clk) begin
    if (axi4_ram_arw_valid & axi4_ram_arw_ready) axi4_ram_payload_id <= axi4_ram_arw_payload_id;
  end

  VexRiscvWithCrossbar core(
    .clk(clk), .reset(reset),
    // peripheral bus
    .io_apb3_PREADY(1'b1),
    .io_apb3_PSLVERROR(1'b0),
    .io_apb3_PSEL(apb_sel),
    .io_apb3_PENABLE(apb_enable),
    .io_apb3_PWRITE(apb_write),
    .io_apb3_PADDR(apb_addr),
    .io_apb3_PWDATA(apb_wdata),
    .io_apb3_PRDATA(apb_rdata),
    // ram bus
    .io_axi4_ram_arw_valid(axi4_ram_arw_valid),
    .io_axi4_ram_arw_ready(axi4_ram_arw_ready),
    .io_axi4_ram_arw_payload_addr(axi4_ram_arw_payload_addr),
    .io_axi4_ram_arw_payload_id(axi4_ram_arw_payload_id),
    .io_axi4_ram_arw_payload_len(axi4_ram_arw_payload_len),
    .io_axi4_ram_arw_payload_write(axi4_ram_arw_payload_write),
    .io_axi4_ram_arw_payload_size(axi4_ram_arw_payload_size),    // expected to be always 3'b010 (4 bytes transfer)
    .io_axi4_ram_arw_payload_burst(axi4_ram_arw_payload_burst),  // expected to be always 2'b01  (INCR)
    .io_axi4_ram_w_valid(axi4_ram_w_valid),
    .io_axi4_ram_w_ready(axi4_ram_w_ready),
    .io_axi4_ram_w_payload_data(axi4_ram_w_payload_data),
    .io_axi4_ram_w_payload_strb(axi4_ram_w_payload_strb),
    .io_axi4_ram_w_payload_last(axi4_ram_w_payload_last),
    .io_axi4_ram_b_valid(axi4_ram_b_valid),
    .io_axi4_ram_b_ready(axi4_ram_b_ready),
    .io_axi4_ram_b_payload_id(axi4_ram_payload_id),
    .io_axi4_ram_r_valid(axi4_ram_r_valid),
    .io_axi4_ram_r_ready(axi4_ram_r_ready),
    .io_axi4_ram_r_payload_data(axi4_ram_r_payload_data),
    .io_axi4_ram_r_payload_id(axi4_ram_payload_id),
    .io_axi4_ram_r_payload_last(axi4_ram_r_payload_last)
  );
  
  wire ddr_arready;
  wire ddr_awready;
  assign axi4_ram_arw_ready = axi4_ram_arw_payload_write ? ddr_awready : ddr_arready;
  
  wire ram_nCS;
  assign DDR_nCS = {3'b0, ram_nCS};

  ddr_sdram_ctrl #(
    .READ_BUFFER(0),
    .BA_BITS(2),
    .ROW_BITS(13),
    .COL_BITS(10),
    .DQ_LEVEL(2),
    .tREFC(10'd650),
    .tW2I(8'd2),
    .tR2I(8'd2)
  ) ram_ctrl (
    .clk(clk),
    .dqs_clk(ram_dqs_clk),
    .reset(reset),
    // AXI4 interface
    .awvalid(axi4_ram_arw_valid & axi4_ram_arw_payload_write),
    .arvalid(axi4_ram_arw_valid & ~axi4_ram_arw_payload_write),
    .awready(ddr_awready),
    .arready(ddr_arready),
    .awaddr(axi4_ram_arw_payload_addr[25:0]),
    .araddr(axi4_ram_arw_payload_addr[25:0]),
    .awlen(axi4_ram_arw_payload_len),
    .arlen(axi4_ram_arw_payload_len),
    .wvalid(axi4_ram_w_valid),
    .wready(axi4_ram_w_ready),
    .wlast(axi4_ram_w_payload_last),
    // axi4_ram_w_payload_strb 3:0
    .wdata(axi4_ram_w_payload_data),
    .bvalid(axi4_ram_b_valid),
    .bready(axi4_ram_b_ready),
    .rvalid(axi4_ram_r_valid),
    .rready(axi4_ram_r_ready),
    .rlast(axi4_ram_r_payload_last),
    .rdata(axi4_ram_r_payload_data),
    // DDR SDRAM interface
    .ddr_ras_n(DDR_nRAS),
    .ddr_cas_n(DDR_nCAS),
    .ddr_we_n(DDR_nWE),
    .ddr_ba(DDR_BA),
    .ddr_a(DDR_A),
    .ddr_dm(DDR_DM),
    .ddr_cke(DDR_CKE),
    .ddr_ck_p(DDR_CK),
    .ddr_ck_n(DDR_nCK),
    .ddr_dq(DDR_DQ),
    .ddr_dqs(DDR_DQS),
    .ddr_cs_n(ram_nCS)
  );

  /*
  assign sdcard_interface.clk = '0;
  assign sdcard_interface.data = 'z;
  assign sdcard_interface.cmd = '0;

  assign sound_interface.i2c_scl = '0;
  assign sound_interface.i2c_sda = 'z;
  assign sound_interface.enable = '0;
  
  assign ethernet_interface.rj45_6 = 'z;
  assign ethernet_interface.rj45_3 = 'z;
  assign ethernet_interface.rj45_2 = 'z;
  assign ethernet_interface.rj45_1 = 'z;*/

  assign usb_dev_dm = 'z;
  assign usb_dev_dp = 'z;
  assign usb_host1_dm = 'z;
  assign usb_host1_dp = 'z;
  assign usb_host2_dm = 'z;
  assign usb_host2_dp = 'z;

endmodule
