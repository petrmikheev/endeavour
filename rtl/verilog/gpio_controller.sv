module GpioController (
  input reset, input clk,

  output  [2:0] leds,
  input   [1:0] keys,

  input   [2:0] apb_PADDR,
  input         apb_PSEL,
  input         apb_PENABLE,
  output        apb_PREADY,
  input         apb_PWRITE,
  input  [31:0] apb_PWDATA,
  output [31:0] apb_PRDATA
);

  reg [2:0] leds_normalized;
  reg [1:0] keys_normalized;

`ifdef ENDEAVOUR_BOARD_VER1
  assign leds = leds_normalized ^ 3'b011;
  assign keys_normalized = ~keys;
`else
  assign leds = leds_normalized;
  assign keys_normalized = keys;
`endif

  assign apb_PRDATA = apb_PADDR[2] ? {30'b0, keys_normalized} : {29'b0, leds_normalized};
  assign apb_PREADY = 1'b1;

  always @(posedge clk) begin
    if (reset)
      leds_normalized <= 3'b0;
    else if (apb_PSEL & apb_PENABLE & apb_PWRITE & ~apb_PADDR[2])
      leds_normalized <= apb_PWDATA[2:0];
  end

endmodule
