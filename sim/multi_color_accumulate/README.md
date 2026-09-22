# multi_color_accumulate Simulation
Simulation for the multi-color accumulator

## Testbench
The multi-color accumulator accepts color data with an AXI-streaming slave interface and outputs summed grb data on 3 AXI-streaming master interfaces. An AXI-S verification IP in master mode drives the input data and three AXI-S VIPs in slave mode collect output data. The master VIP includes TUSER, which identifies the color index associated with TDATA. Data output by the master is acccumulated in the testbench and compared to the results collected by the VIP slaves. Various parameters are defined and configured by `localparam` lines in the testbench.

## Simulation outputs
Simulation output is printed to the simulation console, including any data mismatches.