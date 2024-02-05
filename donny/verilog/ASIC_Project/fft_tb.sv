module fft_tb();

    logic clk, rst;
    logic [((16 * 64) - 1) : 0] input_sig;
    logic [((16 * 64) - 1) : 0] output_sig;
    
    
    initial begin
    integer i;
    clk = 0;
    rst = 1;
    #5 rst  = 0;
    #5 rst  = 1;

    
    for(i = 0; i < 64; i++) begin
       input_sig[(16*i + 15) -: 16] = i;
    end

    #1000
    $finish;
    end

    always begin
        #5
        clk = ~clk;
    end

    fft #(
        .D_WIDTH(64),
        .LOG_2_WIDTH(6)
    ) fft_test(
    .input_sig(input_sig),
    .clk(clk),
    .rst(rst),
    .output_sig(output_sig)
    );


   
endmodule