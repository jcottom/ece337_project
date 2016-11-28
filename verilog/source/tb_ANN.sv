// $Id: $
// File name:   tb_input_node_timer.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: input node timer test bench

`timescale 1ns / 100ps

module tb_ANN
();		
	localparam CLK_PERIOD = 10.0ns;	

	//test bench values
	reg tb_clk; 
	reg tb_n_rst;
	reg tb_image_weights_loaded;
	reg [15:0] tb_image [63:0];
	reg [15:0] tb_weights [63:0][15:0];
	reg tb_done_processing;
	reg tb_request_coef;
	reg tb_coef_select;
	reg [7:0] tb_seven_seg;

	ANN dut(.clk(tb_clk),.n_rst(tb_n_rst),.image_weights_loaded(tb_image_weights_loaded),.image(tb_image),.weights(tb_weights),.done_processing(tb_done_processing),.request_coef(tb_request_coef),.coef_select(tb_coef_select),.seven_seg(tb_seven_seg));
	
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

	task loaded;
	begin
		tb_image_weights_loaded = 1;
		@(posedge tb_clk);
		tb_image_weights_loaded = 0;
		#(1);
	end
	endtask

	task wait_coef_request;
	begin
		tb_image_weights_loaded = 1;
		@(posedge tb_clk);
		tb_image_weights_loaded = 0;
		#(1);
	end
	endtask

	// Test bench process
	initial
	begin	
		//set initial conditions
		tb_image_weights_loaded = 0;			
		

		for(int i = 0; i < 64; i++) begin
			//set the weights to 0			
			for(int j = 0; j < 16; j++) begin
				tb_weights[i][j] = 0;	
			end
			tb_image[i] = 0;  //set the image to 0
		end		

		//reset everything		
		reset();
		
		//wait five clock cycles
		for(int i = 0; i < 5; i++) begin
			@(posedge tb_clk);
		end

		loaded();  //toggle the loaded flag
		
		
	for(int j = 0; j < 4; j++) begin
		wait_coef_request();
	
		for(int i = 0; i < 3; i++) begin
			@(posedge tb_clk);
		end

		loaded();  //toggle the loaded flag

	end

		$display("done processing");
				
	
	end

endmodule
