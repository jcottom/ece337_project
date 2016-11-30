// $Id: $
// File name:   node.sv
// Created:     11/01/2016
// Author:      Ryan McBee
// Lab Section: 7
// Version:     1.0  Initial Design Entry
// Description: Artificial neural network individual node

/* Todo
	
	* figure out how to input 64 two byte inputs
	* add in floating point multiplication
	* add in floating point addition
*/


typedef reg [15:0] double;

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
	input wire [15:0] coef [IMAGE_SIZE - 1:0],
	input wire [15:0] data_in [IMAGE_SIZE - 1:0],
	output reg [15:0] node_out
);

//initialize internal variables
	reg [31:0] add1; //next value to add to the accumulator
	reg [31:0] add2; 
	reg [31:0] sum;
	reg [31:0] nxt_out;
	reg accumulator; //stoes total sum of all the multiplication and addition

//create instance of the activatin funciton

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 0) begin
			node_out <= 0;
			add2 <= 0;
		end  
		else begin
			add2 <= nxt_out;
		end
	end
	
	always_comb begin
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


	fixed_point_mult mult(.a(coef[cnt_val]), .b(data_in[cnt_val]), .result(add1)); //add1 = coef[cnt_val] * data_in[cnt_val];
	fixed_point_add  add(.a(add2), .b(add1), .result(sum)); //sum = add1 + add2
	activation       active(.in(add2[31:16]) ,.out(node_out));


endmodule
