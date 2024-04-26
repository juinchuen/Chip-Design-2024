

with open("signal_router.sv", "w") as file:
    print(f'''module InputSignalRouter #(
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input logic [15:0] input_sig_Re [((D_WIDTH) - 1):0],
    input logic [15:0] input_sig_Im [((D_WIDTH) - 1):0],
    output logic [15:0] output_sig_Re [((D_WIDTH) - 1):0],
    output logic [15:0] output_sig_Im [((D_WIDTH) - 1):0]
);
    // Correctly route the input signal

    logic [15:0] fft_Re [((D_WIDTH) - 1):0];
    logic [15:0] fft_Im [((D_WIDTH) - 1):0];''', file=file)
    for i in range(64):
        ii = 0
        x = i
    
        for j in range(6):
            ii <<= 1
            ii |= (x & 1)
            x >>= 1
        print(f'\tassign fft_Re[{i}] = input_sig_Re[{ii}];', file=file)
        print(f'\tassign fft_Im[{i}] = input_sig_Im[{ii}];', file=file)
    print(f'\tassign output_sig_Re = fft_Re;', file=file)
    print(f'\tassign output_sig_Im = fft_Im;', file=file)   
    print(f'endmodule', file=file)
    
        
        
        
    
