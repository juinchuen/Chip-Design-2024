import serial

ser = serial.Serial('COM7', 115200, timeout=1)

send = [8, 230, 93]

ser.write(bytes(send))

msg = ser.read(2)

ser.close()

print(msg)

print(msg[0] * 256 + msg[1])

print(msg[1] * 256 + msg[0])

