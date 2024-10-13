module I2C (
  input clk,

  input       cmd_active,
  input       cmd_high_speed,
  input [6:0] cmd_addr,
  input       cmd_read,
  output reg  addr_err,

  input            data_valid,
  output reg       data_ready,
  input      [7:0] data_in,
  output reg [7:0] data_out,
  output reg       data_err,

  output i2c_scl,
  inout i2c_sda
);

  localparam HALT          = 3'd0;
  localparam SWITCH_TO_HS  = 3'd1;
  localparam SEND_ADDR     = 3'd2;
  localparam DATA_IDLE     = 3'd3;
  localparam DATA_TRANSFER = 3'd4;

  reg [2:0] state = HALT;
  reg halt_required = 0;

  parameter CLK_FREQ = 48_000_000;
  localparam DIVISOR_400K = CLK_FREQ / (400_000 * 4) - 1;  // 29
  localparam DIVISOR_HS = CLK_FREQ / (3_000_000 * 4) - 1;  // 2

  reg [5:0] clk_counter = 0;
  reg [1:0] q = 0;
  reg [3:0] bit_counter = 0;
  reg [7:0] data;
  reg hs_state = 0;
  initial data_ready = 0;
  initial data_err = 0;
  initial addr_err = 0;

  reg sda = 1;
  reg sda_in;
  assign i2c_scl = ((state == HALT || q[1]) && (state != DATA_IDLE)) ? 1'bz : 1'b0;
  assign i2c_sda = sda ? 1'bz : 1'b0;

  always @(posedge clk) begin
    sda_in <= i2c_sda;
    if (state == HALT)
      halt_required <= 0;
    else if (~cmd_active)
      halt_required <= 1;
    if (data_ready) data_ready <= 0;
    if (clk_counter != 0) begin
      clk_counter <= clk_counter - 1'b1;
    end else begin
      clk_counter <= hs_state ? DIVISOR_HS : DIVISOR_400K;
      q <= q + 1'b1;
      if (q == 2'd0 && state != HALT) begin
        if (|bit_counter) begin
          bit_counter <= bit_counter - 1'b1;
          if (~cmd_read || state != DATA_TRANSFER) {sda, data} <= {data, 1'b1};
          else if (bit_counter == 4'd1) sda <= 0;
        end else sda <= 0;
      end else if (q == 2'd2 && state == HALT) begin
        if (~sda)
          sda <= 1;
        else if (cmd_active) begin
          sda <= 0;
          state <= cmd_high_speed ? SWITCH_TO_HS : SEND_ADDR;
          data  <= cmd_high_speed ? 8'h08 : {cmd_addr, cmd_read};
          bit_counter <= 4'd9;
        end
      end else if (q == 2'd3) begin
        case (state)
          SWITCH_TO_HS:
            if (bit_counter == 4'd0) begin
              state <= SEND_ADDR;
              data <= {cmd_addr, cmd_read};
              bit_counter <= 4'd9;
              hs_state <= 1;
            end
          SEND_ADDR:
            if (bit_counter == 4'd0) begin
              state <= DATA_IDLE;
              addr_err <= sda_in;
            end
          DATA_IDLE:
            if (halt_required) begin
              state <= HALT;
              hs_state <= 0;
            end else if (data_valid) begin
              state <= DATA_TRANSFER;
              data <= data_in;
              bit_counter <= 4'd9;
            end
          DATA_TRANSFER: begin
            if (cmd_read) data <= {data[6:0], sda_in};
            if (bit_counter == 4'd0) begin
              state <= DATA_IDLE;
              if (~data_ready) data_ready <= 1;
              data_out <= data;
              if (~cmd_read) data_err <= sda_in;
            end
          end
        endcase
      end
    end
  end

endmodule
