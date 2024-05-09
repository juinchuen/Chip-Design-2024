# module Router declaration
# this only generates the input and output wires
# remember to delete the final comma, found in: "output wire [15:0] outIm63,"
for i in range(64):  # 0 to 63
    print(f"input wire [15:0] inRe{i},")
    print(f"input wire [15:0] inIm{i},")
    print(f"output wire [15:0] outRe{i},")
    print(f"output wire [15:0] outIm{i},")

# body
# this will generate everything between "always @(stage) begin" and "end"
for stage in range(1, 7, 1): # increments stages 1-6
    if (stage > 1):  # write "else if"
        print("else", end = ' ')
    print(f"if (stage == {stage}) begin")

    for i in range(64):  # 0 to 63
        groupSize = 2 ** stage  # flip by group: stage one flips 2, stage two flips 4, etc.
        if ((i % groupSize) < (groupSize / 2)):  # top half of the wires: move them down by 2^(stage - 1)
            print(f"\toutRe{i + 2**(stage - 1)} = inRe{i};")
            print(f"\toutIm{i + 2 ** (stage - 1)} = inIm{i};")
        else: # bottom half of the wires: move them up by 2^(stage - 1)
            print(f"\toutRe{i - 2 ** (stage - 1)} = inRe{i};")
            print(f"\toutIm{i - 2 ** (stage - 1)} = inIm{i};")

    print("end", end=" ")  # for aesthetic purposes, have "end else if (stage == n)" all on the same line