typedef struct packed {
   reg         sign;
   reg [4:0]   expo;
   reg [9:0]   mant;
} half;
