onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {clock and reset}
add wave -noupdate /tb/clk
add wave -noupdate /tb/reset_n
add wave -noupdate -divider {top_ann signals}
add wave -noupdate /tb/dut/image
add wave -noupdate /tb/dut/weights
add wave -noupdate /tb/dut/image_o
add wave -noupdate /tb/dut/weights_o
add wave -noupdate /tb/dut/request_coef
add wave -noupdate /tb/dut/image_weights_loaded
add wave -noupdate -divider {verification_bus signals}
add wave -noupdate /tb/dut/u0/top_level_image_data
add wave -noupdate /tb/dut/u0/top_level_coeff_data
add wave -noupdate -divider {sdram_interface signals}
add wave -noupdate /tb/dut/u0/sdram_interface/image_data_o
add wave -noupdate /tb/dut/u0/sdram_interface/coeff_data_o
add wave -noupdate /tb/dut/u0/sdram_interface/image_data
add wave -noupdate /tb/dut/u0/sdram_interface/coeff_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13235294 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {105 us}
