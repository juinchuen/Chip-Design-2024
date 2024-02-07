with open("twiddle_factors.sv", "w") as file:
    # Redirect the output to the file
    for key, value in re_dict.items():
        print(f"`define ReW{value} {NUM_BITS}'d{key}", file=file)
    for key, value in im_dict.items():
        print(f"`define ImW{value} = {NUM_BITS}'d{key}", file=file)
