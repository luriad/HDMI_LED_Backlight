##################################################################################################/
## Description
##################################################################################################/
## Script for color indexer Vitis HLS flow
##
import vitis  # Import the Vitis library for High-Level Synthesis (HLS) functionalities
import os     # Import the os module for interacting with the operating system
import sys
import subprocess

class vitis_session:

    def __init__(self, horiz_vert):
        self.client = vitis.create_client()
        self.horiz_vert = horiz_vert
        self.ws_path = f'./vitis/color_indexer_{self.horiz_vert}'
        self.client.set_workspace(path=self.ws_path)
        self.cwd = os.getcwd() + '/'

    def create_new_component(self):
        # Check if the component 'color_indexer_horiz/vert' exists and delete it if it does
        if os.path.exists(f'{self.ws_path}/color_indexer_{self.horiz_vert}'):  # Verify if the specified component directory exists
            self.client.delete_component(name=f'color_indexer_{self.horiz_vert}')  # Delete the existing component to avoid conflicts
        # Create a new HLS component, specifying a configuration file and template
        self.comp = self.client.create_hls_component(name=f'color_indexer_{self.horiz_vert}', cfg_file=[self.cwd + f'config/color_indexer_{self.horiz_vert}.cfg'], template='empty_hls_component')

    def get_existing_component(self):
        self.comp = self.client.get_component(name=f'color_indexer_{self.horiz_vert}')

    def run_c_sim(self):
        self.comp.run(operation='C_SIMULATION')
    
    def run_synth(self):
        self.comp.run(operation='SYNTHESIS')

    def run_cosim(self):
        self.comp.run(operation='CO_SIMULATION')

    def pkg_ip(self):
        self.comp.run(operation='PACKAGE')

    def run_impl(self):
        self.comp.run(operation='IMPLEMENTATION')

if len(sys.argv) < 3:
    print("--USAGE--")
    print("color_indexer.py [horiz or vert] -[flags]")
    print("")
    print("Flags:")
    print("n: Create a new component (or use an existing one if this flag is absent)")
    print("s: Run C Simulation")
    print("y: Run Synthesis")
    print("r: Run RTL/C Cosimulation")
    print("p: Package IP")
    print("i: Run implementation")
    print("Note: The above order is the order steps are run regardless of the order flags are given.")
    sys.exit()
session = vitis_session(sys.argv[1])

if ("n" in sys.argv[2]):
    session.create_new_component()
else:
    session.get_existing_component()

if ("s" in sys.argv[2]):
    session.run_c_sim()

if ("y" in sys.argv[2]):
    session.run_synth()

if ("r" in sys.argv[2]):
    session.run_cosim()

if ("p" in sys.argv[2]):
    session.pkg_ip()

if ("i" in sys.argv[2]):
    session.run_impl()