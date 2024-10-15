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

  output reg reset_cpu,
  output reg reset_peripheral,
  output reg clk_cpu,
  output reg clk_ram,
  // output reg clk_ram_bus,
  output reg clk_peripheral,
  output reg clk_tmds_pixel,
  output reg clk_tmds_x5,

  output reg [63:0] utime,
  output reg timer_interrupt,

  input [1:0] video_mode,

  input   [4:0] apb_PADDR,
  input         apb_PSEL,
  input         apb_PENABLE,
  output        apb_PREADY,
  input         apb_PWRITE,
  input  [31:0] apb_PWDATA,
  output [31:0] apb_PRDATA
);

  assign pllb_i2c_scl = 1'bz;
  assign pllb_i2c_sda = 1'bz;

  parameter PERIPHERAL_FREQ = 48_000_000;
  localparam PERIPHERAL_PERIOD = 1_000_000_000.0 / PERIPHERAL_FREQ;

  parameter TMDS_FREQ_1 = 25_175_000; // 640x480
  parameter TMDS_FREQ_2 = 65_000_000; // 1024x768
  parameter TMDS_FREQ_3 = 74_250_000; // 1280x720

  localparam TMDS_BIT_PERIOD_1 = 1_000_000_000.0 / (TMDS_FREQ_1 * 10);
  localparam TMDS_BIT_PERIOD_2 = 1_000_000_000.0 / (TMDS_FREQ_2 * 10);
  localparam TMDS_BIT_PERIOD_3 = 1_000_000_000.0 / (TMDS_FREQ_3 * 10);

  initial reset_peripheral = 1'b1;
  initial reset_cpu = 1'b1;

  parameter RESET_DELAY = PERIPHERAL_FREQ / 10; // 100ms

  reg [$clog2(RESET_DELAY)-1:0] reset_counter = $clog2(RESET_DELAY)'(RESET_DELAY);

  reg [5:0] utime_counter = 0;
  reg [63:0] utime_value = 0;
  reg utime_read_allowed = 0;
  reg [63:0] utime_cmp;

  always @(posedge clk_peripheral) begin
    if (nreset_in && pll_initialized) begin
      if (reset_counter != 0)
        reset_counter <= reset_counter - 1'b1;
      else
        reset_peripheral <= 0;
    end else begin
      reset_peripheral <= 1;
      reset_counter <= $clog2(RESET_DELAY)'(RESET_DELAY);
    end
    if (utime_counter == 6'd16) utime_read_allowed <= 1;
    else if (utime_counter == 6'd32) utime_read_allowed <= 0;
    if (utime_counter == 6'd47) begin
      utime_counter <= 6'd0;
      utime_value <= utime_value + 1'b1;
    end else
      utime_counter <= utime_counter + 1'd1;
  end

  reg tih, tihe, til;

  always @(posedge clk_cpu) begin
    reset_cpu <= reset_peripheral;
    if (utime_read_allowed) utime <= utime_value;
    tih <= utime[63:32] > utime_cmp[63:32];
    tihe <= utime[63:32] == utime_cmp[63:32];
    til <= utime[31:0] >= utime_cmp[31:0];
    timer_interrupt <= tih | (tihe & til);
  end

`ifdef IVERILOG
  reg [17:0] cpu_freq = CPU_FREQ / 1024;
`else
  reg [17:0] cpu_freq;
  FrequencyCounter cpu_freq_counter(.clk(clk_cpu), .utime(utime[9:0]), .freq_khz(cpu_freq));
`endif

`ifdef IVERILOG

  parameter CPU_FREQ = 85_000_000;
  localparam CPU_PERIOD = 1_000_000_000.0 / CPU_FREQ;

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

  reg pll_initialized = 1;
`else
  reg pll_initialized = 0;
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
  wire pll_areset;
  wire pll_configupdate;
  wire pll_scanclk;
  wire pll_scanclkena;
  wire pll_scandata;
  wire pll_reconfig_busy;
  wire pll_scandataout;
  wire pll_scandone;
  wire vrom_en;
  wire vrom_data;
  wire [7:0] vrom_addr;

  PLL1280 pll(
    .inclk0(clk_in),

    .areset(pll_areset),
    .configupdate(pll_configupdate),
    .scanclk(pll_scanclk),
    .scanclkena(pll_scanclkena),
    .scandata(pll_scandata),
    .scandataout(pll_scandataout),
    .scandone(pll_scandone),

    .c0(clk_tmds_pixel),
    .c1(clk_tmds_x5)
    //.c2(clk_cpu),
    //.c3(clk_ram)
  );

  reg [1:0] video_mode_buf1 = 0;
  reg [1:0] video_mode_buf2 = 0;
  wire video_mode_changed = video_mode_buf1 != video_mode_buf2;
  reg video_mode_changing = 0;

  always @(posedge clk_in) begin
    if (~pll_reconfig_busy) begin
      if (video_mode_changing)
        video_mode_changing <= 0;
      else begin
        if (~video_mode_changed) video_mode_buf1 <= video_mode;
        video_mode_buf2 <= video_mode_buf1;
        video_mode_changing <= video_mode_changed;
      end
    end
  end

  PLL_RECONFIG pll_reconfig(
    .clock(clk_in),

    .pll_areset_in(1'b0),
    .read_param(1'b0),
    .reset(1'b0),
    .write_param(1'b0),

    .reconfig(video_mode_changing & ~pll_reconfig_busy),
    .busy(pll_reconfig_busy),
    .write_from_rom(video_mode_changed),
    .reset_rom_address(1'b0),
    .rom_data_in(vrom_data),
    .rom_address_out(vrom_addr),
    .write_rom_ena(vrom_en),

    .pll_areset(pll_areset),
    .pll_configupdate(pll_configupdate),
    .pll_scanclk(pll_scanclk),
    .pll_scanclkena(pll_scanclkena),
    .pll_scandata(pll_scandata),
    .pll_scandataout(pll_scandataout),
    .pll_scandone(pll_scandone)
  );

  PLL_VIDEO_CONF_ROM pll_vrom(
    .clock(clk_in),
    .address({video_mode_buf1, vrom_addr}),
    .rden(vrom_en),
    .q(vrom_data)
  );

  assign clk_peripheral = clk_in;
  assign clk_cpu = plla_clk0;
  assign clk_ram = plla_clk1;
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

  reg [2:0] addr;
  assign apb_PRDATA = addr == 3'd0 ? {29'b0, leds_normalized}  :
                      addr == 3'd1 ? {30'b0, keys_normalized}  :
                      addr == 3'd2 ? {4'h0, cpu_freq, 10'h3ff} :
                      addr == 3'd3 ? utime_cmp[31:0] : utime_cmp[63:32];
  assign apb_PREADY = 1'b1;

  always @(posedge clk_cpu) begin
    addr <= apb_PADDR[4:2];
    if (reset_cpu) begin
      leds_normalized <= 3'b0;
      utime_cmp <= '1;
    end else if (apb_PSEL & apb_PENABLE & apb_PWRITE) begin
      if (addr == 3'd0) leds_normalized <= apb_PWDATA[2:0];
      if (addr == 3'd3) utime_cmp[31:0] <= apb_PWDATA;
      if (addr == 3'd4) utime_cmp[63:32] <= apb_PWDATA;
    end
  end

  reg [15:0] pll_conf [0:211];
  initial begin
    $readmemh("../verilog/pll_conf.mem", pll_conf);
  end

  //parameter PLL_CONF_FROM = 8'd0;   // 80mhz
  parameter PLL_CONF_FROM = 8'd53;  // 85mhz
  //parameter PLL_CONF_FROM = 8'd106; // 90mhz
  //parameter PLL_CONF_FROM = 8'd159; // 132mhz

  parameter PLL_CONF_TO = PLL_CONF_FROM + 8'd53;

  reg [7:0] pll_cid = PLL_CONF_FROM;
  reg [1:0] pll_cstate = 2'd0;
  reg [7:0] pll_reg, pll_value, pll_din;
  wire pll_i2c_ready;
  wire pll_data_err, pll_addr_err;

  always @(posedge clk_peripheral) begin
    if (pll_cid == PLL_CONF_TO) begin
      pll_initialized <= 1;
    end else begin
      if (pll_cstate == 2'd0) begin
        pll_cstate <= 2'd2;
        {pll_reg, pll_value} <= pll_conf[pll_cid];
      end else if (pll_i2c_ready) begin
        {pll_cid, pll_cstate} <= {pll_cid, pll_cstate} + 1'd1;
      end
    end
  end

  I2C plla_i2c(
    .clk(clk_peripheral),

    .cmd_active(pll_cstate[1]),
    .cmd_high_speed(1'b0),
    .cmd_addr(7'h60),
    .cmd_read(1'b0),

    .data_valid(pll_cstate[1]),
    .data_ready(pll_i2c_ready),
    .data_in(pll_cstate[0] ? pll_value : pll_reg),

    .addr_err(pll_addr_err),
    .data_err(pll_data_err),

    .i2c_scl(plla_i2c_scl),
    .i2c_sda(plla_i2c_sda)
  );

endmodule

module FrequencyCounter(input clk, input [9:0] utime, output reg [17:0] freq_khz);
  reg [17:0] freq_counter = 0;

  always @(posedge clk) begin
    if (utime[9:0] == 10'd0 && |freq_counter[17:9])
      freq_counter <= 10'd0;
    else
      freq_counter <= freq_counter + 1'd1;
    if (utime[9:0] == 10'd976) freq_khz <= freq_counter;
  end
endmodule
