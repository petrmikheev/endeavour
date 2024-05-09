module SdcardController (
  input reset, input clk,

  output        sdcard_clk,
  inout         sdcard_cmd,
  inout   [3:0] sdcard_data,
  input         sdcard_ndetect,

  input   [4:0] apb_PADDR,
  input         apb_PSEL,
  input         apb_PENABLE,
  output        apb_PREADY,
  input         apb_PWRITE,
  input  [31:0] apb_PWDATA,
  output [31:0] apb_PRDATA
);

  wire stall;
  reg stb_done = 0;
  wire stb = apb_PENABLE & apb_PSEL & ~stb_done;
  always @(posedge clk) begin
    if (reset) stb_done <= 1'b0;
    else if (stb) stb_done <= 1'b1;
    else if (apb_PREADY) stb_done <= 1'b0;
  end

  wire inverse = &apb_PADDR[4:3];
  wire [31:0] rdata_be;
  assign apb_PRDATA = inverse ? {rdata_be[7:0], rdata_be[15:8], rdata_be[23:16], rdata_be[31:24]} : rdata_be;

  sdio_top #(
    //.OPT_LITTLE_ENDIAN(1),
    .LGFIFO(9),
    .OPT_EMMC(0),
    .OPT_SERDES(0),
    .OPT_DDR(1),
    .OPT_CARD_DETECT(1),
    .OPT_1P8V(0)
  ) impl(
    .i_clk(clk), // 96-104mhz
    .i_reset(reset),
    //.i_hsclk() clk x4

    .o_ck(sdcard_clk),
    .io_cmd(sdcard_cmd),
    .io_dat(sdcard_data),
`ifdef ENDEAVOUR_BOARD_VER1
    .i_card_detect(1'b1),
`else
    .i_card_detect(~sdcard_ndetect),
`endif
    //.o_int() output wire interrupt

    .i_wb_addr({apb_PADDR[4] & ~apb_PADDR[3], apb_PADDR[3:2]}),
    .i_wb_data(inverse ? {apb_PWDATA[7:0], apb_PWDATA[15:8], apb_PWDATA[23:16], apb_PWDATA[31:24]} : apb_PWDATA),
    .o_wb_data(rdata_be),
    .o_wb_ack(apb_PREADY),
    .o_wb_stall(stall),
    .i_wb_we(apb_PWRITE),
    .i_wb_cyc(apb_PENABLE & apb_PSEL),
    .i_wb_stb(stb),
    .i_wb_sel(4'b1111)
  );

endmodule

/*module IOBUF(input T, input I, output O, inout IO);
  assign IO = T ? 1'bz : I;
  assign O = IO;
endmodule*/
