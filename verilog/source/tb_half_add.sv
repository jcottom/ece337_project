`timescale 1ns / 100ps
module tb_half_add ();

   reg [15:0] tb_a;
   reg [15:0] tb_b;
   wire [15:0] tb_out;
   logic [7:0] ind;
   reg         clk;
   reg         nrst;

   half_add DUT (clk, nrst, tb_a, tb_b, tb_out); 

   always begin
      #5 clk = 0;
      #5 clk = 1;
   end

   initial begin
      //         seeeeemmmmmmmmmm
      tb_a = 16'b0011111010000000; // 1.00
      tb_b = 16'b0100001010000000; // 2.00
      #5;
   end

endmodule // int_to_float
