add_files -norecurse {
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_array.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_attribute.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_math.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_string.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_ram_sdp.vhd
    ../../submodules/open-logic/src/base/vhdl/olo_base_fifo_sync.vhd
    ../../hdl/multi_color_accumulate/mca_pipeline.sv
    ../../hdl/multi_color_accumulate/multi_color_accumulate.sv}
update_compile_order -fileset sources_1

set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_array.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_attribute.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_math.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_pkg_string.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_ram_sdp.vhd]
set_property file_type {VHDL 2008} [get_files  ../../submodules/open-logic/src/base/vhdl/olo_base_fifo_sync.vhd]

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse {
    ./tb/tb_multi_color_accumulate.sv
}
update_compile_order -fileset sim_1