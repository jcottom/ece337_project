# setup variables for simulation script
set system_name      verification_bus
set BASE_DIR         ./
set ANN_DIR          ../verilog/source/
set QSYS_SIMDIR      $BASE_DIR$system_name/simulation
set TOP_LEVEL_NAME   tb
source $QSYS_SIMDIR/mentor/msim_setup.tcl

# compile system
dev_com
com

# compile ann stuff
vlog -sv $ANN_DIR/ann_controller.sv
vlog -sv $ANN_DIR/fixed_point_add.sv
vlog -sv $ANN_DIR/fixed_point_mult.sv
vlog -sv $ANN_DIR/flex_counter.sv
vlog -sv $ANN_DIR/input_node_timer.sv
vlog -sv $ANN_DIR/neural_to_seven.sv
vlog -sv $ANN_DIR/new_activation.sv
vlog -sv $ANN_DIR/node.sv
vlog -sv $ANN_DIR/sync_low.sv
vlog -sv $ANN_DIR/ANN.sv


# compile testbench and test program
#vlog -sv $BASE_DIR/nn_test.sv
vlog -sv $ANN_DIR/top_ann.sv
vlog -sv $BASE_DIR/test_program.sv -L altera_common_sv_packages
vlog -sv $BASE_DIR/tb.sv

# load and run simulation
elab_debug
#do wave.do

# alias to re-compile changes made to test program, load and run simulation
alias rerun {

    # compile ann stuff
    vlog -sv $ANN_DIR/ann_controller.sv
    vlog -sv $ANN_DIR/fixed_point_add.sv
    vlog -sv $ANN_DIR/fixed_point_mult.sv
    vlog -sv $ANN_DIR/flex_counter.sv
    vlog -sv $ANN_DIR/input_node_timer.sv
    vlog -sv $ANN_DIR/neural_to_seven.sv
    vlog -sv $ANN_DIR/new_activation.sv
    vlog -sv $ANN_DIR/node.sv
    vlog -sv $ANN_DIR/sync_low.sv
    vlog -sv $ANN_DIR/ANN.sv

    #vlog -sv $BASE_DIR/nn_test.sv
    vlog -sv $ANN_DIR/top_ann.sv
    vlog -sv $BASE_DIR/test_program.sv -L altera_common_sv_packages
    vlog -sv $BASE_DIR/tb.sv
    elab_debug
    #do wave.do
}

