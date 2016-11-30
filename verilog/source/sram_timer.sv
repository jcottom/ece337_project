// $Id: $
// File name:   input_node_timer.sv
// Created:     11/20/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: sram timer


module sram_timer
#(
	PIXEL = 16,
	IMAGE_SIZE = 64,
	FIRST_LAYER = 16,
	SECOND_LAYER = 8,
	THIRD_LAYER = 10
)
(
	input wire clk,
	input wire n_rst,	
	input wire [6:0] coef_select,
	input wire n_coef_image,
	input wire start_sram,
	output reg read_nxt_byte, //Next avalon bus
	output reg sram_done
);
	reg [14:0] cnt1; //16,384
	reg [11:0] cnt2; //2048
	reg [10:0] cnt3; //1280
	reg done1, done2;

	flex_counter #(.NUM_CNT_BITS(15)) layer1(.clk(clk), .n_rst(n_rst), .clear(1'b0), .count_enable('b1), .rollover_val(cnt1), .count_out(), .rollover_flag(done1));
	flex_counter #(.NUM_CNT_BITS(12)) layer2(.clk(clk), .n_rst(n_rst), .clear(1'b0), .count_enable(done1), .rollover_val(cnt2), .count_out(), .rollover_flag(done2));
	flex_counter #(.NUM_CNT_BITS(11)) layer3(.clk(clk), .n_rst(n_rst), .clear(1'b0), .count_enable(done2), .rollover_val(cnt2), .count_out(), .rollover_flag(done2));

	always_ff @ (posedge clk, negedge n_rst) begin
		if (!n_rst) begin
			read_nxt_byte = 0;
			sram_done = 0;
		end
		read_nxt_byte = 0;
	end

	always @ (done1, done2) begin
		read_nxt_byte = 1'b1;
	end

	always_comb begin
		cnt1 = IMAGE_SIZE * FIRST_LAYER * PIXEL;
		cnt2 = FIRST_LAYER * SECOND_LAYER * PIXEL;
		cnt3 = SECOND_LAYER * THIRD_LAYER * PIXEL;
	end

endmodule
