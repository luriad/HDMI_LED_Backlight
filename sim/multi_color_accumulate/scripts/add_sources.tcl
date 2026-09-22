set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse {
    ./tb/tb_multi_color_accumulate.sv
}
update_compile_order -fileset sim_1

set_property  ip_repo_paths  ../../ip_repo [current_project]
update_ip_catalog