import serial

ser = serial.Serial('COM7', 115200, timeout=1)

send = [9, 103, 37]

ser.write(bytes(send))

ser.close()

#  174 17