help:
	$(info -- MAKE TARGETS --)
	$(info setup_and_build_ip: Sets up the Vitis component, synthesizes and packages the IP, then exports it to the IP repo (../../ip_repo))
	$(info setup:              Sets up the Vitis component and workspace)
	$(info build_ip:           For an existing Vitis component, synthesizes and packages the IP, then exports it to the IP repo (../../ip_repo))
	$(info c_sim:              Runs C simulation for an existing Vitis component)
	$(info cosim:              Runs C/RTL cosimulation for an existing Vitis component)
	$(info open_gui:           Opens the Vitis GUI for an existing workspace)
	$(info clean:              Cleans the workspace)

setup_and_build_ip:
	vitis -s scripts/color_router.py -nyp
	rm -rf ../../ip_repo/color_router/*
	unzip vitis/color_router/color_router/color_router/color_router.zip -d ../../ip_repo/color_router/

setup:
	vitis -s scripts/color_router.py -n

build_ip:
	vitis -s scripts/color_router.py -yp
	rm -rf ../../ip_repo/color_router/*
	unzip vitis/color_router/color_router/color_router/color_router.zip -d ../../ip_repo/color_router/

c_sim:
	vitis -s scripts/color_router.py -s

cosim:
	vitis -s scripts/color_router.py -r

open_gui:
	vitis -w vitis/color_router &

clean:
	rm -rf vitis/color_router/*