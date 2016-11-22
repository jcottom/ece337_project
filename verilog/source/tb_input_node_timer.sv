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
	reg [6:0] tb_max_input;
	reg tb_coef_ready;
	reg tb_n_start_done;
	reg [6:0] tb_input_num;
	
	// Clock gen block
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2.0);
	end
	
	input_node_timer DUT (.clk(tb_clk), .n_rst(tb_n_rst), .max_input(tb_max_input), .coef_ready(tb_coef_ready), .n_start_done(tb_n_start_done), .input_num(tb_input_num));

	
	task test_expected_values;

	input n_start_done;
	input [6:0] input_num;

	begin
		if(n_start_done != tb_n_start_done)
			$error("incorrect n_start_done");

		if(input_num != tb_input_num)
			$error("incorrect input_num");	
	end
	endtask	
	

	// Test bench process
	initial
	begin		
		//initial conditions
		tb_max_input = 4;			
		tb_coef_ready = 0;		

		//test correct values upon reset
		
		tb_n_rst = 1; #1;		
		tb_n_rst = 0; #1;
		tb_n_rst = 1; #1;
		
		//(n_start_done, input_num)
		test_expected_values(0, 0);

		//count up to 4
		
		tb_max_input = 4;			
		tb_coef_ready = 1;

		//reset the counter
		tb_n_rst = 1; #1;		
		tb_n_rst = 0; #1;
		tb_n_rst = 1; #1;
				
		//wait five clock cycles
		for(int i = 0; i < 5; i ++) 
			@(posedge tb_clk);
		#(1);
		//(n_start_done, input_num)
		test_expected_values(1, 4);
		
		#(1);
		tb_coef_ready = 0;
		@(posedge tb_clk);
		tb_coef_ready = 1;
		
		//wait five clock cycles
		for(int i = 0; i < 5; i ++) 
			@(posedge tb_clk);
		#(1);
		//(n_start_done, input_num)
		test_expected_values(1, 4);


				
		//count up to 64
		
		tb_max_input = 64;			
		tb_coef_ready = 1;

		//reset the counter
		tb_n_rst = 1; #1;		
		tb_n_rst = 0; #1;
		tb_n_rst = 1; #1;
				
		//wait five clock cycles
		for(int i = 0; i < 65; i ++) 
			@(posedge tb_clk);
		#(1);
		//(n_start_done, input_num)
		test_expected_values(1, 64);
		
		#(1);
		tb_coef_ready = 0;
		@(posedge tb_clk);
		tb_coef_ready = 1;
		
		//wait five clock cycles
		for(int i = 0; i < 65; i ++) 
			@(posedge tb_clk);
		#(1);
		//(n_start_done, input_num)
		test_expected_values(1, 64);	
			


	$display("Done testing");

	end

endmodule
