# Step 1:  Read in the source file
analyze -format sverilog -lib WORK {flex_counter.sv input_node_timer.sv ann_controller.sv node.sv activation.sv fixed_point_add.sv fixed_point_mult.sv neural_to_seven.sv sync_low.sv new_activation.sv ANN.sv}
elaborate ANN -lib WORK
uniquify
# Step 2: Set design constraints
# Uncomment below to set timing, area, power, etc. constraints
# set_max_delay <delay> -from "<input>" -to "<output>"
# set_max_area <area>
# set_max_total_power <power> mW


# Step 3: Compile the design
compile -map_effort medium

# Step 4: Output reports
report_timing -path full -delay max -max_paths 1 -nworst 1 > reports/ANN.rep
report_area >> reports/ANN.rep
report_power -hier >> reports/ANN.rep

# Step 5: Output final VHDL and Verilog files
write_file -format verilog -hierarchy -output "mapped/ANN.v"
echo "\nScript Done\n"
echo "\nChecking Design\n"
check_design
quit
