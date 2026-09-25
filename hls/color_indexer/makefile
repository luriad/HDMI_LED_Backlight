VERTICAL=vert
HORIZONTAL=horiz

help:
	$(info -- MAKE TARGETS --)
	$(info setup_and_build_ip_all:   Sets up all Vitis components, synthesizes and packages the IPs, then exports them to the IP repo (../../ip_repo))
	$(info setup_all:                Sets up all Vitis components and workspaces)
	$(info build_ip_all:             For an existing Vitis components, synthesizes and packages the IPs, then exports them to the IP repo (../../ip_repo))
	$(info clean_all:                Cleans all workspaces)
	$(info setup_and_build_ip_horiz: Sets up the horizontal indexer Vitis component, synthesizes and packages the IP, then exports it to the IP repo (../../ip_repo))
	$(info setup_horiz:              Sets up the horizontal indexer Vitis component and workspace)
	$(info build_ip_horiz:           For an existing horizontal indexer Vitis component, synthesizes and packages the IP, then exports it to the IP repo (../../ip_repo))
	$(info c_sim_horiz:              Runs C simulation for an existing horizontal indexer Vitis component)
	$(info cosim_horiz:              Runs C/RTL cosimulation for an existing horizontal indexer Vitis component)
	$(info open_gui_horiz:           Opens the Vitis GUI for an existing horizontal indexer workspace)
	$(info clean_horiz:              Cleans the horizontal indexer workspace)
	$(info setup_and_build_ip_vert:  Sets up the vertical indexer Vitis component, synthesizes and packages the IP, then exports it to the IP repo (../../ip_repo))
	$(info setup_vert:               Sets up the vertical indexer Vitis component and workspace)
	$(info build_ip_vert:            For an existing vertical indexer Vitis component, synthesizes and packages the IP, then exports it to the IP repo (../../ip_repo))
	$(info c_sim_vert:               Runs C simulation for an existing vertical indexer Vitis component)
	$(info cosim_vert:               Runs C/RTL cosimulation for an existing vertical indexer Vitis component)
	$(info open_gui_vert:            Opens the Vitis GUI for an existing vertical indexer workspace)
	$(info clean_vert:               Cleans the vertical indexer workspace)

setup_and_build_ip_horiz:
	vitis -s scripts/color_indexer.py ${HORIZONTAL} -nyp
	rm -rf ../../ip_repo/color_indexer_${HORIZONTAL}/*
	unzip vitis/color_indexer_${HORIZONTAL}/color_indexer_${HORIZONTAL}/color_indexer_${HORIZONTAL}/color_indexer.zip -d ../../ip_repo/color_indexer_${HORIZONTAL}/

setup_horiz:
	vitis -s scripts/color_indexer.py ${HORIZONTAL} -n

build_ip_horiz:
	vitis -s scripts/color_indexer.py ${HORIZONTAL} -yp
	rm -rf ../../ip_repo/color_indexer_${HORIZONTAL}/*
	unzip vitis/color_indexer_${HORIZONTAL}/color_indexer_${HORIZONTAL}/color_indexer_${HORIZONTAL}/color_indexer.zip -d ../../ip_repo/color_indexer_${HORIZONTAL}/

c_sim_horiz:
	vitis -s scripts/color_indexer.py ${HORIZONTAL} -s

cosim_horiz:
	vitis -s scripts/color_indexer.py ${HORIZONTAL} -r

open_gui_horiz:
	vitis -w vitis/color_indexer_${HORIZONTAL} &

clean_horiz:
	rm -rf vitis/color_indexer_${HORIZONTAL}/*

setup_and_build_ip_vert:
	vitis -s scripts/color_indexer.py ${VERTICAL} -nyp
	rm -rf ../../ip_repo/color_indexer_${VERTICAL}/*
	unzip vitis/color_indexer_${VERTICAL}/color_indexer_${VERTICAL}/color_indexer_${VERTICAL}/color_indexer.zip -d ../../ip_repo/color_indexer_${VERTICAL}/

setup_vert:
	vitis -s scripts/color_indexer.py ${VERTICAL} -n

build_ip_vert:
	vitis -s scripts/color_indexer.py ${VERTICAL} -yp
	rm -rf ../../ip_repo/color_indexer_${VERTICAL}/*
	unzip vitis/color_indexer_${VERTICAL}/color_indexer_${VERTICAL}/color_indexer_${VERTICAL}/color_indexer.zip -d ../../ip_repo/color_indexer_${VERTICAL}/

c_sim_vert:
	vitis -s scripts/color_indexer.py ${VERTICAL} -s

cosim_vert:
	vitis -s scripts/color_indexer.py ${VERTICAL} -r

open_gui_vert:
	vitis -w vitis/color_indexer_${VERTICAL} &

clean_vert:
	rm -rf vitis/color_indexer_${VERTICAL}/*

setup_and_build_ip_all: setup_and_build_ip_horiz setup_and_build_ip_vert

setup_all: setup_horiz setup_vert

build_ip_all: build_ip_horiz build_ip_vert

clean_all: clean_horiz clean_vert