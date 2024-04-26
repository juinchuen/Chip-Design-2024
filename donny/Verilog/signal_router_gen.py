with open("signal_router.sv", "w") as file:
    print(f'''module InputSignalRouter #(
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input logic [15:0] inputRe [((D_WIDTH) - 1):0],
    input logic [15:0] inputIm [((D_WIDTH) - 1):0],
    output logic [15:0] outputRe [((D_WIDTH) - 1):0],
    output logic [15:0] outputIm [((D_WIDTH) - 1):0]
);
    // Correctly route the input signal

    logic [15:0] fftRe [((D_WIDTH) - 1):0];
    logic [15:0] fftIm [((D_WIDTH) - 1):0];''', file=file)
    for i in range(64):
        ii = 0
        x = i
    
        for j in range(6):
            ii <<= 1
            ii |= (x & 1)
            x >>= 1
        print(f'\tassign fftRe[{i}] = inputRe[{ii}];', file=file)
        print(f'\tassign fftIm[{i}] = inputIm[{ii}];', file=file)
    print(f'\tassign outputRe = fftRe;', file=file)
    print(f'\tassign outputIm = fftIm;', file=file)   
    print(f'endmodule', file=file)
    
        
        
        
    
