# setup variables for simulation script
set system_name      verification_bus
set BASE_DIR         ../../
set QSYS_SIMDIR      $BASE_DIR$system_name/simulation
set TOP_LEVEL_NAME   tb
source $QSYS_SIMDIR/mentor/msim_setup.tcl

# compile system
dev_com
com

# compile testbench and test program
vlog -sv $BASE_DIR/nn_test.sv
vlog -sv $BASE_DIR/test_program.sv -L altera_common_sv_packages
vlog -sv $BASE_DIR/tb.sv

# load and run simulation
elab_debug
##do wave.do
run 50ns

# alias to re-compile changes made to test program, load and run simulation
alias rerun {
   vlog -sv $BASE_DIR/ nn_test.sv
   vlog -sv $BASE_DIR/ test_program.sv -L altera_common_sv_packages
   vlog -sv $BASE_DIR/ tb.sv
   elab_debug
   do wave.do
   run 50ns
}

