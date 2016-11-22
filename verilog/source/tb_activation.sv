`timescale 1ns / 100ps
module tb_activation();
   localparam CLK_PERIOD = 10.0ns;

   reg tb_clk;
   reg [15:0] tb_in, tb_out, tb_expected;
   integer    file,r;

   activation DUT (tb_in, tb_out);

   // Clock generation
   always begin
      tb_clk = 1'b0;
      #(CLK_PERIOD / 2.0);
      tb_clk = 1'b1;
      #(CLK_PERIOD / 2.0);
   end

   initial begin : test
      file = $fopen("../python/lut.pat", "r");
      if(!file) disable test;

      while (!$feof(file)) begin
         // Wait until start of clock cycle
         @(posedge tb_clk);

         // Read in test input and expected output
         r = $fscanf(file, "%b %b\n", tb_in, tb_expected);

         // Wait half a clock cycle
         #(CLK_PERIOD/2)

         // Assert output
         assert(tb_out == tb_expected);
      end // while (!$feof(file))
   end // block: test

endmodule // tb_activation
