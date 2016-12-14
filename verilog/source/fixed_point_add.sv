// $Id: $
// File name:   fixed_point_add.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: fixed point addition

module fixed_point_add
(
	input wire [31:0] a,
	input wire [31:0] b,
	output reg [31:0] result
);

reg [30:0] temp;
reg sign_bit;
	
// Fixed point math logic
	always_comb 
	begin
		if(a[31] == b[31]) begin // Sign of inputs are the same
			temp = a[30:0] + b[30:0]; // Add input a and input b
			result = {a[31], temp}; // Add sign of input a
		end
		else if(a[31] == 1) begin // Sign of inputs are the same and a is negative
			if(a[30:0] < b[30:0]) begin // If magnitude of b is grater than a
				temp = b[30:0] - a[30:0];
				result = {0, temp}; // Positive result
			end
			else begin // Magnitude of a s grater than b
				temp = a[30:0] - b[30:0];
				result = {1, temp}; //Negative result
			end 
		end
		else begin
			if(a[30:0] < b[30:0]) begin // A is negative and b has a larger magnitude
				temp = b[30:0] - a[30:0]; 
				result = {1, temp}; //Negative result
			end
			else begin // A is negative and has a larger magnitude than b
				temp = a[30:0] - b[30:0];
				result = {0, temp}; // Positive result
			end 
		end

	end

endmodule
