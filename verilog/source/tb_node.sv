// $Id: $
// File name:   tb_node.sv
// Created:     11/1/2016
// Author:      Ryan McBee
// Lab Section: 7
// Version:     1.0  Initial Design Entry
// Description: test bench for the node block

`timescale 1ns/10ps

module tb_node();

	reg tb_clk;
	reg tb_n_rst;
	reg [6:0] tb_cnt_val;
	reg [15:0] tb_coef [63:0];
	reg [15:0] tb_in_val [63:0];
	reg [2:0] tb_node_out;

	
	
	localparam CLK_PERIOD = 10ns;

	// Clock gen block
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2.0);
	end

	node DUT(.clk(tb_clk), .n_rst(tb_n_rst), .cnt_val(tb_cnt_val), .coef(tb_cnt), .in_val(tb_in_val), .node_out(tb_node_out));
	
	
		
	initial
	begin

	end


endmodule
