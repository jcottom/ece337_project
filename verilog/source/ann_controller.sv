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
#(
	parameter FIRST_LAYER = 16,     // Narrowed down from 64 bits
	parameter SECOND_LAYER = 8,     // Norrowed down from 16 bits
	parameter THIRD_LAYER = 10,     // Number 0 - 9 with number closest to 1 being final number output

	parameter IMAGE_SIZE = 64	// 8x8 pixel grayscae image 	
)
(
	input wire clk,
	input wire n_rst,
	input wire image_weights_loaded,
   	input wire n_start_done,
	input wire start_detecting,
   	output reg [6:0] max_input,
	output reg coeff_ready,
	output reg reset_accum,
   	output reg [2:0] load_next,
   	output reg request_coef,
   	output reg done_processing,
   	output reg [1:0] coef_select
);

typedef enum bit [3:0] {IDLE, REQUEST_IMAGE, LOAD_IMAGE, WAIT_IMAGE,REQUEST_COEF, WAIT_COEF, START_LAYER, WAIT_LAYER, INCR_LAYER, CHECK_DONE, DISPLAY_OUT, PAUSE_COEF} all_states;



all_states state;
all_states nxt_state;


reg [2:0] cur_layer;
reg [2:0] nxt_layer;

reg [1:0] coef_select_temp;

localparam max_layers = 3;

localparam input_delay = 0;


assign coef_select = coef_select_temp;

always_ff @ (posedge clk, negedge n_rst)
begin
	//reset	variables if n_rst is enabled
	if(n_rst == 1'b0) begin
		state <= IDLE;
		cur_layer <= 0;
	end
	//Assign next state to current and increment layer if current layer is done
	else begin
		state <= nxt_state;
		cur_layer <= nxt_layer;
	end
end

always_comb begin
	
	nxt_state = state; //preset the next state to be the current state to avoid latches
	case(state)
		IDLE : begin // Wait until start detect is enabled 
			if(start_detecting == 1'b1)
				nxt_state = REQUEST_IMAGE;		
		end
		REQUEST_IMAGE: begin // Start image load
			nxt_state = WAIT_IMAGE;
		end
		WAIT_IMAGE: begin // Wait for image to load
			if (image_weights_loaded == 1'b1) begin
				nxt_state = LOAD_IMAGE;
			end
		end
		LOAD_IMAGE: begin // Finished loading image
			nxt_state = REQUEST_COEF;
		end
		REQUEST_COEF: begin // Wait state for load coefficients
			nxt_state = WAIT_COEF;
		end
		WAIT_COEF: begin // Wait to start loading coefficients 
			if(image_weights_loaded == 1'b1)
				nxt_state = PAUSE_COEF;
		end
		PAUSE_COEF: begin // Wait for coefficients to be loaded
			nxt_state = START_LAYER;
		end
		START_LAYER: begin // Wait for  first layer of nodes to complete calculations
			nxt_state = WAIT_LAYER;
		end
		WAIT_LAYER: begin // Wait for the current layer of nodes to load
			if(n_start_done == 1'b1)
				nxt_state = INCR_LAYER;
		end
		INCR_LAYER: begin // Finished current layer and move to next layer
			nxt_state = CHECK_DONE;
		end	
		CHECK_DONE: begin // Check for finsihed ANN
			if(cur_layer == max_layers)
				nxt_state = DISPLAY_OUT;
			else
				nxt_state = REQUEST_COEF;
		end
		DISPLAY_OUT: begin // ANN Finished. Start output of data
			nxt_state = IDLE;
		end
	endcase
	
	// Calculate max layer 
	if(cur_layer == 0) begin
		max_input = IMAGE_SIZE + input_delay;
	end 
	else if(cur_layer == 1) begin
		max_input = FIRST_LAYER + input_delay;
	end
	else begin
		max_input = SECOND_LAYER + input_delay;
	end

	//max_input = 16;  //make this max input based on a look up table
	coeff_ready = 1;
	reset_accum = 0;
   	load_next = 0;
   	request_coef = 0;
   	done_processing = 0;
	nxt_layer = cur_layer;
	
	// Input and output varaibles for current state
	case(state)
		IDLE: begin
			coeff_ready = 0;	
			coef_select_temp = 2'b11;
		end	
		REQUEST_IMAGE: begin
			request_coef = 1; //Request coef from SRAM
			coef_select_temp = 2'b11;
		end
		WAIT_IMAGE: begin  
			request_coef = 0;
		end
		LOAD_IMAGE: begin
			request_coef = 0;
			load_next = 4;
			
			// Wait for image to load
			coeff_ready = 0;
		end
		REQUEST_COEF: begin
			request_coef = 1; // Request coef from SRAM
			coeff_ready = 0; // Ready to read coefficients	

			// Synchronize layers for ANN and SRAM top modules
			if (cur_layer == 2'b00) begin
				coef_select_temp = 2'b00; // Choose first layer of coefficients 
			end 
			if (cur_layer == 2'b01) begin
				coef_select_temp = 2'b01; // Choose second layer of coefficients
			end
			else if (cur_layer == 2'b10) begin
				coef_select_temp = 2'b10; // Choose third layer of coefficients
			end
		end
		WAIT_COEF: begin
			coeff_ready = 0; 
		end
		PAUSE_COEF: begin
			coeff_ready = 0;
		end
		START_LAYER: begin
			reset_accum = 1; // Reset accumulator for next layer
			coeff_ready = 0;	
		end
		WAIT_LAYER: begin
			
		end
		INCR_LAYER: begin
			load_next = cur_layer + 1; // Tell the control register to load the output of the nodes			
			nxt_layer = cur_layer + 1; // Move to next layer
			coeff_ready = 0; 
		end	
		CHECK_DONE: begin
			coeff_ready = 0;
		end
		DISPLAY_OUT: begin
			done_processing = 1; // ANN done computing and final value is ready		
			coeff_ready = 0;
			nxt_layer = 0;
		end
	endcase

end



endmodule
