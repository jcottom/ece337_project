// $Id: $
// File name:   input_node_timer.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: input node timer


module input_node_timer
(
	input wire clk,
	input wire n_rst,	
	input wire [6:0] max_input,
	input wire coef_ready,
	output reg n_start_done,
	output reg [6:0] input_num
);





flex_counter #(.NUM_CNT_BITS(7)) counter(.clk(clk), .n_rst(n_rst), .clear(!coef_ready), .count_enable(coef_ready && !n_start_done), .rollover_val(max_input), .count_out(input_num), .rollover_flag(n_start_done));

always_comb begin
	
end

endmodule
