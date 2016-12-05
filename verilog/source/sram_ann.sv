// $Id: $
// File name:   sram_ann.sv
// Created:     12/4/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SRAM wrapper

module sram_ann 
(
	input clk, 
	input n_rst,
	input [6:0] coef_select,
	input i_loaded,
	input request,
	input p_done,
	input [31:0] read_data,
	input [9:0] start_address;
	output [9:0] address,
	output read
);

	reg sram_done;
	reg start_sram;
	reg [15:0] image [63:0];
	reg [15:0] weights [1023:0];
	reg read_next;
	
	sram_buffer(.clk(clk), .n_rst(n_rst), .sram_data(sram_data), .sram_done(sram_done), .start_sram(start_sram), .image(image), .weights(.weights));
	sram_read(.clk(clk), .n_rst(n_rst), .read_data(read_data), .read_next(read_next), .start_addr(start_address), .read(read));
	sram_timer(.clk(clk), .n_rst(n_rst), .n_coef_image(coef_select), .start_sram(start_sram), .read_nxt_byte(read_next), .sram_done(sram_done));
	sram_controller (.clk(clk), .n_rst(n_rst), .start_detecting(request), .done_processing(p_done), .sram_done(sram_done), .image_weights_loaded(i_loaded), .n_coef_image(coef_select), .start_sram(start_sram)); 

endmodule
