// $Id: $
// File name:   flex_counter.sv
// Created:     9/10/2016
// Author:      Ryan McBee
// Lab Section: 7
// Version:     1.0  Initial Design Entry
// Description: flexible counter to be reused.

module flex_counter
#(
	NUM_CNT_BITS = 4
)

(
	input wire clk,
	input wire n_rst,
	input wire clear,
	input wire count_enable,
	input wire [NUM_CNT_BITS - 1:0] rollover_val,
	output reg [NUM_CNT_BITS - 1:0] count_out,
	output reg rollover_flag
);

	reg [NUM_CNT_BITS - 1:0] nxt_cnt;
	reg nxt_rollover;

always_ff @ (posedge clk, negedge n_rst)
begin
	//reset	
	if(n_rst == 1'b0) begin
		count_out <= 0;
		rollover_flag <= 0;
	end
	else begin
		rollover_flag <= nxt_rollover;	
		count_out <= nxt_cnt;	
	end
end

always_comb begin
	
	if(clear == 1) begin // Restart count at 0
		nxt_cnt = 0;				
		nxt_rollover = 0;
	end
	else if(count_enable == 1'b1) begin //Check if count should increase
		
		if(count_out >= rollover_val) begin // Check for final value
			nxt_cnt = 1;
		end
		else begin
			nxt_cnt = count_out + 1;
		end
		
		
		if(count_out == rollover_val - 1) begin	// Check for one less than final value
			nxt_rollover = 1;
		end
		else begin
			nxt_rollover = 0;
		end
	end
	else begin
		nxt_rollover = rollover_flag;
		nxt_cnt = count_out;
	end	
end



endmodule
