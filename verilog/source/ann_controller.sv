// $Id: $
// File name:   controller.sv
// Created:     11/8/2016
// Author:      Cheyenne Martinez and Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: ANN Controller


//TO DO
	//make max input variable and change over timer; create a table to store max input variables


module ann_controller
(
	input wire clk,
	input wire n_rst,
	input wire image_weights_loaded,
   	input wire n_start_done,
   	output reg [6:0] max_input,
	output reg coeff_ready,
	output reg reset_accum,
   	output reg [1:0] load_next,
   	output reg request_coef,
   	output reg done_processing,
   	output reg [6:0] coef_select
);

typedef enum bit [2:0] {WAIT_IMAGE, REQUEST_COEF, WAIT_COEF, START_LAYER, WAIT_LAYER, INCR_LAYER, CHECK_DONE, DISPLAY_OUT} all_states;



all_states state;
all_states nxt_state;


reg [2:0] cur_layer;
reg [2:0] nxt_layer;

localparam max_layers = 4;



always_ff @ (posedge clk, negedge n_rst)
begin
	//reset	
	if(n_rst == 1'b0) begin
		state <= WAIT_IMAGE;
		cur_layer <= 0;
	end
	else begin
		state <= nxt_state;
		cur_layer <= nxt_layer;
	end
end

always_comb begin
	
	nxt_state = state; //preset the next state to be the current state
	case(state)
		WAIT_IMAGE: begin
			if(image_weights_loaded == 1'b1)
				nxt_state = REQUEST_COEF;
		end
		REQUEST_COEF: begin
			nxt_state = WAIT_COEF;
		end
		WAIT_COEF: begin
			if(image_weights_loaded == 1'b1)
				nxt_state = START_LAYER;
		end
		START_LAYER: begin
			nxt_state = WAIT_LAYER;
		end
		WAIT_LAYER: begin
			if(n_start_done == 1'b1)
				nxt_state = INCR_LAYER;
		end
		INCR_LAYER: begin
			nxt_state = CHECK_DONE;
		end	
		CHECK_DONE: begin
			if(cur_layer == max_layers)
				nxt_state = DISPLAY_OUT;
			else
				nxt_state = REQUEST_COEF;
		end
		DISPLAY_OUT: begin
			nxt_state = WAIT_IMAGE;
		end
	endcase
	
	max_input = 16;  //make this max input based on a look up table
	coeff_ready = 1;
	reset_accum = 0;
   	load_next = 0;
   	request_coef = 0;
   	done_processing = 0;
   	coef_select = 0;  //what does this variable do?
	nxt_layer = cur_layer;
	
	case(state)
		WAIT_IMAGE: begin
			//wait for image to load
			coeff_ready = 0;
		end
		REQUEST_COEF: begin
			request_coef = 1;
			coeff_ready = 0;
			//coef_select = ???
		end
		WAIT_COEF: begin
			coeff_ready = 0;
		end
		START_LAYER: begin
			reset_accum = 1;	
		end
		WAIT_LAYER: begin
			
		end
		INCR_LAYER: begin
			nxt_layer = cur_layer + 1;
			coeff_ready = 0;
		end	
		CHECK_DONE: begin
			coeff_ready = 0;
			load_next = 1;
		end
		DISPLAY_OUT: begin
			done_processing = 1;			
			coeff_ready = 0;
			nxt_layer = 0;
		end
	endcase
end



endmodule
