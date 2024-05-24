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
  pulldown(USB1_DP);
  pullup(USB1_DN);
  pulldown(USB2_DP);
  pulldown(USB2_DN);

  EndeavourSoc system(
    .io_clk_in(clk48mhz),
    .io_nreset(1'b1),
    .io_keys(2'b0),
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
    .io_usb2_dn(USB2_DN)
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

  wire [31:0] pc_decode = testbench.system.vexRiscv_1.decode_PC;
  wire [31:0] instr_decode = testbench.system.vexRiscv_1.decode_INSTRUCTION;
  wire [31:0] instr_execute = testbench.system.vexRiscv_1.execute_INSTRUCTION;
  wire [31:0] instr_memory = testbench.system.vexRiscv_1.memory_INSTRUCTION;
  wire [31:0] instr_writeBack = testbench.system.vexRiscv_1.writeBack_INSTRUCTION;

  wire [31:0] reg01_ra = testbench.system.vexRiscv_1.RegFilePlugin_regFile[1];
  wire [31:0] reg02_sp = testbench.system.vexRiscv_1.RegFilePlugin_regFile[2];
  wire [31:0] reg03_gp = testbench.system.vexRiscv_1.RegFilePlugin_regFile[3];
  wire [31:0] reg04_tp = testbench.system.vexRiscv_1.RegFilePlugin_regFile[4];
  wire [31:0] reg05_t0 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[5];
  wire [31:0] reg06_t1 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[6];
  wire [31:0] reg07_t2 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[7];
  wire [31:0] reg08_s0 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[8];
  wire [31:0] reg09_s1 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[9];
  wire [31:0] reg10_a0 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[10];
  wire [31:0] reg11_a1 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[11];
  wire [31:0] reg12_a2 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[12];
  wire [31:0] reg13_a3 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[13];
  wire [31:0] reg14_a4 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[14];
  wire [31:0] reg15_a5 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[15];
  wire [31:0] reg16_a6 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[16];
  wire [31:0] reg17_a7 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[17];
  wire [31:0] reg18_s2 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[18];
  wire [31:0] reg19_s3 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[19];
  wire [31:0] reg20_s4 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[20];
  wire [31:0] reg21_s5 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[21];
  wire [31:0] reg22_s6 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[22];
  wire [31:0] reg23_s7 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[23];
  wire [31:0] reg24_s8 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[24];
  wire [31:0] reg25_s9 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[25];
  wire [31:0] reg26_s10 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[26];
  wire [31:0] reg27_s11 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[27];
  wire [31:0] reg28_t3 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[28];
  wire [31:0] reg29_t4 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[29];
  wire [31:0] reg30_t5 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[30];
  wire [31:0] reg31_t6 = testbench.system.vexRiscv_1.RegFilePlugin_regFile[31];

  initial begin
    $dumpfile("dump.vcd");
    if ($test$plusargs("dump_all"))
      $dumpvars(0, testbench);
    else
      $dumpvars(1, testbench);

    #10000000;
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
      uart_send_count = uart_send_count + 1;
      #UART_BIT_TIME;
      uart_rx = 0; #UART_BIT_TIME;
      uart_byte = $fgetc(uart_file);
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

endmodule
