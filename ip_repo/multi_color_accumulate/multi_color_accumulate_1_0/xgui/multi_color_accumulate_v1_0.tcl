# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_M_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_FIFO_DEPTH" -parent ${Page_0}
  #Adding Group
  set Color_Groups [ipgui::add_group $IPINST -name "Color Groups" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "C_MAX_NUM_COLORS" -parent ${Color_Groups}
  ipgui::add_param $IPINST -name "C_MAX_PIXELS_PER_COLOR" -parent ${Color_Groups}

  #Adding Group
  set Input_Color_Format [ipgui::add_group $IPINST -name "Input Color Format" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "C_S_AXIS_IN_TDATA_WIDTH" -parent ${Input_Color_Format}
  ipgui::add_param $IPINST -name "C_COLOR_DATA_WIDTH" -parent ${Input_Color_Format}
  ipgui::add_param $IPINST -name "C_G_START_INDEX" -parent ${Input_Color_Format}
  ipgui::add_param $IPINST -name "C_R_START_INDEX" -parent ${Input_Color_Format}
  ipgui::add_param $IPINST -name "C_B_START_INDEX" -parent ${Input_Color_Format}
  ipgui::add_param $IPINST -name "C_AXIS_TUSER_WIDTH" -parent ${Input_Color_Format}



}

proc update_PARAM_VALUE.C_AXIS_TUSER_WIDTH { PARAM_VALUE.C_AXIS_TUSER_WIDTH } {
	# Procedure called to update C_AXIS_TUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIS_TUSER_WIDTH { PARAM_VALUE.C_AXIS_TUSER_WIDTH } {
	# Procedure called to validate C_AXIS_TUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_B_START_INDEX { PARAM_VALUE.C_B_START_INDEX } {
	# Procedure called to update C_B_START_INDEX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_B_START_INDEX { PARAM_VALUE.C_B_START_INDEX } {
	# Procedure called to validate C_B_START_INDEX
	return true
}

proc update_PARAM_VALUE.C_COLOR_DATA_WIDTH { PARAM_VALUE.C_COLOR_DATA_WIDTH } {
	# Procedure called to update C_COLOR_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_COLOR_DATA_WIDTH { PARAM_VALUE.C_COLOR_DATA_WIDTH } {
	# Procedure called to validate C_COLOR_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_FIFO_DEPTH { PARAM_VALUE.C_FIFO_DEPTH } {
	# Procedure called to update C_FIFO_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_FIFO_DEPTH { PARAM_VALUE.C_FIFO_DEPTH } {
	# Procedure called to validate C_FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.C_G_START_INDEX { PARAM_VALUE.C_G_START_INDEX } {
	# Procedure called to update C_G_START_INDEX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_G_START_INDEX { PARAM_VALUE.C_G_START_INDEX } {
	# Procedure called to validate C_G_START_INDEX
	return true
}

proc update_PARAM_VALUE.C_MAX_NUM_COLORS { PARAM_VALUE.C_MAX_NUM_COLORS } {
	# Procedure called to update C_MAX_NUM_COLORS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_MAX_NUM_COLORS { PARAM_VALUE.C_MAX_NUM_COLORS } {
	# Procedure called to validate C_MAX_NUM_COLORS
	return true
}

proc update_PARAM_VALUE.C_MAX_PIXELS_PER_COLOR { PARAM_VALUE.C_MAX_PIXELS_PER_COLOR } {
	# Procedure called to update C_MAX_PIXELS_PER_COLOR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_MAX_PIXELS_PER_COLOR { PARAM_VALUE.C_MAX_PIXELS_PER_COLOR } {
	# Procedure called to validate C_MAX_PIXELS_PER_COLOR
	return true
}

proc update_PARAM_VALUE.C_M_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_R_START_INDEX { PARAM_VALUE.C_R_START_INDEX } {
	# Procedure called to update C_R_START_INDEX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_R_START_INDEX { PARAM_VALUE.C_R_START_INDEX } {
	# Procedure called to validate C_R_START_INDEX
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXIS_IN_TDATA_WIDTH { PARAM_VALUE.C_S_AXIS_IN_TDATA_WIDTH } {
	# Procedure called to update C_S_AXIS_IN_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIS_IN_TDATA_WIDTH { PARAM_VALUE.C_S_AXIS_IN_TDATA_WIDTH } {
	# Procedure called to validate C_S_AXIS_IN_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIS_IN_TDATA_WIDTH { MODELPARAM_VALUE.C_S_AXIS_IN_TDATA_WIDTH PARAM_VALUE.C_S_AXIS_IN_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIS_IN_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIS_IN_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIS_TUSER_WIDTH { MODELPARAM_VALUE.C_AXIS_TUSER_WIDTH PARAM_VALUE.C_AXIS_TUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIS_TUSER_WIDTH}] ${MODELPARAM_VALUE.C_AXIS_TUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_MAX_NUM_COLORS { MODELPARAM_VALUE.C_MAX_NUM_COLORS PARAM_VALUE.C_MAX_NUM_COLORS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_MAX_NUM_COLORS}] ${MODELPARAM_VALUE.C_MAX_NUM_COLORS}
}

proc update_MODELPARAM_VALUE.C_MAX_PIXELS_PER_COLOR { MODELPARAM_VALUE.C_MAX_PIXELS_PER_COLOR PARAM_VALUE.C_MAX_PIXELS_PER_COLOR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_MAX_PIXELS_PER_COLOR}] ${MODELPARAM_VALUE.C_MAX_PIXELS_PER_COLOR}
}

proc update_MODELPARAM_VALUE.C_COLOR_DATA_WIDTH { MODELPARAM_VALUE.C_COLOR_DATA_WIDTH PARAM_VALUE.C_COLOR_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_COLOR_DATA_WIDTH}] ${MODELPARAM_VALUE.C_COLOR_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_G_START_INDEX { MODELPARAM_VALUE.C_G_START_INDEX PARAM_VALUE.C_G_START_INDEX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_G_START_INDEX}] ${MODELPARAM_VALUE.C_G_START_INDEX}
}

proc update_MODELPARAM_VALUE.C_R_START_INDEX { MODELPARAM_VALUE.C_R_START_INDEX PARAM_VALUE.C_R_START_INDEX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_R_START_INDEX}] ${MODELPARAM_VALUE.C_R_START_INDEX}
}

proc update_MODELPARAM_VALUE.C_B_START_INDEX { MODELPARAM_VALUE.C_B_START_INDEX PARAM_VALUE.C_B_START_INDEX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_B_START_INDEX}] ${MODELPARAM_VALUE.C_B_START_INDEX}
}

proc update_MODELPARAM_VALUE.C_FIFO_DEPTH { MODELPARAM_VALUE.C_FIFO_DEPTH PARAM_VALUE.C_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_FIFO_DEPTH}] ${MODELPARAM_VALUE.C_FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH PARAM_VALUE.C_M_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXIS_TDATA_WIDTH}
}

