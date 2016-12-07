// $Id: $
// File name:   top_ann.sv
// Created:     12/7/2016
// Author:      Taylor Lipson
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Top level diagram

module top_ann 
(
	input wire clk,
	input wire n_reset,
	input wire start_detecting,
	input wire [9:0] image_address,
	output reg [7:0] seven_seg,
	output reg done_processing
);
	parameter IMAGE_SIZE = 64;
	parameter FIRST_LAYER = 16;
	reg image_weights_loaded;
	reg [15:0] image [IMAGE_SIZE - 1:0];
	reg [15:0] weights [FIRST_LAYER - 1:0][IMAGE_SIZE - 1:0];
	reg request_coef;
	reg [1:0] coef_select;
	reg [15:0] ANN_pipeline_register [IMAGE_SIZE - 1:0];

	ANN    U1(.clk(clk), .n_rst(n_reset), 
		.image_weights_loaded(image_weights_loaded), .start_detecting(start_detecting), 
		.image(image), .weights(weights), .done_processing(done_processing), .request_coef(request_coef),
		.coef_select(coef_select), .seven_seg(seven_seg), .ANN_pipline_register(ANN_pipeline_register));

	verification_bus U2(.top_level_get_data(request_coef), 
			.top_level_which_data(coef_select) ,
			.top_level_image_data_o(image),
			.top_level_coeff_data_o(weights),
			.top_level_busy(image_weights_loaded); //This might need to be negated

endmodule
