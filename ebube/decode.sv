module decode #(
    parameter data_width = 16,
    parameter encoding_width = 21
) (
    input logic                         clk,
    input logic                         rstb,

    input logic [encoding_width-1:0]    encoded_data,

    output logic [data_width-1:0]       decoded_data,
    output logic                        valid
);

    reg [encoding_width-1:0]    corrected;
    reg [data_width-1:0]        decoded_comb;
    reg [4:0]                   syndrome;
    reg                         flipped;

    always_comb begin
        // calculate the syndrome
        syndrome[0] = encoded_data[0] ^ encoded_data[2] ^ encoded_data[4] ^ encoded_data[6] ^ encoded_data[8] ^ encoded_data[10] ^ encoded_data[12] ^ encoded_data[14] ^ encoded_data[16] ^ encoded_data[18] ^ encoded_data[20];
        syndrome[1] = encoded_data[1] ^ encoded_data[2] ^ encoded_data[5] ^ encoded_data[6] ^ encoded_data[9] ^ encoded_data[10] ^ encoded_data[13] ^ encoded_data[14] ^ encoded_data[17] ^ encoded_data[18];
        syndrome[2] = encoded_data[3] ^ encoded_data[4] ^ encoded_data[5] ^ encoded_data[6] ^ encoded_data[11] ^ encoded_data[12] ^ encoded_data[13] ^ encoded_data[14] ^ encoded_data[19] ^ encoded_data[20];
        syndrome[3] = encoded_data[7] ^ encoded_data[8] ^ encoded_data[9] ^ encoded_data[10] ^ encoded_data[11] ^ encoded_data[12] ^ encoded_data[13] ^ encoded_data[14];
        syndrome[4] = encoded_data[15] ^ encoded_data[16] ^ encoded_data[17] ^ encoded_data[18] ^ encoded_data[19] ^ encoded_data[20];

        // check if any of the syndrome values is not null
        flipped = |syndrome == 0 ? encoded_data[syndrome-1] : ~encoded_data[syndrome-1];
        corrected = encoded_data;
        corrected[syndrome-1] = flipped;

        // get the decoded data
        decoded_comb = {corrected[20:16], corrected[14:8], corrected[6:4], corrected[2]};

    end
    
    always_ff @ (negedge clk or negedge rstb) begin
        if (!rstb) begin
            decoded_data <= 0;
            valid <= 0;
        end else begin
            // clock the results
            decoded_data <= decoded_comb;
            valid <= 1;
        end
    end

    
endmodule
