// $Id: $
// File name:   fixed_point_mult.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: ANN controller test bench

`timescale 1ns / 100ps

module tb_ann_controller
();		
	localparam CLK_PERIOD = 10.0ns;	

	//test bench values
	reg tb_clk;
	reg tb_n_rst;
	reg tb_image_weights_loaded;
   	reg tb_n_start_done;
   	reg [6:0] tb_max_input;
	reg tb_coeff_ready;
	reg tb_reset_accum;
   	reg [1:0] tb_load_next;
   	reg tb_request_coef;
   	reg tb_done_processing;
   	reg [6:0] tb_coef_select;
	
	// Clock gen block
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2.0);
	end
	
	ann_controller DUT(.clk(tb_clk), .n_rst(tb_n_rst), .image_weights_loaded(tb_image_weights_loaded), .n_start_done(tb_n_start_done), .max_input(tb_max_input), 
				.coeff_ready(tb_coeff_ready), .reset_accum(tb_reset_accum), .load_next(tb_load_next), .request_coef(tb_request_coef), 
				.done_processing(tb_done_processing), .coef_select(tb_coef_select));

	
	task test_expected_values;

	input max_input;
	input coeff_ready;
	input reset_accum;
   	input [1:0] load_next;
   	input request_coef;
   	input done_processing;
   	input [6:0] coef_select;

	begin

	end
	endtask	

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
		//test operation of state controller		
		tb_image_weights_loaded = 0;
   		tb_n_start_done	= 0;	

		reset();
		
		for(int i = 0; i < 5; i++) begin
			@(posedge tb_clk);
		end
		
		tb_image_weights_loaded = 1; @(posedge tb_clk); //simulate the SRAM finishing loading an image by pulsing image loaded flag
		tb_image_weights_loaded = 0; 
	


		while(tb_done_processing == 0) begin

			//wait for "coefficients to be loaded" (simulated wait)
			for(int i = 0; i < 5; i++) begin
				@(posedge tb_clk);
			end

			tb_image_weights_loaded = 1; @(posedge tb_clk); //simulate the SRAM finishing loading coefficient by pulsing image loaded flag
			tb_image_weights_loaded = 0; 

		
			//wait for "Neural network row to do calculations" (simulated wait)
			for(int i = 0; i < 5; i++) begin
				@(posedge tb_clk);
			end

			tb_n_start_done = 1;

			//wait for controller to do some calculations		
			for(int i = 0; i < 5; i++) begin
				@(posedge tb_clk);
			end

			tb_image_weights_loaded = 1; @(posedge tb_clk); //simulate the SRAM finishing loading coefficient by pulsing image loaded flag
			tb_image_weights_loaded = 0; 
			tb_n_start_done = 0;

		end
	end

endmodule
