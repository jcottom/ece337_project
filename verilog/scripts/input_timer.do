onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_input_node_timer/tb_clk
add wave -noupdate /tb_input_node_timer/tb_n_rst
add wave -noupdate -radix decimal /tb_input_node_timer/tb_max_input
add wave -noupdate /tb_input_node_timer/tb_coef_ready
add wave -noupdate /tb_input_node_timer/tb_n_start_done
add wave -noupdate -radix unsigned /tb_input_node_timer/tb_input_num
add wave -noupdate -group counter /tb_input_node_timer/DUT/counter/clk
add wave -noupdate -group counter /tb_input_node_timer/DUT/counter/n_rst
add wave -noupdate -group counter /tb_input_node_timer/DUT/counter/clear
add wave -noupdate -group counter /tb_input_node_timer/DUT/counter/count_enable
add wave -noupdate -group counter /tb_input_node_timer/DUT/counter/rollover_val
add wave -noupdate -group counter /tb_input_node_timer/DUT/counter/count_out
add wave -noupdate -group counter /tb_input_node_timer/DUT/counter/rollover_flag
add wave -noupdate -group counter /tb_input_node_timer/DUT/counter/nxt_cnt
add wave -noupdate -group counter /tb_input_node_timer/DUT/counter/nxt_rollover
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {71881 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {110122 ps}
