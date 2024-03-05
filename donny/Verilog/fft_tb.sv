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

    int file;
    bit [15:0] value_Re, value_Im;
    string filename = "data.csv";
    bit [15:0] input_Re[64];
    bit [15:0] input_Im[64];

    // begin simulation
    initial begin
        clk = 0;
        rst = 0;
        #5
        rst = 1;

        file = $fopen(filename, "r");
        if (file == 0) begin
            $display("Failed to open %s", filename);
            $finish;
        end

        for (int i = 0; i < 64; i = i + 1) begin
            if ($feof(file)) begin
                $display("End of file reached before reading 64 entries");
                $finish;
            end

            if ($fscanf(file, "%b,%b\n", value_Re, value_Im) != 2) begin
                $display("Error reading line %d from the file.", i+1);
                $finish;
            end

            input_Re[i] = value_Re;
            input_Im[i] = value_Im;
        end

        $fclose(file);

        #1
        start = 0;
        #15
        start = 1;
        #15
        start = 0;

        // wait 1000 time units
        #1000

        file = $fopen("fft_output.csv", "r");
        if (file == 0) begin
            $display("Failed to open fft_output.csv");
            $finish;
        end

        // Read and compare each line of the expected output
        for (i = 0; i < 64; i = i + 1) begin
            if ($feof(file)) begin
                $display("End of file reached before 64 comparisons");
                break;
            end

            // Read a line from the CSV and parse the expected values
            if ($fscanf(file, "%b,%b\n", expected_Re, expected_Im) != 2) begin
                $display("Error reading line %d from fft_output.csv", i+1);
                break;
            end

            // Compare the module output with the expected values
            if (output_Re[i] !== expected_Re || output_Im[i] !== expected_Im) begin
                $display("Mismatch at index %d: Expected (%b, %b), Got (%b, %b)",
                         i, expected_Re, expected_Im, output_Re[i], output_Im[i]);
                errors = errors + 1;
            end
        end

        // Report the comparison result
        if (errors == 0) begin
            $display("All FFT outputs matched the expected values.");
        end else begin
            $display("%d mismatches found between FFT outputs and expected values.", errors);
        end

        // Close the file
        $fclose(file);

        $finish;
    end
endmodule