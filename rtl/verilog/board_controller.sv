`timescale 1ns/1ps

module BoardController(
  input clk_in,
  input nreset_in,

  output plla_i2c_scl,
  inout  plla_i2c_sda,
  input  plla_clk0,
  input  plla_clk1,
  input  plla_clk2,

  output pllb_i2c_scl,
  inout  pllb_i2c_sda,
  input  pllb_clk0,
  input  pllb_clk1,
  input  pllb_clk2,

  output  [2:0] leds,
  input   [1:0] keys,

  output reg reset,
  output reg clk_cpu,
  output reg clk_ram,
  // output reg clk_ram_bus,
  output reg clk_peripheral,
  output reg clk_tmds_pixel,
  output reg clk_tmds_x5,

  input [1:0] video_mode,

  input   [3:0] apb_PADDR,
  input         apb_PSEL,
  input         apb_PENABLE,
  output        apb_PREADY,
  input         apb_PWRITE,
  input  [31:0] apb_PWDATA,
  output [31:0] apb_PRDATA
);

  assign plla_i2c_scl = 1'bz;
  assign plla_i2c_sda = 1'bz;
  assign pllb_i2c_scl = 1'bz;
  assign pllb_i2c_sda = 1'bz;

  parameter CPU_FREQ = 85_661_538; //92_800_000; //88_727_000; //48_000_000;
  localparam CPU_PERIOD = 1_000_000_000.0 / CPU_FREQ;

  parameter PERIPHERAL_FREQ = 48_000_000;
  localparam PERIPHERAL_PERIOD = 1_000_000_000.0 / PERIPHERAL_FREQ;

  parameter TMDS_FREQ_1 = 25_175_000; // 640x480
  parameter TMDS_FREQ_2 = 65_000_000; // 1024x768
  parameter TMDS_FREQ_3 = 74_250_000; // 1280x720

  localparam TMDS_BIT_PERIOD_1 = 1_000_000_000.0 / (TMDS_FREQ_1 * 10);
  localparam TMDS_BIT_PERIOD_2 = 1_000_000_000.0 / (TMDS_FREQ_2 * 10);
  localparam TMDS_BIT_PERIOD_3 = 1_000_000_000.0 / (TMDS_FREQ_3 * 10);

  initial reset = 1'b1;

  parameter RESET_DELAY = PERIPHERAL_FREQ / 10; // 100ms

  reg [$clog2(RESET_DELAY)-1:0] reset_counter = $clog2(RESET_DELAY)'(RESET_DELAY);

  always @(posedge clk_peripheral) begin
    if (nreset_in) begin
      if (reset_counter != 0)
        reset_counter <= reset_counter - 1'b1;
      else
        reset <= 0;
    end else begin
      reset <= 1;
      reset_counter <= $clog2(RESET_DELAY)'(RESET_DELAY);
    end
  end

`ifdef IVERILOG

  initial begin
    clk_cpu = 0;
    clk_ram = 0;
    clk_peripheral = 0;
    clk_tmds_pixel = 0;
    clk_tmds_x5 = 0;

    #(CPU_PERIOD/4);
    while (1) #(CPU_PERIOD/2) clk_ram = ~clk_ram;
  end

  always #(CPU_PERIOD/2) clk_cpu = ~clk_cpu;
  always #(PERIPHERAL_PERIOD/2) clk_peripheral = ~clk_peripheral;

  reg tmds_bit_clk = 0;

  always #(TMDS_BIT_PERIOD_1/2) if (video_mode == 2'd1) tmds_bit_clk = ~tmds_bit_clk;
  always #(TMDS_BIT_PERIOD_2/2) if (video_mode == 2'd2) tmds_bit_clk = ~tmds_bit_clk;
  always #(TMDS_BIT_PERIOD_3/2) if (video_mode == 2'd3) tmds_bit_clk = ~tmds_bit_clk;

  reg [3:0] tmds_bit_counter = 0;
  always @(posedge tmds_bit_clk) begin
    clk_tmds_x5 = ~clk_tmds_x5;
    tmds_bit_counter <= tmds_bit_counter == 4'd9 ? 4'd0 : (tmds_bit_counter + 4'd1);
    if (tmds_bit_counter == 4'd0 || tmds_bit_counter == 4'd5) clk_tmds_pixel = ~clk_tmds_pixel;
  end

`endif
`ifdef ENDEAVOUR_BOARD_VER1
  PLL pll(
    .inclk0(clk_in),
    .c0(clk_cpu),
    .c1(clk_ram),
    .c2(clk_peripheral),
    .c3(clk_tmds_x5)
  );
  assign clk_tmds_pixel = clk_peripheral;
`endif
`ifdef ENDEAVOUR_BOARD_VER2
  PLL1280 pll(
    .inclk0(clk_in),
    .c0(clk_tmds_pixel),
    .c1(clk_tmds_x5),
    .c2(clk_cpu),
    .c3(clk_ram)
  );
  assign clk_peripheral = clk_in;
`endif

  reg [2:0] leds_normalized;
  reg [1:0] keys_normalized;

`ifdef ENDEAVOUR_BOARD_VER1
  assign leds = leds_normalized ^ 3'b011;
  assign keys_normalized = ~keys;
`else
`ifdef ENDEAVOUR_BOARD_VER2
  assign leds = ~leds_normalized;
  assign keys_normalized = ~keys;
`else
  assign leds = leds_normalized;
  assign keys_normalized = keys;
`endif
`endif

  assign apb_PRDATA = apb_PADDR[3] ? 32'(CPU_FREQ) :
                      apb_PADDR[2] ? {30'b0, keys_normalized} : {29'b0, leds_normalized};
  assign apb_PREADY = 1'b1;

  always @(posedge clk_cpu) begin
    if (reset)
      leds_normalized <= 3'b0;
    else if (apb_PSEL & apb_PENABLE & apb_PWRITE & apb_PADDR[3:2] == 0)
      leds_normalized <= apb_PWDATA[2:0];
  end

endmodule

