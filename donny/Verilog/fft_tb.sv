// module fft_tb();
//     // declare stimuli
//     logic [15:0] input_Re [63:0];
//     logic [15:0] input_Im [63:0];
//     logic start, clk, rst, ifft;
//     logic [15:0] output_Re [63:0];
//     logic [15:0] output_Im [63:0];

//     // instantiate uut
//      FFT fft(
//         .input_Re(input_Re),
//         .input_Im(input_Im),
//         .start(start),
//         .clk(clk),
//         .rst(rst),
//         .ifft(ifft),
//         .output_Re(output_Re),
//         .output_Im(output_Im)
//     );

//     // clock gen
//     always #5 clk = ~clk;

//     int file;
//     bit [15:0] value_Re, value_Im;
//     string filename = "data.csv";

//     // begin simulation
//     initial begin
//         clk = 0;
//         rst = 0;
//         #5
//         rst = 1;
//         ifft = 0;

//         // open data.csv and load into the fft module
//         file = $fopen(filename, "r");
//         if (file == 0) begin
//             $display("Failed to open %s", filename);
//             $finish;
//         end

//         for (int i = 0; i < 64; i = i + 1) begin
//             if ($feof(file)) begin
//                 $display("End of file reached before reading 64 entries");
//                 $finish;
//             end

//             if ($fscanf(file, "%b,%b\n", value_Re, value_Im) != 2) begin
//                 $display("Error reading line %d from the file.", i+1);
//                 $finish;
//             end

//             input_Re[i] = value_Re;
//             input_Im[i] = value_Im;
//         end

//         $fclose(file);

//         #1
//         start = 0;
//         #15
//         start = 1;
//         #15
//         start = 0;

//         // wait 1000 time units
//         #2000
//         $finish;
//     end
// endmodule

module fft_tb();
    // declare stimuli
    logic [15:0] input_Re [63:0];
    logic [15:0] input_Im [63:0];
    logic start, clk, rst;
    logic [15:0] output_Re [63:0];
    logic [15:0] output_Im [63:0];

    // instantiate uut
     FFT fft(
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
            if (i < 32) begin
                input_Re[i] = 16'b0000000000100000;
                input_Im[i] = 16'b0000000000000000;
            end else begin
                input_Re[i] = 16'b0000000000000000;
                input_Im[i] = 16'b0000000000000000;
            end
        end

        #1
        start = 1;
        #12
        start = 0;

        // end simulation

        #2000 
        for (int i = 0; i < 64; i = i + 1) begin
            $display("output_Re[%0d] = %0d", i, output_Re[i]);
        end
        $finish;
    end
endmodule