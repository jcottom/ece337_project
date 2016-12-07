onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {clock and reset}
add wave -noupdate /tb/clk
add wave -noupdate /tb/reset_n
add wave -noupdate -divider {top_ann signals}
add wave -noupdate /tb/dut/image
add wave -noupdate -radix binary -subitemconfig {{/tb/dut/weights[15]} {-childformat {{{/tb/dut/weights[15][63]} -radix binary} {{/tb/dut/weights[15][0]} -radix binary}}} {/tb/dut/weights[15][63]} {-radix binary} {/tb/dut/weights[15][0]} {-radix binary} {/tb/dut/weights[0]} {-childformat {{{/tb/dut/weights[0][63]} -radix hexadecimal} {{/tb/dut/weights[0][0]} -radix hexadecimal}}} {/tb/dut/weights[0][63]} {-radix hexadecimal} {/tb/dut/weights[0][0]} {-radix hexadecimal}} /tb/dut/weights
add wave -noupdate /tb/dut/image_o
add wave -noupdate /tb/dut/weights_o
add wave -noupdate /tb/dut/request_coef
add wave -noupdate /tb/dut/image_weights_loaded
add wave -noupdate -divider {verification_bus signals}
add wave -noupdate /tb/dut/u0/top_level_image_data
add wave -noupdate /tb/dut/u0/top_level_coeff_data
add wave -noupdate /tb/dut/u0/top_level_get_data
add wave -noupdate /tb/dut/u0/top_level_which_data
add wave -noupdate /tb/dut/u0/top_level_busy
add wave -noupdate -divider {sdram_interface signals}
add wave -noupdate /tb/dut/u0/sdram_interface/image_data_o
add wave -noupdate /tb/dut/u0/sdram_interface/coeff_data_o
add wave -noupdate /tb/dut/u0/sdram_interface/image_data
add wave -noupdate /tb/dut/u0/sdram_interface/coeff_data
add wave -noupdate /tb/dut/u0/sdram_interface/get_data
add wave -noupdate /tb/dut/u0/sdram_interface/which_data
add wave -noupdate /tb/dut/u0/sdram_interface/busy
add wave -noupdate /tb/dut/u0/sdram_interface/state
add wave -noupdate /tb/dut/u0/sdram_interface/address
add wave -noupdate /tb/dut/u0/sdram_interface/master_address
add wave -noupdate -divider {avalon bfm slave}
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_waitrequest
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_readdatavalid
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_readdata
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_write
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_read
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {196021279 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 191
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
WaveRestoreZoom {194950397 ps} {197100694 ps}
