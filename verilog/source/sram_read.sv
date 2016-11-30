// $Id: $
// File name:   sram_read.sv
// Created:     11/30/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SRAM read

module sram_read
(
	input wire clk,
	input wire n_rst,
	input wire [31:0] read_data,
	input wire read_next,
	input wire start_addr,
	output reg address,
	output reg read
);

	reg next_add;

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

	//call sram_interface ();
	
endmodule
