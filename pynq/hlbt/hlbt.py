import argparse
import os
import shutil
import sys
import HDMI_LED_Backlight as hlb

def UpdateSettings(args):
    overlay = hlb.overlays.BacklightOverlay('HDMI_LED_Backlight.bit', download=args.init)
    hdmi_in = overlay.video.hdmi_in
    hdmi_in.stop()
    hdmi_out = overlay.video.hdmi_out
    hdmi_out.stop()

    overlay.set_resolution([args.resolution_width, args.resolution_height])
    num_leds = {"top":args.top_leds, "bottom":args.bottom_leds, "left":args.left_leds, "right":args.right_leds};
    overlay.set_num_ws_leds(num_leds)
    overlay.calc_bounds()

def EnableHDMI(args):
    overlay = hlb.overlays.BacklightOverlay('HDMI_LED_Backlight.bit', download=False)
    hdmi_in = overlay.video.hdmi_in
    hdmi_in.configure()
    hdmi_in.start()
    if args.loopback:
        hdmi_out = overlay.video.hdmi_out
        hdmi_out.configure(hdmi_in.mode)
        hdmi_out.start()
        hdmi_in.tie(hdmi_out)

def DisableHDMI(args):
    overlay = hlb.overlays.BacklightOverlay('HDMI_LED_Backlight.bit', download=False)
    hdmi_in = overlay.video.hdmi_in
    hdmi_in.stop()
    hdmi_out = overlay.video.hdmi_out
    hdmi_out.stop()

def _hlbt_parser():
    """Initialize and return the argument parser."""
    parser = argparse.ArgumentParser(description="HDMI LED Backlight Tool")
    subparsers = parser.add_subparsers(required=True)
                       
    settings = subparsers.add_parser("update-settings", help="update LED driver settings. Needs to be enabled after changing settings.")
    settings.set_defaults(func=UpdateSettings)
    settings.add_argument("-i", "--init", action="store_true",
                       help="program the PL with the overlay bitstream")
    settings.add_argument("-w", "--resolution-width", type=int, required=True,
                       help="the display resolution width in pixels")
    settings.add_argument("-s", "--resolution-height", type=int, required=True,
                       help="the display resolution height in pixels")
    settings.add_argument("-t", "--top-leds", type=int, required=True,
                       help="the number of LEDs in the top string")
    settings.add_argument("-b", "--bottom-leds", type=int, required=True,
                       help="the number of LEDs in the bottom string")
    settings.add_argument("-l", "--left-leds", type=int, required=True,
                       help="the number of LEDs in the left string")
    settings.add_argument("-r", "--right-leds", type=int, required=True,
                       help="the number of LEDs in the top string")
    
    enable = subparsers.add_parser("enable", help="enable the HDMI to LED pipeline")
    enable.set_defaults(func=EnableHDMI)
    enable.add_argument("-l", "--loopback", action="store_true", 
                       help="enables HDMI loopback")

    disable = subparsers.add_parser("disable", help="disable the HDMI to LED pipeline")
    disable.set_defaults(func=DisableHDMI)
    return parser

def main():
    parser = _hlbt_parser()
    args, opts = parser.parse_known_args()
    args.func(args)
