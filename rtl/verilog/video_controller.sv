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

  output reg        axi_ar_valid,
  input             axi_ar_ready,
  output reg [31:0] axi_ar_payload_addr,
  output reg  [7:0] axi_ar_payload_len,
  output      [1:0] axi_ar_payload_burst,
  input             axi_r_valid,
  output            axi_r_ready,
  input      [31:0] axi_r_payload_data,
  input             axi_r_payload_last
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
  reg use_graphic_alpha = 0;
  reg [3:0] font_height;
  reg [2:0] font_width;
  reg [31:0] text_addr;
  reg [31:0] graphic_addr;

  reg [10:0] charmap_index;

  // CHARMAP_SIZE = 512: symbols with codes 8-127 (ASCII)
  // CHARMAP_SIZE = 1024: symbols with codes 8-255
  // CHARMAP_SIZE = 2048: symbols with codes 8-255, two fonts
  localparam CHARMAP_SIZE = 2048;

  reg [31:0] charmap [CHARMAP_SIZE-1:0];  // 8 M9K
  reg [31:0] text_line [255:0];           // 1 M9K
  reg [31:0] graphic_line [1023:0];       // 4 M9K

  localparam PIXEL_DELAY = 2'd3;

  // *** APB interface

  assign video_mode_out = video_mode;
  reg [2:0] apb_reg;

  always @(posedge clk) begin
    apb_reg <= apb_PADDR[4:2];
    if (reset) begin
      video_mode <= 2'd0;
      show_text <= 1'd0;
      show_graphic <= 1'd0;
    end else begin
      if (apb_PSEL & apb_PENABLE & apb_PWRITE) begin
        if (apb_reg == 3'd0) begin
          {use_graphic_alpha, font_width, font_height, show_graphic, show_text, video_mode} <= apb_PWDATA[11:0];
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
        if (apb_reg == 3'd3) charmap_index <= apb_PWDATA[10:0];
        if (apb_reg == 3'd4) charmap[charmap_index] <= apb_PWDATA;
      end
    end
  end

  assign apb_PREADY = 1'b1;
  assign apb_PRDATA = apb_reg == 3'd0 ? {20'b0, use_graphic_alpha, font_width, font_height, show_graphic, show_text, video_mode} :
                      apb_reg == 3'd1 ? text_addr :
                      apb_reg == 3'd2 ? graphic_addr :
                                        {22'b0, charmap_index};

  // *** Counters

  reg [10:0] hCounter = 11'd0;
  reg  [9:0] vCounter = 10'd0;
  reg  [7:0] hCharCounter;
  reg  [6:0] vCharCounter = 0;
  reg  [2:0] char_px;
  reg  [3:0] char_py = 0;
  reg  [6:0] text_read_len = 7'd40;

  reg hDraw = 0;
  reg vDraw = 0;
  reg hSync = 0;
  reg vSync = 0;
  wire DrawArea = hDraw & vDraw;

  reg [2:0] pixel_group_request_counter = 0;
  reg [2:0] pixel_group_done_counter = 0;
  reg text_line_request_parity = 0;
  reg text_line_done_parity = 0;

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
      if (show_text && char_py == font_height && hCounter == 3'd4) text_line_request_parity = ~text_line_request_parity;
      if (show_graphic && hDraw && &hCounter[6:0]) pixel_group_request_counter = pixel_group_request_counter + 1'b1;
      if (hCounter == PIXEL_DELAY) hDraw <= 1;
      if (hCounter == hDrawEnd) begin
        hDraw <= 0;
        text_read_len <= hCharCounter[7:1];
      end
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

  assign axi_ar_payload_burst = 2'd1;
  assign axi_r_ready = 1'b1;

  reg [7:0] text_line_index = 0;
  reg [9:0] graphic_line_index = 0;
  reg text_line_request_parity_buf = 0;
  reg [2:0] pixel_group_request_counter_buf = 0;
  reg [9:0] pixel_load_y = 10'd1023;
  reg [13:0] pixel_group_addr;
  reg pixel_loading = 0;
  reg text_loading = 0;
  always @(posedge clk) begin
    text_line_request_parity_buf <= text_line_request_parity;
    pixel_group_request_counter_buf <= pixel_group_request_counter;
    if (reset) begin
      pixel_loading <= 0;
      text_loading <= 0;
    end if (pixel_loading | text_loading) begin
      if (axi_ar_valid & axi_ar_ready) axi_ar_valid <= 1'b0;
      if (axi_r_valid & text_loading) begin
        text_line_index <= text_line_index + 1'b1;
        text_line[text_line_index] <= axi_r_payload_data;
        if (axi_r_payload_last) text_loading <= 1'b0;
      end
      if (axi_r_valid & pixel_loading) begin
        graphic_line_index <= graphic_line_index + 1'b1;
        graphic_line[graphic_line_index] <= axi_r_payload_data;
        if (axi_r_payload_last) pixel_loading <= 1'b0;
      end
    end else if (pixel_group_request_counter_buf != pixel_group_done_counter) begin
      pixel_group_done_counter <= pixel_group_done_counter + 1'b1;
      pixel_loading <= 1;
      axi_ar_valid <= 1'b1;
      axi_ar_payload_len <= 8'd63;
      if (pixel_load_y != vCounter) begin
        pixel_load_y <= vCounter;
        pixel_group_addr <= {10'(graphic_addr[21:12] + vCounter), graphic_addr[11:8]};
        axi_ar_payload_addr <= {graphic_addr[31:22], 10'(graphic_addr[21:12] + vCounter), graphic_addr[11:0]};
        graphic_line_index <= 0;
      end else begin
        pixel_group_addr <= pixel_group_addr + 1'd1;
        axi_ar_payload_addr <= {graphic_addr[31:22], 14'(pixel_group_addr + 1'd1), graphic_addr[7:0]};
      end
    end else if (text_line_request_parity_buf != text_line_done_parity) begin
      text_line_done_parity <= ~text_line_done_parity;
      text_loading <= 1;
      axi_ar_payload_addr <= {text_addr[31:16], 7'(text_addr[31:9] + vCharCounter), text_addr[8:0]};
      axi_ar_payload_len <= text_read_len;
      axi_ar_valid <= 1'b1;
      text_line_index <= {~vCharCounter[0], 7'd0};
    end
  end

  // *** Color calculation

  reg [31:0] gword, tword;
  wire [7:0] tchar = hCharCounter[0] ? tword[23:16] : tword[7:0];
  wire [3:0] tfg_index = hCharCounter[0] ? tword[27:24] : tword[11:8];
  wire [3:0] tbg_index = hCharCounter[0] ? tword[31:28] : tword[15:12];
  reg [10:0] charmap_rindex;
  reg [31:0] charmap_rdata;
  reg [31:0] tfg, tbg, charmap_word;
  reg [7:0] char_shift = 0;
  reg [31:0] char_fg, char_bg;
  wire [31:0] tcolor = char_shift[7] ? char_fg : char_bg;
  wire [15:0] gcolor16 = hCounter[0] ? gword[15:0] : gword[31:16];
  wire        galpha = use_graphic_alpha ? gcolor16[5] : 1'b0;
  wire [23:0] gcolor24 = {
      /*R*/ gcolor16[15:11], gcolor16[15:13],
      /*G*/ gcolor16[10:6], (use_graphic_alpha ? gcolor16[10:8] : {gcolor16[5], gcolor16[10:9]}),
      /*B*/ gcolor16[4:0], gcolor16[4:2]};
  reg [7:0] red, green, blue;
  reg [7:0] gred1, ggreen1, gblue1;
  reg [7:0] gred2, ggreen2, gblue2;
  reg [9:0] diff_r, diff_g, diff_b;
  reg [13:0] mul_r, mul_g, mul_b;
  reg [6:0] alpha1, alpha2;

  always @(posedge tmds_pixel_clk) begin
    if (show_graphic) begin
      if (~hCounter[0]) gword <= graphic_line[hCounter[10:1]];
    end else
      gword <= 0;
    if (show_text) begin
      charmap_rdata <= charmap[charmap_rindex[$clog2(CHARMAP_SIZE)-1:0]];
      if (char_px == 3'd1)
        charmap_rindex <= {7'd1, tfg_index};
      else if (char_px == 3'd2) begin
        charmap_rindex <= {7'd0, tbg_index};
      end else if (char_px == 3'd3) begin
        tfg <= charmap_rdata;
        charmap_rindex <= {charmap_rdata[7], tchar, char_py[3:2]};
      end else if (char_px == 3'd4) begin
        tbg <= charmap_rdata;
      end else if (char_px == 3'd5) begin
        charmap_word <= |charmap_rindex[10:5] ? charmap_rdata : 32'd0;
      end
      if (char_px == 0) begin
        tword <= text_line[{vCharCounter[0], hCharCounter[7:1]}];
        case (char_py[1:0])
          2'd0: char_shift <= charmap_word[7:0];
          2'd1: char_shift <= charmap_word[15:8];
          2'd2: char_shift <= charmap_word[23:16];
          2'd3: char_shift <= charmap_word[31:24];
        endcase
        char_fg <= tfg;
        char_bg <= tbg;
      end else char_shift[7:1] <= char_shift[6:0];
    end else begin
      char_fg <= 0;
      char_bg <= 0;
    end

    {gred1, ggreen1, gblue1} <= gcolor24;
    {gred2, ggreen2, gblue2} <= {gred1, ggreen1, gblue1};
    diff_r <= {2'b10, tcolor[31:24]} - gcolor24[23:16];
    diff_g <= {2'b10, tcolor[23:16]} - gcolor24[15:8];
    diff_b <= {2'b10, tcolor[15:8]}  - gcolor24[7:0];
    alpha1 <= show_graphic ? (galpha ? 7'd0 : tcolor[6:0]) : 7'd64;
    alpha2 <= alpha1;
    mul_r <= $unsigned({4'b0, diff_r}) * $unsigned(alpha1);
    mul_g <= $unsigned({4'b0, diff_g}) * $unsigned(alpha1);
    mul_b <= $unsigned({4'b0, diff_b}) * $unsigned(alpha1);
    red   <= gred2   + mul_r[13:6] - {alpha2[4:0], 3'b0};
    green <= ggreen2 + mul_g[13:6] - {alpha2[4:0], 3'b0};
    blue  <= gblue2  + mul_b[13:6] - {alpha2[4:0], 3'b0};
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

  reg [9:0] TMDS_buf = 0;
  always @(posedge clk) TMDS_buf <= VDE ? TMDS_data : TMDS_code;
  always @(posedge clk) TMDS <= TMDS_buf;
  always @(posedge clk) balance_acc <= VDE ? balance_acc_new : 4'h0;
endmodule

