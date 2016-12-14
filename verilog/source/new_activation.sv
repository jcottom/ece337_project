/*
 This module serves as the activation function for the neural network.  It is a
 combinational block which implements a look-up table for the sigmoid function:

                            f(x) = (1 + e^-x)^-1

 I assume that this table is synthesized as a 2^16 to 1 multiplexer, or a
 2^16*16 bit to 1*16 bit mux, which can be implemented as the following number
 of NAND gates:

      16*4(2^16/2 + 2^15/2 + ... + 2^2/2 + 2/2) = 16*4(2^16 - 1) = 4194240

 The current table entries assume a fixed-point encoding of

                      (0111 1111 1111 1111)_2 = 100_10
                      (0000 0000 0000 0000)_2 = 0_10

 This can be changed as needed by generating a new set of table entries with the
 script in ece337_project/python/lut.py. The variable s contains the scaling
 factor for the fixed point encoding, and the function genLUTArray() will print
 a new set of values for this table.  In order to test this design, one would
 need to generate a new ece337_project/python/lut.pat using the same scaling
 factor, which is used by the tb_activation module.
 */
module new_activation(
                  input wire [15:0]  in,
                  output reg [15:0] out,
					output reg[4:0] state
                  );
	
	reg [15:0] temp_out;
	
	always_comb begin

		//if positive
		if(in[15] == 1'b0) begin
			//if X > 5
			if(in > 16'h0500) begin
				//y = 1
				temp_out = 16'h0100;
				state = 0;
			end
			//else if x > 2.375
			else if(in > 16'h02A0) begin
				// y = 0.03125 * x + 0.84375
				temp_out = {5'b0, in[15:5]} + 16'b0000000011011000;
				state = 1;
			end
			//else if x > 1
			else if(in > 16'h0100) begin
				// y = 0.125 * x + 0.625
				temp_out = {3'b0, in[15:3]} + 16'b0000000010100000;	
				state = 2;
			end
			//else if x > 0
			else begin
				//y = 0.25 * x + 0.5
				temp_out = {2'b0, in[15:2]} + 16'b0000000010000000;
				state = 7;
			end
				
		end
		else begin
			//if X < -5
			if(in[14:0] > 16'h0500) begin
				//y = 0
				temp_out = 0;
				state = 6;
			end
			//else if x > -5
			else if(in[14:0] > 16'h02A0) begin
				//y = 0.03125 * x + 0.15625
				temp_out = 16'b0000000000101000 - {6'b0, in[14:5]};
				state = 5;
			end
			//else if x > -2.375
			else if(in[14:0] > 16'h0100) begin
				//y = 0.125 * x + 0.375
				temp_out = 16'b0000000001100000 - {4'b0, in[14:3]};
				state = 4;
			end
			//else if x > -1
			else begin
				//y = 0.25 * x + 0.5
				temp_out = 16'b0000000010000000 - {3'b0, in[14:2]};
				state = 3;
			end

		end	
end

assign out = temp_out << 4;

endmodule // activation
