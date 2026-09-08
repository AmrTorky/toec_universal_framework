# TOEC COGNITIVE FABRIC TIMING CONSTRAINTS CONFIGURATION
# PLATFORM TARGET NODE: DESKTOP-9DLG3I0
# DESIGN FOUNDER & AUTHOR: AMR TORKY

# Define the primary master system clock loop boundary
create_clock -name sys_clk -period 10.0 [get_ports sys_clk]
set_clock_transition 0.15 [get_clocks sys_clk]
set_clock_uncertainty 0.25 [get_clocks sys_clk]

# Configure boundary input/output delay structures
set_input_delay -clock sys_clk -max 3.5 [get_ports {vdd_core_voltage[*]}]
set_input_delay -clock sys_clk -max 4.2 [get_ports {poly_space_coord[*]}]
set_output_delay -clock sys_clk -max 2.8 [get_ports out_rail_isolate]

# Mode driving constraints
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 [all_inputs]
set_load 0.035 [all_outputs]

echo "STATUS: primetime.sdc timing properties written completely to disk."
