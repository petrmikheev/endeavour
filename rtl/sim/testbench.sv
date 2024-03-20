`timescale 1 ns/ 1 ps

module testbench;

  reg clk100mhz = 0;
  always #5 clk100mhz = ~clk100mhz;

  wire [2:0] leds;
  reg [2:0] keys = 3'b0;
  
  reg uart_rx = 1;
  
  Endeavour system(
    .clk100mhz(clk100mhz),
    .keys(keys),
    .leds(leds),
    .uart_rx(uart_rx)
  );
  
  integer i;
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, testbench);
    for (i = 0; i < 32; i = i + 1) $dumpvars(0, testbench.system.core.cpu.RegFilePlugin_regFile[i]);
    
    #1000000;
    $finish;
  end

  //integer serial_file = $fopen("PATH_TO_SERIAL_IN", "rb");
  /*reg [7:0] serial_byte = 8'd83;
  integer k;
  initial begin
        #100000;
        while (1) begin //(!$feof(serial_file)) begin
              #9168;
              uart_rx = 0; #9168;

              //serial_byte = $fgetc(serial_file);
              for (k=0; k<8; k=k+1) begin
                    uart_rx = serial_byte[k]; #9168;
              end

              uart_rx = 1; #9168;
        end
  end*/

endmodule

`ifdef IVERILOG

module PLL(input inclk0, output reg c0);
  assign c0 = inclk0;
  /*initial c0 = 0;
  always #11 c0 = ~c0;  // 45.45mhz instead of 48mhz*/
endmodule

`endif
