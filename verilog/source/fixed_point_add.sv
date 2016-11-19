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

always_comb begin
	if(a[31] == b[31]) begin
		temp = a[30:0] + b[30:0];
		result = {a[31], temp};
	end
	else if(a[31] == 1) begin
		if(a[30:0] < b[30:0]) begin
			temp = b[30:0] - a[30:0];
			result = {0, temp};
		end
		else begin
			temp = a[30:0] - b[30:0];
			result = {1, temp};
		end 
	end
	else begin
		if(a[30:0] < b[30:0]) begin
			temp = b[30:0] - a[30:0];
			result = {1, temp};
		end
		else begin
			temp = a[30:0] - b[30:0];
			result = {0, temp};
		end 
	end
	
end

endmodule
