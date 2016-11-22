// $Id: $
// File name:   tb_input_node_timer.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: input node timer test bench

`timescale 1ns / 100ps

module tb_ANN
();		
	localparam CLK_PERIOD = 10.0ns;	

	//test bench values
	reg tb_clk; 
	reg tb_n_rst;
	reg tb_image_weights_loaded;
   	reg tb_n_start_done;
	reg tb_done_processing;
	reg tb_request_coef;
	reg tb_coef_select;
	reg [7:0] tb_seven_seg;

	
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
		
	
	end

endmodule
