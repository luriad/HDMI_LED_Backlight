from pynq import DefaultIP

class color_router(DefaultIP):
    bindto = ['xilinx.com:HDMI_LED_Backlight:color_router:1.0']
    def __init__(self, description):
        super().__init__(description)
        self.bounds = {"top":[[0,0],[0,0]], "bottom":[[0,0],[0,0]], "left":[[0,0],[0,0]], "right":[[0,0],[0,0]]}

    def get_resolution(self):
        return [self.register_map.settings_resolution_x, self.register_map.settings_resolution_y]
    
    def set_resolution(self, new_resolution):
        if (len(new_resolution) != 2):
            raise ValueError("Wrong number of elements in resolution specification")
        self.register_map.settings_resolution_x = new_resolution[0]
        self.register_map.settings_resolution_y = new_resolution[1]

    def get_bounds(self):
        return self.bounds

    def set_bounds(self, new_bounds):
        for key, value in new_bounds.items():
            if key != "top" and key != "bottom" and key != "left" and key != "right":
                raise ValueError(f"Wrong bounds box name: {key}")
            if len(value) != 2 or len(value[0]) !=2 or len(value[1]) != 2:
                raise ValueError("Wrong number of elements in bounds specification")
            self.bounds[key] = value
            
        self.register_map.settings_top_bounds_x_lower = self.bounds["top"][0][0]
        self.register_map.settings_top_bounds_x_upper = self.bounds["top"][0][1]
        self.register_map.settings_top_bounds_y_lower = self.bounds["top"][1][0]
        self.register_map.settings_top_bounds_y_upper = self.bounds["top"][1][1]

        self.register_map.settings_bottom_bounds_x_lower = self.bounds["bottom"][0][0]
        self.register_map.settings_bottom_bounds_x_upper = self.bounds["bottom"][0][1]
        self.register_map.settings_bottom_bounds_y_lower = self.bounds["bottom"][1][0]
        self.register_map.settings_bottom_bounds_y_upper = self.bounds["bottom"][1][1]

        self.register_map.settings_left_bounds_x_lower = self.bounds["left"][0][0]
        self.register_map.settings_left_bounds_x_upper = self.bounds["left"][0][1]
        self.register_map.settings_left_bounds_y_lower = self.bounds["left"][1][0]
        self.register_map.settings_left_bounds_y_upper = self.bounds["left"][1][1]

        self.register_map.settings_right_bounds_x_lower = self.bounds["right"][0][0]
        self.register_map.settings_right_bounds_x_upper = self.bounds["right"][0][1]
        self.register_map.settings_right_bounds_y_lower = self.bounds["right"][1][0]
        self.register_map.settings_right_bounds_y_upper = self.bounds["right"][1][1]

class color_indexer(DefaultIP):
    bindto = ['xilinx.com:HDMI_LED_Backlight:color_indexer_horiz:1.0', 'xilinx.com:HDMI_LED_Backlight:color_indexer_vert:1.0']
    def __init__(self, description):
        super().__init__(description)

    def get_bounds(self):
        return [[self.register_map.settings_bounds_x_lower, self.register_map.settings_bounds_x_upper], [self.register_map.settings_bounds_y_lower, self.register_map.settings_bounds_y_upper]]

    def set_bounds(self, new_bounds):
        if len(new_bounds) != 2 or len(new_bounds[0]) !=2 or len(new_bounds[1]) != 2:
            raise ValueError("Wrong number of elements in bounds specification")
        
        self.register_map.settings_bounds_x_lower = new_bounds[0][0]
        self.register_map.settings_bounds_x_upper = new_bounds[0][1]
        self.register_map.settings_bounds_y_lower = new_bounds[1][0]
        self.register_map.settings_bounds_y_upper = new_bounds[1][1]

    def get_interval(self):
        return self.register_map.settings_interval

    def set_interval(self, new_interval):
        self.register_map.settings_interval = new_interval

class multi_color_accumulator(DefaultIP):
    bindto = ['user.org:HDMI_LED_Backlight:multi_color_accumulate:1.0']
    def __init__(self, description):
        super().__init__(description)
        
    def get_max_count(self):
        return self.read(0x0)

    def set_max_count(self, new_max):
        self.write(0x0, new_max)