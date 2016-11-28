module display(
               input wire [3:0]  in_num,
               output reg [6:0] digit [7:0]
               );
   parameter ZERO  = 7'b1000000;
   parameter ONE   = 7'b1111001;
   parameter TWO   = 7'b0100100;
   parameter THREE = 7'b0110000;
   parameter FOUR  = 7'b0011001;
   parameter FIVE  = 7'b0010010;
   parameter SIX   = 7'b0000010;
   parameter SEVEN = 7'b1111000;
   parameter EIGHT = 7'b0000000;
   parameter NINE  = 7'b0011000;
   parameter BLANK = 7'b1111111;

   // All other displays should be blank
   assign digit[7:1] = '{BLANK, BLANK, BLANK, BLANK, BLANK, BLANK, BLANK};

   // First display outputs prediction
   always_comb begin
      digit[0] = BLANK;
      case(in_num)
        4'h0: begin
           digit[0] = ZERO;
        end
        4'h1: begin
           digit[0] = ONE;
        end
        4'h2: begin
           digit[0] = TWO;
        end
        4'h3: begin
           digit[0] = THREE;
        end
        4'h4: begin
           digit[0] = FOUR;
        end
        4'h5: begin
           digit[0] = FIVE;
        end
        4'h6: begin
           digit[0] = SIX;
        end
        4'h7: begin
           digit[0] = SEVEN;
        end
        4'h8: begin
           digit[0] = EIGHT;
        end
        4'h9: begin
           digit[0] = NINE;
        end
      endcase // case (in_num)
   end


endmodule
