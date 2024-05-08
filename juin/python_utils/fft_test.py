import serial
import time

ser = serial.Serial('COM7', 781250, timeout=1)

f_in = open("../top/fft_in.txt", "r")

f_out = open("../top/fft_test_out.txt", "w")

for line in f_in.readlines():

    # print(line)s

    ser.write(int(line).to_bytes(2,'big'))

retval = ser.read(512)

for i in range(int(len(retval)/2)):

    f_out.write(str( retval[2 * i + 1] + 256 * retval[2 * i] ) + "\n")

f_in.close()
f_out.close()


# for i in range(256):

#     print("writing " + str(num))

#     ser.write(num.to_bytes(2, 'big'))

#     num = num + 1

#     time.sleep(0.05)



