import time

num = 0

for i in range(10):

    print("Testing: " + str(num), end = "\r")

    num = num + 1

    time.sleep(1)