from setuptools import setup
from pynq.utils import build_py
import HDMI_LED_Backlight

setup(
    name = "HDMI_LED_Backlight",
    version = "0.1",
    url = 'https://github.com/luriad/HDMI_LED_Backlight',
    license = 'GPL-3.0',
    author = "David Luria",
    author_email = "dluria13@gmail.com",
    packages = ['pynq'],
    inlcude_package_data=True,
    install_requires=[
        'pynq'
    ],
    setup_requires=[
        'pynq'
    ],
    entry_points={
        'pynq.overlays': ['overlay = BacklightOverlay.overlays']
    },
    cmdclass={'build_py': build_py},
    description = "Overlay for HDMI LED Backlight repo"
)