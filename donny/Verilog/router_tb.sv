module fft_tb();

    logic clk, rst;
    logic [15:0] input_sig_Re [63:0];
    logic [15:0] input_sig_Im [63:0];
    logic [15:0] output_sig_Re [63:0];
    logic [15:0] output_sig_Im [63:0];
    
    
    initial begin
    integer i;
    clk = 0;
    rst = 1;
    #5 rst  = 0;
    #5 rst  = 1;

    
    for(i = 0; i < 64; i++) begin
        input_sig_Re[i] = i;
        input_sig_Im[i] = i;
    end

    #100
    $finish;
    end

    always begin
        #5
        clk = ~clk;
    end

    InputSignalRouter #(
        .D_WIDTH(64),
        .LOG_2_WIDTH(6)
    ) fft_test(
    .input_sig_Re(input_sig_Re),
    .input_sig_Im(input_sig_Im),
    .clk(clk),
    .rst(rst),
    .output_sig_Re(output_sig_Re),
    .output_sig_Im(output_sig_Im)
    );


   
endmodule

// module fft_tb();
//     logic start, clk, rst;
//     wire out;
//     CountTo64 CountTo64TB(.start(start), .clk(clk), .rst(rst), .out(out));

//     initial begin
//         clk = 0;
//         start = 0;
//         rst  = 0;
//         #5 rst  = 1;
//         #15 start = 1;
//         #10 start = 0;
//         #1000
//         $finish;
//     end

//     always begin
//         #5
//         clk = ~clk;
//     end

// endmodule



//     logic start, clk, rst;
//     wire [4:0] out;

//     StageClock StageClockTest(.start(start), .shift(clk), .rst(rst), .out(out));

//     initial begin
//         clk = 0;
//         rst  = 0;
//         start = 0;
//         #5 rst  = 1;
//         #10 start = 1;
//         #10 start = 0;
//         #100 start = 1;
//         #30 start = 0;
//         #100
//         $finish;
//     end

//     always begin
//         #5
//         clk = ~clk;
//     end

// endmodule


// module fft_tb();
//     logic [5:0] twiddle;
//     logic start, clk, rst;
//     wire [5:0] out;
//     TwiddleFactorIndex TwiddleFactorIndexTB(.stage(twiddle), .start(start), .clk(clk), .rst(rst), .out(out));

//     initial begin
//         twiddle = 32;
//         clk = 0;
//         start = 0;
//         rst  = 0;
//         #5 rst  = 1; start = 1;
//         #10 start = 0;
//         #60 twiddle = 4; start = 1;
//         #10 start = 0;
//         #1000
//         $finish;
//     end

//     always begin
//         #5
//         clk = ~clk;
//     end

// endmodule
