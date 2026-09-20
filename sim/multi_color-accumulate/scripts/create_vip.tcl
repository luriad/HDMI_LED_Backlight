# Master VIP
create_ip -name axi4stream_vip -vendor xilinx.com -library ip -version 1.1 -module_name axi4stream_vip_0
set_property -dict [list \
  CONFIG.HAS_TLAST {1} \
  CONFIG.INTERFACE_MODE {MASTER} \
  CONFIG.TDATA_NUM_BYTES {3} \
  CONFIG.TDEST_WIDTH {0} \
  CONFIG.TID_WIDTH {0} \
  CONFIG.TUSER_WIDTH {10} \
] [get_ips axi4stream_vip_0]
generate_target all [get_ips axi4stream_vip_0]
catch { config_ip_cache -export [get_ips -all axi4stream_vip_0] }
export_ip_user_files -of_objects [get_ips axi4stream_vip_0] -no_script -sync -force -quiet
export_simulation -of_objects [get_ips axi4stream_vip_0] -directory ./vivado_project/project_1.ip_user_files/sim_scripts -ip_user_files_dir ./vivado_project/project_1.ip_user_files -ipstatic_source_dir ./vivado_project/project_1.ip_user_files/ipstatic -lib_map_path [list {modelsim=./vivado_project/project_1.cache/compile_simlib/modelsim} {questa=./vivado_project/project_1.cache/compile_simlib/questa} {xcelium=./vivado_project/project_1.cache/compile_simlib/xcelium} {vcs=./vivado_project/project_1.cache/compile_simlib/vcs} {riviera=./vivado_project/project_1.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet

# Slave VIP
create_ip -name axi4stream_vip -vendor xilinx.com -library ip -version 1.1 -module_name axi4stream_vip_1
set_property -dict [list \
  CONFIG.HAS_TLAST {1} \
  CONFIG.INTERFACE_MODE {SLAVE} \
  CONFIG.TDATA_NUM_BYTES {4} \
  CONFIG.TDEST_WIDTH {0} \
  CONFIG.TID_WIDTH {0} \
  CONFIG.TUSER_WIDTH {10} \
] [get_ips axi4stream_vip_1]
generate_target all [get_ips axi4stream_vip_1]
catch { config_ip_cache -export [get_ips -all axi4stream_vip_1] }
export_ip_user_files -of_objects [get_ips axi4stream_vip_1] -no_script -sync -force -quiet
export_simulation -of_objects [get_ips axi4stream_vip_1] -directory ./vivado_project/project_1.ip_user_files/sim_scripts -ip_user_files_dir ./vivado_project/project_1.ip_user_files -ipstatic_source_dir ./vivado_project/project_1.ip_user_files/ipstatic -lib_map_path [list {modelsim=./vivado_project/project_1.cache/compile_simlib/modelsim} {questa=./vivado_project/project_1.cache/compile_simlib/questa} {xcelium=./vivado_project/project_1.cache/compile_simlib/xcelium} {vcs=./vivado_project/project_1.cache/compile_simlib/vcs} {riviera=./vivado_project/project_1.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet