# HLS
High-level synthesis source code and build environments for the HDMI LED Backlight repo

## Directories
- `color_indexer`: Color grouping indexer
- `color_router`: Color data routing to screen edges
- `include`: Global includes for all HLS components

## How to build
Each subdirectory contains a makefile. Run 'make' in the directory to see the build options. The first listed option builds all components

## Sub-directory structure
Each subdirectory, other than include, contains one or more HLS components. Each subdirectory has the following structure

- `config`: HLS config files
- `scripts`: HLS flow scripts
- `sim`: Simulation testbenches
- `src`: HLS source files
- `vitis`: Empty placeholder for the Vitis components
- `makefile`: makefile for directing Vitis builds
- `README.md`: Description of the HLS component(s)