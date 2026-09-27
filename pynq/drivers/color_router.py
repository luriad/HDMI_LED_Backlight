from pynq import DefaultIP

class color_router(DefaultIP):
    bindto = ['xilinx.com:HDMI_LED_Backlight:color_router:1.0']
    def __init__(self, description):
        super().__init__(description)
        self.bounds = {"top":[[0,0],[0,0]], "bottom":[[0,0],[0,0]], "left":[[0,0],[0,0]], "right":[[0,0],[0,0]]}

    def resolution():
        return [self.register_map.settings_resolution_x, self.register_map.settings_resolution_y]
    
    def resolution(new_resolution):
        if (len(new_resolution) != 2):
            raise ValueError("Wrong number of elements in resolution specification")
        self.register_map.settings_resolution_x = new_resolution[0]
        self.register_map.settings_resolution_y = new_resolution[1]

    def bounds():
        return self.bounds

    def bounds(new_bounds):
        for key, value in new_bounds:
            if key != "top" or key != "bottom" or key != "left" or key != "right":
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