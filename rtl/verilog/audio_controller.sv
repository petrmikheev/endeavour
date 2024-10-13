module AudioController (
  input reset, input clk,

  output        i2c_scl,
  inout         i2c_sda,
  output reg    shdn,

  input   [2:0] apb_PADDR,
  input         apb_PSEL,
  input         apb_PENABLE,
  output        apb_PREADY,
  input         apb_PWRITE,
  input  [31:0] apb_PWDATA,
  output [31:0] apb_PRDATA
);

  parameter I2C_ADDR = 7'b1100000;
  parameter FIFO_SIZE = 1024;
  localparam FIFO_BITS = $clog2(FIFO_SIZE);

  reg [15:0] divisor = 0;
  reg [15:0] counter = 0;
  reg [3:0] target_volume = 4'd11;

  reg [23:0] fifo [0:FIFO_SIZE-1];
  reg [FIFO_BITS-1:0] ina, outa, remaining;
  reg sel_cfg, sel_stream;
  reg flush;

  assign apb_PREADY = 1'b1;
  assign apb_PRDATA = sel_cfg ? {12'b0, target_volume, divisor} : remaining;

  localparam STATE_HALT = 3'd0;
  localparam STATE_IDLE = 3'd1;
  localparam STATE_ADDR = 3'd2;
  localparam STATE_CFG  = 3'd3;
  localparam STATE_DHI  = 3'd4;
  localparam STATE_DLO  = 3'd5;

  reg [2:0] state = STATE_HALT;
  reg [23:0] value;

`ifdef ENDEAVOUR_BOARD_VER1
  assign shdn = ~(state == STATE_HALT && counter == 0);
`else
  assign shdn = state == STATE_HALT && counter == 0;
`endif

  /*wire i2c_ready;
  wire i2c_halted;
  I2C i2c(
    .halt(shdn),
    .halted(i2c_halted),
    .clk(clk),
    .hs(1'b0),
    .wr(1'b1),
    .ready(i2c_ready),
    .enable(|state[2:1]),
    .din(state == STATE_ADDR ? {I2C_ADDR, 1'b0} :
         state == STATE_DHI  ? {4'b0, ~value[11], value[10:8]} :
         state == STATE_DLO  ? value[7:0] : 8'b0),
    .i2c_scl(i2c_scl),
    .i2c_sda(i2c_sda)
  );

  always @(posedge clk) begin
    if (reset) begin
      divisor <= 0;
      counter <= 0;
      ina <= 0;
      outa <= 0;
      remaining <= FIFO_BITS'(FIFO_SIZE - 1);
      state <= STATE_HALT;
    end else begin
      remaining <= FIFO_BITS'(ina - outa - 1'b1);
      sel_cfg <= apb_PSEL & ~apb_PADDR[2];
      sel_stream <= apb_PSEL & apb_PADDR[2];
      if (apb_PENABLE & apb_PWRITE & sel_cfg) begin
        divisor <= apb_PWDATA[15:0];
        target_volume <= apb_PWDATA[19:16];
        flush <= apb_PWDATA[31];
      end else
        flush <= 0;
      if (apb_PENABLE & apb_PWRITE & sel_stream) begin
        fifo[ina] <= {apb_PWDATA[27:16], apb_PWDATA[11:0]};
        ina <= ina + 1'b1;
      end else if (flush)
        ina <= outa;
      if (|counter)
        counter <= counter - 1'b1;
      else if (ina != outa) begin
        counter <= divisor;
        outa <= outa + 1'b1;
        value <= fifo[outa];
        if (state == STATE_HALT && i2c_halted) state <= STATE_ADDR;
        if (state == STATE_IDLE) state <= STATE_DHI;
      end else if (state == STATE_IDLE) state <= STATE_HALT;
      if (state == STATE_ADDR && i2c_ready) state <= STATE_CFG;
      if (state == STATE_CFG && i2c_ready) state <= STATE_DHI;
      if (state == STATE_DHI && i2c_ready) state <= STATE_DLO;
      if (state == STATE_DLO && i2c_ready) state <= STATE_IDLE;
    end
  end*/

endmodule
