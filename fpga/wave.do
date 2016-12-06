onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/reset_n
add wave -noupdate /tb/dut/u0/sdram_interface/state
add wave -noupdate /tb/dut/u0/sdram_interface/master_address
add wave -noupdate /tb/dut/u0/sdram_interface/master_writedata
add wave -noupdate /tb/dut/u0/sdram_interface/master_write
add wave -noupdate /tb/dut/u0/sdram_interface/master_read
add wave -noupdate /tb/dut/u0/sdram_interface/master_readdata
add wave -noupdate /tb/dut/u0/sdram_interface/master_readdatavalid
add wave -noupdate /tb/dut/u0/sdram_interface/master_waitrequest
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_waitrequest
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_readdatavalid
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_readdata
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_write
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_read
add wave -noupdate /tb/dut/u0/mm_slave_bfm_0/avs_address
add wave -noupdate /tb/tb_busy
add wave -noupdate /tb/tb_image_data
add wave -noupdate /tb/tb_coeff_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3329730 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {8400 ns}
