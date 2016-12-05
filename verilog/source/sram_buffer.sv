// $Id: $
// File name:   sram_buffer.sv
// Created:     11/30/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SRAM Buffer

module sram_buffer
(
	input wire clk,
	input wire n_rst,
	input [31:0] sram_data,
	input sram_done,
	input start_sram,
	output [15:0] image [63:0],
	output [15:0] weights [1023:0]
);
	integer i, j;
	
	always @ (posedge clk, negedge n_rst) begin
		if (!n_rst) begin
			for (i = 0; i < 64; i = i + 1) begin
				image[i] = 'b0;
			end
			for (j = 0; j < 1024; j = j + 1) begin
				weights[j] = 'b0;
			end
		end
	end 
	always @ (start_sram) begin
		if (!sram_done) begin
			for( i = 0; i < 64; i = i + 1) begin
				image[i] = sram[i];
			end
		else begin
			for ( i = 0; i < 64; i = i + 1) begin
				weights[j] = sram[i];
			end
		end
	end
	

	

endmodule
