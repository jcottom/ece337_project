`timescale 1ns / 10ps
module tb_nn_test ();

   localparam CLK_PERIOD = 20ns;

   reg                tb_clk;
   reg                tb_nrst;
   reg                tb_get_coeffs;
   reg                tb_get_image;
   reg [1:0]          tb_layer;
   reg                tb_busy;
   reg [63:0][7:0]    tb_image_data;
   reg [1023:0][15:0] tb_coeff_data;

   nn_test DUT (tb_clk, tb_nrst, tb_get_coeffs, tb_get_image, tb_layer, tb_busy, tb_image_data, tb_coeff_data);

   always begin
      tb_clk = 1'b1;
      #(CLK_PERIOD/2);
      tb_clk = 1'b0;
      #(CLK_PERIOD/2);
   end

   test_program tp();

   initial begin
      tb_nrst = 1'b0;
      tb_get_coeffs = 1'b0;
      tb_get_image = 1'b0;
      tb_layer = 2'b00;

      #(CLK_PERIOD);
      tb_nrst = 1'b1;

      #(CLK_PERIOD*2);
      @(negedge tb_clk);
      tb_get_image = 1'b1;
      #(CLK_PERIOD);
      tb_get_image = 1'b0;

   end

endmodule
