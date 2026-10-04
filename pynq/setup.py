from setuptools import setup, find_namespace_packages
from pynq.utils import build_py

setup(
    name = "HDMI_LED_Backlight",
    version = "0.1",
    url = 'https://github.com/luriad/HDMI_LED_Backlight',
    license = 'GPL-3.0',
    author = "David Luria",
    author_email = "dluria13@gmail.com",
    packages = find_namespace_packages(),
    package_data =  {
        'HDMI_LED_Backlight': ['*.bit', '*.hwh'], 
        'HDMI_LED_Backlight.notebooks': ['*.ipynb']
    },
    inlcude_package_data=True,
    install_requires=[
        'pynq'
    ],
    setup_requires=[
        'pynq'
    ],
    entry_points={
        'pynq.overlays': ['HDMI_LED_Backlight = HDMI_LED_Backlight'],
        'pynq.notebooks': ['HDMI_LED_Backlight = HDMI_LED_Backlight.notebooks'],
        "console_scripts": ["pynq-hlbt = hlbt.hlbt:main"],
    },
    cmdclass={'build_py': build_py},
    description = "Overlay for HDMI LED Backlight repo"
)