help:
	$(info -- MAKE TARGETS --)
	$(info setup_prj_and_run_build:       Builds the Vivado project and then runs an FPGA build through bitstream generation)
	$(info setup_prj_and_run_build_batch: Builds the Vivado project and then runs an FPGA build through bitstream generation in batch mode)
	$(info setup_prj_and_run_sim:         Builds the Vivado project and then runs simulation)
	$(info setup_prj:                     Builds the Vivado project)
	$(info open_existing_project:         Opens an existing Vivado project)
	$(info run_build:                     Opens an existing Vivado project and then runs an FPGA build through bistream generation)
	$(info run_sim:                       Opens an existing Vivado project and then runs simulation)
	$(info clean:                         Deletes the Vivado project and logs)

setup_prj_and_run_build:
	vivado -mode 'gui' -source ./scripts/setup_prj_and_run_build.tcl &

setup_prj_and_run_build_batch:
	vivado -mode 'batch' -source ./scripts/setup_prj_and_run_build.tcl

setup_prj_and_run_sim:
	vivado -mode 'gui' -source ./scripts/setup_prj_and_run_sim.tcl &

setup_prj:
	vivado -mode 'gui' -source ./scripts/setup_prj.tcl &

open_existing_project:
	vivado ./vivado_project/HDMI_LED_Backlight.xpr &

run_build:
	vivado -mode 'gui' -source ./scripts/run_build.tcl ./vivado_project/HDMI_LED_Backlight.xpr &

run_sim:
	vivado -mode 'gui' -source ./scripts/run_sim.tcl ./vivado_project/HDMI_LED_Backlight.xpr &

clean:
	rm -rf ./vivado_project/*
	rm -rf ./.Xil
	rm -rf vivado*.*