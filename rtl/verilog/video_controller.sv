module VideoController(
  input clk,
  input reset,
  input tmds_pixel_clk,
  input tmds_x5_clk,
  output reg [1:0] video_mode_out,
  output dvi_tmds0p, output dvi_tmds0m, // blue
  output dvi_tmds1p, output dvi_tmds1m, // green
  output dvi_tmds2p, output dvi_tmds2m, // red
  output dvi_tmdsCp, output dvi_tmdsCm
);

  assign dvi_tmdsCp = tmds_pixel_clk;
  assign dvi_tmdsCm = ~dvi_tmdsCp;

  assign video_mode_out = 2'd1;

  // mode 1 (640x480)
  reg [10:0] hDrawEnd   = 11'd640;
  reg [10:0] hSyncStart = 11'd656;
  reg [10:0] hSyncEnd   = 11'd752;
  reg [10:0] hLast      = 11'd799;

  reg  [9:0] vDrawEnd   = 10'd480;
  reg  [9:0] vSyncStart = 10'd490;
  reg  [9:0] vSyncEnd   = 10'd492;
  reg  [9:0] vLast      = 10'd524;
/*
  // mode 2 (1024x768)
  reg [10:0] hDrawEnd   = 11'd1024;
  reg [10:0] hSyncStart = 11'd1048;
  reg [10:0] hSyncEnd   = 11'd1184;
  reg [10:0] hLast      = 11'd1343;

  reg  [9:0] vDrawEnd   = 10'd768;
  reg  [9:0] vSyncStart = 10'd771;
  reg  [9:0] vSyncEnd   = 10'd777;
  reg  [9:0] vLast      = 10'd805;

  // mode 3 (1280x720)
  reg [10:0] hDrawEnd   = 11'd1280;
  reg [10:0] hSyncStart = 11'd1390;
  reg [10:0] hSyncEnd   = 11'd1430;
  reg [10:0] hLast      = 11'd1649;

  reg  [9:0] vDrawEnd   = 10'd720;
  reg  [9:0] vSyncStart = 10'd725;
  reg  [9:0] vSyncEnd   = 10'd730;
  reg  [9:0] vLast      = 10'd749;*/

  reg [10:0] hCounter = 11'd0;
  reg  [9:0] vCounter = 10'd0;

  reg hDraw = 0;
  reg vDraw = 0;
  reg hSync = 0;
  reg vSync = 0;
  wire DrawArea = hDraw & vDraw;

  reg [7:0] red, green, blue;

  wire [7:0] W = {8{hCounter[7:0]==vCounter[7:0]}};
  wire [7:0] A = {8{hCounter[7:5]==3'h2 && vCounter[7:5]==3'h2}};

  always @(posedge tmds_pixel_clk) begin
    if (hCounter == hLast) begin
      hCounter <= 0;
      if (vCounter == vLast) begin
        vCounter <= 0;
      end else begin
        vCounter <= vCounter + 1'd1;
        if (vCounter == 10'd0) vDraw <= 1;
        if (vCounter == vDrawEnd) vDraw <= 0;
        if (vCounter == vSyncStart) vSync <= 1;
        if (vCounter == vSyncEnd) vSync <= 0;
      end
    end else begin
      hCounter <= hCounter + 1'd1;
      if (hCounter == 11'd0) hDraw <= 1;
      if (hCounter == hDrawEnd) hDraw <= 0;
      if (hCounter == hSyncStart) hSync <= 1;
      if (hCounter == hSyncEnd) hSync <= 0;
    end

    red <= ({hCounter[5:0] & {6{vCounter[4:3]==~hCounter[4:3]}}, 2'b00} | W) & ~A;
    green <= (hCounter[7:0] & {8{vCounter[6]}} | W) & ~A;
    blue <= vCounter[7:0] | W | A;
  end

  reg [9:0] tmds0_data, tmds1_data, tmds2_data;
  TMDS_encoder encode_R(.clk(tmds_pixel_clk), .VD(red  ), .CD(2'b00)         , .VDE(DrawArea), .TMDS(tmds2_data));
  TMDS_encoder encode_G(.clk(tmds_pixel_clk), .VD(green), .CD(2'b00)         , .VDE(DrawArea), .TMDS(tmds1_data));
  TMDS_encoder encode_B(.clk(tmds_pixel_clk), .VD(blue ), .CD({vSync, hSync}), .VDE(DrawArea), .TMDS(tmds0_data));

  reg [2:0] shift_counter = 3'd0;
  reg [9:0] tmds0_shift, tmds1_shift, tmds2_shift;

  always @(posedge tmds_x5_clk) begin
    if (shift_counter == 3'd0) begin
      shift_counter <= 3'd4;
      tmds0_shift <= tmds0_data;
      tmds1_shift <= tmds1_data;
      tmds2_shift <= tmds2_data;
    end else begin
      shift_counter <= shift_counter - 1'd1;
      tmds0_shift <= {2'd0, tmds0_shift[9:2]};
      tmds1_shift <= {2'd0, tmds1_shift[9:2]};
      tmds2_shift <= {2'd0, tmds2_shift[9:2]};
    end
  end

  // TODO DDR_OUT3
  assign dvi_tmds0p = tmds0_shift[0];
  assign dvi_tmds0m = tmds0_shift[1];
  assign dvi_tmds1p = tmds1_shift[0];
  assign dvi_tmds1m = tmds1_shift[1];
  assign dvi_tmds2p = tmds2_shift[0];
  assign dvi_tmds2m = tmds2_shift[1];

endmodule

// Source: https://www.fpga4fun.com/HDMI.html
module TMDS_encoder(
  input clk,
  input [7:0] VD,  // video data (red, green or blue)
  input [1:0] CD,  // control data
  input VDE,  // video data enable, to choose between CD (when VDE=0) and VD (when VDE=1)
  output reg [9:0] TMDS = 0
);
  wire [3:0] Nb1s = VD[0] + VD[1] + VD[2] + VD[3] + VD[4] + VD[5] + VD[6] + VD[7];
  wire XNOR = (Nb1s>4'd4) || (Nb1s==4'd4 && VD[0]==1'b0);
  wire [8:0] q_m = {~XNOR, q_m[6:0] ^ VD[7:1] ^ {7{XNOR}}, VD[0]};

  reg [3:0] balance_acc = 0;
  wire [3:0] balance = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7] - 4'd4;
  wire balance_sign_eq = (balance[3] == balance_acc[3]);
  wire invert_q_m = (balance==0 || balance_acc==0) ? ~q_m[8] : balance_sign_eq;
  wire [3:0] balance_acc_inc = balance - ({q_m[8] ^ ~balance_sign_eq} & ~(balance==0 || balance_acc==0));
  wire [3:0] balance_acc_new = invert_q_m ? balance_acc-balance_acc_inc : balance_acc+balance_acc_inc;
  wire [9:0] TMDS_data = {invert_q_m, q_m[8], q_m[7:0] ^ {8{invert_q_m}}};
  wire [9:0] TMDS_code = CD[1] ? (CD[0] ? 10'b1010101011 : 10'b0101010100) : (CD[0] ? 10'b0010101011 : 10'b1101010100);

  always @(posedge clk) TMDS <= VDE ? TMDS_data : TMDS_code;
  always @(posedge clk) balance_acc <= VDE ? balance_acc_new : 4'h0;
endmodule

