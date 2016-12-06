module tb_neural_network();
   // Clock
   logic         CLOCK_50 ;
   logic [3:0]   KEY ;

   // SDRAM signals
   logic [11:0]  DRAM_ADDR;
   logic [1:0]   DRAM_BA;
   logic         DRAM_CAS_N;
   logic         DRAM_CKE;
   logic         DRAM_CLK;
   logic         DRAM_CS_N;
   logic [31:0]  DRAM_DQ;
   logic [3:0]   DRAM_DQM;
   logic         DRAM_RAS_N;
   logic         DRAM_WE_N;
   // Seven-segment displays
   logic [6:0]   HEX0;
   logic [6:0]   HEX1;
   logic [6:0]   HEX2;
   logic [6:0]   HEX3;
   logic [6:0]   HEX4;
   logic [6:0]   HEX5;
   logic [6:0]   HEX6;
   logic [6:0]   HEX7;

   neural_network NET_INST (CLOCK_50 , KEY , DRAM_ADDR, DRAM_BA, DRAM_CAS_N, DRAM_CKE, DRAM_CLK, DRAM_CS_N, DRAM_DQ, DRAM_DQM, DRAM_RAS_N, DRAM_WE_N, plays HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);


   localparam CLK_PERIOD = 20ns;
   always begin
      #(CLK_PERIOD/2)
      CLOCK_50 = 1'b1;
      #(CLK_PERIOD/2)
      CLOCK_50 = 1'b0;
   end

   initial begin

   end



endmodule // tb_neural_network
