import argparse
import os
import shutil
import sys
import HDMI_LED_Backlight as hlb

def init_hlb(args):
    hlb.overlays.BacklightOverlay('HDMI_LED_Backlight.bit')

def update_settings(args):
    overlay = hlb.overlays.BacklightOverlay('HDMI_LED_Backlight.bit', dowload=False)
    overlay.configure_hdmi()
    num_leds = {"top":args.top_leds, "bottom":args.bottom_leds, "left":args.left_leds, "right":args.right_leds};
    overlay.set_num_ws_leds(num_leds)
    overlay.calc_bounds()

def loopback(args):
    overlay = hlb.overlays.BacklightOverlay('HDMI_LED_Backlight.bit', download=False)
    if (args.enable):
        hdmi_in = overlay.video.hdmi_in
        hdmi_out = overlay.video.hdmi_out
        hdmi_in.configure()
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
    
    enable = subparsers.add_parser("loopback", help="enable the HDMI to LED pipeline")
    enable.set_defaults(func=loopback)
    enable.add_argument("-e", "--enable", action="store_true", 
                       help="enables HDMI loopback")
    enable.add_argument("-d", "--disable", action="store_true", 
                       help="disables HDMI loopback")
    return parser

def main():
    parser = _hlbt_parser()
    args, opts = parser.parse_known_args()
    args.func(args)
