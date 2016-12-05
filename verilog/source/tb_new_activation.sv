/*
 This module serves as a testbench for the activation module in activation.sv.
 It reads values from ece337_project/python/lut.pat, which are generated by
 ece337_project/python/lut.py. It is important that the values in lut.pat are
 generated with the same fixed-point scaling factor (variable "s") as used to
 generate the table in activation.sv. Note that there isn't a great reason to
 generate a clock signal in this testbench, because the design is combinational;
 it just serves to separate each test by a clock cycle.
 */

`timescale 1ns / 100ps
module tb_new_activation();
   localparam CLK_PERIOD = 10.0ns;
   localparam NUM_TESTCASES = 17'h10000;

   reg tb_clk;
   reg [15:0] tb_in, tb_out, tb_expected;
   integer    file,r;

   logic [16:0] num_passes;
   logic [16:0] num_failures;

	reg [4:0] tb_state;

   new_activation DUT (tb_in, tb_out, tb_state);

   // Clock generation
   always begin
      tb_clk = 1'b0;
      #(CLK_PERIOD / 2.0);
      tb_clk = 1'b1;
      #(CLK_PERIOD / 2.0);
   end

   initial begin : test
      for(int i = 0; i < 65500; i++) begin
			tb_in = i;
			@(posedge tb_clk);
	end
   end // block: test

endmodule // tb_activation