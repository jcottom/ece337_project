// $Id: $
// File name:   neural_to_seven.sv
// Created:     12/1/2016
// Author:      Taylor Lipson
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Neural Network Output Decode to Seven Segment display

module neural_to_seven
(
    input wire [15:0] neural_out [9:0],
    output wire [7:0] seven_seg
);
shortint thresh = 16'h0400; //0000.010000000000
reg [3:0] i;
reg [7:0] seven;

assign seven_seg = seven;

always_comb begin
    if (neural_out[0] > thresh) begin
	i = 0;
    end
    else if (neural_out[1] > thresh) begin
	i = 1;
    end
    else if (neural_out[2] > thresh) begin
	i = 2;
    end
    else if (neural_out[3] > thresh) begin
	i = 3;
    end
    else if (neural_out[4] > thresh) begin
	i = 4;
    end
    else if (neural_out[5] > thresh) begin
	i = 5;
    end
    else if (neural_out[6] > thresh) begin
	i = 6;
    end
    else if (neural_out[7] > thresh) begin
	i = 7;
    end
    else if (neural_out[8] > thresh) begin
	i = 8;
    end
    else if (neural_out[9] > thresh) begin
	i = 9;
    end
    else begin
	i = 10;
    end

	//gfebcda
    case (i)
	4'b0000: seven = 8'h3F;
	4'b0001: seven = 8'h06;
	4'b0010: seven = 8'h5b;
	4'b0011: seven = 8'h4F;
	4'b0100: seven = 8'h66;
	4'b0101: seven = 8'h6D;
	4'b0110: seven = 8'h7D;
	4'b0111: seven = 8'h07;
	4'b1000: seven = 8'h7F;
	4'b1001: seven = 8'h6F;
	default: seven = 8'h00;
    endcase
end


endmodule