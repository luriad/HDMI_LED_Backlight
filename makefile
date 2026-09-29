PYTHON = python3

help:
	$(info -- MAKE TARGETS --)
	$(info all:       Builds everything in the repo. Output product is a python package copied to this directory. (Add 'PYTHON=<path>' in the make call to change the python path))
	$(info hls:       Builds the Vitis HLS IPs. Output product is a set of IPs in the ip_repo directory)
	$(info bitstream: Builds the bitstream using Vivado. Output product is the bitstream and hardware handoff file to the pynq python directory)
	$(info python:    Builds the python package. Output product is the package as a tarball copied to this directory. (Add 'PYTHON=<path>' in the make call to change the python path))


hls_ips:
	cd hls/color_indexer && make clean_all && make setup_and_build_ip_all
	cd hls/color_router && make clean && make setup_and_build_ip

bitstream:
	cd top && make clean && make setup_prj_and_run_build_batch

python:
	cd pynq && $(PYTHON) setup.py sdist && cp -f dist/*.tar.gz ../

all: hls_ips bitstream python