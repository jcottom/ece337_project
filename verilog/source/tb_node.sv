// $Id: $
// File name:   tb_node.sv
// Created:     11/21/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test bench for node

`timescale 1ns / 100ps


module tb_node ();

	localparam PERIOD = 10.0ns
	localparam DELAY = 2.0ns

	reg tb_clk;
	reg tb_n_rst;
	reg tb_start;
	reg tb_reset_acc;
	reg [6:0] tb_cnt_val [63:0];
	reg [15:0] tb_coef [63:0];
	reg [15:0] tb_data_in [63:0];
	reg [2:0] tb_node_out;

	integer i, j;

	node DUT(.clk(tb_clk), .n_rst(tb_n_rst), .start(tb_start), .reset_acc(tb_reset_acc), .cnt_val(tb_cnt_val), .coef(tb_coef), .data_in(tb_data_in), .node_out(tb_node_out));

	always begin
		tb_clk = 1'b0;
		#(PERIOD / 2)
		tb_clk = 1'b1;
		#(PERIOD / 2)
	end 

	initial begin

		//Initialize random values for cnt_val, data_in, and coef
		for (i = 0; i <= 6; i = i + 1) begin
			tb_cnt_val[i] = {$random} * 2; // Only positive integers for cnt_val
		end
		
		for (j = 0; j <= 15; j = j + 1) begin
			tb_data_in[j] = $random * 2;
			tb_coef[j] = $random * 2;
		end

		//GOLD standard for determining expected output

		//Tets n_rst
		//Test Rest of accumulator


	end

endmodule
