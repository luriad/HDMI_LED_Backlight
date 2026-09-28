import pynq
from pynq import GPIO
import pynq.lib
import pynq.lib.video
import pynq.lib.audio
import math

class BacklightOverlay(pynq.Overlay):
     """ The HDMI LED Backlight overlay for the Pynq-Z2

     This overlay is designed to interact with the HDMI video pipeline
     and external WS2812C LED strips through the PMODA connector.
     It exposes the following attributes:

     Attributes
     ----------

     leds : AxiGPIO
          4-bit output GPIO for interacting with the green LEDs LD0-3
     buttons : AxiGPIO
          4-bit input GPIO for interacting with the buttons BTN0-3
     switches : AxiGPIO
          2-bit input GPIO for interacting with the switches SW0 and SW1
     rgbleds : [pynq.board.RGBLED]
          Wrapper for GPIO for LD4 and LD5 multicolour LEDs
     video : pynq.lib.video.HDMIWrapper
          HDMI input and output interfaces
     audio : pynq.lib.audio.Audio
          Headphone jack and on-board microphone
     LED_Driver : HDMI_LED_Backlight
          Driver of WS2812C LEDs through PMODA

     """

     def __init__(self, bitfile, **kwargs):
          super().__init__(bitfile, **kwargs)
          if self.is_loaded():
               self.audio = self.audio_codec_ctrl_0
               self.audio.configure()

               self.leds = self.leds_gpio.channel1
               self.switches = self.switches_gpio.channel1
               self.buttons = self.btns_gpio.channel1
               self.leds.setlength(4)
               self.switches.setlength(2)
               self.buttons.setlength(4)
               self.leds.setdirection("out")
               self.switches.setdirection("in")
               self.buttons.setdirection("in")
               self.rgbleds = ([None] * 4) + [pynq.lib.RGBLED(i) for i in range(4, 6)]

               self.resolution = [0,0]
               self.num_ws_leds = {"top":0, "bottom":0, "left":0, "right":0}
               self.bounds = {"top":[[0,0],[0,0]], "bottom":[[0,0],[0,0]], "left":[[0,0],[0,0]], "right":[[0,0],[0,0]]}
               self.interval = {"top":0, "bottom":0, "left":0, "right":0}

     def get_resolution(self):
          return self.resolution

     def set_resolution(self, new_resolution):
          if (len(new_resolution) != 2):
               raise ValueError("Wrong number of elements in resolution specification")
          self.resolution = new_resolution
          self.LED_Driver.color_router_0.set_resolution(new_resolution)

     def get_num_ws_leds(self):
          return num_ws_leds

     def set_num_ws_leds(self, new_nums):
          for key, value in new_nums.items():
               if key != "top" and key != "bottom" and key != "left" and key != "right":
                    raise ValueError(f"Wrong side name: {key}")
               self.num_ws_leds[key] = value

     def calc_bounds(self):
          for key, num_leds in self.num_ws_leds.items():
               interval = 0
               res = 0
               if key == "top" or key == "bottom":
                    res = self.resolution
               else:
                    res = [self.resolution[1], self.resolution[0]]
               interval = math.floor(res[0]/num_leds)
               box_height = interval
               box_width = interval * num_leds
               diff = res[0] - box_width
               left_pos = math.floor(diff / 2)
               right_pos = left_pos + box_width - 1
               if key == "top": 
                    self.bounds[key] = [[left_pos, right_pos],[0, box_height-1]]
               elif key == "bottom":
                    self.bounds[key] = [[left_pos, right_pos],[res[1]-box_height, res[1]-1]]
               elif key == "left":
                    self.bounds[key] = [[0, box_height-1],[left_pos, right_pos]]
               else:
                    self.bounds[key] = [[res[1]-box_height, res[1]-1],[left_pos, right_pos]]
               self.interval[key] = interval

          self.LED_Driver.color_router_0.set_bounds(self.bounds)

          self.LED_Driver.color_indexer_top.set_bounds(self.bounds["top"])
          self.LED_Driver.color_indexer_bottom.set_bounds(self.bounds["bottom"])
          self.LED_Driver.color_indexer_vert_left.set_bounds(self.bounds["left"])
          self.LED_Driver.color_indexer_vert_right.set_bounds(self.bounds["right"])

          self.LED_Driver.color_indexer_top.set_interval(self.interval["top"])
          self.LED_Driver.color_indexer_bottom.set_interval(self.interval["bottom"])
          self.LED_Driver.color_indexer_vert_left.set_interval(self.interval["left"])
          self.LED_Driver.color_indexer_vert_right.set_interval(self.interval["right"])

          self.LED_Driver.multi_color_acc_top.set_max_count(self.interval["top"]**2)
          self.LED_Driver.multi_color_acc_bottom.set_max_count(self.interval["bottom"]**2)
          self.LED_Driver.multi_color_acc_left.set_max_count(self.interval["left"]**2)
          self.LED_Driver.multi_color_acc_right.set_max_count(self.interval["right"]**2)
