// Rough simulation of `rtl/quartus_ip` functionality. Needed to simulare the project with Icarus Verilog.

`timescale 1ns/1ps

`ifdef IVERILOG

`define FREQ_96

module PLL(input inclk0, output reg c0, output reg c1);
  initial c0 = 0;
  initial c1 = 0;
`ifdef FREQ_96
  always #5.208 c0 = ~c0;  // 96mhz
  initial begin
    #2.604;
    while (1) #5.208 c1 = ~c1;
  end
`else
  always #5.952 c0 = ~c0;  // 84mhz
  initial begin
    #2.976;
    while (1) #5.952 c1 = ~c1;
  end
`endif
endmodule

module ddr_gpio_sim #(parameter WIDTH, parameter INCLOCK_INV = 0) (
  inclock, dout,
  outclock, din,
  oe,
  pad_io
);

  input inclock;
  output reg [WIDTH*2-1:0] dout;
  input outclock;
  input [WIDTH*2-1:0] din;
  input [WIDTH-1:0] oe;
  inout [WIDTH-1:0] pad_io;

  reg [WIDTH-1:0] pad_o;

  reg [WIDTH-1:0] pad_o_buf;
  reg [WIDTH*2-1:0] pad_i_buf;

  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : assign_pad_io
      assign pad_io[i] = oe[i] ? pad_o[i] : 1'bz;
    end
  endgenerate

  always @(posedge outclock) begin
    pad_o <= din[WIDTH-1:0];
    pad_o_buf <= din[WIDTH*2-1:WIDTH];
  end

  always @(negedge outclock) begin
    pad_o <= pad_o_buf;
  end

  always @(posedge inclock or negedge inclock) begin
    #0.001 pad_i_buf = {pad_io, pad_i_buf[WIDTH*2-1:WIDTH]};
  end

  always @(negedge (inclock ^ INCLOCK_INV)) begin
    dout <= pad_i_buf;
  end

endmodule

module DDR_IO8(
  inclock, dout,
  outclock, din,
  oe,
  pad_io
);
  localparam WIDTH = 8;

  input inclock;
  output reg [WIDTH*2-1:0] dout;
  input outclock;
  input [WIDTH*2-1:0] din;
  input [WIDTH-1:0] oe;
  inout [WIDTH-1:0] pad_io;

  ddr_gpio_sim #(.WIDTH(WIDTH), .INCLOCK_INV(1)) impl(
    .inclock(inclock), .dout(dout),
    .outclock(outclock), .din(din),
    .oe(oe), .pad_io(pad_io)
  );

endmodule

`endif
