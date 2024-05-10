with open("signal_router.sv", "w") as file:
    print(f'''module InputSignalRouter #(
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input logic [((D_WIDTH) * 15 - 1):0] inputRe,
    input logic [((D_WIDTH) * 15 - 1):0] inputIm,
    output logic [((D_WIDTH) * 15 - 1):0] outputRe,
    output logic [((D_WIDTH) * 15 - 1):0] outputIm
);
    // Correctly route the input signal

    logic [((D_WIDTH) * 15 - 1):0] fftRe;
    logic [((D_WIDTH) * 15 - 1):0] fftIm;''', file=file)
    for i in range(64):
        ii = 0
        x = i
    
        for j in range(6):
            ii <<= 1
            ii |= (x & 1)
            x >>= 1
        print(f'\tassign fftRe[{i}* 16 +: 15] = inputRe[{ii}* 16 +: 15];', file=file)
        print(f'\tassign fftIm[{i}* 16 +: 15] = inputIm[{ii}* 16 +: 15];', file=file)
    print(f'\tassign outputRe = fftRe;', file=file)
    print(f'\tassign outputIm = fftIm;', file=file)   
    print(f'endmodule', file=file)
    
        
        
        
    
