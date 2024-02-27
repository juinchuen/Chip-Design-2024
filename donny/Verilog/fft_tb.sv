// module fft_tb();

//     logic clk, rst;
//     logic [((16 * 64) - 1) : 0] input_sig;
//     logic [((16 * 64) - 1) : 0] output_sig;
    
    
//     initial begin
//     integer i;
//     clk = 0;
//     rst = 1;
//     #5 rst  = 0;
//     #5 rst  = 1;

    
//     for(i = 0; i < 64; i++) begin
//        input_sig[(16*i + 15) -: 16] = i;
//     end

//     #1000
//     $finish;
//     end

//     always begin
//         #5
//         clk = ~clk;
//     end

//     InputSignalSorter #(
//         .D_WIDTH(64),
//         .LOG_2_WIDTH(6)
//     ) fft_test(
//     .input_sig(input_sig),
//     .clk(clk),
//     .rst(rst),
//     .output_sig(output_sig)
//     );


   
// endmodule

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

module fft_tb;
    // declare stimuli
    reg [15:0] input_Re [63:0];
    reg [15:0] input_Im [63:0];
    reg start, clk, rst;
    wire [15:0] output_Re [63:0];
    wire [15:0] output_Im [63:0];

    // instantiate uut
    Butterfly uut(
        .input_Re(input_Re),
        .input_Im(input_Im),
        .start(start),
        .clk(clk),
        .rst(rst),
        .output_Re(output_Re),
        .output_Im(output_Im)
    );

    // clock gen
    always #5 clk = ~clk;

    // begin simulation
    initial begin
        clk = 0;
        rst = 0;
        #5
        rst = 1;

        for (int i = 0; i < 64; i = i + 1) begin
            input_Re[i] = 16'b0000000000000001;
            input_Im[i] = 16'b0000000000000000;
        end

        #1
        start = 0;
        #10
        start = 1;

        // end simulation
        #1000 $finish;
    end
endmodule