module decode_tb ();

    // parameters
    logic           clk, rstb, valid;
    logic [20:0]    encoded;
    logic [15:0]    decoded;

    // set values for testing
    initial begin
        clk = 0;
        rstb = 1;
        encoded = 82;
        // should return 10

        #10 rstb = 0;
        #10 rstb = 1;

        #10 encoded = 599040;
        // should return 19008

        #10 encoded = 599168;
        // single bit error @ encoded[7] -> returns 19008

        #10 encoded = 599104;
        // single bit error @ encoded[6] -> returns 19008

        #10 encoded = 74752;
        // single bit error @ encoded[19] -> returns 19008

        #30 $finish;
    end

    // clocking
    always begin
        #5
        clk = ~clk;
    end

    // initialize decoder module
    decode #(
        .data_width(16),
        .encoding_width(21)
    ) decoder (
        .clk(clk),
        .rstb(rstb),
        .encoded_data(encoded),
        .decoded_data(decoded),
        .valid(valid)
    );



endmodule