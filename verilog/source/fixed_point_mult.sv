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
	sign_bit = a[15] ^ b[15];
	temp = a[14:0] * b[14:0];

	result = {sign_bit, 1'b0, temp[29:0]};

end

endmodule
