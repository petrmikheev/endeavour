`ifdef MINIMAL

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
        .wren(wr & |addr[11:10]),  // first 4KB is ROM
        .q(rdData));

`else

  reg [31:0] data [0:4095];

  integer i;
  integer file = $fopen("../../software/bios/bios_minimal.bin", "rb");
  initial begin
    for (i = 0; i < 4096; i = i + 1) data[i] = '0;
    if (!$fread(data, file)) $display("BIOS ROM initialization failed");
  end

  reg wr_buf;
  reg [11:0] addr_buf;
  reg [7:0] mask_buf;
  reg [31:0] wrData_buf;

  assign rdData = {data[addr_buf][7:0], data[addr_buf][15:8], data[addr_buf][23:16], data[addr_buf][31:24]};

  always @(posedge clk) begin
    if (en) begin
      wr_buf <= wr & |addr[11:10];
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

`endif

endmodule

`endif
