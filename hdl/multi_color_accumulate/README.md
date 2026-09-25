# Multi-Color Accumulate
Accumulates color data for multiple pixels, for multiple interleaved groups and outputs the sum of each group

## Files
- `mca_pipeline.sv`: Data pipeline for the multi-color accumulator
- `multi_color_accumulate.sv`: Multi-color accumulator top module
- `multi_color_accumulate_slave_lite_v1_0_S00_AXI.v`: AXI-Lite slave interface for multicolor accumulator register space
- `multi_color_accumulate_axi_top.sv`: Multi-color accumulator top module with axi-lite interface

## Dependencies
- `mca_pipeline.sv`
    - None
- `multi_color_accumulate.sv`
    - `mca_pipeline.sv`
    - `../../submodules/open-logic/src/base/vhdl/olo_base_ram_sdp.vhd`
    - `../../submodules/open-logic/src/base/vhdl/olo_base_fifo_sync.vhd`
    - `../../submodules/open-logic/src/base/vhdl/olo_base_pkg*`
- `multi_color_accumulate_slave_lite_v1_0_S00_AXI.v`
    - None
- `multi_color_accumulate_axi_top.sv`
    - `multi_color_accumulate.sv`
    - `multi_color_accumulate_slave_lite_v1_0_S00_AXI.v`

