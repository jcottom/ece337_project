// $Id: $
// File name:   tb_top_ann.sv
// Created:     12/7/2016
// Author:      Taylor Lipson
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: test bench for ANN implementation with SRAM, only works on fpga


`timescale 1ns / 100ps

module tb_top_ann
();		
	/*parameter  IMAGE_FILE   = "../python/testcases8x8/t4in_fixbin.txt";
	parameter  COEF_FILE    = "../python/shapeWeights8x8_bin.txt";	
	int image_file;
	int coef_file;*/

	parameter IMAGE_SIZE = 64;

	localparam CLK_PERIOD = 30.0ns;	

	//test bench values
	reg tb_clk; 
	reg tb_n_rst;


	reg tb_done_processing;
	reg tb_start_detecting;
	reg [7:0] tb_seven_seg;
	reg [9:0] tb_image_address,

top_ann NN 
(
	.clk(tb_clk),
	.n_reset(tb_n_rst),
	.start_detecting(tb_start_detecting),
	.image_address(tb_image_address),
	.seven_seg(tb_seven_seg),
	.done_processing(tb_done_processing)
);

	// Clock gen block
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2.0);
	end
	
	task reset;
	begin
		//test reset
		tb_n_rst = 1; #1;		
		tb_n_rst = 0; #1;
		tb_n_rst = 1; #1;
	end
	endtask


	

	// Test bench process
	initial
	begin	
		
	
		reset();
		@(negedge tb_clk);
		tb_image_address = 0;
		tb_start_detecting = 1;
		@(negedge tb_clk);
		tb_start_detecting = 0;
		

				
	
	end

endmodule
