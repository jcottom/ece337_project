// $Id: $
// File name:   fixed_point_mult.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: ANN controller test bench

`timescale 1ns / 100ps

module tb_sram_controller
();		
	localparam CLK_PERIOD = 10.0ns;	

	//test bench values
	reg tb_clk;
	reg tb_n_rst;
	reg tb_start_detecting;
	reg tb_request_coef;
	reg tb_done_processing;	
	reg tb_sram_done;
	reg tb_image_weights_loaded;
	reg tb_n_coef_image;
	reg tb_start_sram;
	

	sram_controller DUT(.clk(tb_clk),.n_rst(tb_n_rst),.start_detecting(tb_start_detecting),.request_coef(tb_request_coef),.done_processing(tb_done_processing),.sram_done(tb_sram_done),.image_weights_loaded(tb_image_weights_loaded),.n_coef_image(tb_n_coef_image),.start_sram(tb_start_sram));

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
		
	reg [4:0] i;

	task wait_one;

	begin
		@(posedge tb_clk);
	end
	endtask	
	
	task wait_five;

	begin
		@(posedge tb_clk);
		@(posedge tb_clk);
		@(posedge tb_clk);
		@(posedge tb_clk);
		@(posedge tb_clk);	
	end
	endtask	


	// Test bench process
	initial
	begin	 
		tb_start_detecting = 0;
		tb_request_coef = 0;
		tb_done_processing = 0;	
		tb_sram_done = 0;

		
		//reset
			reset();
		//wait in start idle
			wait_five();

		//initiate loading image
			tb_start_detecting = 1;
			wait_one();
			tb_start_detecting = 0;

		//simulate wait for loading image
			wait_five();
			
		//send signal to end image loading
			tb_sram_done = 1;
			wait_one();
			tb_sram_done = 0;
		
		//load the coefficients twice
		for(int j = 0; j < 2; j++) begin	
	
		//wait in coef idle
			wait_five();

		//initiate loading coef
			tb_request_coef = 1;
			wait_one;
			tb_request_coef = 0;

		//simulate wait for loading coef
			wait_five;

		//send signal to end coef load
			tb_sram_done = 1;
			wait_one;
			tb_sram_done = 0;
		
		end //end to the for loop

		tb_done_processing = 1; 

		wait_five;

		$display("Done processing");		
	end

endmodule
