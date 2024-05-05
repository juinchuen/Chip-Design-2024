module encode #(
    parameter data_width = 16,
    parameter encoding_width = 21
) (
    input logic                         clk,
    input logic                         rstb,

    input logic [data_width-1:0]        raw_data,
    input logic                         valid_in,

    output logic [encoding_width-1:0]   encoded_data,
    output logic                        valid_out
);

    reg [encoding_width-1:0]    encoded_comb;
    reg [4:0]                   syndrome;

    always_comb begin
        // get parity bits
        syndrome[0] = raw_data[0] ^ raw_data[1] ^ raw_data[3] ^ raw_data[4] ^ raw_data[6] ^ raw_data[8] ^ raw_data[10] ^ raw_data[11] ^ raw_data[13] ^ raw_data[15];
        syndrome[1] = raw_data[0] ^ raw_data[2] ^ raw_data[3] ^ raw_data[5] ^ raw_data[6] ^ raw_data[9] ^ raw_data[10] ^ raw_data[12] ^ raw_data[13];
        syndrome[2] = raw_data[1] ^ raw_data[2] ^ raw_data[3] ^ raw_data[7] ^ raw_data[8] ^ raw_data[9] ^ raw_data[10] ^ raw_data[14] ^ raw_data[15];
        syndrome[3] = raw_data[4] ^ raw_data[5] ^ raw_data[6] ^ raw_data[7] ^ raw_data[8] ^ raw_data[9] ^ raw_data[10]
        syndrome[4] = raw_data[11] ^ raw_data[12] ^ raw_data[13] ^ raw_data[14] ^ raw_data[15];

        // arrange in encoded_data
        encoded_comb = {raw_data[15:11], syndrome[4], raw_data[10:4], syndrome[3], raw_data[3:1], syndrome[2], raw_data[0], syndrome[1:0]};
    end
    
    always_ff @ (negedge clk or negedge rstb) begin
        if (!rstb) begin

            valid_out <= 0;

        end else begin

            // clock the results
            if (valid_in) begin
                encoded_data <= encoded_comb;
                valid_out <= 1;
            end else begin
                valid_out <= 0;
            end

        end
    end

    
endmodule
