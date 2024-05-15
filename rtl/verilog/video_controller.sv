module VideoController(
  input clk,
  input reset,
  input tmds_pixel_clk,
  input tmds_x5_clk,
  output [1:0] video_mode_out,
  output dvi_tmds0p, output dvi_tmds0m, // blue
  output dvi_tmds1p, output dvi_tmds1m, // green
  output dvi_tmds2p, output dvi_tmds2m, // red
  output dvi_tmdsCp, output dvi_tmdsCm,

  input   [4:0] apb_PADDR,
  input         apb_PSEL,
  input         apb_PENABLE,
  output        apb_PREADY,
  input         apb_PWRITE,
  input  [31:0] apb_PWDATA,
  output [31:0] apb_PRDATA,

  output        axi_ar_valid,
  input         axi_ar_ready,
  output [31:0] axi_ar_payload_addr,
  output  [7:0] axi_ar_payload_len,
  output  [1:0] axi_ar_payload_burst,
  input         axi_r_valid,
  output        axi_r_ready,
  input  [31:0] axi_r_payload_data,
  input         axi_r_payload_last
);

  reg [10:0] hDrawEnd;
  reg [10:0] hSyncStart;
  reg [10:0] hSyncEnd;
  reg [10:0] hLast;

  reg  [9:0] vDrawEnd;
  reg  [9:0] vSyncStart;
  reg  [9:0] vSyncEnd;
  reg  [9:0] vLast;

  reg [1:0] video_mode;
  reg show_text = 0;
  reg show_graphic = 0;
  reg [3:0] font_height;
  reg [2:0] font_width;
  reg [31:0] text_addr;
  reg [31:0] graphic_addr;

  reg [9:0] charmap_index;

  // CHARMAP_SIZE = 512: symbols with codes 8-127 (ASCII)
  // CHARMAP_SIZE = 1024: symbols with codes 8-255
  // CHARMAP_SIZE = 2048: symbols with codes 8-255, two fonts
  localparam CHARMAP_SIZE = 2048;

  reg [31:0] charmap [CHARMAP_SIZE-1:0];  // 8 M9K
  reg [31:0] text_line [255:0];           // 1 M9K
  reg [31:0] graphic_line [2047:0];       // 8 M9K

  localparam PIXEL_DELAY = 1'd1;

  // *** APB interface

  assign video_mode_out = video_mode;
  reg [2:0] apb_reg;

  always @(posedge clk) begin
    apb_reg <= apb_PADDR[4:2];
    if (reset) begin
      video_mode <= 2'd0;
    end else begin
      if (apb_PSEL & apb_PENABLE & apb_PWRITE) begin
        if (apb_reg == 3'd0) begin
          {font_width, font_height, show_graphic, show_text, video_mode} <= apb_PWDATA[10:0];
          if (apb_PWDATA[1:0] == 2'd1) begin  // 640x480
            hDrawEnd   <= 11'd640 + PIXEL_DELAY;
            hSyncStart <= 11'd656 + PIXEL_DELAY;
            hSyncEnd   <= 11'd752 + PIXEL_DELAY;
            hLast      <= 11'd799;
            vDrawEnd   <= 10'd480;
            vSyncStart <= 10'd490;
            vSyncEnd   <= 10'd492;
            vLast      <= 10'd524;
          end
          if (apb_PWDATA[1:0] == 2'd2) begin  // 1024x768
            hDrawEnd   <= 11'd1024 + PIXEL_DELAY;
            hSyncStart <= 11'd1048 + PIXEL_DELAY;
            hSyncEnd   <= 11'd1184 + PIXEL_DELAY;
            hLast      <= 11'd1343;
            vDrawEnd   <= 10'd768;
            vSyncStart <= 10'd771;
            vSyncEnd   <= 10'd777;
            vLast      <= 10'd805;
          end
          if (apb_PWDATA[1:0] == 2'd3) begin  // 1280x720
            hDrawEnd   <= 11'd1280 + PIXEL_DELAY;
            hSyncStart <= 11'd1390 + PIXEL_DELAY;
            hSyncEnd   <= 11'd1430 + PIXEL_DELAY;
            hLast      <= 11'd1649;
            vDrawEnd   <= 10'd720;
            vSyncStart <= 10'd725;
            vSyncEnd   <= 10'd730;
            vLast      <= 10'd749;
          end
        end
        if (apb_reg == 3'd1) text_addr <= apb_PWDATA;
        if (apb_reg == 3'd2) graphic_addr <= apb_PWDATA;
        if (apb_reg == 3'd3) charmap_index <= apb_PWDATA[9:0];
        if (apb_reg == 3'd4) charmap[charmap_index] <= apb_PWDATA;
      end
    end
  end

  assign apb_PREADY = 1'b1;
  assign apb_PRDATA = apb_reg == 3'd0 ? {21'b0, font_width, font_height, show_graphic, show_text, video_mode} :
                      apb_reg == 3'd1 ? text_addr :
                      apb_reg == 3'd2 ? graphic_addr :
                                        {22'b0, charmap_index};

  // *** Counters

  reg [10:0] hCounter = 11'd0;
  reg  [9:0] vCounter = 10'd0;
  reg  [7:0] hCharCounter;
  reg  [5:0] vCharCounter = 0;
  reg  [2:0] char_px;
  reg  [3:0] char_py = 0;

  reg hDraw = 0;
  reg vDraw = 0;
  reg hSync = 0;
  reg vSync = 0;
  wire DrawArea = hDraw & vDraw;

  reg [7:0] red, green, blue;

  always @(posedge tmds_pixel_clk) begin
    if (hCounter == hLast) begin
      hCounter <= 0;
      hCharCounter <= 1;
      char_px <= 0;
      if (vCounter == vLast) begin
        vCounter <= 0;
        vCharCounter <= 0;
        char_py <= font_height;
      end else begin
        vCounter <= vCounter + 1'd1;
        if (vCounter == 10'd0) vDraw <= 1;
        if (vCounter == vDrawEnd) vDraw <= 0;
        if (vCounter == vSyncStart) vSync <= 1;
        if (vCounter == vSyncEnd) vSync <= 0;
      end
    end else begin
      hCounter <= hCounter + 1'd1;
      if (hCounter == PIXEL_DELAY) hDraw <= 1;
      if (hCounter == hDrawEnd) hDraw <= 0;
      if (hCounter == hSyncStart) hSync <= 1;
      if (hCounter == hSyncEnd) begin
        hSync <= 0;
        hCharCounter <= 0;
        if (char_py == font_height) begin
          char_py <= 0;
          vCharCounter <= vCharCounter + 1'b1;
        end else
          char_py <= char_py + 1'b1;
      end else if (|hCharCounter && char_px == font_width) begin
        char_px <= 0;
        hCharCounter <= hCharCounter + 1'b1;
      end else
        char_px <= char_px + 1'b1;
    end
  end

  // *** RAM interface

  assign axi_ar_valid = 1'b0;
  assign axi_ar_payload_burst = 2'd1;
  assign axi_r_ready = 1'b1;

  always @(posedge clk) begin
    // TODO
  end

  // *** Color calculation

  wire [7:0] W = {8{hCounter[7:0]==vCounter[7:0]}};
  wire [7:0] A = {8{hCounter[7:5]==3'h2 && vCounter[7:5]==3'h2}};

  reg [31:0] gcolor, tcolor;
  reg [31:0] tword;
  wire [7:0] tchar = hCharCounter[0] ? tword[23:16] : tword[7:0];
  wire [3:0] tfg_index = hCharCounter[0] ? tword[27:24] : tword[11:8];
  wire [3:0] tbg_index = hCharCounter[0] ? tword[31:28] : tword[15:12];
  reg [10:0] charmap_rindex;
  reg [31:0] charmap_rdata;
  reg [31:0] tfg, tbg, charmap_word;
  reg [7:0] char_shift;
  always @(posedge tmds_pixel_clk) begin
    tword <= {8'h0f, 8'd65, 8'h0f, 8'd66}; // text_line[hCharCounter[7:1]]; // px=0
    charmap_rdata <= charmap[charmap_rindex[$clog2(CHARMAP_SIZE)-1:0]];
    if (char_px == 3'd1)
      charmap_rindex <= {7'd1, tfg_index};
    else if (char_px == 3'd2) begin
      charmap_rindex <= {7'd0, tbg_index};
    end else if (char_px == 3'd3) begin
      tfg <= charmap_rdata;
      charmap_rindex <= {charmap_rdata[28], tchar, char_py[3:2]};
    end else if (char_px == 3'd4) begin
      tbg <= charmap_rdata;
    end else if (char_px == 3'd5) begin
      charmap_word <= |charmap_rindex[10:5] ? charmap_rdata : 32'd0;
    end
    if (char_px == 0) begin
      case (char_py[1:0])
        2'd0: char_shift <= charmap_word[7:0];
        2'd1: char_shift <= charmap_word[15:8];
        2'd2: char_shift <= charmap_word[23:16];
        2'd3: char_shift <= charmap_word[31:24];
      endcase
    end else char_shift[7:1] <= char_shift[6:0];
    gcolor <= graphic_line[hCounter];
    tcolor = char_shift[7] ? tfg : tbg;
    case ({show_text, show_graphic})
      2'b00: begin
        // test pattern
        red <= ({hCounter[5:0] & {6{vCounter[4:3]==~hCounter[4:3]}}, 2'b00} | W) & ~A;
        green <= (hCounter[7:0] & {8{vCounter[6]}} | W) & ~A;
        blue <= vCounter[7:0] | W | A;
      end
      2'b01: {blue, green, red} <= gcolor[23:0];
      2'b10: {blue, green, red} <= tcolor[23:0];
      2'b11: {blue, green, red} <= char_shift[7] ? tfg : gcolor;  // TODO blending
    endcase
  end

  // *** Encode

  reg [9:0] tmds0_data, tmds1_data, tmds2_data;
  TMDS_encoder encode_R(.clk(tmds_pixel_clk), .VD(red  ), .CD(2'b00)         , .VDE(DrawArea), .TMDS(tmds2_data));
  TMDS_encoder encode_G(.clk(tmds_pixel_clk), .VD(green), .CD(2'b00)         , .VDE(DrawArea), .TMDS(tmds1_data));
  TMDS_encoder encode_B(.clk(tmds_pixel_clk), .VD(blue ), .CD({vSync, hSync}), .VDE(DrawArea), .TMDS(tmds0_data));

  reg [2:0] shift_counter = 3'd0;
  reg [9:0] tmds0_shift, tmds1_shift, tmds2_shift;
  reg [7:0] tmds_buf;
  reg tmdsC, tmdsC_next;

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
    tmdsC <= |shift_counter[2:1];
    tmdsC_next <= shift_counter[2] | &shift_counter[1:0];
    tmds_buf <= {tmdsC_next, tmds2_shift[1], tmds1_shift[1], tmds0_shift[1], tmdsC, tmds2_shift[0], tmds1_shift[0], tmds0_shift[0]};
  end

  wire [3:0] pad_out_p;
  wire [3:0] pad_out_m;
  DDR_O4 out_p(
    .outclock(tmds_x5_clk),
    .din(tmds_buf),
    .pad_out(pad_out_p)
  );
  DDR_O4 out_m(
    .outclock(tmds_x5_clk),
    .din(~tmds_buf),
    .pad_out(pad_out_m)
  );
  assign dvi_tmds0p = pad_out_p[0];
  assign dvi_tmds0m = pad_out_m[0];
  assign dvi_tmds1p = pad_out_p[1];
  assign dvi_tmds1m = pad_out_m[1];
  assign dvi_tmds2p = pad_out_p[2];
  assign dvi_tmds2m = pad_out_m[2];
  assign dvi_tmdsCp = pad_out_p[3];
  assign dvi_tmdsCm = pad_out_m[3];

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

