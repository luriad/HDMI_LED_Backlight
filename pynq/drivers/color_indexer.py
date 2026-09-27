from pynq import DefaultIP

class color_indexer(DefaultIP):
    bindto = ['xilinx.com:HDMI_LED_Backlight:color_indexer_horiz:1.0', 'xilinx.com:HDMI_LED_Backlight:color_indexer_vert:1.0']
    def __init__(self, description):
        super().__init__(description)

    def bounds():
        return [[self.register_map.settings_bounds_x_lower, self.register_map.settings_bounds_x_upper], [self.register_map.settings_bounds_y_lower, self.register_map.settings_bounds_y_upper]]

    def bounds(new_bounds):
        if len(new_bounds) != 2 or len(new_bounds[0]) !=2 or len(new_bounds[1]) != 2:
            raise ValueError("Wrong number of elements in bounds specification")
        
        self.register_map.settings_bounds_x_lower = new_bounds[0][0]
        self.register_map.settings_bounds_x_upper = new_bounds[0][1]
        self.register_map.settings_bounds_y_lower = new_bounds[1][0]
        self.register_map.settings_bounds_y_upper = new_bounds[1][1]

    def interval():
        return self.register_map.settings_interval

    def interval(new_interval):
        self.register_map.settings_interval = new_interval