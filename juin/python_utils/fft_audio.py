import sounddevice as sd

import matplotlib.pyplot as plt
import matplotlib as mpl

import numpy as np

import serial

import time

import sys as system

class fft_audio:

    def __init__(self, COM_port = "COM7", fs = 1024, duration = 5,\
                device_id = 2, window_width = 64, fft_max_bits = 4, baudrate = 781250):

        self.COM_port = COM_port
        self.fs =fs
        self.duration = duration
        self.device_id = device_id
        self.width = window_width
        self.half = int(self.width / 2)
        self.max_bits = fft_max_bits
        self.baudrate = baudrate

        self.ser = serial.Serial(COM_port, baudrate, timeout = 1)
        self.ser.set_buffer_size(rx_size = 32768, tx_size = 32768)

    def record_audio(self):

        num = 3

        self.sig = sd.rec(int((self.duration + 3) * self.fs), samplerate = self.fs, channels = 1, device=2)

        while num != 0:

            print("Countdown: " + str(num), end = '\r')

            num = num - 1

            time.sleep(1)

        print("Say something!")

        sd.wait()

        self.sig = self.sig.flatten()

        self.sig = self.sig[3072:]

        self.windlist = []

        index = 0

        scale = max(np.max(self.sig), -np.min(self.sig))

        self.sig = (self.sig / scale) * (2 ** self.max_bits)

        while (index + self.width < len(self.sig)):

            self.windlist.append(self.sig[index : index + self.width])

            index = index + self.half

    def numpy_fft(self):

        self.fft_debug = []

        for w in self.windlist:

            self.fft_debug.append(np.fft.fft(w))

        self.fft_debug = np.array(self.fft_debug)
        self.fft_debug = np.absolute(self.fft_debug)
        self.fft_debug = self.fft_debug.transpose()

        self.fft_debug = self.fft_debug[self.half:]
        self.fft_debug = self.fft_debug - np.min(self.fft_debug)
        self.fft_debug = self.fft_debug / np.max(self.fft_debug)
        self.fft_debug = self.fft_debug * 255

        plt.imshow(self.fft_debug, cmap='gray', vmin = 0, vmax=255, interpolation='nearest', aspect=2)

    def fpga_fft(self):

        self.fft_fpga = []
        self.fft_fpga_real = []
        self.fft_fpga_imag = []

        for w in self.windlist:

            # send data to fpga
            self.send_to_fpga(w)

        for j in range(158):

            raw = []

            bytes = self.ser.read(256)

            for i in range(128):

                raw.append(int.from_bytes(bytes[2*i:2*i+2], byteorder=system.byteorder, signed=True))

            real = raw[:64]
            imag = raw[64:] 

            abs = np.sqrt(np.multiply(real, real) + np.multiply(imag, imag))

            self.fft_fpga.append(abs)
            self.fft_fpga_real.append(real)
            self.fft_fpga_imag.append(imag)

        # process data
        self.fft_fpga = np.array(self.fft_fpga)
        self.fft_fpga = self.fft_fpga.transpose()
        self.fft_fpga = self.fft_fpga[self.half:]
        self.fft_fpga = self.fft_fpga - np.min(self.fft_fpga)
        self.fft_fpga = self.fft_fpga / np.max(self.fft_fpga)
        self.fft_fpga = self.fft_fpga * 255
        plt.imshow(self.fft_fpga, cmap='gray', vmin = 0, vmax=255, interpolation='nearest', aspect=2)

    def send_to_fpga(self, window):

        self.ser.write(int("0").to_bytes(2,'big'))

        for d in window:

            self.ser.write(int(d).to_bytes(2,'big', signed=True))

        for i in range(64):

            self.ser.write(int("0").to_bytes(2,'big'))

        time.sleep(0.01)

        # return self.ser.read(512)




        

        

