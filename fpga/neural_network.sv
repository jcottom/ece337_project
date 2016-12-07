module neural_network(
                      // Clock
                      input logic         CLOCK_50 ,
                      input logic [3:0]   KEY ,

                      // SDRAM signals
                      output logic [11:0] DRAM_ADDR,
                      output logic [1:0]  DRAM_BA,
                      output logic        DRAM_CAS_N,
                      output logic        DRAM_CKE,
                      output logic        DRAM_CLK,
                      output logic        DRAM_CS_N,
                      inout logic [31:0]  DRAM_DQ,
                      output logic [3:0]  DRAM_DQM,
                      output logic        DRAM_RAS_N,
                      output logic        DRAM_WE_N,

                      // PCIE signals
                      input logic         PCIE_PERST_N,
                      input logic         PCIE_REFCLK_P,
                      input logic         PCIE_RX_P,
                      output logic        PCIE_TX_P,
                      output logic        PCIE_WAKE_N,

                      // Fan control
                      inout logic         FAN_CTRL,

                      // Seven-segment displays
                      output logic [6:0]  HEX0,
                      output logic [6:0]  HEX1,
                      output logic [6:0]  HEX2,
                      output logic [6:0]  HEX3,
                      output logic [6:0]  HEX4,
                      output logic [6:0]  HEX5,
                      output logic [6:0]  HEX6,
                      output logic [6:0]  HEX7
                      );

   localparam IMSIZE = 128;
   localparam CSIZE = (64*16 + 16*8 + 8*10)*2;
   localparam LBITS = 2;

   wire                                   get_data;
   wire [LBITS-1:0]                       which_data;
   wire                                   busy;
   wire [IMSIZE-1:0][7:0]                 image_data;
   wire [CSIZE-1:0][7:0]                  coeff_data;

   // Assigments
   //assign DRAM_CLK = CLOCK_50;
   assign FAN_CTRL = 1'b0; // This fan is way too loud

   // Instantiate 7-segment display controller
   display DISPLAY (4'h4, '{HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7});

   // Instantiate interface to SDRAM
   neural_network_bus BUS_INST (
                                .clk_clk                     (CLOCK_50),                                  //                         clk.clk
                                .reset_reset_n               (KEY[0]),                            //                       reset.reset_n
                                // To other submodules
                                .top_level_busy              (busy),              //         top_level.busy
                                .top_level_coeff_data        (coeff_data),        //                  .coeff_data
                                .top_level_image_data        (image_data),        //                  .image_data
                                .top_level_which_data        (which_data),             //                  .layer
                                .top_level_get_data          (get_data),         //                  .get_coeffs
                                // To SDRAM
                                .sdram_addr                  (DRAM_ADDR),                          //                  sdram_wire.addr
                                .sdram_ba                    (DRAM_BA),                            //                            .ba
                                .sdram_cas_n                 (DRAM_CAS_N),                         //                            .cas_n
                                .sdram_cke                   (DRAM_CKE),                           //                            .cke
                                .sdram_cs_n                  (DRAM_CS_N),                          //                            .cs_n
                                .sdram_dq                    (DRAM_DQ),                            //                            .dq
                                .sdram_dqm                   (DRAM_DQM),                           //                            .dqm
                                .sdram_ras_n                 (DRAM_RAS_N),                         //                            .ras_n
                                .sdram_we_n                  (DRAM_WE_N),                           //                            .we_n
                                // To PLL
                                .altpll_sdram_clk            (DRAM_CLK),            //      altpll_sdram.clk
                                // To PCIE
                                .pcie_ip_rx_in_rx_datain_0   (PCIE_RX_P),   //     pcie_ip_rx_in.rx_datain_0
                                .pcie_ip_tx_out_tx_dataout_0 (PCIE_TX_P), //    pcie_ip_tx_out.tx_dataout_0
                                .pcie_ip_pcie_rstn_export    (PCIE_PERST_N),    // pcie_ip_pcie_rstn.export
                                .pcie_ip_refclk_export       (PCIE_REFCLK_P)       //    pcie_ip_refclk.export
                                );

endmodule
