`timescale 1ns/1ps

`define SIMULATION

module testbench;

  parameter CPU_FREQ = 96_000_000;
  parameter UART_BAUD_RATE = 16_000_000;

  defparam system.clocks.RESET_DELAY = 3;
  defparam system.uart_ctrl.OVERRIDE_DIVISOR = CPU_FREQ / UART_BAUD_RATE - 1;

  reg clk100mhz = 0;
  always #5 clk100mhz = ~clk100mhz;

  //wire [2:0] leds;
  //reg [2:0] keys = 3'b110;
  
  reg uart_rx = 1;
  wire uart_tx;
  
  /*wire [15:0] DDR_DQ;
  wire [1:0]  DDR_DQS;
  wire [12:0] DDR_A;
  wire [1:0]  DDR_BA;
  wire [3:0]  DDR_nCS;
  wire        DDR_CK;
  wire        DDR_nCK;
  wire        DDR_CKE;
  wire        DDR_nWE;
  wire        DDR_nCAS;
  wire        DDR_nRAS;
  wire [1:0]  DDR_DM;*/

  wire SD_CLK;
  wire SD_CMD;
  wire [3:0] SD_DATA;

  pullup(SD_CMD);

  EndeavourSoc system(
    .io_clk100mhz(clk100mhz),
    .io_nreset(1'b1),
    //.keys(keys),
    //.leds(leds),
    .io_uart_rx(uart_rx),
    .io_uart_tx(uart_tx),
    /*.DDR_DQ(DDR_DQ),
    .DDR_DQS(DDR_DQS),
    .DDR_A(DDR_A),
    .DDR_BA(DDR_BA),
    .DDR_nCS(DDR_nCS),
    .DDR_CK(DDR_CK),
    .DDR_nCK(DDR_nCK),
    .DDR_CKE(DDR_CKE),
    .DDR_nWE(DDR_nWE),
    .DDR_nCAS(DDR_nCAS),
    .DDR_nRAS(DDR_nRAS),
    .DDR_DM(DDR_DM)*/
    .io_sdcard_clk(SD_CLK),
    .io_sdcard_cmd(SD_CMD),
    .io_sdcard_data(SD_DATA)
  );

  mdl_sdio sdcard(
    .sd_clk(SD_CLK),
    .sd_cmd(SD_CMD),
    .sd_dat(SD_DATA)
  );

  // AS4C32M16D1A
  /*micron_ddr_sdram_model #(
    .DEBUG(0),
    .BA_BITS(2),
    .ROW_BITS(13),
    .COL_BITS(10),
    .DQ_LEVEL(2)*/
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
  /*) ram (
    .Clk(DDR_CK), .Clk_n(DDR_nCK), .Cke(DDR_CKE),
    .Cs_n(DDR_nCS[3]),
    .Ras_n(DDR_nRAS), .Cas_n(DDR_nCAS), .We_n(DDR_nWE),
    .Ba(DDR_BA), .Addr(DDR_A),
    .Dm(DDR_DM), .Dq(DDR_DQ), .Dqs(DDR_DQS)
  );*/

  integer i;
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
    // cpu registers
    //for (i = 1; i < 32; i = i + 1) $dumpvars(1, testbench.system.core.cpu.RegFilePlugin_regFile[i]);
    //for (i = 0; i < 32; i = i + 1) $dumpvars(1, testbench.sdcard.mem[i], testbench.sdcard.mem_buf[i]);
    /*$dumpvars(1,
        // cpu instruction
        testbench.system.core.cpu.decode_PC,
        testbench.system.core.cpu.decode_INSTRUCTION,
        testbench.system.core.cpu.execute_INSTRUCTION,
        testbench.system.core.cpu.memory_INSTRUCTION,
        testbench.system.core.cpu.writeBack_INSTRUCTION,
        // cpu io
        testbench.system.core.cpu.dBus_cmd_valid,
        testbench.system.core.cpu.dBus_cmd_ready,
        testbench.system.core.cpu.dBus_cmd_payload_wr,
        testbench.system.core.cpu.dBus_cmd_payload_uncached,
        testbench.system.core.cpu.dBus_cmd_payload_address,
        testbench.system.core.cpu.dBus_cmd_payload_data,
        testbench.system.core.cpu.dBus_cmd_payload_mask,
        testbench.system.core.cpu.dBus_cmd_payload_size,
        testbench.system.core.cpu.dBus_cmd_payload_last,
        testbench.system.core.cpu.dBus_rsp_valid,
        testbench.system.core.cpu.dBus_rsp_payload_last,
        testbench.system.core.cpu.dBus_rsp_payload_data,
        testbench.system.core.cpu.dBus_rsp_payload_error,
        testbench.system.core.cpu.timerInterrupt,
        testbench.system.core.cpu.externalInterrupt,
        testbench.system.core.cpu.softwareInterrupt,
        testbench.system.core.cpu.iBus_cmd_valid,
        testbench.system.core.cpu.iBus_cmd_ready,
        testbench.system.core.cpu.iBus_cmd_payload_address,
        testbench.system.core.cpu.iBus_cmd_payload_size,
        testbench.system.core.cpu.iBus_rsp_valid,
        testbench.system.core.cpu.iBus_rsp_payload_data,
        testbench.system.core.cpu.iBus_rsp_payload_error,*/
        // ram
        /*testbench.system.ram_ctrl.ddr_in,
        testbench.system.ram_ctrl.ddr_out,
        testbench.system.ram_ctrl.stat*/
        //testbench.system.ram_ctrl
    //);

    #1000000;
    $finish;
  end
  integer uart_send_count = 0;
  integer uart_file = -1;
  reg [511:0] uart_file_path;
  initial begin
    if ($value$plusargs("uart_send=%s", uart_file_path))
      uart_file = $fopen(uart_file_path, "rb");
  end

  reg [7:0] uart_byte;
  localparam UART_BIT_TIME = 1_000_000_000.0 / UART_BAUD_RATE;
  initial begin
    #100000;
    while (uart_file != -1 && !$feof(uart_file)) begin
      uart_send_count = uart_send_count + 1;
      #UART_BIT_TIME;
      uart_rx = 0; #UART_BIT_TIME;
      uart_byte = $fgetc(uart_file);
      for (i = 0; i < 8; i = i + 1) begin
        uart_rx = uart_byte[i]; #UART_BIT_TIME;
      end
      uart_rx = ^uart_byte; #UART_BIT_TIME;  // parity bit
      /*if (uart_send_count == 57) begin  // simulate framing error
        uart_rx = 0;
        #(UART_BIT_TIME*2/3);
      end*/
      uart_rx = 1; #UART_BIT_TIME;
    end
  end

endmodule
