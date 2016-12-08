// $Id: $
// File name:   fixed_point_mult.sv
// Created:     11/8/2016
// Author:      Ryan McBee
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: fixed point multiplication

module fixed_point_mult
(
	input wire [15:0] a,
	input wire [15:0] b,
	output reg [31:0] result
);

/*
	How the encoding works

	num bits:1        3	      12
	input: [sign][whole nums].[fraction]

	num bits:  1      1        6	      24
	output: [sign][buffer][whole nums].[fraction]

*/



reg sign_bit;
reg [29:0] temp;

always_comb begin
	sign_bit = a[15] ^ b[15]; // Reduction OR determines sign bit
	temp = a[14:0] * b[14:0]; // Multiply magnitudes 

	result = {sign_bit, 1'b0, temp[29:0]}; //Add sign and round to 30 bits

end

endmodule
