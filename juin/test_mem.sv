module test_mem (
    input logic [2:0] test_i,

    output logic [31:0] test_bits
);

    assign test_bits =  test_i == 0 ? 32'hff00f00f :
                        test_i == 1 ? 32'h70011585 :
                        test_i == 2 ? 32'h04020202 :
                        test_i == 3 ? 32'hf003fff0 :
                        test_i == 4 ? 32'h7f04700f :
                        test_i == 5 ? 32'hff05f00f :
                        test_i == 6 ? 32'h0f0600f0 :
                        32'h0;

endmodule