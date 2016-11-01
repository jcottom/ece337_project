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

module node (
	input wire clk,
	input wire n_rst,
	input wire [6:0] cnt_val,
	input wire [15:0] coef [63:0],
	input wire [15:0] in_val [63:0],
	output wire [2:0] node_out
);

//initialize internal variables
	//nxt_add: the next value to add to the accumulator 
	//accumulator: stores the total sum of all of the mult and addition

//create instance of the activatin funciton

always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 0) begin
		//reset node_out to 0
		//reset the accumulator to 0
	end  
	else begin
		//accumulator = accumulator + nxt_add
	end
end

always_comb begin
	//nxt_add = coef[cnt_val] * in_val[cnt_val]

	//node_out = activation_fucntion(accumuulator)
end


endmodule
