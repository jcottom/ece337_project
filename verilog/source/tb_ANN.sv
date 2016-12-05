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
	parameter  IMAGE_FILE   = "../python/testcases8x8/t1in_fixbin.txt";
	parameter  COEF_FILE    = "../python/shapeWeights8x8_bin.txt";	
	int image_file;
	int coef_file;
	reg [7:0] temp;

	parameter IMAGE_SIZE = 64;

	localparam CLK_PERIOD = 15.0ns;	

	//test bench values
	reg tb_clk; 
	reg tb_n_rst;
	reg tb_image_weights_loaded;
	reg [15:0] tb_image [IMAGE_SIZE - 1:0];
	reg [15:0] tb_weights [15:0][IMAGE_SIZE - 1:0];



	reg tb_done_processing;
	reg tb_request_coef;
	reg tb_coef_select;
	reg [7:0] tb_seven_seg;
	reg [15:0] tb_ANN_pipeline_register [IMAGE_SIZE - 1:0];

	ANN  dut(.clk(tb_clk),.n_rst(tb_n_rst),.image_weights_loaded(tb_image_weights_loaded),.image(tb_image),.weights(tb_weights),.done_processing(tb_done_processing),.request_coef(tb_request_coef),.coef_select(tb_coef_select),.seven_seg(tb_seven_seg), .ANN_pipeline_register(tb_ANN_pipeline_register));
	
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
		while(tb_request_coef == 0) begin
			#(1);
		end
	end
	endtask
	
	//task that loads a 64 pixel image
	task load_image_64;	
	begin
		//read 64 short integers
		for(int i = 0; i < IMAGE_SIZE; i++) begin
			tb_image[i][15:8] <= $fgetc(image_file); 
			tb_image[i][7:0] <= $fgetc(image_file);
		end
	end
	@(posedge tb_clk);
	
	endtask

	task load_image_16;	
	begin
		//read 16 short integers
		for(int i = 0; i < 16; i++) begin
			tb_image[i][15:8] <= $fgetc(image_file); 
			tb_image[i][7:0] <= $fgetc(image_file); 
		end
	end
	@(posedge tb_clk);

	endtask

	task load_coef_first;
	begin
		//read the first layer coefficients
		for(int i = 0; i < IMAGE_SIZE; i++) begin
			for(int j = 0; j < 16; j++) begin
				tb_weights[j][i][15:8] = $fgetc(coef_file); 
				tb_weights[j][i][7:0] = $fgetc(coef_file); 
			end			
		end
	end
	@(posedge tb_clk);

	endtask

	task load_coef_second;
	begin
		//read the second layer coefficents
		for(int i = 0; i < 16; i++) begin
			for(int j = 0; j < 8; j++) begin
				tb_weights[j][i][15:8] = $fgetc(coef_file); 
				tb_weights[j][i][7:0] = $fgetc(coef_file); 
			end			
		end
	@(posedge tb_clk);

	end
	endtask

	task load_coef_third;
	begin
		//read the second layer coefficents
		for(int i = 0; i < 8; i++) begin
			for(int j = 0; j < 10; j++) begin
				tb_weights[j][i][15:8] <= $fgetc(coef_file); 	
				tb_weights[j][i][7:0] <= $fgetc(coef_file); 
			end			
		end
	@(posedge tb_clk);
	
	end
	endtask

	

	// Test bench process
	initial
	begin	
		
		//opens the coefficients file
		image_file = $fopen(IMAGE_FILE, "rb");
		coef_file = $fopen(COEF_FILE, "rb");
	
		//loads the 8x8 image		
		load_image_64();

		for(int i = 0; i < IMAGE_SIZE; i++) begin
			for(int j = 0; j < 16; j++) begin
				tb_weights[j][i] = 0;
			end			
		end
		
		//set initial conditions
		tb_image_weights_loaded = 0;			
			

		//reset everything		
		reset();
		
		//wait five clock cycles
		for(int i = 0; i < 5; i++) begin
			@(posedge tb_clk);
		end

		loaded();  //toggle the loaded flag
		
		
	for(int j = 0; j < 4; j++) begin
		
		@(negedge tb_clk);

		$error("j = %d", j);
		if(j == 1) begin
			load_coef_first();
		end
		else if(j == 2) begin
			load_coef_second();
		end 
		else if(j == 3) begin
			load_coef_third();
		end

		wait_coef_request();
	
		for(int i = 0; i < 3; i++) begin
			@(posedge tb_clk);
		end

		loaded();  //toggle the loaded flag

	end

		$display("done processing");
				
	
	end

endmodule
