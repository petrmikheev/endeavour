module ApbClockBridge #(parameter AWIDTH)(
  input clk_input, input clk_output,

  input  [AWIDTH-1:0] input_PADDR,
  input               input_PSEL,
  input               input_PENABLE,
  output              input_PREADY,
  input               input_PWRITE,
  input        [31:0] input_PWDATA,
  output       [31:0] input_PRDATA,

  output [AWIDTH-1:0] output_PADDR,
  output              output_PSEL,
  output              output_PENABLE,
  input               output_PREADY,
  output              output_PWRITE,
  output       [31:0] output_PWDATA,
  input        [31:0] output_PRDATA
);

  assign output_PADDR = input_PADDR;
  assign output_PSEL = input_PSEL;
  assign output_PWRITE = input_PWRITE;
  assign output_PWDATA = input_PWDATA;

  reg started, finished, mfinished;
  always @(posedge clk_input) begin
    started <= input_PSEL & input_PENABLE & ~mfinished;
    mfinished <= finished;
  end

  reg sstarted;
  reg [31:0] rdata;
  always @(posedge clk_output) begin
    sstarted <= started;
    if (~started)
      finished <= 0;
    else if (sstarted & output_PREADY) begin
      finished <= 1;
      rdata <= output_PRDATA;
    end
  end

  assign output_PENABLE = sstarted & ~finished;
  assign input_PRDATA = rdata;
  assign input_PREADY = started & mfinished;

endmodule
