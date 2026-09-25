VERTICAL=vert
HORIZONTAL=horiz

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