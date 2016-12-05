// $Id: $
// File name:   sram_read.sv
// Created:     11/30/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SRAM read

module sram_read
#(
	parameter = IMAGE_SIZE = 64;
)
(
	input wire clk,
	input wire n_rst,
	input wire [31:0] read_data,
	input wire read_next,
	input wire start_addr,
	output reg sram_data
	output reg address,
	output reg read
);

	reg next_add;
	int image_file;
	int coef_file;
	

	always_ff @ (posedge clk, negedge n_rst) begin
		if (!n_rst)
			address = start_addr;
		else
			address = next_add;
	end

	always_comb begin
		address = start_addr;

		if (read_next) begin
			next_add = address + 1;
		end 
	end
	
	image_file = $fopen("../python/testcases8x8/t9in_fixbin.txt", "rb");
	coef_file = $fopen("../python/shapeWeights8x8_bin.txt", "rb");
	
	task load_image_64;	
	begin
		//read 64 short integers
		for(int i = 0; i < IMAGE_SIZE; i++) begin
			image[i][15:8] = $fgetc(image_file); 
			image[i][7:0] = $fgetc(image_file);
		end
	end
	@(posedge clk);
	
	endtask

	task load_image_16;	
	begin
		//read 16 short integers
		for(int i = 0; i < 16; i++) begin
			image[i][15:8] = $fgetc(image_file);
			image[i][7:0] = $fgetc(image_file);
		end
	end
	endtask

	task load_coef_first;
	begin
		//read the first layer coefficients
		for(int i = 0; i < IMAGE_SIZE; i++) begin
			for(int j = 0; j < 16; j++) begin
				weights[j][i][15:8] = $fgetc(coef_file);
				weights[j][i][7:0] = $fgetc(coef_file);
				//@(posedge tb_clk);
			end			
		end
	end
	endtask

	task load_coef_second;
	begin
		//read the second layer coefficents
		for(int i = 0; i < 16; i++) begin
			for(int j = 0; j < 8; j++) begin
				weights[j][i][15:8] = $fgetc(coef_file);
				weights[j][i][7:0] = $fgetc(coef_file);
				//@(posedge tb_clk);
			end			
		end
	end
	endtask

	task load_coef_third;
	begin
		//read the second layer coefficents
		for(int i = 0; i < 8; i++) begin
			for(int j = 0; j < 10; j++) begin
				weights[j][i][15:8] = $fgetc(coef_file);
				weights[j][i][7:0] = $fgetc(coef_file);
				//@(posedge tb_clk);
			end			
		end
	end
	endtask

	
	
endmodule
