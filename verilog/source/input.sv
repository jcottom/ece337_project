// $Id: $
// File name:   input.sv
// Created:     11/8/2016
// Author:      Cheyenne Martinez
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Input to node timer

module input
  (
    input wire max,
    input wire next,
    input wire math_done,
    output reg done,
    output reg start_math,
    output reg input_num
  );
  
  
