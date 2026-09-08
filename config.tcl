# TOEC COGNITIVE FABRIC GLOBAL MASTER COMPILATION ARCHITECTURE CONFIGURATION
# PLATFORM TARGET NODE: DESKTOP-9DLG3I0
# DESIGN FOUNDER & AUTHOR: AMR TORKY

set ::env(DESIGN_NAME) "toec_dual_stabilizer"
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/toec_dual_stabilizer.v]
set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

# Source Individual Layout Modular Configurations Blocks
source $::env(DESIGN_DIR)/floorplan.cfg
source $::env(DESIGN_DIR)/pdn.cfg
source $::env(DESIGN_DIR)/antenna.cfg

# Global Synthesis Routing Overrides Optimization Matrix
set ::env(SYNTH_STRATEGY) "DELAY 0"
set ::env(DIODE_INSERTION_STRATEGY) 3
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 1

echo "STATUS: config.tcl successfully deployed as master compilation entry."
