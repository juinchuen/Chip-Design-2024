import cmath
import math
NUM_BITS =9
N = 64

def format_negative(num):
    if num < 0:
        return f"{NUM_BITS + 1}'d{abs(num)}"
    return f"-{NUM_BITS + 1}'d{abs(num)}"

def round_to_nearest(value, precision):
    return round(value / precision) * precision

def calculate_output(k, N, precision, NUM_BITS):
    result = cmath.exp(2j * cmath.pi * k / (N)).imag
    rounded_result = round_to_nearest(result, precision)
    scaled_result = int(rounded_result * 2**(NUM_BITS - 1))
    if scaled_result > 0:
        return min(256, max(0, scaled_result))
    else: 
        return max(-256, min(0, scaled_result))

def calculate_twiddle_factors(N, precision= 1/(2**(12-1))):
    twiddle_factors = [
        (
            calculate_output(k, N, precision, NUM_BITS),
            int(round_to_nearest(cmath.exp(2j * cmath.pi * (k - cmath.pi/2)/ N).imag, precision)* 2**(NUM_BITS-1)),
        )
        for k in range(N)
    ]
    return twiddle_factors


precision = 1/(2**(NUM_BITS-1))
twiddle_factors = calculate_twiddle_factors(N, precision)

moduleRe = f'''module TwiddleMux (
    input [{int((math.log2(N))-1)}:0] select,
    output [{NUM_BITS-1}:0] out
);
reg [{NUM_BITS}:0] twiddle;
always_comb begin
    case(select)
'''

moduleIm = f'''module ImTwiddleMux (
    input [{int((math.log2(N))-1)}:0] select,
    output [{NUM_BITS}:0] out
);
reg [{NUM_BITS}:0] twiddle;
always_comb begin
    case(select)'''

moduleEnd = '''
    endcase
end

assign out = twiddle;

endmodule


'''
# for index, (real_part, _) in enumerate(twiddle_factors):
#     print(real_part)
#     print(index)
# Open a file for writing
with open("twiddle_factor_mux.sv", "w") as file:
    print(moduleRe, file=file)
    # Redirect the output to the file
    i = 0
    for index, (real_part, _) in enumerate(twiddle_factors):
        num = format_negative(real_part)
        print(f"\t\t\t6'b{bin(index)[2:]}: twiddle <= {num};", file=file)
    print(moduleEnd, file=file)
    # print(moduleIm, file=file)
    # i = 0
    # for index, (real_part, imag_part) in enumerate(twiddle_factors):
    #     if i < 32:
    #         num = format_negative(imag_part)
    #         print(f"\t\t\t6'b{bin(i)[2:]}: twiddle <= {num};", file=file)
    #     i = i + 1
    # print(moduleEnd, file=file)


# Confirmation message
print("Twiddle factors have been saved to 'twiddle_factor_mux.sv'")
