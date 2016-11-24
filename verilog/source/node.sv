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
	localparam BITS = 16
)
(
	input wire clk,
	input wire n_rst,
	input wire start,
	input wire reset_acc,
	input wire [6:0] cnt_val,
	input wire [15:0] coef [63:0],
	input wire [15:0] data_in [63:0],
	output wire [2:0] node_out
);

//initialize internal variables
	reg add1; //next value to add to the accumulator
	reg add2; 
	reg sum;
	reg out;
	reg accumulator; //stoes total sum of all the multiplication and addition

//create instance of the activatin funciton

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 0) begin
			node_out = 0;
			add2 = 0;
		end  
		else begin
			// node_out = Activation functiion
			add2 = out;
		end
	end
	
	always @ (start, reset_acc) begin
		if(reset_acc == 1) begin
			out = 0;
		end  
		else if (start == 0) begin
			out = sum;
		end
		else begin
			out = add2;
		end
	end

	always_comb begin
		fixed_point_mult(.a(coef[cnt_val]), .b(data_in[cnt_val]), .result(add1)); //add1 = coef[cnt_val] * data_in[cnt_val];
		fixed_point_add(.a(add2), .b(add1), .result(sum)); //sum = add1 + add2
	end


endmodule