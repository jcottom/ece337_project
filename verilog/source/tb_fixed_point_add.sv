// $Id: $
// File name:   fixed_point_add.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: tb_fixed point addition test bench

`timescale 1ns / 100ps

module tb_fixed_point_add
();		
	localparam num_tests = 7;

						// 1 + 1 = 2	,-1 + 1 = -0,  -2 + 1 = -1   1 + -2 = -1   -1 + -1 = -2	  -1 + 2 = 1   2 + -1 = 1
	reg [31:0] test_a[num_tests] 		= {32'h00000001, 32'h80000001, 32'h80000002, 32'h00000001, 32'h80000001, 32'h80000001, 32'h00000002};
	reg [31:0] test_b[num_tests] 		= {32'h00000001, 32'h00000001, 32'h00000001, 32'h80000002, 32'h80000001, 32'h00000002, 32'h80000001};
	reg [31:0] test_results[num_tests] 	= {32'h00000002, 32'h80000000, 32'h80000001, 32'h80000001, 32'h80000002, 32'h00000001, 32'h00000001};

	//test bench values
	reg [31:0] tb_a; 
	reg [31:0] tb_b;
	reg [31:0] tb_result;

	fixed_point_add DUT (tb_a, tb_b, tb_result);
		

	// Test bench process
	initial
	begin		
		for(int i = 0; i < num_tests; i++) begin
			tb_a = test_a[i];
			tb_b = test_b[i];
			#(1);
			if(tb_result != test_results[i])
				$error("Failed test case %d, got %d and should have got %d", i, tb_result, test_results[i]);		
		end			
		$display("Done!");
	end

endmodule
