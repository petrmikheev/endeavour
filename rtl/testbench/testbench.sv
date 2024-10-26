`timescale 1ns/1ps

`define SIMULATION

module testbench;

  defparam system.board_ctrl.RESET_DELAY = 3;

  reg clk48mhz = 0;
  always #10.417 clk48mhz = ~clk48mhz;

  wire [2:0] leds;

  reg uart_rx = 1;
  wire uart_tx;

  wire [15:0] DDR_DQ;
  wire [1:0]  DDR_DQS;
  wire [13:0] DDR_A;
  wire [1:0]  DDR_BA;
  wire        DDR_CK;
  wire        DDR_nCK;
  wire        DDR_CKE;
  wire        DDR_nWE;
  wire        DDR_nCAS;
  wire        DDR_nRAS;
  wire [1:0]  DDR_DM;

  wire SD_CLK;
  wire SD_CMD;
  wire [3:0] SD_DATA;
  reg SD_NDETECT = 1'b1;

  pullup(SD_CMD);

  wire USB1_DP, USB1_DN, USB2_DP, USB2_DN;
  pulldown(USB1_DN);
  pullup(USB1_DP);
  pullup(USB2_DN);
  pulldown(USB2_DP);

  wire PLLA_SCL, PLLA_SDA;
  pullup(PLLA_SCL);
  pullup(PLLA_SDA);

  reg [1:0] keys = 2'b0;

  EndeavourSoc system(
    .io_clk_in(clk48mhz),
    .io_nreset(1'b1),
    .io_keys(keys),
    .io_leds(leds),
    .io_uart_rx(uart_rx),
    .io_uart_tx(uart_tx),
    .io_ddr_sdram_dq(DDR_DQ),
    .io_ddr_sdram_dqs(DDR_DQS),
    .io_ddr_sdram_a(DDR_A),
    .io_ddr_sdram_ba(DDR_BA),
    .io_ddr_sdram_ck_p(DDR_CK),
    .io_ddr_sdram_ck_n(DDR_nCK),
    .io_ddr_sdram_cke(DDR_CKE),
    .io_ddr_sdram_we_n(DDR_nWE),
    .io_ddr_sdram_cas_n(DDR_nCAS),
    .io_ddr_sdram_ras_n(DDR_nRAS),
    .io_ddr_sdram_dm(DDR_DM),
    .io_sdcard_clk(SD_CLK),
    .io_sdcard_cmd(SD_CMD),
    .io_sdcard_data(SD_DATA),
    .io_sdcard_ndetect(SD_NDETECT),
    .io_usb1_dp(USB1_DP),
    .io_usb1_dn(USB1_DN),
    .io_usb2_dp(USB2_DP),
    .io_usb2_dn(USB2_DN),
    .io_plla_i2c_scl(PLLA_SCL),
    .io_plla_i2c_sda(PLLA_SDA)
  );

  mdl_sdio #(.OPT_HIGH_CAPACITY(1'b1), .LGMEMSZ(27)) sdcard(
    .sd_clk(SD_CLK),
    .sd_cmd(SD_CMD),
    .sd_dat(SD_DATA)
  );

  // AS4C16M16D1
  micron_ddr_sdram_model #(
    .DEBUG(0),
    .BA_BITS(2),
    .ROW_BITS(14),
    .COL_BITS(10),
    .DQ_LEVEL(2)
/*    .tCK(7.5),     // tCK    ns    Nominal Clock Cycle Time
    .tDQSQ(0.4),   // tDQSQ  ns    DQS-DQ skew, DQS to last DQ valid, per group, per access
    .tMRD(10.0),   // tMRD   ns    Load Mode Register command cycle time
    // .tRAP(?),   // tRAP   ns    ACTIVE to READ with Auto precharge command
    .tRAS(40.0),   // tRAS   ns    Active to Precharge command time
    .tRC(55.0),    // tRC    ns    Active to Active/Auto Refresh command time
    .tRFC(70.0),   // tRFC   ns    Refresh to Refresh Command interval time
    .tRCD(15.0),   // tRCD   ns    Active to Read/Write command time
    .tRP(15.0),    // tRP    ns    Precharge command period
    .tRRD(10.0),   // tRRD   ns    Active bank a to Active bank b command time
    .tWR(15.0)     // tWR    ns    Write recovery time*/
  ) ram (
    .Clk(DDR_CK), .Clk_n(DDR_nCK), .Cke(DDR_CKE),
    .Cs_n(1'b0),
    .Ras_n(DDR_nRAS), .Cas_n(DDR_nCAS), .We_n(DDR_nWE),
    .Ba(DDR_BA), .Addr(DDR_A),
    .Dm(DDR_DM), .Dq(DDR_DQ), .Dqs(DDR_DQS)
  );

  wire         ram_int_a_fire   = testbench.system.internalRam_thread_logic.io_up_a_fire;
  wire [31:0]  ram_int_a_addr   = testbench.system.internalRam_thread_logic.io_up_a_payload_address;
  wire [127:0] ram_int_a_opcode = testbench.system.internalRam_thread_logic.io_up_a_payload_opcode_string;
  wire         ram_int_d_fire   = testbench.system.internalRam_thread_logic.io_up_d_ready & testbench.system.internalRam_thread_logic.io_up_d_valid;

  wire         ram_ext_a_fire   = testbench.system.toAxi4_logic_bridge.io_up_a_fire;
  wire [31:0]  ram_ext_a_addr   = testbench.system.toAxi4_logic_bridge.io_up_a_payload_address;
  wire [127:0] ram_ext_a_opcode = testbench.system.toAxi4_logic_bridge.io_up_a_payload_opcode_string;
  wire         ram_ext_d_fire   = testbench.system.toAxi4_logic_bridge.io_up_d_fire;

  wire [26:0]  apb_addr   = testbench.system.toApb_logic_bridge.io_down_PADDR;
  wire         apb_en_sel = testbench.system.toApb_logic_bridge.io_down_PENABLE & testbench.system.toApb_logic_bridge.io_down_PSEL;
  wire         apb_ready  = testbench.system.toApb_logic_bridge.io_down_PREADY;
  wire         apb_write  = testbench.system.toApb_logic_bridge.io_down_PWRITE;
  wire [31:0]  apb_rdata  = testbench.system.toApb_logic_bridge.io_down_PRDATA;
  wire [31:0]  apb_wdata  = testbench.system.toApb_logic_bridge.io_down_PWDATA;

  wire [31:0] cpu_aligner_pc = testbench.system.vexiiRiscv_1.AlignerPlugin_logic_buffer_pc;
  wire [63:0] cpu_aligner_instr = testbench.system.vexiiRiscv_1.AlignerPlugin_logic_buffer_data;

  wire cpu_clk = testbench.system.board_ctrl.clk_cpu;
  wire [31:0] cpu_pc = testbench.system.vexiiRiscv_1.PcPlugin_logic_harts_0_output_payload_pc;
  wire cpu_pc_ready = testbench.system.vexiiRiscv_1.PcPlugin_logic_harts_0_output_ready;
  wire cpu_pc_valid = testbench.system.vexiiRiscv_1.PcPlugin_logic_harts_0_output_valid;
  wire cpu_pc_fire = testbench.system.vexiiRiscv_1.PcPlugin_logic_harts_0_output_fire;

`define REGFILE0 testbench.system.vexiiRiscv_1.integer_RegFilePlugin_logic_regfile_fpga.ramSyncMwMux_1.ram_0
`define REGFILE1 testbench.system.vexiiRiscv_1.integer_RegFilePlugin_logic_regfile_fpga.ramSyncMwMux_1.ram_1
`define REGFILE(i) testbench.system.vexiiRiscv_1.integer_RegFilePlugin_logic_regfile_fpga.ramSyncMwMux_1.location.ram_``i ? `REGFILE1[i] : `REGFILE0[i]
`define REGFILE_FLOAT(i) testbench.system.vexiiRiscv_1.float_RegFilePlugin_logic_regfile_fpga.asMem_ram[i]

  wire [31:0] reg01_ra = `REGFILE(1);
  wire [31:0] reg02_sp = `REGFILE(2);
  wire [31:0] reg03_gp = `REGFILE(3);
  wire [31:0] reg04_tp = `REGFILE(4);
  wire [31:0] reg05_t0 = `REGFILE(5);
  wire [31:0] reg06_t1 = `REGFILE(6);
  wire [31:0] reg07_t2 = `REGFILE(7);
  wire [31:0] reg08_s0 = `REGFILE(8);
  wire [31:0] reg09_s1 = `REGFILE(9);
  wire [31:0] reg10_a0 = `REGFILE(10);
  wire [31:0] reg11_a1 = `REGFILE(11);
  wire [31:0] reg12_a2 = `REGFILE(12);
  wire [31:0] reg13_a3 = `REGFILE(13);
  wire [31:0] reg14_a4 = `REGFILE(14);
  wire [31:0] reg15_a5 = `REGFILE(15);
  wire [31:0] reg16_a6 = `REGFILE(16);
  wire [31:0] reg17_a7 = `REGFILE(17);
  wire [31:0] reg18_s2 = `REGFILE(18);
  wire [31:0] reg19_s3 = `REGFILE(19);
  wire [31:0] reg20_s4 = `REGFILE(20);
  wire [31:0] reg21_s5 = `REGFILE(21);
  wire [31:0] reg22_s6 = `REGFILE(22);
  wire [31:0] reg23_s7 = `REGFILE(23);
  wire [31:0] reg24_s8 = `REGFILE(24);
  wire [31:0] reg25_s9 = `REGFILE(25);
  wire [31:0] reg26_s10 = `REGFILE(26);
  wire [31:0] reg27_s11 = `REGFILE(27);
  wire [31:0] reg28_t3 = `REGFILE(28);
  wire [31:0] reg29_t4 = `REGFILE(29);
  wire [31:0] reg30_t5 = `REGFILE(30);
  wire [31:0] reg31_t6 = `REGFILE(31);

  initial begin
    $dumpfile("dump.vcd");
    if ($test$plusargs("dump_all"))
      $dumpvars(0, testbench);
    else
      $dumpvars(1, testbench);

    #100000000;
    $finish;
  end

  // Initialize sdcard content
  integer sdcard_file;
  reg [511:0] sdcard_file_path;
  initial begin
    if ($value$plusargs("sdcard=%s", sdcard_file_path)) begin
      SD_NDETECT = 1'b0;
      sdcard_file = $fopen(sdcard_file_path, "rb");
      if (!$fread(sdcard.mem, sdcard_file)) $display("Sdcard content initialization failed");
    end
  end

  // Initialize RAM content
  integer ram_file;
  reg [511:0] ram_file_path;
  integer ram_offset = 0;
  initial begin
    if ($test$plusargs("memtest"))
      keys[0] = 0;
    else
      keys[0] = 1;

    if ($value$plusargs("ram_fill_size=%x", ram_offset)) begin
      ram_offset = ram_offset / 2 - 1;
      while (ram_offset >= 0) begin
        ram.mem_array[ram_offset] = 16'hABCD;
        ram_offset = ram_offset - 1;
      end
    end

    if ($value$plusargs("ram=%s", ram_file_path)) begin
      if (!$value$plusargs("ram_offset=%x", ram_offset))
        ram_offset = 0;
      ram_offset = ram_offset / 2;
      ram_file = $fopen(ram_file_path, "rb");
      while (!$feof(ram_file)) begin
        ram.mem_array[ram_offset + 1][7:0] = $fgetc(ram_file);
        ram.mem_array[ram_offset + 1][15:8] = $fgetc(ram_file);
        ram.mem_array[ram_offset][7:0] = $fgetc(ram_file);
        ram.mem_array[ram_offset][15:8] = $fgetc(ram_file);
        ram_offset = ram_offset + 2;
      end
    end
  end

  // Send uart
  integer uart_send_count = 0;
  integer uart_file = -1;
  integer uart_i;
  reg [511:0] uart_file_path;
  initial begin
    if ($value$plusargs("uart=%s", uart_file_path))
      uart_file = $fopen(uart_file_path, "rb");
  end

  reg [7:0] uart_byte;
  parameter UART_BAUD_RATE = 16_000_000;
  localparam UART_BIT_TIME = 1_000_000_000.0 / UART_BAUD_RATE;
  initial begin
    #400000;
    while (uart_file != -1 && !$feof(uart_file)) begin
      uart_byte = $fgetc(uart_file);
      if (!$feof(uart_file)) begin
        uart_send_count = uart_send_count + 1;
        #UART_BIT_TIME;
        uart_rx = 0; #UART_BIT_TIME;
        for (uart_i = 0; uart_i < 8; uart_i = uart_i + 1) begin
          uart_rx = uart_byte[uart_i]; #UART_BIT_TIME;
        end
        uart_rx = ^uart_byte;
        // if (uart_send_count == 40) uart_rx = ~uart_rx;  // simulate parity error
        #UART_BIT_TIME;  // parity bit
        /*if (uart_send_count == 57) begin  // simulate framing error
          uart_rx = 0;
          #(UART_BIT_TIME*2/3);
        end*/
        uart_rx = 1; #UART_BIT_TIME;
      end
    end
  end

endmodule
