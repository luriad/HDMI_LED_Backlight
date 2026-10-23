import argparse
import os
import shutil
import sys
import hlbt_desktop as d
import serial

def init_hlb(args):
    ser = d.connect(args.port)
    d.login(ser)
    d.init(ser)
    d.disconnect(ser)

def update_settings(args):
    ser = d.connect(args.port)
    d.update_settings(ser, args.top_leds, args.bottom_leds, args.left_leds, args.right_leds)
    d.disconnect(ser)

def enable_leds(args):
    ser = d.connect(args.port)
    d.enable_output(ser, args.enable)
    d.disconnect(ser)

def enable_passthrough(args):
    ser = d.connect(args.port)
    d.enable_passthrough(ser, args.enable)
    d.disconnect(ser)

def _hlbt_parser():
    """Initialize and return the argument parser."""
    parser = argparse.ArgumentParser(description="HDMI LED Backlight Tool")
    subparsers = parser.add_subparsers(required=True)

    init = subparsers.add_parser("init", help="initialize the LED driver overlay")
    init.set_defaults(func=init_hlb)
    init.add_argument("-p", "--port", type=str, required=True,
                       help="the serial port PYNQ is connected to")
                       
    settings = subparsers.add_parser("update-settings", help="update LED driver settings")
    settings.set_defaults(func=update_settings)
    settings.add_argument("-p", "--port", type=str, required=True,
                       help="the serial port PYNQ is connected to")   
    settings.add_argument("-t", "--top-leds", type=int, required=True,
                       help="the number of LEDs in the top string")
    settings.add_argument("-b", "--bottom-leds", type=int, required=True,
                       help="the number of LEDs in the bottom string")
    settings.add_argument("-l", "--left-leds", type=int, required=True,
                       help="the number of LEDs in the left string")
    settings.add_argument("-r", "--right-leds", type=int, required=True,
                       help="the number of LEDs in the top string")

    enable = subparsers.add_parser("output", help="control LED output")
    enable.set_defaults(func=enable_leds)
    enable.add_argument("-p", "--port", type=str, required=True,
                       help="the serial port PYNQ is connected to") 
    enable_group = enable.add_mutually_exclusive_group()
    enable_group.add_argument("-e", "--enable", action="store_true", 
                       help="enables LED output")
    enable_group.add_argument("-d", "--disable", action="store_true", 
                       help="disables LED output")
    
    passthrough = subparsers.add_parser("passthrough", help="enable HDMI passthrough")
    passthrough.set_defaults(func=enable_passthrough)
    passthrough.add_argument("-p", "--port", type=str, required=True,
                       help="the serial port PYNQ is connected to") 
    passthrough_enable_group = passthrough.add_mutually_exclusive_group()
    passthrough_enable_group.add_argument("-e", "--enable", action="store_true", 
                       help="enables HDMI passthrough")
    passthrough_enable_group.add_argument("-d", "--disable", action="store_true", 
                       help="disables HDMI passthrough")
    return parser

parser = _hlbt_parser()
args, opts = parser.parse_known_args()
args.func(args)