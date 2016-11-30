// $Id: $
// File name:   input_node_timer.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: ANN that combines multiple sub modules


module ANN
#(	
	parameter FIRST_LAYER = 16,
	parameter SECOND_LAYER = 4,
	parameter THIRD_LAYER = 10,

	parameter IMAGE_SIZE = 16
)
(
	input wire clk,
	input wire n_rst,
	input wire image_weights_loaded,
	input wire [15:0] image [IMAGE_SIZE - 1:0],
	input wire [15:0] weights [FIRST_LAYER - 1:0][IMAGE_SIZE - 1:0],
	output reg done_processing,
	output reg request_coef,
	output reg coef_select,
	output reg [7:0] seven_seg
);

reg [6:0] max_input;
reg coef_ready;
reg [6:0] input_num;
reg reset_accum;
reg [2:0] load_next;
reg n_start_done;

reg [15:0] ANN_pipeline_register [IMAGE_SIZE - 1:0];
reg [15:0] all_zeros [IMAGE_SIZE - 1:0] ;  //variable used to zero out the ANN pipeline register
reg [15:0] node_out [IMAGE_SIZE - 1:0];

reg [15:0] nxt_ann_pipeline_val [IMAGE_SIZE - 1:0];



//creates 16 nodes for the ANN
genvar i;

generate
for(i = 0; i < FIRST_LAYER; i++) begin
	node #(.IMAGE_SIZE(IMAGE_SIZE)) thisNode(.clk(clk),.n_rst(n_rst),.start(n_start_done),.reset_acc(reset_accum), .cnt_val(input_num), .coef(weights[i]), .data_in(ANN_pipeline_register), .node_out(node_out[i]));
end

endgenerate






//input to node timer
input_node_timer timer(.clk(clk),.n_rst(n_rst), .max_input(max_input), .coef_ready(coef_ready), .n_start_done(n_start_done), .input_num(input_num));

//ANN controller
ann_controller #(.IMAGE_SIZE(IMAGE_SIZE))controller(.clk(clk),.n_rst(n_rst),.image_weights_loaded(image_weights_loaded),.n_start_done(n_start_done),.max_input(max_input),.coeff_ready(coef_ready),
			.reset_accum(reset_accum),.load_next(load_next),.request_coef(request_coef),.done_processing(done_processing),.coef_select(coef_select));


always_ff @ (posedge clk, negedge n_rst)
begin
	//if reset	
	if(n_rst == 0) begin
		//reset the pipeline register	
		/*for(int i = 0; i < IMAGE_SIZE; i++) begin
			ANN_pipeline_register[i] <= 0;
			node_out[i] <= 0;
		end*/	
		
	end 
	


	//if load next values is ,4 load the initial image 
	/*if(load_next == 4) begin
		ANN_pipeline_register <= image;
	end*/
	//if load next = 1, load all nodes used in the first layer
	/*else if(load_next == 1) begin
		ANN_pipeline_register[FIRST_LAYER - 1:0] <= node_out[FIRST_LAYER - 1:0];
		for(int i = FIRST_LAYER; i < IMAGE_SIZE; i++) begin
			ANN_pipeline_register[i] <= 0;
		end
	end
	//if load next = 2, load all nodes used in the second layer
	else if(load_next == 2) begin
		ANN_pipeline_register[SECOND_LAYER - 1:0] <= node_out[SECOND_LAYER - 1:0];
		for(int i = SECOND_LAYER; i < IMAGE_SIZE; i++) begin
			ANN_pipeline_register[i] <= 0;
		end
	end	
	//if load next = 3, load all nodes used in the third layer
	else if(load_next == 3) begin
		ANN_pipeline_register[THIRD_LAYER - 1:0] <= node_out[THIRD_LAYER - 1:0];
		//ANN_pipeline_register[IMAGE_SIZE - 1:THIRD_LAYER] <= all_zeros[IMAGE_SIZE - 1:THIRD_LAYER];
		for(int i = THIRD_LAYER; i < IMAGE_SIZE; i++) begin
			ANN_pipeline_register[i] <= 0;
		end
	end
	//else keep the regsiter the same
	else begin
		ANN_pipeline_register <= ANN_pipeline_register;
	end*/
end


endmodule
