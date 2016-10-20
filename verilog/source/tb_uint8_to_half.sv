`timescale 1ns / 100ps
module tb_uint8_to_half ();

   reg [7:0] tb_in;
   wire [15:0] tb_out;
   logic [7:0] ind;

   uint8_to_half DUT (tb_in, tb_out);

     initial begin
        for(ind = 0; ind < 256; ++ind) begin
           tb_in = ind;
           #5;
        end
     end

endmodule // int_to_float
