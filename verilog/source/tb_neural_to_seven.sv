// $Id: $
// File name:   tb_timer.sv
// Created:     10/7/2016
// Author:      Taylor Lipson
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: test bench for the timer module for the usb receiver

`timescale 1ns / 100ps

module tb_neural_to_seven
();
	// Define parameters
	// basic test bench parameters
	localparam	P	= 2.5; //clock period
	//localparam	CHECK_DELAY = 1; // Check 1ns after the rising edge to allow for propagation delay
	localparam num_bits = 4;
	// Shared Test Variables
	reg tb_clk = 0;

	// Clock generation block
	always #(P / 2) tb_clk++;
	
    	reg [15:0] tb_neural_out[9:0];
    	reg [7:0] tb_seven_seg;
	
   	integer tb_test_num = 0;
	integer k = 0;


	neural_to_seven TEST1 
	(
		.neural_out(tb_neural_out),
    		.seven_seg(tb_seven_seg)
	 );

    initial begin
	//initialize
	@(negedge tb_clk);	//8x8 testcase 1 out
	tb_neural_out[0] = 16'b0000011111110010;	//0000 0111 1111 0010
	tb_neural_out[1] = 16'b0000000110111011;
	tb_neural_out[2] = 16'b0000000010111111;
	tb_neural_out[3] = 16'b0000000111010111;
	tb_neural_out[4] = 16'b0000000001100101;
	tb_neural_out[5] = 16'b0000001000001000;
	tb_neural_out[6] = 16'b0000000000011010;
	tb_neural_out[7] = 16'b0000000000110111;
	tb_neural_out[8] = 16'b0000000000011111;
	tb_neural_out[9] = 16'b0000000000010111;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);	//8x8 testcase 2 out
	tb_neural_out[0] = 16'b0000000011000101;	
	tb_neural_out[1] = 16'b0000000000101111;
	tb_neural_out[2] = 16'b0000000100000100;
	tb_neural_out[3] = 16'b0000000000011000;
	tb_neural_out[4] = 16'b0000111100100110;
	tb_neural_out[5] = 16'b0000000000010010;
	tb_neural_out[6] = 16'b0000000000100110;
	tb_neural_out[7] = 16'b0000000001011100;
	tb_neural_out[8] = 16'b0000000000101010;
	tb_neural_out[9] = 16'b0000000011101001;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_neural_out[0] = 16'b0000000111110010;	
	tb_neural_out[1] = 16'b0000000110111011;
	tb_neural_out[2] = 16'b0000000010111111;
	tb_neural_out[3] = 16'b0000000111010111;
	tb_neural_out[4] = 16'b0000000001100101;
	tb_neural_out[5] = 16'b0000001000001000;
	tb_neural_out[6] = 16'b0000000000011010;
	tb_neural_out[7] = 16'b0000000000110111;
	tb_neural_out[8] = 16'b0000000000011111;
	tb_neural_out[9] = 16'b0000000000010111;
	@(negedge tb_clk);


    end
endmodule