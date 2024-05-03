module fft_wrapper (
    input logic clk,
    input logic rstb,
    input logic shift_en,

    input logic [15:0] dinRe,
    input logic [15:0] dinIm,

    input logic start,

    output logic done,

    output logic [15:0] doutRe,
    output logic [15:0] doutIm

);

    logic [15:0] inputRe [63:0];
    logic [15:0] inputIm [63:0];

    logic [15:0] outputRe [63:0];
    logic [15:0] outputIm [63:0];

    logic [15:0] outputRe_wire [63:0];   
    logic [15:0] outputIm_wire [63:0];


    assign doutRe = outputRe[63];
    assign doutIm = outputIm[63];
    
    always @ (negedge clk or negedge rstb) begin

        if (!rstb) begin

            for (int i = 0; i < 64; i++) begin

                inputRe[i] <= 0;
                inputIm[i] <= 0;

                outputRe[i] <= 0;
                outputIm[i] <= 0;

            end

        end else begin

            if (shift_en) begin

                inputRe[0] <= dinRe;
                inputIm[0] <= dinIm;

                for (int i = 0; i < 63; i++) begin

                    inputRe[i+1] <= inputRe[i];
                    inputIm[i+1] <= inputIm[i];

                end

                for (int i = 0; i < 63; i++) begin

                    outputRe[i+1] <= outputRe[i];
                    outputIm[i+1] <= outputIm[i];

                end

            end else if (done) begin

                for (int i = 0; i < 64; i++)begin

                    outputRe[i] <= outputRe_wire[i];
                    outputIm[i] <= outputIm_wire[i];

                end

            end

        end

    end

    fft DUT0 ( 
        .inputRe     (inputRe),
        .inputIm     (inputIm),
        .start       (start),
        .done        (done),
        .clk         (clk),
        .rst         (rstb),
        .outputRe    (outputRe_wire),
        .outputIm    (outputIm_wire)
    );

endmodule