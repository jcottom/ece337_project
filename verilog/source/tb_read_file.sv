// $Id: $
// File name:   fir_filter.sv
// Created:     9/23/2015
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: Course Staff Provided Image Processing Test bench

`timescale 1ns / 100ps

module tb_read_file();

	parameter  INPUT_FILENAME   = "./test.txt";

	integer in_file;

	reg [9:0][7:0] data_in;

	// Test bench process
	initial
	begin
		// Open the input file
		in_file = $fopen(INPUT_FILENAME, "rb");
		
		$fscanf(in_file,"%c" , data_in[0]);

		$display("The value is %d", data_in[0]);

		$fscanf(in_file,"%c" , data_in[0]);

		$display("The value is %d", data_in[0]);
	end

endmodule
