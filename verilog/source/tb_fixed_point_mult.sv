// 337 TA Provided Lab 2 Testbench
// This code serves as a test bench for the 1 bit adder design 

`timescale 1ns / 100ps

module tb_fixed_point_mult
();		
	localparam num_tests = 4;

						// 0.5 * 0.5= 0.25	0.5 * 1 = 0.5		-0.5*0.5=-0.25		-0.5*-0.5=0.25
	reg [31:0] test_a[num_tests] 		= {16'h0800, 		16'h0800, 		16'h8800, 		16'h8800};
	reg [31:0] test_b[num_tests] 		= {16'h0800, 		16'h1000, 		16'h0800, 		16'h8800};
	reg [31:0] test_results[num_tests] 	= {32'h00400000,	32'h00800000, 		32'h80400000, 		32'h00400000};

	//test bench values
	reg [15:0] tb_a; 
	reg [15:0] tb_b;
	reg [31:0] tb_result;

	fixed_point_mult DUT (tb_a, tb_b, tb_result);
		

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
