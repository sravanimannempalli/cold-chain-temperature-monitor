set_cmd_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm -distance um
read_liberty /home/vsduser/Desktop/work/tools/openlane_working_dir/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog /home/vsduser/Desktop/work/tools/openlane_working_dir/openlane/designs/cold_chain_temp_monitor/runs/23-10_10-27/results/lvs/cold_chain_temp_monitor.lvs.powered.v
link_design cold_chain_temp_monitor
read_spef /home/vsduser/Desktop/work/tools/openlane_working_dir/openlane/designs/cold_chain_temp_monitor/runs/23-10_10-27/results/routing/cold_chain_temp_monitor.spef

create_clock -name clk -period 10 [get_ports clk]
set_input_delay 2 -clock clk [get_ports {rst_n temp_high}]
set_output_delay 2 -clock clk [get_ports alarm]
set_input_transition 0.1 [get_ports {rst_n temp_high}]
set_load 0.01765 [get_ports alarm]

puts "===== CORNER tt ====="
report_checks -path_delay max -format full_clock_expanded
report_checks -path_delay min -format full_clock_expanded
report_worst_slack -max
report_worst_slack -min
report_tns
report_wns
exit
