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
	wire image_weights_loaded;
	reg [15:0] image [IMAGE_SIZE - 1:0];
	reg [15:0] weights [FIRST_LAYER - 1:0][IMAGE_SIZE - 1:0];
	reg request_coef;
	reg [1:0] coef_select;
	reg [15:0] ANN_pipeline_register [IMAGE_SIZE - 1:0];

   wire [IMAGE_SIZE*16-1:0] image_o;
   wire [FIRST_LAYER*IMAGE_SIZE*16-1:0] weights_o;

	reg nxt_loaded, loaded;

   genvar                                 i;
   genvar                                 j;
   genvar                                 k;

   generate
      for(i = 0; i < IMAGE_SIZE; i = i + 1) begin
         for (k = 0; k < 16; k = k +1) begin
            assign image_o[i*16 + k] = image[i][k];
         end
      end

      for(i = 0; i < IMAGE_SIZE; i = i + 1) begin
         for(j = 0; j < FIRST_LAYER; j = j + 1) begin
            for (k = 0; k < 16; k = k +1) begin
               assign weights_o[k + 16*j + IMAGE_SIZE*i] = weights[i][j][k];
            end
         end
      end
   endgenerate

   ANN   u1 (
             .clk(clk),
             .n_rst(n_reset),
             .image_weights_loaded(image_weights_loaded),
             .start_detecting(start_detecting),
             .image(image),
             .weights(weights),
             .done_processing(done_processing),
             .request_coef(request_coef),
             .coef_select(coef_select),
             .seven_seg(seven_seg),
             .ANN_pipeline_register(ANN_pipeline_register));

   verification_bus u0(.top_level_get_data(request_coef),
                       .top_level_which_data(coef_select) ,
                       .top_level_image_data(image_o),
                       .top_level_coeff_data(weights_o),
                       .clk_clk             (clk),
                       .reset_reset_n       (n_reset),
                       .top_level_busy(nxt_loaded)); //This might need to be negated

assign image_weights_loaded = (loaded == 1)&(nxt_loaded==0);

always_ff @ (posedge clk, negedge n_reset) begin
	if (n_reset == 0) begin
		loaded <= 0;
	end
	else begin
		loaded <= nxt_loaded;	
	end
end

endmodule
