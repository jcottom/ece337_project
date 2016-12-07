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
	parameter SECOND_LAYER = 8,
	parameter THIRD_LAYER = 10,

	parameter IMAGE_SIZE = 64
)
(
	input wire clk,
	input wire n_rst,
	input wire image_weights_loaded,
	input wire [IMAGE_SIZE - 1:0][15:0] image ,
	input wire [FIRST_LAYER - 1:0][IMAGE_SIZE - 1:0][15:0] weights,
	input wire start_detecting,
	output reg done_processing,
	output reg request_coef,
	output reg [1:0]coef_select,
	output reg [7:0] seven_seg,
	output reg [IMAGE_SIZE - 1:0][15:0] ANN_pipeline_register
);


//variables to link the different modules together
reg [6:0] max_input;
reg coef_ready;
reg [6:0] input_num;
reg reset_accum;
reg [2:0] load_next;
reg n_start_done;

//register variables
//reg [15:0] ANN_pipeline_register [IMAGE_SIZE - 1:0];
reg [IMAGE_SIZE - 1:0][15:0] nxt_ANN_pipeline_register ;

//output from the nodes variables
reg [IMAGE_SIZE - 1:0][15:0] node_out ;
reg [IMAGE_SIZE - 1:0][15:0] nxt_node_out ;

reg nxt_done_processing;



//creates 16 nodes for the ANN
genvar i;

generate
for(i = 0; i < FIRST_LAYER; i++) begin
	node #(.IMAGE_SIZE(IMAGE_SIZE)) thisNode(.clk(clk),.n_rst(n_rst),.start(n_start_done),.reset_acc(reset_accum), .cnt_val(input_num), .coef(weights[i]), .data_in(ANN_pipeline_register), .node_out(nxt_node_out[i]));
end

endgenerate


neural_to_seven seven_segment_display(.neural_out(ANN_pipeline_register[9:0]), .seven_seg(seven_seg));



//input to node timer
input_node_timer timer(.clk(clk),.n_rst(n_rst), .max_input(max_input), .coef_ready(coef_ready), .n_start_done(n_start_done), .input_num(input_num));

//ANN controller
ann_controller #(.IMAGE_SIZE(IMAGE_SIZE))controller(.clk(clk),.n_rst(n_rst),.image_weights_loaded(image_weights_loaded),.n_start_done(n_start_done),.max_input(max_input),.coeff_ready(coef_ready),
			.reset_accum(reset_accum),.load_next(load_next),.request_coef(request_coef),.done_processing(nxt_done_processing),.coef_select(coef_select), .start_detecting(start_detecting));


always_ff @ (posedge clk, negedge n_rst)
begin
	//if reset	
	if(n_rst == 0) begin
		//reset the pipeline register	
		for(int i = 0; i < IMAGE_SIZE; i++) begin
			ANN_pipeline_register[i] <= 0;
			node_out[i] <= 0;
		end	
		done_processing <= 0;	
	end 
	else begin
		ANN_pipeline_register <= nxt_ANN_pipeline_register;
		done_processing <= nxt_done_processing;
		node_out <= nxt_node_out;
	end

	
end

always_comb begin
	//if load next values is ,4 load the initial image 
	if(load_next == 4) begin
		nxt_ANN_pipeline_register = image;
	end
	//if load next = 1, load all nodes used in the first layer
	else if(load_next == 1) begin
		/*for(int i = 0; i < IMAGE_SIZE; i++) begin
			nxt_ANN_pipeline_register[i] = 0;
		end
		nxt_ANN_pipeline_register[FIRST_LAYER - 1:0] = node_out[FIRST_LAYER - 1:0];*/
		/*for(int i = 0; i < IMAGE_SIZE; i++) begin
			nxt_ANN_pipeline_register[IMAGE_SIZE - 1 - i] = node_out[i];
		end*/
		nxt_ANN_pipeline_register = 0;
		nxt_ANN_pipeline_register[15:0] = node_out[15:0];
	end
	//if load next = 2, load all nodes used in the second layer
	else if(load_next == 2) begin
		//nxt_ANN_pipeline_register[SECOND_LAYER - 1:0] = node_out[SECOND_LAYER - 1:0];
		/*for(int i = 0; i < IMAGE_SIZE; i++) begin
			nxt_ANN_pipeline_register[i] = 0;
		end
		nxt_ANN_pipeline_register[FIRST_LAYER - 1:FIRST_LAYER -SECOND_LAYER] = node_out[SECOND_LAYER - 1:0];*/
		/*for(int i = 0; i < IMAGE_SIZE; i++) begin
			nxt_ANN_pipeline_register[IMAGE_SIZE - 1 - i] = node_out[i];
		end*/
		nxt_ANN_pipeline_register = 0;
		nxt_ANN_pipeline_register[15:0] = node_out[15:0];
	end	
	//if load next = 3, load all nodes used in the third layer
	else if(load_next == 3) begin
		/*nxt_ANN_pipeline_register[THIRD_LAYER - 1:0] = node_out[THIRD_LAYER - 1:0];
		for(int i = THIRD_LAYER; i < IMAGE_SIZE; i++) begin
			nxt_ANN_pipeline_register[i] = 0;
		end*/
		/*for(int i = 0; i < IMAGE_SIZE; i++) begin
			nxt_ANN_pipeline_register[IMAGE_SIZE - 1 - i] = node_out[i];
		end*/
		nxt_ANN_pipeline_register = 0;
		nxt_ANN_pipeline_register[15:0] = node_out[15:0];
	end
	//else keep the regsiter the same
	else begin
		nxt_ANN_pipeline_register = ANN_pipeline_register;
	end
end


endmodule
