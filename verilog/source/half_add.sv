/*
 Returns the sum of a and b
 */

`include "half.sv"
module half_add(
                input wire clk,
                input wire nrst,
                input wire enable,
                input      half in1,
                input      half in2,
                output     half out
                );

   half a;
   half b;

   reg [4:0]               diff;
   reg                     guard;
   reg                     round;
   reg                     sticky;

   logic                   ind;


   // State registers for state
   typedef enum            {UNPACK, ALIGN, ADD, ZERO, WAIT} stateType;
   stateType state, next_state;

   // State FF for state
   always @ ( posedge clk, negedge nrst ) begin
      if (!nrst) state <= UNPACK; else
        state <= next_state;
   end

   // Next State Logic for state
   always_comb begin
      //guard = 1'b1;
      //round = 1'b1;
      //sticky = 1'b1;
      next_state = UNPACK;

      case (state)
        UNPACK: begin
           if (!enable) next_state = UNPACK;
           else begin
              if (in1 == 16'b0) begin
                 a = in2;
                 next_state = ZERO;
              end else if (in2 == 16'b0) begin
                 a = in1;
                 next_state = ZERO;
              end else begin
                 // a.mant >= b.mant
                 if(in1[14:10] >= in2[14:10]) begin
                    a = in1;
                    b = in2;
                 end else begin
                    b = in1;
                    a = in2;
                 end
                 next_state = ALIGN;
              end // else: !if(in2 == 16'b0)
           end // else: !if(!enable)
        end
        ALIGN: begin
           // Shift lower mantissa to the right by the difference of exponents
           diff = a.expo - b.expo;
           $display("diff = %b - %b = %b", a.expo, b.expo, diff);
           //                        shifts by 1       shifts by remainder of diff
           if (diff != 0)
             {b.mant, guard, round} = {1'b1, b.mant, 1'b0} >> (diff - 1);
           else
             {guard, round} = {1'b0, 1'b0};

           out.expo = a.expo;

           sticky = 1'b0;
           if (diff > 9) begin
              for (ind = 0; ind < 9; ind = ind + 1) begin
                 if(b.mant[ind] == 1'b1) sticky = 1'b1;
              end
           end else begin
              for (ind = 0; ind < diff; ind = ind + 1) begin
                 if(b.mant[ind] == 1'b1) sticky = 1'b1;
              end
           end
           next_state = ADD;
        end
        ADD: begin
           if (a.sign == b.sign) begin
              out.sign = a.sign;
              out.mant = a.mant + b.mant;
           end
           else if (a.sign > b.sign)
             next_state = UNPACK;
        end
        ZERO: begin
           out = a;
           next_state = WAIT;
        end
        WAIT: begin
           next_state = UNPACK;
        end
      endcase // case (state)
   end // always @ (...

endmodule // half_add
