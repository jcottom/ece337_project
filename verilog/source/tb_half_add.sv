`timescale 1ns / 100ps
module tb_half_add ();

   reg         tb_enable;
   reg [15:0]  tb_a;
   reg [15:0]  tb_b;
   wire [15:0] tb_out;
   reg         clk;
   reg         nrst;

   half_add DUT (clk, nrst, tb_enable, tb_a, tb_b, tb_out); 

   logic [7:0] ind;
   reg [15:0]  tb_expected;

   always begin
      #5 clk = 0;
      #5 clk = 1;
   end

   initial begin
      tb_enable = 0;
      # 25
      tb_enable = 1;
      // 1 + 2 = 3
      //                seeeeemmmmmmmmmm
      tb_expected = 16'b0100001000000000; // 3.00
      tb_a        = 16'b0011110000000000; // 1.00
      tb_b        = 16'b0100000000000000; // 2.00
      #25;
      assert(tb_expected == tb_out);

      // 0 + 2 = 2
      //                seeeeemmmmmmmmmm
      tb_expected = 16'b0100000000000000; // 2.00
      tb_a        = 16'b0000000000000000; // 0.00
      tb_b        = 16'b0100000000000000; // 2.00
      #25;
      Kassert(tb_expected == tb_out);

      // 1 + 0 = 1
      //                seeeeemmmmmmmmmm
      tb_expected = 16'b0011110000000000; // 1.00
      tb_a        = 16'b0011110000000000; // 1.00
      tb_b        = 16'b0000000000000000; // 0.00
      #25;
      assert(tb_expected == tb_out);

   end

endmodule // int_to_float

