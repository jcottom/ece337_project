// $Id: $
// File name:   input_node_timer.sv
// Created:     11/20/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: sram timer


module sram_timer
(
	input wire clk,
	input wire n_rst,	
	input wire [6:0] coef_select,
	input wire n_coef_image,
	input wire start_sram,
	output reg read_nxt_byte,
	output reg sram_done
);





flex_counter #(.NUM_CNT_BITS(10)) counter(.clk(clk), .n_rst(n_rst), .clear(), .count_enable(), .rollover_val(), .count_out(), .rollover_flag());

always_comb begin
	
end

endmodule
