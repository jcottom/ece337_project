# TCL File Generated by Component Editor 14.0
# Wed Dec 07 14:51:58 EST 2016
# DO NOT MODIFY


# 
# sdram_interface "SDRAM_interface" v1.0
#  2016.12.07.14:51:58
# This component reads image and coefficient data from SDRAM
# 

# 
# request TCL package from ACDS 14.0
# 
package require -exact qsys 14.0


# 
# module sdram_interface
# 
set_module_property DESCRIPTION "This component reads image and coefficient data from SDRAM"
set_module_property NAME sdram_interface
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME SDRAM_interface
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sdram_interface
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file sdram_interface.sv SYSTEM_VERILOG PATH sdram_interface.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL sdram_interface
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file sdram_interface.sv SYSTEM_VERILOG PATH sdram_interface.sv


# 
# parameters
# 
add_parameter MASTER_ADDRESSWIDTH INTEGER 32 ""
set_parameter_property MASTER_ADDRESSWIDTH DEFAULT_VALUE 32
set_parameter_property MASTER_ADDRESSWIDTH DISPLAY_NAME MASTER_ADDRESSWIDTH
set_parameter_property MASTER_ADDRESSWIDTH TYPE INTEGER
set_parameter_property MASTER_ADDRESSWIDTH UNITS None
set_parameter_property MASTER_ADDRESSWIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property MASTER_ADDRESSWIDTH DESCRIPTION ""
set_parameter_property MASTER_ADDRESSWIDTH HDL_PARAMETER true
add_parameter DATAWIDTH INTEGER 8 ""
set_parameter_property DATAWIDTH DEFAULT_VALUE 8
set_parameter_property DATAWIDTH DISPLAY_NAME DATAWIDTH
set_parameter_property DATAWIDTH TYPE INTEGER
set_parameter_property DATAWIDTH UNITS None
set_parameter_property DATAWIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DATAWIDTH DESCRIPTION ""
set_parameter_property DATAWIDTH HDL_PARAMETER true
add_parameter NUMREGS INTEGER 16 ""
set_parameter_property NUMREGS DEFAULT_VALUE 16
set_parameter_property NUMREGS DISPLAY_NAME NUMREGS
set_parameter_property NUMREGS TYPE INTEGER
set_parameter_property NUMREGS UNITS None
set_parameter_property NUMREGS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property NUMREGS DESCRIPTION ""
set_parameter_property NUMREGS HDL_PARAMETER true
add_parameter REGWIDTH INTEGER 32
set_parameter_property REGWIDTH DEFAULT_VALUE 32
set_parameter_property REGWIDTH DISPLAY_NAME REGWIDTH
set_parameter_property REGWIDTH TYPE INTEGER
set_parameter_property REGWIDTH UNITS None
set_parameter_property REGWIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property REGWIDTH HDL_PARAMETER true
add_parameter IMSIZE INTEGER 64
set_parameter_property IMSIZE DEFAULT_VALUE 64
set_parameter_property IMSIZE DISPLAY_NAME IMSIZE
set_parameter_property IMSIZE TYPE INTEGER
set_parameter_property IMSIZE UNITS None
set_parameter_property IMSIZE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property IMSIZE HDL_PARAMETER true
add_parameter IMBITS INTEGER 6
set_parameter_property IMBITS DEFAULT_VALUE 6
set_parameter_property IMBITS DISPLAY_NAME IMBITS
set_parameter_property IMBITS TYPE INTEGER
set_parameter_property IMBITS UNITS None
set_parameter_property IMBITS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property IMBITS HDL_PARAMETER true
add_parameter CSIZE INTEGER 2048
set_parameter_property CSIZE DEFAULT_VALUE 2048
set_parameter_property CSIZE DISPLAY_NAME CSIZE
set_parameter_property CSIZE TYPE INTEGER
set_parameter_property CSIZE UNITS None
set_parameter_property CSIZE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property CSIZE HDL_PARAMETER true
add_parameter NUMLAYERS INTEGER 2
set_parameter_property NUMLAYERS DEFAULT_VALUE 2
set_parameter_property NUMLAYERS DISPLAY_NAME NUMLAYERS
set_parameter_property NUMLAYERS TYPE INTEGER
set_parameter_property NUMLAYERS UNITS None
set_parameter_property NUMLAYERS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property NUMLAYERS HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock
set_interface_property conduit_end associatedReset reset
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end busy busy Output 1
add_interface_port conduit_end image_data_o image_data Output IMSIZE*8
add_interface_port conduit_end coeff_data_o coeff_data Output CSIZE*8
add_interface_port conduit_end get_data get_data Input 1
add_interface_port conduit_end which_data which_data Input NUMLAYERS


# 
# connection point avalon_master
# 
add_interface avalon_master avalon start
set_interface_property avalon_master addressUnits SYMBOLS
set_interface_property avalon_master associatedClock clock
set_interface_property avalon_master associatedReset reset
set_interface_property avalon_master bitsPerSymbol 8
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master burstcountUnits WORDS
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master holdTime 0
set_interface_property avalon_master linewrapBursts false
set_interface_property avalon_master maximumPendingReadTransactions 0
set_interface_property avalon_master maximumPendingWriteTransactions 0
set_interface_property avalon_master readLatency 0
set_interface_property avalon_master readWaitTime 1
set_interface_property avalon_master setupTime 0
set_interface_property avalon_master timingUnits Cycles
set_interface_property avalon_master writeWaitTime 0
set_interface_property avalon_master ENABLED true
set_interface_property avalon_master EXPORT_OF ""
set_interface_property avalon_master PORT_NAME_MAP ""
set_interface_property avalon_master CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master SVD_ADDRESS_GROUP ""

add_interface_port avalon_master master_address address Output MASTER_ADDRESSWIDTH
add_interface_port avalon_master master_writedata writedata Output DATAWIDTH
add_interface_port avalon_master master_write write Output 1
add_interface_port avalon_master master_read read Output 1
add_interface_port avalon_master master_readdata readdata Input DATAWIDTH
add_interface_port avalon_master master_readdatavalid readdatavalid Input 1
add_interface_port avalon_master master_waitrequest waitrequest Input 1

