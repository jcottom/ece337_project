/*
 This module converts an unsigned 8-bit number to a half-precision floating
 point number, defined as binary16 in IEEE 754. This 16 bit number is formatted as follows:

 | sign | exponent | significand |
 | [15] | [14:10]  | [9:0]       |

 The number represented depends on the values of the exponent and the significand:

 |        exponent | significand = 0  | significand > 0   | number                                         |
 |           00000 | +0,-0            | subnormal numbers | -1^sign * 2^-14 * 0.significand_(2)            |
 | 00001,...,11110 | normalized value | <==               | -1^sign * 2^(exponent - 15) * 1.signficand_(2) |
 |           11111 | +-infinity       | NaN               |                                                |

 Some examples:
 | number | half representation |
 |      0 | 0 00000 0000000000  |
 |      1 | 0 01111 0000000000  |
 |      2 | 0 10000 0000000000  |
 |    128 | 0 10110 0000000000  |
 |    255 | 0 10110 1111110000  |
 |  65504 | 0 11110 1111111111  |

 */

module uint8_to_half (
                     input wire [7:0]   in,
                     output wire [15:0] out
                     );

   reg                                  sign;
   reg [4:0]                            exponent;
   reg [9:0]                            significand;

   // Converts uchar to half by looking for the most significant 1, setting the
   // exponent to 15 + binary place of MS1, and setting the most significant
   // bits of the significand to the bits following the MS1
   always_comb begin
      if(in & 8'd128 == 8'd128) begin
         exponent = 15 + 7;
         significand = {in[6:0], 3'd0};
      end else if(in & 8'd64 == 8'd64) begin
         exponent = 15 + 6;
         significand = {in[5:0], 4'd0};
      end else if(in & 8'd32 == 8'd32) begin
         exponent = 15 + 5;
         significand = {in[4:0], 5'd0};
      end else if(in & 8'd16 == 8'd16) begin
         exponent = 15 + 4;
         significand = {in[3:0], 6'd0};
      end else if(in & 8'd8 == 8'd8) begin
         exponent = 15 + 3;
         significand = {in[2:0], 7'd0};
      end else if(in & 8'd4 == 8'd4) begin
         exponent = 15 + 2;
         significand = {in[1:0], 8'd0};
      end else if(in & 8'd2 == 8'd2) begin
         exponent = 15 + 1;
         significand = {in[0], 9'd0};
      end else if(in & 8'd1 == 8'd1) begin
         exponent = 15;
         significand = 0;
      end else begin
         exponent = 0;
         significand = 0;
      end
   end // always_comb

   assign sign = 0; // input values are always unsigned
   assign out = {sign, exponent, significand};

endmodule // int_to_float
