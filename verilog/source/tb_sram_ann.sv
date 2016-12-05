// $Id: $
// File name:   tb_sram_ann.sv
// Created:     12/4/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Test Bench for SRAM wrapper file

module tb_sram_ann ();

	reg tb_clk;
	reg tb_n_rst;
	reg [6:0] tb_coef_select;
	reg tb_i_loaded;
	reg tb_p_done;
	reg [31:0] tb_read_data;
	reg tb_start_address;
	reg [9:0] tb_address;
	reg tb_read;

	sram_ann (.clk(tb_clk), .n_rst(tb_n_rst), .coef_select(tb_coef_select), .i_loaded(tb_i_loaded), .p_done(tb_p_done), .read_date(tb_read_data), start_address(tb_start_address), .address(tb_address), .read(tb_read));
	
endmodule 
