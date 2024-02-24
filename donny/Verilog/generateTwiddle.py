import cmath
NUM_BITS = 12

def round_to_nearest(value, precision):
    return round(value / precision) * precision

def calculate_twiddle_factors(N, precision= 1/(2**(12-1))):
    twiddle_factors = [
        (
            int(round_to_nearest(cmath.exp(-2j * cmath.pi * k / N).real, precision)* 2**(NUM_BITS-1)),
            int(round_to_nearest(cmath.exp(-2j * cmath.pi * (k + N/2) / N).imag, precision)* 2**(NUM_BITS-1)),
        )
        for k in range(N)
    ]
    return twiddle_factors

N = 64
precision = 0.00390625
twiddle_factors = calculate_twiddle_factors(N, precision)

re_dict = {}
im_dict = {}

for index, (real_part, imag_part) in enumerate(twiddle_factors):
    if real_part in re_dict:
        re_dict[real_part] = f"{re_dict[real_part]}or{index}"
    else:
        re_dict[real_part] = f"{index}"
    
    if imag_part in im_dict:
        im_dict[imag_part] = f"{im_dict[imag_part]}or{index}"
    else:
        im_dict[imag_part] = f"{index}"

# Open a file for writing
with open("twiddle_factors.sv", "w") as file:
    # Redirect the output to the file
    for key, value in re_dict.items():
        print(f"`define ReW{value} {NUM_BITS}'d{key}", file=file)
    for key, value in im_dict.items():
        print(f"`define ImW{value} = {NUM_BITS}'d{key}", file=file)

# Confirmation message
print("Twiddle factors have been saved to 'twiddle_factors.sv'")
