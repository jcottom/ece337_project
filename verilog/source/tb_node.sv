// $Id: $
// File name:   tb_node.sv
// Created:     11/21/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for node

`timescale 1ns / 100ps


module tb_node ();
	
	//test bench variable
	localparam PERIOD = 10.0ns;
	localparam DELAY = 5.0ns;


	reg tb_clk;
	reg tb_n_rst;
	reg tb_start;
	reg tb_reset_acc;
	reg [6:0] tb_cnt_val;
	reg [15:0] tb_coef [15:0];
	reg [15:0] tb_data_in [63:0];
	reg [15:0] tb_node_out;

	integer i, j;

	always begin
		tb_clk = 1'b0;
		#(PERIOD / 2);
		tb_clk = 1'b1;
		#(PERIOD / 2);
	end 

	node DUT (.clk(tb_clk), .n_rst(tb_n_rst), .start(tb_start), .reset_acc(tb_reset_acc), .cnt_val(tb_cnt_val), .coef(tb_coef), .data_in(tb_data_in), .node_out(tb_node_out));

	initial begin

		//Initialize variables
		tb_clk = 'b0;
		tb_n_rst = 'b0;
		tb_start = 'b0;
		tb_reset_acc = 'b0;
		tb_cnt_val = 'b0;
		for (i = 0; i < 16; i = i + 1) begin
			tb_coef[i] = 16'b0;
		end 
		for (j = 0; j < 64; j = j + 1) begin
			tb_data_in[j] = 16'b0;
		end 

		#(PERIOD * 5);

		//TEST 0: n_rst

		assert(tb_node_out == 0) 
			$info("Test 0: Complete");
		else 
			$error("Test 0: Unable to reset node_out");
		
		//TEST 1: Check node output
		tb_cnt_val = 0;
		tb_data_in[0] = 'b1;
		tb_start = 0;
		tb_reset_acc = 0;

		#(PERIOD * 5);

		assert(tb_node_out == 16'h0000)
			$info("Test 1: Complete");
		else 
			$error("Test 1: INCORRECT node output");

		#(DELAY);

		//Test 2: Check start
		tb_cnt_val = 1;
		tb_data_in[tb_cnt_val] = 16'h0004;
		tb_coef[tb_cnt_val] = 16'h0001;
		tb_start = 1;
		
		#(PERIOD * 5);
		
		assert(tb_node_out == 16'h00A4)
			$info("Test 2: Complete");
		else 
			$error("Test 2: INCORRECT output for start = 1");

		//TEST 3: Check accumulator
		#(DELAY);
		tb_start = 0;
		tb_cnt_val = 1;
		tb_data_in[tb_cnt_val] = 16'h0004;
		tb_coef[tb_cnt_val] = 16'h0001;

		#(PERIOD * 5);
		assert(tb_node_out == 16'h00A3)
			$info("Test 3: Complete");
		else 
			$error("Test 3: INCORRECT output for accumulator");
		
		

	end

endmodule
