// $Id: $
// File name:   input_node_timer.sv
// Created:     11/20/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: sram timer


module sram_controller
(
	input wire clk,
	input wire n_rst,
	input wire start_detecting,
	input wire request_coef,
	input wire done_processing,	
	input wire sram_done,
	output reg image_weights_loaded,
	output reg n_coef_image,
	output reg start_sram
);

typedef enum bit [2:0] {START_IDLE, LOAD_IMAGE, WAIT_IMAGE, DONE_IMAGE, COEF_IDLE, LOAD_COEF, WAIT_COEF, COEF_DONE} all_states;

all_states state;
all_states nxt_state;

always_ff @ (posedge clk, negedge n_rst)
begin
	//reset	
	if(n_rst == 1'b0) begin
		state <= START_IDLE;
	end
	else begin
		state <= nxt_state;
	end
end

	//initial states for the output variables
	image_weights_loaded = 0;
	n_coef_image = 0;
	start_sram = 0;

always_comb begin
	
	//next state logic
	nxt_state = state;	
	
	case(state)
		START_IDLE: begin
    			if(start_detecting == 1)
				nxt_state = LOAD_IMAGE;
		end
		LOAD_IMAGE: begin
			nxt_state = WAIT_IMAGE;
			n_coef_image = 1;  //request the image
			start_sram = 1;
		end
		WAIT_IMAGE: begin
			if(sram_done == 1) 
				nxt_state = DONE_IMAGE;
			n_coef_image = 1;  //request the image
		end
		DONE_IMAGE: begin
			nxt_state = COEF_IDLE;
			image_weights_loaded = 1;
		end
		COEF_IDLE: begin
			if(request_coef == 1)
				nxt_state = LOAD_COEF;
			else if(done_processing == 1)
				nxt_state = START_IDLE;	
		end
		LOAD_COEF: begin 
			nxt_state = WAIT_COEF;
			start_sram = 1;
		end
		WAIT_COEF: begin
			if(sram_done == 1)
				nxt_state = COEF_DONE;
		end
		COEF_DONE: begin
			nxt_state = COEF_IDLE;
			image_weights_loaded = 1;
		end
	endcase
end

endmodule
