// Based on https://github.com/WangXuan95/FPGA-DDR-SDRAM/blob/main/RTL/ddr_sdram_ctrl.v
// License: GPL-3.0
// Modifications:
// - Instead of extra high frequency clock `drv_clk` using DDR IO buffer "DDR_IO8" (instance of altera_gpio_lite)
//   and shifted clock `dqs_clk` = `clk` with tCK/4 delay.

//--------------------------------------------------------------------------------------------------------
// Module  : ddr_sdram_ctrl
// Type    : synthesizable, IP's top
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: DDR1 SDRAM controller
//           with AXI4 interface
//--------------------------------------------------------------------------------------------------------

module ddr_sdram_ctrl #(
    parameter       BA_BITS   = 2,
    parameter       ROW_BITS  = 13,
    parameter       COL_BITS  = 11,
    parameter       DQ_LEVEL  = 2,  // DDR DQ_BITS = 4<<DQ_LEVEL, AXI4 DATA WIDTH = 8<<DQ_LEVEL, for example:
                                    // DQ_LEVEL = 0: DQ_BITS = 4  (x4)  , AXI DATA WIDTH = 8
                                    // DQ_LEVEL = 1: DQ_BITS = 8  (x8)  , AXI DATA WIDTH = 16    (default)
                                    // DQ_LEVEL = 2: DQ_BITS = 16 (x16) , AXI DATA WIDTH = 32
    parameter [9:0] tREFC     = 10'd600,
    parameter [7:0] tW2I      = 8'd2,
    parameter [7:0] tR2I      = 8'd2
) (
    input clk,
    input dqs_clk,  // should be same rate as `clk` with 1/4 period delay
    input reset,
    // user interface (AXI4)
    input  wire                                           arw_valid,
    output wire                                           arw_ready,
    input  wire  [BA_BITS+ROW_BITS+COL_BITS+DQ_LEVEL-2:0] arw_addr,   // byte address, not word address.
    input  wire                                    [ 7:0] arw_len,
    input  wire                                           arw_write,
    input  wire                                           wvalid,
    output wire                                           wready,
    input  wire                                           wlast,
    input  wire                       [(8<<DQ_LEVEL)-1:0] wdata,
    output wire                                           bvalid,
    input  wire                                           bready,
    output wire                                           rvalid,
    input  wire                                           rready,
    output wire                                           rlast,
    output wire                       [(8<<DQ_LEVEL)-1:0] rdata,
    //
    input wire   [0:0] arw_id,
    input wire   [2:0] arw_size,  // ignored
    input wire   [1:0] arw_burst, // ignored
    input wire   [3:0] wstrb,     // ignored
    output reg   [0:0] bid,
    output reg   [0:0] rid,
    // DDR-SDRAM interface
    output wire                                           ddr_ck_p, ddr_ck_n,
    output wire                                           ddr_cke,
    output reg                                            ddr_cs_n,
    output reg                                            ddr_ras_n,
    output reg                                            ddr_cas_n,
    output reg                                            ddr_we_n,
    output reg                  [            BA_BITS-1:0] ddr_ba,
    output reg                  [           ROW_BITS-1:0] ddr_a,
    output wire                 [((1<<DQ_LEVEL)+1)/2-1:0] ddr_dm,
    inout                       [((1<<DQ_LEVEL)+1)/2-1:0] ddr_dqs,
    inout                       [      (4<<DQ_LEVEL)-1:0] ddr_dq
);


localparam DQS_BITS = ((1<<DQ_LEVEL)+1)/2;

reg        init_done = 1'b0;
reg  [2:0] ref_idle = 3'd1, ref_real = 3'd0;
reg  [9:0] ref_cnt = 10'd0;
reg  [7:0] cnt = 8'd0;

localparam [3:0] RESET     = 4'd0,
                 IDLE      = 4'd1,
                 CLEARDLL  = 4'd2,
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

wire read_accessible, read_respdone;
reg  output_enable=1'b0, output_enable_d1=1'b0, output_enable_d2=1'b0;

// -------------------------------------------------------------------------------------
//   constants defination and assignment
// -------------------------------------------------------------------------------------
localparam [ROW_BITS-1:0] DDR_A_DEFAULT      = 'b0100_0000_0000;
localparam [ROW_BITS-1:0] DDR_A_EMR          = 'b0000_0000_0000;  // or 0x2  -> weak drive strength
localparam [ROW_BITS-1:0] DDR_A_MR0          = 'b0001_0010_1001;  // 0x29 -> CL2, burst length 2, interleave
localparam [ROW_BITS-1:0] DDR_A_MR_CLEAR_DLL = 'b0000_0010_1001;


initial ddr_cs_n = 1'b1;
initial ddr_ras_n = 1'b1;
initial ddr_cas_n = 1'b1;
initial ddr_we_n = 1'b1;
initial ddr_ba = 0;
initial ddr_a = DDR_A_DEFAULT;

// -------------------------------------------------------------------------------------
//   refresh wptr self increasement
// -------------------------------------------------------------------------------------
always @ (posedge clk)
    if(reset) begin
        ref_cnt <= tREFC;
        ref_idle <= 3'd1;
    end else begin
        if(init_done) begin
            if (|ref_cnt) begin
                ref_cnt <= ref_cnt - 10'd1;
            end else begin
                ref_cnt <= tREFC;
                ref_idle <= ref_idle + 3'd1;
            end
        end
    end

// -------------------------------------------------------------------------------------
//   DDR clock
// -------------------------------------------------------------------------------------
assign ddr_ck_p = dqs_clk; //~clk;
assign ddr_ck_n = ~dqs_clk; //clk;
assign ddr_cke = ~ddr_cs_n;

// -------------------------------------------------------------------------------------
//  assignment for user interface (AXI4)
// -------------------------------------------------------------------------------------
assign wready  = stat==WRITE;
assign bvalid  = stat==WRESP;
assign arw_ready = stat==IDLE && init_done && ref_real==ref_idle && (arw_write || read_accessible);

// -------------------------------------------------------------------------------------
//   main FSM for generating DDR-SDRAM behavior
// -------------------------------------------------------------------------------------
always @ (posedge clk)
    if(reset) begin
        ddr_cs_n <= 1'b1;
        ddr_ras_n <= 1'b1;
        ddr_cas_n <= 1'b1;
        ddr_we_n <= 1'b1;
        ddr_ba <= 0;
        ddr_a <= DDR_A_DEFAULT;
        col_addr <= 0;
        burst_len <= 8'd0;
        init_done <= 1'b0;
        ref_real <= 3'd0;
        cnt <= 8'd0;
        stat <= RESET;
    end else begin
        case(stat)
            RESET: begin
                cnt <= cnt + 8'd1;
                if(cnt[5:0]<8'd13) begin
                end else if(cnt[5:0]<8'd50) begin
                    ddr_cs_n <= 1'b0;
                end else if(cnt[5:0]<8'd51) begin
                    ddr_ras_n <= 1'b0;
                    ddr_we_n <= 1'b0;
                end else if(cnt[5:0]<8'd53) begin
                    ddr_ras_n <= 1'b1;
                    ddr_we_n <= 1'b1;
                end else if(cnt[5:0]<8'd54) begin
                    ddr_ras_n <= 1'b0;
                    ddr_cas_n <= 1'b0;
                    ddr_we_n <= 1'b0;
                    ddr_ba <= 1;
                    ddr_a <= DDR_A_EMR;
                end else begin
                    ddr_ba <= 0;
                    ddr_a <= DDR_A_MR0;
                    stat <= IDLE;
                end
            end
            IDLE: begin
                ddr_ras_n <= 1'b1;
                ddr_cas_n <= 1'b1;
                ddr_we_n <= 1'b1;
                ddr_ba <= 0;
                ddr_a <= DDR_A_DEFAULT;
                cnt <= 8'd0;
                if(ref_real != ref_idle) begin
                    ref_real <= ref_real + 3'd1;
                    stat <= REFRESH;
                end else if(~init_done) begin
                    stat <= CLEARDLL;
                end else if(arw_valid & arw_write) begin
                    ddr_ras_n <= 1'b0;
                    {ddr_ba, ddr_a, col_addr} <= arw_addr[BA_BITS+ROW_BITS+COL_BITS+DQ_LEVEL-2:DQ_LEVEL];
                    burst_len <= arw_len;
                    stat <= WPRE;
                    bid <= arw_id;
                end else if(arw_valid & ~arw_write & read_accessible) begin
                    ddr_ras_n <= 1'b0;
                    {ddr_ba, ddr_a, col_addr} <= arw_addr[BA_BITS+ROW_BITS+COL_BITS+DQ_LEVEL-2:DQ_LEVEL];
                    burst_len <= arw_len;
                    stat <= RPRE;
                    rid <= arw_id;
                end
            end
            CLEARDLL: begin
                ddr_ras_n <= cnt!=8'd0;
                ddr_cas_n <= cnt!=8'd0;
                ddr_we_n <= cnt!=8'd0;
                ddr_a <= cnt!=8'd0 ? DDR_A_DEFAULT : DDR_A_MR_CLEAR_DLL;
                cnt <= cnt + 8'd1;
                if(cnt==8'd255) begin
                    init_done <= 1'b1;
                    stat <= IDLE;
                end
            end
            REFRESH: begin
                cnt <= cnt + 8'd1;
                if(cnt<8'd1) begin
                    ddr_ras_n <= 1'b0;
                    ddr_we_n <= 1'b0;
                end else if(cnt<8'd3) begin
                    ddr_ras_n <= 1'b1;
                    ddr_we_n <= 1'b1;
                end else if(cnt == 8'd4) begin
                    ddr_ras_n <= 1'b0;
                    ddr_cas_n <= 1'b0;
                end else if(cnt<8'd10) begin
                    ddr_ras_n <= 1'b1;
                    ddr_cas_n <= 1'b1;
                end else if(cnt == 8'd11) begin
                    ddr_ras_n <= 1'b0;
                    ddr_cas_n <= 1'b0;
                end else if(cnt<8'd17) begin
                    ddr_ras_n <= 1'b1;
                    ddr_cas_n <= 1'b1;
                end else begin
                    stat <= IDLE;
                end
            end
            WPRE: begin
                ddr_ras_n <= 1'b1;
                cnt <= 8'd0;
                stat <= WRITE;
            end
            WRITE: begin
                ddr_a <= ddr_a_col;
                if(wvalid) begin
                    ddr_cas_n <= 1'b0;
                    ddr_we_n <= 1'b0;
                    col_addr <= col_addr + {{(COL_BITS-2){1'b0}}, 1'b1};
                    if(burst_last | wlast) begin
                        cnt <= 8'd0;
                        stat <= WRESP;
                    end else begin
                        cnt <= cnt + 8'd1;
                    end
                end else begin
                    ddr_cas_n <= 1'b1;
                    ddr_we_n <= 1'b1;
                end
            end
            WRESP: begin
                ddr_cas_n <= 1'b1;
                ddr_we_n <= 1'b1;
                cnt <= cnt + 8'd1;
                if(bready)
                    stat <= WWAIT;
            end
            WWAIT: begin
                cnt <= cnt + 8'd1;
                if(cnt>=tW2I)
                    stat <= IDLE;
            end
            RPRE: begin
                ddr_ras_n <= 1'b1;
                cnt <= 8'd0;
                stat <= READ;
            end
            READ: begin
                ddr_cas_n <= 1'b0;
                ddr_a <= ddr_a_col;
                col_addr <= col_addr + {{(COL_BITS-2){1'b0}}, 1'b1};
                if(burst_last) begin
                    cnt <= 8'd0;
                    stat <= RRESP;
                end else begin
                    cnt <= cnt + 8'd1;
                end
            end
            RRESP: begin 
                ddr_cas_n <= 1'b1;
                cnt <= cnt + 8'd1;
                if(read_respdone)
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
always @ (posedge clk)
    if(reset) begin
        output_enable <= 1'b0;
        output_enable_d1 <= 1'b0;
        output_enable_d2 <= 1'b0;
    end else begin
        output_enable <= stat==WRITE || output_enable_d1 || output_enable_d2;
        output_enable_d1 <= stat==WRITE;
        output_enable_d2 <= output_enable_d1;
    end

// -------------------------------------------------------------------------------------
//   DDR DQ
// -------------------------------------------------------------------------------------

wire [31:0] ddr_in;
reg [31:0] ddr_out;
reg [31:0] ddr_out_buf;
reg ddr_out_valid = 0;
reg ddr_out_valid_buf = 0;

DDR_IO8 io_l(
  .outclock(clk),
  .inclock(ddr_dqs[0]),
  .oe(output_enable ? 8'hff : 8'h0),
  .pad_io(ddr_dq[7:0]),
  .din({ddr_out[7:0], ddr_out[23:16]}),
  .dout({ddr_in[7:0], ddr_in[23:16]})
);

DDR_IO8 io_h(
  .outclock(clk),
  .inclock(ddr_dqs[1]),
  .oe(output_enable ? 8'hff : 8'h0),
  .pad_io(ddr_dq[15:8]),
  .din({ddr_out[15:8], ddr_out[31:24]}),
  .dout({ddr_in[15:8], ddr_in[31:24]})
);

assign ddr_dm  = output_enable ? {DQS_BITS{1'b0}}   : {DQS_BITS{1'bz}};
assign ddr_dqs = {DQS_BITS{output_enable ? (dqs_clk & ddr_out_valid) : 1'bz}};

// -------------------------------------------------------------------------------------
//   output data latches
// -------------------------------------------------------------------------------------
always @ (posedge clk)
    if(reset) begin
        ddr_out_valid <= 1'b0;
        ddr_out_valid_buf <= 1'b0;
        ddr_out <= 32'b0;
        ddr_out_buf <= 32'b0;
    end else begin
        ddr_out_valid_buf <= (stat==WRITE && wvalid);
        ddr_out_buf <= wdata;
        ddr_out_valid <= ddr_out_valid_buf;
        ddr_out <= ddr_out_buf;
    end

// -------------------------------------------------------------------------------------
//   dq sampling for input (read)
// -------------------------------------------------------------------------------------

reg                      i_v_a = 1'b0;
reg                      i_l_a = 1'b0;
reg                      i_v_b = 1'b0;
reg                      i_l_b = 1'b0;
reg                      i_v_c = 1'b0;
reg                      i_l_c = 1'b0;
reg                      i_dqs_c = 1'b0;
reg                      i_v_d = 1'b0;
reg                      i_l_d = 1'b0;
reg                      i_v_e = 1'b0;
reg                      i_l_e = 1'b0;
reg  [(8<<DQ_LEVEL)-1:0] i_d_e = 0;

always @ (posedge clk)
    if(reset) begin
        {i_v_a, i_v_b, i_v_c, i_v_d} <= 0;
        {i_l_a, i_l_b, i_l_c, i_l_d} <= 0;
    end else begin
        i_v_a <= stat==READ ? 1'b1 : 1'b0;
        i_l_a <= burst_last;
        i_v_b <= i_v_a;
        i_l_b <= i_l_a & i_v_a;
        i_v_c <= i_v_b;
        i_l_c <= i_l_b;
        i_v_d <= i_v_c;
        i_l_d <= i_l_c;
    end

always @ (posedge clk)
    if(reset) begin
        i_v_e <= 1'b0;
        i_l_e <= 1'b0;
    end else begin
        i_v_e <= i_v_d;
        i_l_e <= i_l_d;
        i_d_e <= ddr_in;
    end

assign rvalid = i_v_e;
assign rlast = i_l_e;
assign rdata = i_d_e;
assign read_accessible = 1'b1;
assign read_respdone = i_l_e;

endmodule
