import serial
from time import sleep

def connect(port):
    ser = serial.Serial(port)
    ser.baudrate = 115200
    return ser

def login(ser):
    ser.write(b'sudo su\n')
    ser.write(b'xilinx\n')
    sleep(5)

def logout(ser):
    ser.write(b'exit\n')

def disconnect(ser):
    ser.close()

def init(ser):
    ser.write(b'pynq-hlbt init\n')

def update_settings(ser, top, bottom, left, right):
    ser.write(f'pynq-hlbt update-settings -t {top} -b {bottom} -l {left} -r {right}\n'.encode())

def enable_output(ser, enable):
    if enable:
        ser.write(b'pynq-hlbt output -e\n')
    else:
        ser.write(b'pynq-hlbt output -d\n')

def enable_passthrough(ser, enable):
    if enable:
        ser.write(b'pynq-hlbt passthrough -e\n')
    else:
        ser.write(b'pynq-hlbt passthrough -d\n')