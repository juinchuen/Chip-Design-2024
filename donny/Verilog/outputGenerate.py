import numpy as np
import csv

# Function to read input data from CSV
def read_input_csv(filename):
    input_data = []
    with open(filename, 'r') as csvfile:
        csvreader = csv.reader(csvfile)
        for row in csvreader:
            # Convert binary strings to integers and then to complex numbers
            real_part = int(row[0], 2)
            imag_part = int(row[1], 2)
            input_data.append(complex(real_part, imag_part))
    return np.array(input_data)

# Function to perform FFT
def perform_fft(input_data):
    return np.fft.fft(input_data)

import csv
import numpy as np

# Function to write FFT output to CSV in the same format as the input
def write_output_csv(data, filename):
    with open(filename, 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        for val in data:
            # Convert complex numbers to 16-bit integers
            real_part = np.int16(np.round(val.real))
            imag_part = np.int16(np.round(val.imag))
            # Format as 16-bit binary strings
            formatted_real = format(real_part & 0xffff, '016b')
            formatted_imag = format(imag_part & 0xffff, '016b')
            csvwriter.writerow([formatted_real, formatted_imag])

# Main function
def main():
    input_filename = 'data.csv'
    output_filename = 'expected_fft_output.csv'

    # Read the input data
    input_data = read_input_csv(input_filename)

    # Perform FFT
    fft_output = perform_fft(input_data)

    # Write the output data
    write_output_csv(fft_output, output_filename)

    print(f"FFT output has been written to '{output_filename}' in the same format as the input.")

if __name__ == "__main__":
    main()
