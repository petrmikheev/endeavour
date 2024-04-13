/*module InternalRam #(parameter ADDR_BITS = 14) (
  input clk,
  input reset,

  input                 axi_arw_valid,
  output                axi_arw_ready,
  input [ADDR_BITS-1:0] axi_arw_payload_addr,
  input           [0:0] axi_arw_payload_id,
  input           [7:0] axi_arw_payload_len,
  input           [2:0] axi_arw_payload_size,
  input           [1:0] axi_arw_payload_burst,
  input                 axi_arw_payload_write,

  input         axi_w_valid,
  output        axi_w_ready,
  input  [31:0] axi_w_payload_data,
  input   [3:0] axi_w_payload_strb,
  input         axi_w_payload_last,

  output        axi_b_valid,
  input         axi_b_ready,
  output  [0:0] axi_b_payload_id,

  output        axi_r_valid,
  input         axi_r_ready,
  output [31:0] axi_r_payload_data,
  output  [0:0] axi_r_payload_id,
  output        axi_r_payload_last
);

  assign axi_arw_ready = 1'b1;

  reg addr_incr, addr_wrap;
  reg [ADDR_BITS-1:0] addr;

  always @(posedge clk) begin
    if (axi_arw_valid & axi_arw_ready) begin
      addr <= axi_arw_payload_addr;
      {addr_wrap, addr_incr} <= axi_arw_payload_burst;
    end
  end

endmodule*/

module Ram_1wrs(
  input clk,
  input en,
  input wr,
  input [11:0] addr,
  input [3:0] mask,
  input [31:0] wrData,
  output reg [31:0] rdData
);

parameter wordCount = 4096;
parameter wordWidth = 32;
parameter readUnderWrite = "dontCare";
parameter duringWrite = "dontCare";
parameter technology = "auto";
parameter maskWidth = 4;
parameter maskEnable = 1'b1;

`ifndef IVERILOG

OnChipRAM internal_ram(
        .address(addr),
        .byteena(mask),
        .clken(en),
        .clock(clk),
        .data(wrData),
        .wren(wr & addr[11]),  // first 8KB is ROM
        .q(rdData));

`else

  reg [31:0] data [0:4095];

  integer i;
  integer file = $fopen("../../software/bios/bios_sim.bin", "rb");
  initial begin
    for (i = 0; i < 4096; i = i + 1) data[i] = '0;
    if (!$fread(data, file)) $display("BIOS ROM initialization failed");
  end

  reg wr_buf;
  reg [11:0] addr_buf;
  reg [3:0] mask_buf;
  reg [31:0] wrData_buf;

  assign rdData = {data[addr_buf][7:0], data[addr_buf][15:8], data[addr_buf][23:16], data[addr_buf][31:24]};

  always @(posedge clk) begin
    if (en) begin
      wr_buf <= wr & addr[11];
      addr_buf <= addr;
      mask_buf <= mask;
      wrData_buf <= wrData;
    end
    if (wr_buf) begin
      if (mask_buf[0]) data[addr_buf][31:24] <= wrData_buf[7:0];
      if (mask_buf[1]) data[addr_buf][23:16] <= wrData_buf[15:8];
      if (mask_buf[2]) data[addr_buf][15:8] <= wrData_buf[23:16];
      if (mask_buf[3]) data[addr_buf][7:0] <= wrData_buf[31:24];
    end
  end

  /*always @(posedge clk) begin
    if (en) rdData <= {data[addr][7:0], data[addr][15:8], data[addr][23:16], data[addr][31:24]};
    if (en & wr & addr[11]) begin
      if (mask[0]) data[addr][31:24] <= wrData[7:0];
      if (mask[1]) data[addr][23:16] <= wrData[15:8];
      if (mask[2]) data[addr][15:8] <= wrData[23:16];
      if (mask[3]) data[addr][7:0] <= wrData[31:24];
    end
  end*/

`endif

endmodule
