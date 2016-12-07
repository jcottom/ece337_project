`timescale 1ns / 1ns

module tb ();

   logic clk    = 1'b0;
   logic reset_n  = 1'b0;

   // logic rdwr_cntl = 1'b1;
   // logic n_action = 1'b1;
   // logic [25:0] address = 26'b0;

   /*
   reg                tb_get_coeffs;
   reg                tb_get_image;
   reg [1:0]          tb_layer;
   reg                tb_busy;
   reg [63:0][7:0]    tb_image_data;
   reg [1023:0][15:0] tb_coeff_data;

    */
   localparam  CLOCK_PERIOD            = 20; // Clock period in ns
   localparam  INITIAL_RESET_CYCLES    = 2;  // Number of cycles to reset when simulation starts

	 reg                tb_done_processing;
	 reg                tb_start_detecting;
	 reg [7:0]          tb_seven_seg;
	 reg [9:0]          tb_image_address;

   //nn_test dut (clk, reset_n, tb_get_coeffs, tb_get_image, tb_layer, tb_busy, tb_image_data, tb_coeff_data);
   top_ann dut (
	              .clk(clk),
	              .n_reset(reset_n),
	              .start_detecting(tb_start_detecting),
	              .image_address(tb_image_address),
	              .seven_seg(tb_seven_seg),
	              .done_processing(tb_done_processing)
                );

   test_program  tp();

   // Clock signal generator
   always begin
      #(CLOCK_PERIOD / 2);
      clk = ~clk;
   end



   // Initial reset
   initial begin
      reset_n = 1'b0;
      repeat(INITIAL_RESET_CYCLES) @(posedge clk);
      reset_n = 1'b1;

   end

endmodule
