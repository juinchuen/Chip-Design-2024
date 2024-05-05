module encode_tb ();

    // parameters
    logic           clk, rstb, valid_in, valid_out;
    logic [20:0]    encoded_data;
    logic [15:0]    raw_data;

    // set values for testing
    initial begin
        clk = 0;
        rstb = 1;
        valid_in = 1;
        raw_data = 10;
        // should return 82

        #10 rstb = 0;
        #10 rstb = 1;

        #10 encoded_data = 19008;
        // 599040

        #10 encoded_data = 44561;
        // 1433996

        #30 $finish;
    end

    // clocking
    always begin
        #5
        clk = ~clk;
    end

    // initialize encoder module
    encode #(
    .data_width(16),
    .encoding_width(21)
    ) encoder(
    .clk(clk),
    .rstb(rstb),
    .raw_data(raw_data),
    .valid_in(valid_in),
    .encoded_data(encoded_data),
    .valid_out(valid_out)
    );


endmodule