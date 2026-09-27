launch_runs synth_1 -jobs 8
wait_on_runs synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_runs impl_1
source scripts/export_overlay.tcl