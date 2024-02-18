import cmath
import math
NUM_BITS = 9

def format_negative(num):
    if num < 0:
        return f"-{NUM_BITS}'d{abs(num)}"
    return f"{NUM_BITS}'d{num}"

def round_to_nearest(value, precision):
    return round(value / precision) * precision

def calculate_twiddle_factors(N, precision= 1/(2**(12-1))):
    twiddle_factors = [
        (
            int(round_to_nearest(cmath.exp(-2j * cmath.pi * k / N).real, precision)* 2**(NUM_BITS-1)),
            int(round_to_nearest(cmath.exp(-2j * cmath.pi * k / N).imag, precision)* 2**(NUM_BITS-1)),
        )
        for k in range(N)
    ]
    return twiddle_factors

N = 64
precision = 1/(2**(9-1))
twiddle_factors = calculate_twiddle_factors(N, precision)

moduleRe = f'''module ReTwiddleMux (
    input [{int((math.log2(N))-1)}:0] select,
    output [{NUM_BITS-1}:0] out
);
reg [{NUM_BITS-1}:0] twiddle;
always_comb begin
    case(select)
'''

moduleIm = f'''module ImTwiddleMux (
    input [{int((math.log2(N))-1)}:0] select,
    output [{NUM_BITS-1}:0] out
);
reg [{NUM_BITS-1}:0] twiddle;
always_comb begin
    case(select)'''

moduleEnd = '''
    endcase
end

assign out = twiddle;

endmodule


'''

# Open a file for writing
with open("twiddle_factor_mux.sv", "w") as file:
    print(moduleRe, file=file)
    # Redirect the output to the file
    i = 0
    for index, (real_part, _) in enumerate(twiddle_factors):
        if i < 32:
            num = format_negative(real_part)
            print(f"\t\t\t6'b{bin(i)[2:]}: twiddle = {num};", file=file)
        i = i + 1
    print(moduleEnd, file=file)
    print(moduleIm, file=file)
    i = 0
    for index, (real_part, imag_part) in enumerate(twiddle_factors):
        if i < 32:
            num = format_negative(imag_part)
            print(f"\t\t\t6'b{bin(i)[2:]}: twiddle = {num};", file=file)
        i = i + 1
    print(moduleEnd, file=file)


# Confirmation message
print("Twiddle factors have been saved to 'twiddle_factor_mux.sv'")
