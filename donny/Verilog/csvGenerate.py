import csv
import random

# Filename for the CSV file
filename = 'data.csv'

# Open the file with write permission
with open(filename, 'w', newline='') as csvfile:
    # Create a CSV writer object
    csvwriter = csv.writer(csvfile)

    # Data to be written: 64 lines of random 16-bit binary values and zeros
    data = [(format(random.randint(0, 0xFFFF), '016b'), '0000000000000000') for _ in range(64)]

    # Write data to the CSV file
    csvwriter.writerows(data)

print(f"CSV file '{filename}' has been created with 64 lines of random values and zeros.")
