// Rough simulation of `rtl/quartus_ip` functionality. Needed to simulare the project with Icarus Verilog.

`timescale 1ns/1ps

`ifdef IVERILOG

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

module DDR_IO2(
  inclock, dout,
  outclock, din,
  oe,
  pad_io
);
  localparam WIDTH = 2;

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

module DDR_IO1(
  inclock, dout,
  outclock, din,
  oe,
  pad_io
);
  localparam WIDTH = 1;

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

module DDR_O4 (
  input  wire       outclock,
  input  wire [7:0] din,
  output wire [3:0] pad_out
);
  ddr_gpio_sim #(.WIDTH(4)) impl(
    .inclock(1'b0),
    .outclock(outclock), .din(din),
    .oe(4'b1111), .pad_io(pad_out)
  );
endmodule

module DDR_O2 (
  input  wire       outclock,
  input  wire [3:0] din,
  output wire [1:0] pad_out
);
  ddr_gpio_sim #(.WIDTH(2)) impl(
    .inclock(1'b0),
    .outclock(outclock), .din(din),
    .oe(2'b11), .pad_io(pad_out)
  );
endmodule

module DDR_O1 (
  input  wire       outclock,
  input  wire [1:0] din,
  output wire [0:0] pad_out
);
  ddr_gpio_sim #(.WIDTH(1)) impl(
    .inclock(1'b0),
    .outclock(outclock), .din(din),
    .oe(1'b1), .pad_io(pad_out)
  );
endmodule

`endif
