// $Id: $
// File name:   input_node_timer.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: ANN that combines multiple sub modules


module ANN
#(
	parameter INPUT_LAYER = 16,
	parameter SECOND_LAYER = 4,
	parameter THIRD_LAYER = 1	
)
(
	input wire clk,
	input wire n_rst,
	input wire image_weights_loaded,
   	input wire n_start_done,
	output reg done_processing,
	output reg request_coef,
	output reg coef_select,
	output reg [7:0] seven_seg
);

reg [6:0] max_input;
reg coef_ready;
reg input_num;
reg reset_accum;
reg [1:0] load_next;

//node

//input to node timer
input_node_timer (.clk(clk),.n_rst(n_rst), .max_input(max_input), .coef_ready(coef_ready), .n_start_done(n_start_done), .input_num(input_num));

//ANN controller
ann_controller (.clk(clk),.n_rst(n_rst),.image_weights_loaded(image_weights_loaded),.n_start_done(n_start_done),.max_input(max_input),.coeff_ready(coef_ready),
			.reset_accum(reset_accum),.load_next(load_next),.request_coef(request_coef),.done_processing(done_processing),.coef_select(coef_select));

//ANN pipeline register



always_comb begin
	
end


endmodule
