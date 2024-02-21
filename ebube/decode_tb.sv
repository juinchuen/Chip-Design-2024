module moduleName ();
    // parameters
    logic clk, rstb;
    logic [31:0] n, received[];
    wire no_error;
    wire [31:0] out_data;

    // clocking
    always begin
        #5
        clk = ~clk;
    end

    // initialize decoder module
    decode decoder(
        .clk(clk),
        .rstb(rstb),
        .n(n),
        .received(received),
        .no_error(no_error),
        .data(out_data),
    );

    // set values for testing
    initial begin
        clk = 0;
        rstb = 0;
        // test case 1: n, received (ideal)
        // should return 10110010101100101011001010110010
        n = 32;
        received = [1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1]
        #20 
        rstb = 1;
        #20
        // test case 2: n, received (1 bit is wrong)
        // should return correct array
        n = 32;
        received = [1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1]
        #20
    end

endmodule