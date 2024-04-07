// Used in VexRiscvGen as internal RAM.

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
	.wren(wr & |addr[11:10]),  // first 4KB is bootloader ROM
	.q(rdData));

`else

  reg [31:0] data [0:4095];

  integer i;
  integer file = $fopen("../software/bootloader/bootloader.bin", "rb");
  initial begin
    for (i = 0; i < 4096; i = i + 1) data[i] = '0;
    if (!$fread(data, file)) $display("BootloaderROM initialization failed");
  end

  always @(posedge clk) begin
    if (en) rdData <= {data[addr][7:0], data[addr][15:8], data[addr][23:16], data[addr][31:24]};
    if (en & wr & |addr[11:10]) begin
      if (mask[0]) data[addr][31:24] <= wrData[7:0];
      if (mask[1]) data[addr][23:16] <= wrData[15:8];
      if (mask[2]) data[addr][15:8] <= wrData[23:16];
      if (mask[3]) data[addr][7:0] <= wrData[31:24];
    end
  end

`endif

endmodule
