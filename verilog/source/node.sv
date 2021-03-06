// $Id: $
// File name:   node.sv
// Created:     11/01/2016
// Author:      Ryan McBee, Cheyenne Martinez, and Taylor Lipson
// Lab Section: 7
// Version:     1.0  Initial Design Entry
// Description: Artificial neural network individual node

module node 
#(
	parameter IMAGE_SIZE = 64
)
(
	input wire clk,
	input wire n_rst,
	input wire start,
	input wire reset_acc,
	input wire [6:0] cnt_val,
	input wire [IMAGE_SIZE - 1:0][15:0] coef,
	input wire [IMAGE_SIZE - 1:0][15:0] data_in,
	output reg [15:0] node_out
);

//initialize internal variables
	reg [31:0] add1; //next value to add to the accumulator
	reg [31:0] add2; //other value put into the add block, also the accumlated value
	reg [31:0] sum; //sum of the addition block
	reg [31:0] nxt_out;  //the next output to go into add2(the accumulator)
	

//create instance of the activatin funciton
	always_ff @(posedge clk, negedge n_rst)
	begin
		if(n_rst == 0) begin
			add2 <= 0;
		end  
		else begin
			add2 <= nxt_out;	
		end
	end
	
	always_comb begin // Next out based on current inputs
		if(reset_acc == 1) begin
			nxt_out = 0;
		end  
		else if (start == 0) begin
			nxt_out = sum;
		end
		else begin
			nxt_out = add2;
		end
	end
	
	//fixed point multiplication
	fixed_point_mult mult(.a(coef[cnt_val]), .b(data_in[cnt_val]), .result(add1));

	//fixed point addition
	fixed_point_add  add(.a(add2), .b(add1), .result(sum)); //sum = add1 + add2

	//activation function
	new_activation       active(.in(add2[31:16]) ,.out(node_out)); //Use only top 16 bits


endmodule
