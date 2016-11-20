// $Id: $
// File name:   tb_input_node_timer.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: input node timer test bench

`timescale 1ns / 100ps

module tb_input_node_timer
();		
	localparam CLK_PERIOD = 10.0ns;	

	//test bench values
	reg tb_clk; 
	reg tb_n_rst;
	reg [6:0] tb_coef_select;
	reg tb_n_coef_image;
	reg tb_start_sram;
	reg tb_read_nxt_byte;
	reg tb_sram_done;
	
	// Clock gen block
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2.0);
	end

	
	task test_expected_values;

	//input n_start_done;
	//input [6:0] input_num;

	begin
		
	end
	endtask	
	

	// Test bench process
	initial
	begin		
			


	$display("Done testing");

	end

endmodule
