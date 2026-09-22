help:
	$(info -- MAKE TARGETS --)
	$(info setup_and_run_sim:     Builds the Vivado project and runs simulation)
	$(info run_sim:               Runs simulation from an existing Vivado project)
	$(info open_existing_project: Opens an existing Vivado project but does not run simulation)
	$(info clean:                 Deletes the Vivado project and logs)

setup_and_run_sim:
	vivado -mode 'gui' -source ./scripts/run_all.tcl &

run_sim:
	vivado -mode 'gui' -source ./scripts/run_sim.tcl ./vivado_project/sim_multi_color_accumulate.xpr &

open_existing_project:
	vivado ./vivado_project/sim_multi_color_accumulate.xpr &

clean:
	rm -rf ./vivado_project/*
	rm -rf ./.Xil
	rm -rf vivado*.*