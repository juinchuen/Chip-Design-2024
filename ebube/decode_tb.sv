module decode_tb (

    input logic clk,
    input logic rst,

    output logic [7:0] led
);
    // init: wires, registers
    reg [2:0]       test_index;
    wire [37:0]     test_full;

    wire [20:0]     encoded;
    wire [15:0]     decoded_test, decoded_true;
    wire            valid_test, valid_true;

    // index test_mem module
    assign encoded          = test_full[20:0];
    assign decoded_true     = test_full[36:21];
    assign valid_true       = test_full[37];

    // led logic: text vs truth
    always @ (negedge clk or negedge rst) begin
        if (rst) begin
            test_index <= 0;
            led <= 0;
        end else begin
            test_index <= test_index + 1;
            led <= (decoded_test == decoded_true) && (valid_test == valid_true);
        end
    end

    // module instantiation
    decode #(
        .data_width(16),
        .encoding_width(21)
    ) decoder (
        .clk            (clk),
        .rstb           (rst),
        .encoded_data   (encoded),
        .decoded_data   (decoded_test),
        .valid          (valid)
    );

    test_mem testing (
		.index 	(test_index),
		.data	(test_full)
	);
    
endmodule