`timescale 1ns / 1ns

module tb ();

   logic clk    = 1'b0;
   logic reset_n  = 1'b0;

   // logic rdwr_cntl = 1'b1;
   // logic n_action = 1'b1;
   // logic [25:0] address = 26'b0;

   reg                tb_get_coeffs;
   reg                tb_get_image;
   reg [1:0]          tb_layer;
   reg                tb_busy;
   reg [63:0][7:0]    tb_image_data;
   reg [1023:0][15:0] tb_coeff_data;

   localparam  CLOCK_PERIOD            = 20; // Clock period in ns
   localparam  INITIAL_RESET_CYCLES    = 20;  // Number of cycles to reset when simulation starts

   nn_test dut (clk, reset_n, tb_get_coeffs, tb_get_image, tb_layer, tb_busy, tb_image_data, tb_coeff_data);

   test_program  tp();

   // Clock signal generator
   always begin
      #(CLOCK_PERIOD / 2);
      clk = ~clk;
   end



   // Initial reset
   initial begin
      repeat(INITIAL_RESET_CYCLES) @(posedge clk);
      reset_n = 1'b1;

   end

endmodule
