import serial

def connect(port):
    ser = serial.Serial(port)
    ser.baudrate = 115200
    ser.write(b'sudo su\n')
    ser.write(b'xilinx\n')
    return ser

def disconnect(ser):
    ser.write(b'exit\n')
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