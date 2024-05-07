import serial

ser = serial.Serial('COM7', 781250, timeout=1)

num = 0

msg = "let's see if this works "

line = ""

for i in range(100):

    send = msg + str(num) + "\n"

    num = num + 1

    line += send

print(len(line))

ser.write(bytes(line, 'ascii'))

print(ser.read(10000))
    



