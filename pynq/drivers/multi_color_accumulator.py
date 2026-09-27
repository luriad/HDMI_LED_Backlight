from pynq import DefaultIP

class multi_color_accumulator(DefaultIP):
    bindto = ['xilinx.com:HDMI_LED_Backlight:color_indexer_vert:1.0']
    def __init__(self, description):
        super().__init__(description)
        
    def max_count():
        return self.read(0x0)

    def max_count(new_max):
        self.write(0x0, new_max)