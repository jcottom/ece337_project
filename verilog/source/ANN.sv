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
	input wire [15:0] image [63:0],
	input wire [15:0] weights [63:0][15:0],
	output reg done_processing,
	output reg request_coef,
	output reg coef_select,
	output reg [7:0] seven_seg
);

reg [6:0] max_input;
reg coef_ready;
reg [6:0] input_num;
reg reset_accum;
reg [1:0] load_next;
reg n_start_done;

reg [15:0] ANN_pipeline_register [63:0];
reg [15:0] all_zeros [63:0];  //variable used to zero out the ANN pipeline register
reg [15:0] node_out [63:0];



//nodes
genvar i;

generate
for(i = 0; i < 16; i++) begin
	node thisNode(.clk(clk),.n_rst(n_rst),.start(n_start_done),.reset_acc(reset_accum), .cnt_val(input_num), .coef(weights[i]), .data_in(ANN_pipeline_register), .node_out(node_out[i]));
end

endgenerate



//input to node timer
input_node_timer timer(.clk(clk),.n_rst(n_rst), .max_input(max_input), .coef_ready(coef_ready), .n_start_done(n_start_done), .input_num(input_num));

//ANN controller
ann_controller controller(.clk(clk),.n_rst(n_rst),.image_weights_loaded(image_weights_loaded),.n_start_done(n_start_done),.max_input(max_input),.coeff_ready(coef_ready),
			.reset_accum(reset_accum),.load_next(load_next),.request_coef(request_coef),.done_processing(done_processing),.coef_select(coef_select));


always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 0) begin
		//reset the pipeline register	
		for(int i = 0; i < 64; i++) begin
			ANN_pipeline_register[i] <= 0;
		end	
		
	end 
	//if load next values is 1, load the initial image 
	if(load_next == 1) begin
		ANN_pipeline_register <= image;
	end
	else begin
		ANN_pipeline_register <= node_out;
	end
end




always_comb begin
	
end


endmodule
