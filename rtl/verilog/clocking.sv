`timescale 1ns/1ps

module Clocking(
  input clk_in,
  input nreset_in,
  input [1:0] video_mode,
  output reg clk,
  output reg reset,
  output reg clk_delayed,
  output reg tmds_pixel_clk,
  output reg tmds_x5_clk
);

  parameter CLK_FREQ = 96_000_000;
  localparam CLK_PERIOD = 1_000_000_000.0 / CLK_FREQ;

  parameter TMDS_FREQ_1 = 25_175_000; // 640x480
  parameter TMDS_FREQ_2 = 65_000_000; // 1024x768
  parameter TMDS_FREQ_3 = 74_250_000; // 1280x720

  localparam TMDS_BIT_PERIOD_1 = 1_000_000_000.0 / (TMDS_FREQ_1 * 10);
  localparam TMDS_BIT_PERIOD_2 = 1_000_000_000.0 / (TMDS_FREQ_2 * 10);
  localparam TMDS_BIT_PERIOD_3 = 1_000_000_000.0 / (TMDS_FREQ_3 * 10);

  initial reset = 1'b1;

  parameter RESET_DELAY = CLK_FREQ / 1000; // 1ms

  reg [$clog2(RESET_DELAY)-1:0] reset_counter = RESET_DELAY;

  always @(posedge clk) begin
    if (nreset_in) begin
      if (|reset_counter)
        reset_counter <= reset_counter - 1'b1;
      else
        reset <= 0;
    end else begin
      reset <= 1;
      reset_counter <= RESET_DELAY;
    end
  end

`ifdef IVERILOG

  initial begin
    clk = 0;
    clk_delayed = 0;
    tmds_pixel_clk = 0;
    tmds_x5_clk = 0;

    #(CLK_PERIOD/4);
    while (1) #(CLK_PERIOD/2) clk_delayed = ~clk_delayed;
  end

  always #(CLK_PERIOD/2) clk = ~clk;

  reg tmds_bit_clk = 0;

  always #(TMDS_BIT_PERIOD_1/2) if (video_mode == 2'd1) tmds_bit_clk = ~tmds_bit_clk;
  always #(TMDS_BIT_PERIOD_2/2) if (video_mode == 2'd2) tmds_bit_clk = ~tmds_bit_clk;
  always #(TMDS_BIT_PERIOD_3/2) if (video_mode == 2'd3) tmds_bit_clk = ~tmds_bit_clk;

  reg [3:0] tmds_bit_counter = 0;
  always @(posedge tmds_bit_clk) begin
    tmds_x5_clk = ~tmds_x5_clk;
    tmds_bit_counter <= tmds_bit_counter == 4'd9 ? 4'd0 : (tmds_bit_counter + 4'd1);
    if (tmds_bit_counter == 4'd0 || tmds_bit_counter == 4'd5) tmds_pixel_clk = ~tmds_pixel_clk;
  end

`else

  PLL pll(
    .inclk0(clk_in),
    .c0(clk),
    .c1(clk_delayed),
    .c2(tmds_pixel_clk),
    .c3(tmds_x5_clk)
  );

`endif

endmodule

