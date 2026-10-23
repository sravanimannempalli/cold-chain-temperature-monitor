
if { [info exist ::env(MAGIC_EXT_USE_GDS)] && $::env(MAGIC_EXT_USE_GDS) } {
	gds read $::env(CURRENT_GDS)
} else {
	lef read /home/vsduser/Desktop/work/tools/openlane_working_dir/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
	if {  [info exist ::env(EXTRA_LEFS)] } {
		set lefs_in $::env(EXTRA_LEFS)
		foreach lef_file $lefs_in {
			lef read $lef_file
		}
	}
	def read /openLANE_flow/designs/cold_chain_temp_monitor/runs/23-10_10-27/results/routing/cold_chain_temp_monitor.def
}
load cold_chain_temp_monitor -dereference
cd /openLANE_flow/designs/cold_chain_temp_monitor/runs/23-10_10-27/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
if { ! 0 } {
	extract unique
}
# extract warn all
extract

ext2spice lvs
ext2spice -o /openLANE_flow/designs/cold_chain_temp_monitor/runs/23-10_10-27/results/magic/cold_chain_temp_monitor.spice cold_chain_temp_monitor.ext
feedback save /openLANE_flow/designs/cold_chain_temp_monitor/runs/23-10_10-27/logs/magic/37-magic_ext2spice.feedback.txt
# exec cp cold_chain_temp_monitor.spice /openLANE_flow/designs/cold_chain_temp_monitor/runs/23-10_10-27/results/magic/cold_chain_temp_monitor.spice

