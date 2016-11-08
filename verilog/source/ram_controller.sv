// $Id: $
// File name:   ram_controller.sv
// Created:     11/8/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: RAM Controller

module ram_controller
  (
    input wire start_detect,
    input wire request,
    output reg start_sram,
    output reg image,
    output reg image_load
  );
