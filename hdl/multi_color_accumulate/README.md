# Multi-Color Accumulate
Accumulates color data for multiple pixels, for multiple interleaved groups and outputs the sum of each group

## Files
- `mca_pipeline.sv`: Data pipeline for the multi-color accumulator
- `multi_color_accumulate.sv`: Multi-color accumulator top module

## Dependencies
- `mca_pipeline.sv`
    - None
- `multi_color_accumulate.sv`
    - `mca_pipeline.sv`
    - `../../submodules/open-logic/src/base/vhdl/olo_base_ram_sdp.vhd`
    - `../../submodules/open-logic/src/base/vhdl/olo_base_fifo_sync.vhd`
    - `../../submodules/open-logic/src/base/vhdl/olo_base_pkg*`

