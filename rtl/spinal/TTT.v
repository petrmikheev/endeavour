// Generator : SpinalHDL dev    git head : fc89224e30e9122905da5b706fd5d1ee02332489
// Component : TTT
// Git hash  : ec5077a24cb9cfbe63a7ad234ada600049abf918

`timescale 1ns/1ps

module TTT (
  input  wire          io_a,
  output wire          io_b
);


  assign io_b = (! io_a);

endmodule
