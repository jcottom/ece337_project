// $Id: $
// File name:   sram_read.sv
// Created:     11/30/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: SRAM read

module sram_read
(
	input wire [31:0] read_data,
	input wire read_next,
	input wire start_addr,
	output reg address,
	output reg read
);

endmodule