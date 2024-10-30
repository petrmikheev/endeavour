// Based on https://github.com/WangXuan95/FPGA-DDR-SDRAM/blob/main/RTL/ddr_sdram_ctrl.v (license: GPL-3.0),
// but most of the code is rewritten.

module DDRSdramController #(
    parameter       ROW_BITS  = 13,
    parameter       COL_BITS  = 11,
    parameter       ID_WIDTH  = 1,
    parameter [9:0] tREFC     = 10'd600,
    parameter [7:0] tW2I      = 8'd2,
    parameter [7:0] tR2I      = 8'd2
) (
    input clk,
    input clk_shifted,  // should be same rate as `clk` with 1/4 period delay
    input reset,
    // user interface (AXI4)
    input  wire                          arw_valid,
    output wire                          arw_ready,
    input  wire  [ROW_BITS+COL_BITS+2:0] arw_addr,   // byte address, not word address.
    input  wire                    [7:0] arw_len,
    input  wire                          arw_write,
    input  wire                          wvalid,
    output wire                          wready,
    input  wire                          wlast,
    input  wire                   [63:0] wdata,
    input wire                     [7:0] wstrb,
    output wire                          bvalid,
    input  wire                          bready,
    output wire                    [1:0] bresp,
    output wire                          rvalid,
    input  wire                          rready,
    output wire                    [1:0] rresp,
    output wire                          rlast,
    output wire                   [63:0] rdata,
    //
    input wire   [ID_WIDTH-1:0] arw_id,
    output reg   [ID_WIDTH-1:0] bid,
    output wire  [ID_WIDTH-1:0] rid,
    input wire   [2:0] arw_size,     // ignored, expected 4 byte (0x2)
    input wire   [1:0] arw_burst,    // ignored, expected INCR
    input wire         arw_allStrb,  // ignored
    // DDR-SDRAM interface
    output wire                                ddr_ck_p, ddr_ck_n,
    output reg                                 ddr_cke,
    output reg                                 ddr_ras_n,
    output reg                                 ddr_cas_n,
    output reg                                 ddr_we_n,
    output reg                           [1:0] ddr_ba,
    output reg                  [ROW_BITS-1:0] ddr_a,
    output wire                          [1:0] ddr_dm,
    inout                                [1:0] ddr_dqs,
    inout                               [15:0] ddr_dq
);

reg  [2:0] ref_idle = 3'd1, ref_real = 3'd0;
reg  [9:0] ref_cnt = 10'd0;
reg  [7:0] cnt = 8'd0;

localparam [3:0] RESET     = 4'd0,
                 IDLE      = 4'd1,
                 REFRESH   = 4'd3,
                 WPRE      = 4'd4,
                 WRITE     = 4'd5,
                 WRESP     = 4'd6,
                 WWAIT     = 4'd7,
                 RPRE      = 4'd8,
                 READ      = 4'd9,
                 RRESP     = 4'd10,
                 RWAIT     = 4'd11;
reg  [3:0] stat = RESET;

reg  [7:0] burst_len = 8'd0;
wire       burst_last = cnt==burst_len;
reg  [COL_BITS-2:0] col_addr = 0;

wire [ROW_BITS-1:0] ddr_a_col;
generate if(COL_BITS>10) begin
    assign ddr_a_col = {col_addr[COL_BITS-2:9], burst_last, col_addr[8:0], 1'b0};
end else begin
    assign ddr_a_col = {burst_last, col_addr[8:0], 1'b0};
end endgenerate

reg next_ras_n, next_cas_n, next_we_n;
reg [ROW_BITS-1:0] next_a;
reg [1:0] next_ba;

wire new_command = stat == IDLE && ref_real == ref_idle && arw_valid;

// -------------------------------------------------------------------------------------
//   refresh wptr self increasement
// -------------------------------------------------------------------------------------
always @(posedge clk) begin
    if(reset) begin
        ref_cnt <= tREFC;
        ref_idle <= 3'd1;
    end else begin
        if (stat != RESET) begin
            if (|ref_cnt) begin
                ref_cnt <= ref_cnt - 10'd1;
            end else begin
                ref_cnt <= tREFC;
                ref_idle <= ref_idle + 3'd1;
            end
        end
    end
end

// -------------------------------------------------------------------------------------
//  assignment for user interface (AXI4)
// -------------------------------------------------------------------------------------
assign bvalid  = stat==WRESP;
assign arw_ready = stat==IDLE && ref_real==ref_idle;
assign rresp = 2'b0;
assign bresp = 2'b0;
assign rid = bid;
reg wready32 = 0;
assign wready = wready32 & cnt[0];

// -------------------------------------------------------------------------------------
//   main FSM for generating DDR-SDRAM behavior
// -------------------------------------------------------------------------------------
always @ (posedge clk)
    if( reset) begin
        ddr_cke <= 1'b0;
        {next_ras_n, next_cas_n, next_we_n} <= 3'b111;
        col_addr <= 0;
        burst_len <= 8'd0;
        ref_real <= 3'd0;
        cnt <= 8'd0;
        stat <= RESET;
        wready32 <= 0;
    end else begin
        case (stat)
            RESET: begin
                cnt <= cnt + 8'd1;
                case (cnt)
                    8'd0  : ddr_cke <= 1'b1;  // NOP
                    8'd1  : begin             // Precharge all
                        {next_ras_n, next_cas_n, next_we_n} <= 3'b010;
                        next_a[10] <= 1'b1;
                    end
                    8'd2  : {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // 2x NOP
                    8'd4  : begin             // EMRS
                        {next_ras_n, next_cas_n, next_we_n} <= 3'b000;
                        next_ba <= 2'b01;
                        next_a <= 'h2;   // 0x0 (default) or 0x2 (weak drive strength)
                    end
                    8'd5  : {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // 2x NOP
                    8'd7  : begin             // MRS, reset DLL
                        {next_ras_n, next_cas_n, next_we_n} <= 3'b000;
                        next_ba <= 2'b00;
                        next_a <= 'h121; // DLL_RESET (0x100) | CL2 (0x20) | burst length 2 (0x1)
                    end
                    8'd8  : {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // 2x NOP
                    8'd9: begin               // Precharge all
                        {next_ras_n, next_cas_n, next_we_n} <= 3'b010;
                        next_a[10] <= 1'b1;
                    end
                    8'd10: {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // 2x NOP
                    8'd12, 8'd140: {next_ras_n, next_cas_n, next_we_n} <= 3'b001; // Auto refresh
                    8'd13, 8'd141: {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // NOPs
                    8'd207: begin             // MRS, clear DLL reset
                        {next_ras_n, next_cas_n, next_we_n} <= 3'b000;
                        next_ba <= 2'b00;
                        next_a <= 'h21;  // CL2 (0x20) | burst length 2 (0x1)
                    end
                    8'd208: {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // 2x NOP
                    8'd210: stat <= IDLE;
                endcase
            end
            IDLE: begin
                cnt <= 8'd0;
                if (ref_real != ref_idle) begin
                    ref_real <= ref_real + 3'd1;
                    stat <= REFRESH;
                    {next_ras_n, next_cas_n, next_we_n} <= 3'b010; // Precharge all
                    next_a[10] <= 1'b1;
                end else
                    {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // NOP
                if (new_command) begin
                    burst_len <= {arw_len[6:0], 1'b1};
                    stat <= arw_write ? WPRE : RPRE;
                    bid <= arw_id;
                    {next_ba, next_a, col_addr} <= arw_addr[ROW_BITS+COL_BITS+2:2];
                end
            end
            REFRESH: begin
                cnt <= cnt + 8'd1;
                case (cnt[4:0])
                    5'd0: {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // 2x NOP
                    5'd2: {next_ras_n, next_cas_n, next_we_n} <= 3'b001; // Auto refresh
                    5'd3: {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // 15x NOP
                    5'd18: stat <= IDLE;
                endcase
            end
            WPRE: begin
                // Note: if clk>110mhz then second NOP is needed
                {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // controlled in new_rcw_n assignment
                cnt <= 8'd0;
                stat <= WRITE;
                wready32 <= 1;
            end
            RPRE: begin
                {next_ras_n, next_cas_n, next_we_n} <= 3'b101; // READ    Note: if clk>110mhz then second NOP is needed
                cnt <= 8'd0;
                stat <= READ;
            end
            WRITE: begin
                if(wvalid) begin
                    col_addr <= col_addr + {{(COL_BITS-2){1'b0}}, 1'b1};
                    if(burst_last | (wlast & cnt[0])) begin
                        cnt <= 8'd0;
                        stat <= WRESP;
                        wready32 <= 0;
                        {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // NOP
                    end else begin
                        cnt <= cnt + 8'd1;
                    end
                end
            end
            WRESP: begin
                cnt <= cnt + 8'd1;
                if(bready)
                    stat <= WWAIT;
            end
            WWAIT: begin
                cnt <= cnt + 8'd1;
                if(cnt>=tW2I)
                    stat <= IDLE;
            end
            READ: begin
                col_addr <= col_addr + {{(COL_BITS-2){1'b0}}, 1'b1};
                if(burst_last) begin
                    cnt <= 8'd0;
                    stat <= RRESP;
                    {next_ras_n, next_cas_n, next_we_n} <= 3'b111; // NOP
                end else begin
                    cnt <= cnt + 8'd1;
                end
            end
            RRESP: begin 
                cnt <= cnt + 8'd1;
                if(rlast)
                    stat <= RWAIT;
            end
            RWAIT: begin
                cnt <= cnt + 8'd1;
                if(cnt>=tR2I)
                    stat <= IDLE;
            end
            default: stat <= IDLE;
        endcase
    end

// -------------------------------------------------------------------------------------
//   output enable generate
// -------------------------------------------------------------------------------------
reg  output_enable=1'b0, output_enable_d1=1'b0, output_enable_d2=1'b0, output_enable_dqs=1'b0;
always @(posedge clk) output_enable_d1 <= stat==WRITE;
always @(negedge clk) begin
    output_enable <= output_enable_d2;
    output_enable_d2 <= output_enable_d1;
end

always @(negedge clk_shifted) begin
    output_enable_dqs <= output_enable_d2 | output_enable;
end

// -------------------------------------------------------------------------------------
//   io bufs
// -------------------------------------------------------------------------------------

wire [31:0] ddr_in;
reg [31:0] ddr_out;
reg [15:0] ddr_out_buf;
reg ddr_out_valid = 0;
reg ddr_out_valid_buf = 0;
reg [3:0] wstrb1, wstrb2;

DDR_IO8 io_l(
  .outclock(clk),
  .inclock(clk),
  .oe(output_enable ? 8'hff : 8'h0),
  .pad_io(ddr_dq[7:0]),
  .din({ddr_out[23:16], ddr_out[7:0]}),
  .dout({ddr_in[7:0], ddr_in[23:16]})
);

DDR_IO8 io_h(
  .outclock(clk),
  .inclock(clk),
  .oe(output_enable ? 8'hff : 8'h0),
  .pad_io(ddr_dq[15:8]),
  .din({ddr_out[31:24], ddr_out[15:8]}),
  .dout({ddr_in[15:8], ddr_in[31:24]})
);

DDR_O1 o_ck_p(.outclock(clk_shifted), .din(2'b10), .pad_out(ddr_ck_p));
DDR_O1 o_ck_n(.outclock(clk_shifted), .din(2'b01), .pad_out(ddr_ck_n));

DDR_O1 o_dm0(.outclock(clk), .din(~{wstrb2[2], wstrb2[0]}), .pad_out(ddr_dm[0]));
DDR_O1 o_dm1(.outclock(clk), .din(~{wstrb2[3], wstrb2[1]}), .pad_out(ddr_dm[1]));

DDR_IO1 io_dqs0(
  .outclock(clk_shifted), .inclock(clk_shifted),
  .oe({output_enable_dqs}), .pad_io(ddr_dqs[0]), .din({ddr_out_valid, 1'b0})
);
DDR_IO1 io_dqs1(
  .outclock(clk_shifted), .inclock(clk_shifted),
  .oe({output_enable_dqs}), .pad_io(ddr_dqs[1]), .din({ddr_out_valid, 1'b0})
);

// Hardware buffers SDR_O1 are needed to have timings of A, BA, nRAS, nCAS, nWE to be aligned with DQ, DQS, CK, nCK (DDR buffers)

wire [2:0] new_rcw_n = stat == WRITE ? (wvalid ? 3'b100 : 3'b111) : // WRITE or NOP
                         new_command ? 3'b011 : // Bank active
                                       {next_ras_n, next_cas_n, next_we_n};
wire [1:0] new_ba = new_command ? arw_addr[ROW_BITS+COL_BITS+2:ROW_BITS+COL_BITS+1] : next_ba;
wire [ROW_BITS-1:0] new_a = (stat == WRITE || stat == READ) ? ddr_a_col :
                                                new_command ? arw_addr[ROW_BITS+COL_BITS:COL_BITS+1] : next_a;

reg [2:0] buf_rcw_n;
reg [1:0] buf_ba;
reg [ROW_BITS-1:0] buf_a;

always @(posedge clk) begin
//always @(negedge clk_shifted) begin
  buf_rcw_n <= new_rcw_n;
  buf_ba <= new_ba;
  buf_a <= new_a;
end

wire sdr_clock = ~clk;

SDR_O1 sdr1(.outclock(sdr_clock), .din(buf_rcw_n[2]), .pad_out(ddr_ras_n));
SDR_O1 sdr2(.outclock(sdr_clock), .din(buf_rcw_n[1]), .pad_out(ddr_cas_n));
SDR_O1 sdr3(.outclock(sdr_clock), .din(buf_rcw_n[0]), .pad_out(ddr_we_n));
SDR_O1 sdr4(.outclock(sdr_clock), .din(buf_ba[1]), .pad_out(ddr_ba[1]));
SDR_O1 sdr5(.outclock(sdr_clock), .din(buf_ba[0]), .pad_out(ddr_ba[0]));

genvar sdr_i;
generate
    for (sdr_i = 0; sdr_i < ROW_BITS; sdr_i = sdr_i + 1) begin : sdr_addr
        SDR_O1 sdr_a(.outclock(sdr_clock), .din(buf_a[sdr_i]), .pad_out(ddr_a[sdr_i]));
    end
endgenerate

// -------------------------------------------------------------------------------------
//   output data latches
// -------------------------------------------------------------------------------------
wire [31:0] wdata32 = cnt[0] ? wdata[63:32] : wdata[31:0];
always @(posedge clk) begin
    if(reset) begin
        ddr_out_valid_buf <= 1'b0;
        ddr_out <= 32'b0;
        ddr_out_buf <= 32'b0;
    end else begin
        ddr_out_valid_buf <= (stat==WRITE && wvalid);
        ddr_out_buf <= wdata32[15:0];
        ddr_out <= {wdata32[31:16], ddr_out_buf};
        wstrb1 <= cnt[0] ? wstrb[7:4] : wstrb[3:0];
        wstrb2 <= wstrb1;
    end
end
always @(negedge clk) ddr_out_valid <= ddr_out_valid_buf;

// -------------------------------------------------------------------------------------
//   read delay
// -------------------------------------------------------------------------------------

reg         i_v_a = 1'b0;
reg         i_l_a = 1'b0;
reg         i_v_b = 1'b0;
reg         i_l_b = 1'b0;
reg         i_v_c = 1'b0;
reg         i_l_c = 1'b0;
reg         i_v_d = 1'b0;
reg         i_l_d = 1'b0;
reg         i_v_e = 1'b0;
reg         i_l_e = 1'b0;
reg [31:0] rdata_lo;

always @ (posedge clk) begin
    if(reset) begin
        {i_v_a, i_v_b, i_v_c, i_v_d} <= 0;
        {i_l_a, i_l_b, i_l_c, i_l_d} <= 0;
        i_v_e <= 1'b0;
        i_l_e <= 1'b0;
    end else begin
        i_v_a <= (stat==READ) && cnt[0];
        i_l_a <= burst_last;
        i_v_b <= i_v_a;
        i_l_b <= i_l_a & i_v_a;
        i_v_c <= i_v_b;
        i_l_c <= i_l_b;
        i_v_d <= i_v_c;
        i_l_d <= i_l_c;
        i_v_e <= i_v_d;
        i_l_e <= i_l_d;
        rdata_lo <= ddr_in;
    end
end

assign rvalid = i_v_e;
assign rlast = i_l_e;
assign rdata = {ddr_in, rdata_lo};

endmodule
