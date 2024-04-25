import csv

def twos_complement_to_int(binary_str):
    """Convert a binary string in 2's complement to an integer."""
    if binary_str[0] == '1':  # If the number is negative
        return -1 * (int(''.join('1' if b == '0' else '0' for b in binary_str), 2) + 1)
    else:
        return int(binary_str, 2)

def calculate_error(expected, actual):
    """Calculate the percentage error between expected and actual values."""
    try:
        error = abs(expected - actual) / abs(expected) * 100
    except ZeroDivisionError:
        error = 0  # Handle division by zero if expected is 0
    return error

def process_files(expected_file, actual_file, output_file):
    with open(expected_file, 'r') as exp_f, open(actual_file, 'r') as act_f, open(output_file, 'w', newline='') as out_f:
        exp_reader = csv.reader(exp_f)
        act_reader = csv.reader(act_f)
        out_writer = csv.writer(out_f)

        for exp_line, act_line in zip(exp_reader, act_reader):
            # Process the first value in the pair
            exp_val1 = twos_complement_to_int(exp_line[0])
            act_val1 = twos_complement_to_int(act_line[0])
            error1 = calculate_error(exp_val1, act_val1)

            # Process the second value in the pair
            exp_val2 = twos_complement_to_int(exp_line[1])
            act_val2 = twos_complement_to_int(act_line[1])
            error2 = calculate_error(exp_val2, act_val2)

            out_writer.writerow([f'{error1:.1f}%', f'{error2:.1f}%'])

# Replace 'expected_fft_output.csv' and 'actual_fft_output.csv' with the paths to your CSV files
process_files('expected_fft_output.csv', 'actual_fft_output.csv', 'error_output.csv')
