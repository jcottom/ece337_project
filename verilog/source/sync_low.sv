// $Id: $
// File name:   sync_low.sv
// Created:     8/31/2016
// Author:      Ryan McBee
// Lab Section: 7
// Version:     1.0  Initial Design Entry
// Description: Reset on logic low synchronizer

module sync_low
(
	input wire clk,
	input wire n_rst,
	input wire async_in,
	output reg sync_out,
	reg front
);

always_ff @ (posedge clk, negedge n_rst)
begin
	if(1'b0 == n_rst)  //If reset
	begin
		sync_out <= 1'b0;
		front <= 1'b0;
	end
	else
	begin // Synchronize output to clock edge
		sync_out <= front;
		front <= async_in;
	end
			

end

endmodule;		
