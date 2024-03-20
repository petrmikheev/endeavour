module UART (
  input reset, input clk,
  input rx, output reg tx,
  input sel_receiver, input sel_transmitter, input sel_divisor,
  input apb_enable, input apb_write,
  input [31:0] apb_wdata,
  output [31:0] apb_rdata
);

  reg selbuf_divisor;
  reg selbuf_receiver;
  reg selbuf_transmitter;

  reg [15:0] divisor;

  reg write_buf_empty;
  reg read_buf_empty;
  reg [7:0] read_buf;

  reg [3:0] read_bit_num = '0;
  reg [15:0] read_state = '0;
  reg [7:0] read_data = '0;
  reg [3:0] write_bit_num = '0;
  reg [15:0] write_state = '0;
  reg [7:0] write_data = '0;
  
  assign apb_rdata = selbuf_divisor  ? {16'b0, divisor} :
                     selbuf_receiver ? {read_buf_empty, 23'b0, read_buf} :
                                       {write_buf_empty, 31'b0};

  always @(posedge clk) begin
    if (reset) begin
      divisor <= 16'd9;
      selbuf_divisor <= 0;
      selbuf_receiver <= 0;
      selbuf_transmitter <= 0;
      
      read_buf_empty <= 1;
      write_buf_empty <= 1;
      
      read_bit_num <= '0;
      read_state <= '0;
      write_bit_num <= '0;
      write_state <= '0;
      
      tx <= 1;
    end else begin

      // apb interface
      selbuf_divisor <= sel_divisor;
      selbuf_receiver <= sel_receiver;
      selbuf_transmitter <= sel_transmitter;
      if (selbuf_divisor) begin
        if (apb_write & apb_enable) divisor <= apb_wdata[15:0];
      end else if (selbuf_receiver) begin
        if (apb_enable) read_buf_empty <= 1;
      end else if (selbuf_transmitter) begin
        if (apb_write & apb_enable & write_buf_empty) begin
          write_buf_empty <= 0;
          write_data <= apb_wdata[7:0];
        end
      end
    
      // receive
      if (|read_bit_num) begin
        if (|read_state)
          read_state <= read_state - 1'b1;
        else begin
          read_bit_num <= read_bit_num - 1'b1;
          read_data <= {rx, read_data[7:1]};
          if ((read_bit_num == 1'b1) & rx) begin
            read_buf_empty <= 0;
            read_buf <= read_data;
          end else read_state <= divisor;
        end
      end else begin
        if (read_state == '0 & ~rx)
          read_state[14:0] <= {divisor[15:2], 1'b1};
        else if ((read_state == 1'b1) & ~rx) begin
          read_state <= divisor;
          read_bit_num <= 4'd9;
        end else if (|read_state)
          read_state <= read_state - 1'b1;
      end
      
      // transmit
      if (|write_state) write_state <= write_state - 1'b1;
      else begin
        if (|write_bit_num) begin
          write_bit_num <= write_bit_num - 1'b1;
          {write_data, tx} <= {1'b1, write_data};
          write_state <= divisor;
          if (write_bit_num == 1'b1) write_buf_empty <= 1;
        end else if (~write_buf_empty) begin
          tx <= 0;
          write_state <= divisor;
          write_bit_num <= 4'd9;
`ifdef IVERILOG
  $write("%c", write_data);
`endif
        end else tx <= 1;
      end

    end
  end

endmodule