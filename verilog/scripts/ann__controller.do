onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ann_controller/tb_clk
add wave -noupdate /tb_ann_controller/tb_n_rst
add wave -noupdate /tb_ann_controller/tb_image_weights_loaded
add wave -noupdate /tb_ann_controller/tb_n_start_done
add wave -noupdate -radix decimal /tb_ann_controller/tb_max_input
add wave -noupdate /tb_ann_controller/tb_coeff_ready
add wave -noupdate /tb_ann_controller/tb_reset_accum
add wave -noupdate /tb_ann_controller/tb_load_next
add wave -noupdate /tb_ann_controller/tb_request_coef
add wave -noupdate /tb_ann_controller/tb_done_processing
add wave -noupdate -expand -group ann_controller /tb_ann_controller/DUT/max_layers
add wave -noupdate -expand -group ann_controller /tb_ann_controller/DUT/state
add wave -noupdate -expand -group ann_controller /tb_ann_controller/DUT/nxt_state
add wave -noupdate -expand -group ann_controller -radix decimal /tb_ann_controller/DUT/cur_layer
add wave -noupdate -expand -group ann_controller -radix decimal /tb_ann_controller/DUT/nxt_layer
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {123256 ps} 0}
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
WaveRestoreZoom {0 ps} {2100 ns}
