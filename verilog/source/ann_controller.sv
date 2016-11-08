// $Id: $
// File name:   controller.sv
// Created:     11/8/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: ANN Controller

module ann_controller
  (
    input wire image_loaded,
    input wire start,
    output reg max_input,
    output reg next_coeff,
    output reg load_next,
    output reg request,
    output reg done,
    output reg num_coeff
  );
