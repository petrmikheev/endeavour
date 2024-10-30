module Ram_1wrs(
  input clk,
  input en,
  input wr,
  input [10:0] addr,
  input [7:0] mask,
  input [63:0] wrData,
  output reg [63:0] rdData
);

parameter wordCount = 2048;
parameter wordWidth = 64;
parameter readUnderWrite = "dontCare";
parameter duringWrite = "dontCare";
parameter technology = "auto";
parameter maskWidth = 8;
parameter maskEnable = 1'b1;

`ifndef IVERILOG

OnChipRAM internal_ram(
        .address(addr),
        .byteena(mask),
        .clken(en),
        .clock(clk),
        .data(wrData),
        .wren(wr & addr[10]),  // first 8KB is ROM
        .q(rdData));

`else

  reg [63:0] data [0:2047];

  integer i;
  integer file = $fopen("../../software/bios/bios_sim.bin", "rb");
  initial begin
    for (i = 0; i < 2048; i = i + 1) data[i] = '0;
    if (!$fread(data, file)) $display("BIOS ROM initialization failed");
  end

  reg wr_buf;
  reg [10:0] addr_buf;
  reg [7:0] mask_buf;
  reg [63:0] wrData_buf;

  assign rdData = {data[addr_buf][7:0], data[addr_buf][15:8], data[addr_buf][23:16], data[addr_buf][31:24],
                   data[addr_buf][39:32], data[addr_buf][47:40], data[addr_buf][55:48], data[addr_buf][63:56]};

  always @(posedge clk) begin
    if (en) begin
      wr_buf <= wr & addr[10];
      addr_buf <= addr;
      mask_buf <= mask;
      wrData_buf <= wrData;
    end
    if (wr_buf) begin
      if (mask_buf[0]) data[addr_buf][63:56] <= wrData_buf[7:0];
      if (mask_buf[1]) data[addr_buf][55:48] <= wrData_buf[15:8];
      if (mask_buf[2]) data[addr_buf][47:40] <= wrData_buf[23:16];
      if (mask_buf[3]) data[addr_buf][39:32] <= wrData_buf[31:24];
      if (mask_buf[4]) data[addr_buf][31:24] <= wrData_buf[39:32];
      if (mask_buf[5]) data[addr_buf][23:16] <= wrData_buf[47:40];
      if (mask_buf[6]) data[addr_buf][15:8] <= wrData_buf[55:48];
      if (mask_buf[7]) data[addr_buf][7:0] <= wrData_buf[63:56];
    end
  end

`endif

endmodule
