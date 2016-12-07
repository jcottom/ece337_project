
/*
 This module serves to verify the behavior of the neural network using a different Qsys configuration, called verifcation_bus
 */
module nn_test #(
                 parameter IMBITS = 6,
                 parameter IMSIZE = 64,
                 parameter CBITS = 11,
                 parameter CSIZE = 2048, // # of 8bit values
                 parameter LBITS = 2
                 )(
                   // Clock
                   input logic                   clock ,
                   input logic                   reset_n ,
                   input wire                    get_coeffs,
                   input wire                    get_image,
                   input wire [LBITS-1:0]        layer,
                   output wire                   busy
                   //output wire [IMSIZE-1:0][7:0] image_data,
                   //output wire [CSIZE-1:0][7:0]  coeff_data
                   );



   // Assigments
   //assign DRAM_CLK = CLOCK_50;

   // Instantiate 7-segment display controller
   //display DISPLAY (4'h4, '{HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7});

   // Instantiate interface to SDRAM
   verification_bus u0 (
		                    .top_level_busy      (busy),
		                    .top_level_get_image (get_image),
		                    .top_level_layer     (layer),
		                    .top_level_get_coeffs(get_coeffs),
		                    .top_level_image_data(image_data),
		                    .top_level_coeff_data(coeff_data)
		                    //.clk_clk             (clock),
		                    //.reset_reset_n       (reset_n)
	                       );
   /*
   verification_bus u0 (
                              .clk_clk                     (clock),                                  //                         clk.clk
                              .reset_reset_n               (reset_n),                            //                       reset.reset_n
                              // To other submodules
                              .top_level_busy              (busy),              //         top_level.busy
                              .top_level_cd0               (coeff_data[CSIZE-1:CSIZE*15/16]),        //                  .coeff_data
                              .top_level_cd1               (coeff_data[CSIZE*15/16-1:CSIZE*14/16]),        //                  .coeff_data
                              .top_level_cd2               (coeff_data[CSIZE*14/16-1:CSIZE*13/16]),        //                  .coeff_data
                              .top_level_cd3               (coeff_data[CSIZE*13/16-1:CSIZE*12/16]),        //                  .coeff_data
                              .top_level_cd4               (coeff_data[CSIZE*12/16-1:CSIZE*11/16]),        //                  .coeff_data
                              .top_level_cd5               (coeff_data[CSIZE*11/16-1:CSIZE*10/16]),        //                  .coeff_data
                              .top_level_cd6               (coeff_data[CSIZE*10/16-1:CSIZE*9/16]),        //                  .coeff_data
                              .top_level_cd7               (coeff_data[CSIZE*9/16-1:CSIZE*8/16]),        //                  .coeff_data
                              .top_level_cd8               (coeff_data[CSIZE*8/16-1:CSIZE*7/16]),        //                  .coeff_data
                              .top_level_cd9               (coeff_data[CSIZE*7/16-1:CSIZE*6/16]),        //                  .coeff_data
                              .top_level_cd10              (coeff_data[CSIZE*6/16-1:CSIZE*5/16]),        //                  .coeff_data
                              .top_level_cd11              (coeff_data[CSIZE*5/16-1:CSIZE*4/16]),        //                  .coeff_data
                              .top_level_cd12              (coeff_data[CSIZE*4/16-1:CSIZE*3/16]),        //                  .coeff_data
                              .top_level_cd13              (coeff_data[CSIZE*3/16-1:CSIZE*2/16]),        //                  .coeff_data
                              .top_level_cd14              (coeff_data[CSIZE*2/16-1:CSIZE*1/16]),        //                  .coeff_data
                              .top_level_cd15              (coeff_data[CSIZE*1/16-1:0]),        //                  .coeff_data
                              .top_level_get_image         (get_image),         //                  .get_image
                              .top_level_image_data        (image_data),        //                  .image_data
                              .top_level_layer             (layer),             //                  .layer
                              .top_level_get_coeffs        (get_coeffs)         //                  .get_coeffs
                              );

    */
endmodule
