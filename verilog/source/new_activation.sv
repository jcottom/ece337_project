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
module activation(
                  input wire [15:0]  in,
                  output wire [15:0] out
                  );

   
	always_comb begin
		//if X > 5
		if(in > 16'h5000) begin
			//y = 1
			out = 16'1000;
		end
		//else if x > 2.375
		else if(x > 16'h2A00) begin
			// y = 0.03125 * x + 0.84375
			
		end
		//else if x > 1
		else if(x > 16'h1000) begin
			// y = 0.125 * x + 0.625
			
		end
		//else if x > -1
		else if(x > 16'h9000) begin
			//y = 0.25 * x + 0.5
		end
		//else if x > -2.375
		else if(x > 16'hAA00) begin
			//y = 0.125 * x + 0.375
		end
		//else if x > -5
		else if(x > 16'hD000) begin
			//y = 0.03125 * x + 0.15625
		end
		//else
		else begin
			//y = 0
			out = 0;
		end
			
	end



endmodule // activation
