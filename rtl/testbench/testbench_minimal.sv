`timescale 1ns/1ps

module testbench;

  defparam system.board_ctrl.RESET_DELAY = 3;

  reg clk48mhz = 0;
  always #10.417 clk48mhz = ~clk48mhz;

  wire [2:0] leds;

  reg uart_rx = 1;
  wire uart_tx;

  wire PLLA_SCL, PLLA_SDA, AUDIO_SCL, AUDIO_SDA;
  pullup(PLLA_SCL);
  pullup(PLLA_SDA);
  pullup(AUDIO_SCL);
  pullup(AUDIO_SDA);

  reg [1:0] keys = 2'b10;

  EndeavourMinimalSoc system(
    .io_clk_in(clk48mhz),
    .io_nreset(1'b1),
    .io_keys(keys),
    .io_leds(leds),
    .io_plla_i2c_scl(PLLA_SCL),
    .io_plla_i2c_sda(PLLA_SDA),
    //.io_audio_i2c_scl(AUDIO_SCL),
    //.io_audio_i2c_sda(AUDIO_SDA),
    .io_uart_rx(uart_rx),
    .io_uart_tx(uart_tx)
  );

  wire cpu_clk = testbench.system.board_ctrl.clk_cpu;
  wire [31:0] cpu_pc = testbench.system.vexiiRiscv_1.PcPlugin_logic_harts_0_output_payload_pc;
  wire cpu_pc_ready = testbench.system.vexiiRiscv_1.PcPlugin_logic_harts_0_output_ready;
  wire cpu_pc_valid = testbench.system.vexiiRiscv_1.PcPlugin_logic_harts_0_output_valid;
  wire cpu_pc_fire = testbench.system.vexiiRiscv_1.PcPlugin_logic_harts_0_output_fire;

`define REGFILE(i) testbench.system.vexiiRiscv_1.integer_RegFilePlugin_logic_regfile_fpga.asMem_ram[i]

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
    $dumpfile("dump_minimal.vcd");
    if ($test$plusargs("dump_all"))
      $dumpvars(0, testbench);
    else
      $dumpvars(1, testbench);

    #100000000;
    $finish;
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
