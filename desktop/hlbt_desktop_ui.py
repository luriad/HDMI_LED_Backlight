import hlbt_desktop as d
import serial

valid_commands = {"connect":True, "disconnect":True, "init":True, "update-settings":True, "output-enable":True, "output-disable":True, "passthrough-enable":True, "passthrough-disable":True, "exit":True}

ser = serial.Serial()
while (True):
    print("> ", end='')
    cmd = input()
    if not cmd in valid_commands.keys():
        print("Invalid command")

    elif cmd == "connect":
        print("port: ", end='')
        port = input()
        ser = d.connect(port)
        d.login(ser)

    elif cmd == "disconnect":
        d.logout(ser)
        d.disconnect(ser)

    elif cmd == "init":
        d.init(ser)

    elif cmd == "update-settings":
        print("top: ", end='')
        top = input()
        print("bottom: ", end='')
        bottom = input()
        print("left: ", end='')
        left = input()
        print("right: ", end='')
        right = input()
        d.update_settings(ser, top, bottom, left, right)

    elif cmd == "output-enable":
        d.enable_output(ser, True)

    elif cmd == "output-disable":
        d.enable_output(ser, False)

    elif cmd == "passthrough-enable":
        d.enable_passthrough(ser, True)

    elif cmd == "passthrough-disable":
        d.enable_passthrough(ser, False)

    elif cmd == "exit":
        break