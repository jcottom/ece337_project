// custom_master_slave module : Acts as an avalon slave to receive input commands from PCIE IP

module sdram_interface #(
                         parameter MASTER_ADDRESSWIDTH = 26 ,  	// ADDRESSWIDTH specifies how many addresses the Master can address
                         //parameter SLAVE_ADDRESSWIDTH = 3 ,  	// ADDRESSWIDTH specifies how many addresses the slave needs to be mapped to. log(NUMREGS)
                         parameter DATAWIDTH = 8 ,    		// DATAWIDTH specifies the data width. Default 32 bits
                         parameter NUMREGS = 8 ,       		// Number of Internal Registers for Custom Logic
                         parameter REGWIDTH = 32,       		// Data Width for the Internal Registers. Default 32 bits

                         // My additions
                         parameter IMBITS = 6,
                         parameter CBITS = 11,
                         parameter NUMLAYERS = 2     // ciel( log2( number of layers in network = 3 ) )
                         )
   (
    input logic                            clk,
    input logic                            reset_n,

    // Interface to Top Level
    input wire                             get_image, // Pulsed high when an image is needed
    input wire                             get_coeffs, // Pulsed high when layer coefficients are needed
    input wire [NUMLAYERS-1:0]             layer, // Specifies which layer to retrieve
    output wire [64*8-1:0]                 image_data_o, // Contains all 64 pixels of image data
    output reg [128*8-1:0]                 coeff_data_0, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_1, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_2, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_3, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_4, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_5, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_6, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_7, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_8, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_9, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_10, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_11, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_12, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_13, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_14, // Contains all coefficients for requested layer
    output reg [128*8-1:0]                 coeff_data_15, // Contains all coefficients for requested layer
    output reg                             busy, // Set high when reading data

    // Bus Master Interface
    output logic [MASTER_ADDRESSWIDTH-1:0] master_address,
    output logic [DATAWIDTH-1:0]           master_writedata,
    output logic                           master_write,
    output logic                           master_read,
    input logic [DATAWIDTH-1:0]            master_readdata,
    input logic                            master_readdatavalid,
    input logic                            master_waitrequest

    // My additions
    //output reg [MAXREAD-1:0]               master_burstcount, There doesn't appear to be burst capability on the SDRAM controller, which is a shame.

    );
   localparam IMSIZE = 64;      // Size of input image (8x8 pixels)
   localparam L0SIZE = 64*16*2; // Number of coefficients in layer 0 times size of coefficient
   localparam L1SIZE = 16*4*2;  // Size of layer 1 coefficients
   localparam L2SIZE = 4*10*2;  // Size of layer 2 coefficients

   logic [IMBITS-1:0][7:0]                 image_data;
   logic [CBITS-1:0][7:0]                  coeff_data;


   localparam START_BYTE = 32'hF00BF00B;
   localparam STOP_BYTE = 32'hDEADF00B;
   localparam SDRAM_ADDR = 32'h08000000;

   logic [MASTER_ADDRESSWIDTH-1:0]         address, nextAddress;
   logic [DATAWIDTH-1:0]                   nextRead_data, read_data;
   logic [DATAWIDTH-1:0]                   nextData, wr_data;
   logic [NUMREGS-1:0][REGWIDTH-1:0]       csr_registers;  		// Command and Status Registers (CSR) for custom logic
   logic [NUMREGS-1:0]                     reg_index, nextRegIndex;
   logic [NUMREGS-1:0][REGWIDTH-1:0]       read_data_registers;  //Store SDRAM read data for display
   logic                                   new_image_data_flag;
   logic                                   new_coeff_data_flag;

   typedef enum                            {IDLE, IMREAD, L0READ, L1READ, L2READ} state_t;
   state_t state, nextState;

   assign image_data_o = image_data;
   //assign coeff_data_o = coeff_data;
   assign {coeff_data_0, coeff_data_1, coeff_data_2, coeff_data_3, coeff_data_4, coeff_data_5, coeff_data_6, coeff_data_7, coeff_data_8, coeff_data_9, coeff_data_10, coeff_data_11, coeff_data_12, coeff_data_13, coeff_data_14, coeff_data_15} = coeff_data;

   // Master Side

   always_ff @ ( posedge clk, negedge reset_n) begin
      if (!reset_n) begin
         address <= SDRAM_ADDR;
         reg_index <= 0;
         state <= IDLE;
         wr_data <= 0 ;
         read_data <= 32'hFEEDFEED;
         read_data_registers <= '0;
      end else begin
         //$display("%t state: %d, nextState: %d", $time, state, nextState);
         state <= nextState;
         address <= nextAddress;
         reg_index <= nextRegIndex;
         wr_data <= nextData;
         //read_data <= nextRead_data;
         if(new_image_data_flag)
           image_data[reg_index] <= nextRead_data;
         if(new_coeff_data_flag)
           coeff_data[reg_index] <= nextRead_data;
      end
   end

   // Next State Logic
   // If user wants to input data and addresses using a state machine instead of signals/conditions,
   // the following code has commented lines for how this could be done.
   always_comb begin
      nextState = state;
      nextAddress = address;
      nextRegIndex = reg_index;
      //nextData = wr_data;
      nextRead_data = master_readdata;
      new_image_data_flag = 0;
      new_coeff_data_flag = 0;
      case( state )
        IDLE : begin
           nextAddress = SDRAM_ADDR;
           nextRegIndex = 0;
           if (get_image && address >= SDRAM_ADDR) begin
              //$display("%t address: %h, SDRAM_ADDR: %h, get_image: %b", $time, address, SDRAM_ADDR, get_image);
              nextState = IMREAD;
           end else if (get_coeffs && layer == 2'h0 && address >= SDRAM_ADDR) begin
              nextState = L0READ;
              nextAddress = SDRAM_ADDR + IMSIZE;
           end else if (get_coeffs && layer == 2'h1 && address >= SDRAM_ADDR) begin
              nextState = L1READ;
              nextAddress = SDRAM_ADDR + IMSIZE + L0SIZE;
           end else if (get_coeffs && layer == 2'h2 && address >= SDRAM_ADDR) begin
              nextState = L2READ;
              nextAddress = SDRAM_ADDR + IMSIZE + L0SIZE + L1SIZE;
           end
        end
        IMREAD : begin
           if (reg_index >= IMSIZE) begin
              nextState = IDLE;
           end else begin
              if (!master_waitrequest) begin
                 nextAddress = address + 1;
              end
              if (master_readdatavalid) begin
                 new_image_data_flag = 1;
                 nextRegIndex = reg_index + 1;
              end
           end
        end
        L0READ : begin
           if (reg_index >= L0SIZE) begin
              nextState = IDLE;
           end else begin
              if (!master_waitrequest) begin
                 nextAddress = address + 1;
              end
              if (master_readdatavalid) begin
                 new_coeff_data_flag = 1;
                 nextRegIndex = reg_index + 1;
              end
           end
        end
        L1READ : begin
           if (reg_index >= L1SIZE) begin
              nextState = IDLE;
           end else begin
              if (!master_waitrequest) begin
                 nextAddress = address + 1;
              end
              if (master_readdatavalid) begin
                 new_coeff_data_flag = 1;
                 nextRegIndex = reg_index + 1;
              end
           end
        end
        L2READ : begin
           if (reg_index >= L2SIZE) begin
              nextState = IDLE;
           end else begin
              if (!master_waitrequest) begin
                 nextAddress = address + 1;
              end
              if (master_readdatavalid) begin
                 new_coeff_data_flag = 1;
                 nextRegIndex = reg_index + 1;
              end
           end
        end
      endcase
   end

   // Output Logic

   always_comb begin
      master_write = 1'b0;
      master_read = 1'b0;
      master_writedata = 32'h0;
      master_address = 32'hbad1bad1;
      busy = 1'b1;

      case(state)
        IDLE: begin
           busy = 1'b0;
        end
        IMREAD : begin
           if( address >= SDRAM_ADDR + IMSIZE) begin
              master_read = 0;
           end else begin
              master_read = 1;
           end
           master_address = address;
        end
        L0READ : begin
           if( address >= SDRAM_ADDR + IMSIZE + L0SIZE) begin
              master_read = 0;
           end else begin
              master_read = 1;
           end
           master_address = address;
        end
        L1READ : begin
           if( address >= SDRAM_ADDR + IMSIZE + L0SIZE + L1SIZE) begin
              master_read = 0;
           end else begin
              master_read = 1;
           end
           master_address = address;
        end
        L2READ : begin
           if( address >= SDRAM_ADDR + IMSIZE + L0SIZE + L1SIZE + L2SIZE) begin
              master_read = 0;
           end else begin
              master_read = 1;
           end
           master_address = address;
        end
      endcase
   end

endmodule
