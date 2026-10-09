import argparse
import os
import shutil
import sys
import HDMI_LED_Backlight as hlb

def init_hlb(args):
    hlb.overlays.BacklightOverlay('HDMI_LED_Backlight.bit')

def update_settings(args):
    overlay = hlb.overlays.BacklightOverlay('HDMI_LED_Backlight.bit', download=False)
    num_leds = {"top":args.top_leds, "bottom":args.bottom_leds, "left":args.left_leds, "right":args.right_leds};
    overlay.set_num_ws_leds(num_leds)
    overlay.configure_hdmi()
    overlay.calc_bounds()

def enable_leds(args):
    overlay = hlb.overlays.BacklightOverlay('HDMI_LED_Backlight.bit', download=False)
    overlay.enable_led_output(args.enable)

def enable_passthrough(args):
    overlay = hlb.overlays.BacklightOverlay('HDMI_LED_Backlight.bit', download=False)
    hdmi_in = overlay.video.hdmi_in
    hdmi_out = overlay.video.hdmi_out
    if (args.enable):
        overlay.configure_hdmi()
        hdmi_out.configure(hdmi_in.mode)
        hdmi_in.start()
        hdmi_out.start()
        hdmi_in.tie(hdmi_out)
    elif (args.disable):
        hdmi_out.close()
        hdmi_in.close()

def _hlbt_parser():
    """Initialize and return the argument parser."""
    parser = argparse.ArgumentParser(description="HDMI LED Backlight Tool")
    subparsers = parser.add_subparsers(required=True)

    settings = subparsers.add_parser("init", help="initialize the LED driver overlay")
    settings.set_defaults(func=init_hlb)
                       
    settings = subparsers.add_parser("update-settings", help="update LED driver settings")
    settings.set_defaults(func=update_settings)
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
    enable_group = enable.add_mutually_exclusive_group()
    enable_group.add_argument("-e", "--enable", action="store_true", 
                       help="enables LED output")
    enable_group.add_argument("-d", "--disable", action="store_true", 
                       help="disables LED output")
    
    passthrough = subparsers.add_parser("passthrough", help="enable HDMI passthrough")
    passthrough.set_defaults(func=enable_passthrough)
    passthrough_enable_group = passthrough.add_mutually_exclusive_group()
    passthrough_enable_group.add_argument("-e", "--enable", action="store_true", 
                       help="enables HDMI passthrough")
    passthrough_enable_group.add_argument("-d", "--disable", action="store_true", 
                       help="disables HDMI passthrough")
    return parser

def main():
    parser = _hlbt_parser()
    args, opts = parser.parse_known_args()
    args.func(args)
