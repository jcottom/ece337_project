/*
 Returns the sum of a and b
 */

module half_add(
                input wire        clk,
                input wire        nrst,
                input wire [15:0] a,
                input wire [15:0] b,
                output reg [15:0] out
                );

   reg                           signa; // sign of a
   reg                           signb; // sign of b
   reg [4:0]                     expa;  // exponent of a
   reg [4:0]                     expb;  // exponent of b
   reg [9:0]                     manta; // mantissa of a
   reg [9:0]                     mantb; // mantissa of b

   reg [4:0]                      diff;


   // State registers for state
   typedef enum {UNPACK, DIFF, ALIGN, ADD} stateType;
   stateType state, next_state;

   // State FF for state
   always @ ( posedge clk, negedge nrst ) begin
      if (!nrst) state <= DIFF; else
        state <= next_state;
   end

   // Next State Logic for state
   always_comb begin
      case (state)
        UNPACK: begin
           signa = a[15];
           signb = b[15];
           expa = a[14:10];
           expb = b[14:10];
           manta = a[9:0];
           mantb = b[9:0];

           next_state = DIFF;
        end
        DIFF: begin
           if(expa >= expb) begin
              diff = expa - expb;
              expb = expa;
              mantb = mantb >> diff;
           end else begin
              diff = expb - expa;
              expa = expb;
              manta = manta >> diff;
           end
           next_state = ALIGN;
        end
        ALIGN: begin
           next_state = ADD;
        end
        ADD: begin
           next_state = DIFF;
        end
      endcase // case (state)
   end // always @ (...

endmodule // half_add
