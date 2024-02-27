module router_tb ();

    reg [15:0] input_sig_Re [63:0];
    reg [15:0] input_sig_Im [63:0];
    wire [15:0] output_sig_Re [63:0];
    wire [15:0] output_sig_Im [63:0];

    InputSignalRouter #(.D_WIDTH(64),.LOG_2_WIDTH(6)) InputSignalRouter (
    .input_sig_Re(input_sig_Re),
    .input_sig_Im(input_sig_Im),
    .output_sig_Re(output_sig_Re),
    .output_sig_Im(output_sig_Im)
    );

    initial begin
        integer i;
        #5
        for(i = 0; i < 64; i++) begin
            input_sig_Re[i] = i;
            input_sig_Im[i] = i;
        end
        #5

        #100
        $finish;
    end   
endmodule
