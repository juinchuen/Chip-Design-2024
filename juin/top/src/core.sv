`define PRINT_IO

module core (

    // receive channel
    input logic[15:0]   data_in,
    input logic         data_in_valid,

    // transmit channel
    input logic         tx_done,

    output logic[15:0]  data_out,
    output logic        data_out_valid,

    // status
    output logic        core_busy,

    // global signals
    input logic clk,
    input logic rstb

);

    typedef enum logic[3:0] {   IDLE, RECEIVE_FFT, COMPUTE_FFT, TRANSMIT_FFT,
                                RECEIVE_FIR, COMPUTE_FIR_1, COMPUTE_FIR_2,
                                TRANSMIT_FIR, WIND_FIR, LOAD_FIR} core_state_t;

    core_state_t core_state;

    // logic [3:0] fir_counter;
    // logic [15:0] fir_data_in;

    // fft signals
    logic fft_init, fft_start, fft_done;
    logic [15:0] fft_output [127:0];

    // fir signals
    logic fir_start,    fir_done;
    logic fir_wind,     fir_load;
    logic [15:0] fir_data_out;

    logic [15:0] fft_cache [127:0];
    logic [7:0]  cache_counter;

    logic data_in_valid_prev;
    logic tx_done_prev;

    assign fir_wind = (core_state == WIND_FIR) & (data_in_valid & ~data_in_valid_prev);
    assign fir_load = ((core_state == LOAD_FIR) | (core_state == RECEIVE_FIR)) & (data_in_valid & ~data_in_valid_prev);

    // Print the inputs and outputs of the core
    `ifdef PRINT_IO

    int input_file, output_file;

    initial begin

        input_file = $fopen("verif_data/fir_in.txt", "w");
        output_file = $fopen("verif_data/fir_out.txt", "w");

    end

    always @ (posedge data_out_valid) begin

        $fdisplay(output_file, "%d", data_out);

    end

    always @ (posedge data_in_valid) begin

        $fdisplay(input_file, "%d", data_in);

    end

    `endif

    always @ (negedge clk or negedge rstb) begin

        if (!rstb) begin

            core_state      <= IDLE;

            fir_start       <= 0;

            fft_init        <= 0;
            fft_start       <= 0;

            cache_counter   <= 0;

            data_out_valid <= 0;

        end else begin

            data_in_valid_prev  <= data_in_valid;
            tx_done_prev        <= tx_done;

            case (core_state)

                IDLE: begin

                    // OHJUINC: We usually reset in the departing state,
                    //          so that the variables are already reset
                    //          when we enter the IDLE state
                    // 
                    // fir_init      <= 0;
                    // fft_init      <= 0;
                    // cache_counter <= 0;
                    // data_in_valid_prev <= 0;

                    cache_counter <= 0;

                    if (data_in_valid && data_in[2:0] == 3'h0) begin

                        core_state <= RECEIVE_FFT; // FFT mode: 00

                    end else if (data_in_valid && data_in[2:0] == 3'h1) begin

                        core_state <= RECEIVE_FIR; // FIR mode: 01

                    end else if (data_in_valid && data_in[2:0] == 3'h2) begin

                        core_state <= WIND_FIR;

                    end else if (data_in_valid && data_in[2:0] == 3'h3) begin

                        core_state <= LOAD_FIR;

                    end

                end

                RECEIVE_FFT: begin

                    if (data_in_valid & ~data_in_valid_prev) begin // on rising edge of data_in_valid

                        // write the input data to the current cache position
                        fft_cache[cache_counter] <= data_in;

                        if (cache_counter == 127) begin

                            cache_counter   <= 0;
                            fft_init        <= 1;
                            fft_start       <= 1;
                            core_busy       <= 1;
                            core_state      <= COMPUTE_FFT;

                        end else begin
                            
                            cache_counter <= cache_counter + 1;

                        end
                    end
                end

                COMPUTE_FFT: begin

                    // OHJUINC: assign statements are not allowed in sequential blocks
                    //          assign statements are purely combinational constructs

                    fft_start <= 0;

                    if (fft_done) begin

                        core_state      <= TRANSMIT_FFT;

                        data_out        <= fft_output[0];
                        data_out_valid  <= 1;
                        cache_counter   <= 1;

                    end
                end

                TRANSMIT_FFT: begin

                    data_out_valid <= 0;

                    if (tx_done & ~tx_done_prev) begin
                        
                        if (cache_counter == 128) begin

                            cache_counter   <= 0;
                            core_state      <= IDLE;
                            core_busy       <= 0;

                        end else begin

                            data_out        <= fft_output[cache_counter];
                            data_out_valid  <= 1;
                            cache_counter   <= cache_counter + 1;

                        end

                    end
                end

                WIND_FIR: begin

                    if (data_in_valid & ~data_in_valid_prev) begin

                        if (cache_counter == 15) begin

                            core_state      <= IDLE;
                            cache_counter   <= 0;

                        end else begin

                            cache_counter   <= cache_counter + 1;

                        end

                    end

                end

                LOAD_FIR: begin

                    if (data_in_valid & ~data_in_valid_prev) begin

                        if (cache_counter == 15) begin

                            core_state      <= IDLE;
                            cache_counter   <= 0;

                        end else begin

                            cache_counter   <= cache_counter + 1;

                        end

                    end

                end

                RECEIVE_FIR: begin

                    if (data_in_valid & ~data_in_valid_prev) begin

                        core_state <= COMPUTE_FIR_1;

                    end

                end

                COMPUTE_FIR_1: begin

                    fir_start <= 1;

                    core_state <= COMPUTE_FIR_2;

                end

                COMPUTE_FIR_2: begin

                    if (fir_done) begin

                        fir_start <= 0;

                        core_state <= TRANSMIT_FIR;

                        data_out_valid <= 1;

                        data_out <= fir_data_out;

                    end

                end

                TRANSMIT_FIR: begin

                    data_out_valid <= 0;

                    if (tx_done & ~tx_done_prev) begin

                        core_state <= IDLE;

                    end

                end
          endcase
        end
    end

    fft #(
        .D_WIDTH        (64),
        .LOG_2_WIDTH    (6)
    ) uFFT ( 
        .inputRe    (fft_cache[ 63: 0]),    
        .inputIm    (fft_cache[127:64]),    
        .start      (fft_start),    
        .clk        (clk),    
        .rst        (rstb),
        .outputRe   (fft_output[ 63: 0]),        
        .outputIm   (fft_output[127:64]),        
        .done       (fft_done)
    );

    fir uFIR(
        
        .clk        (clk),
        .rstb       (rstb),
        .wind       (fir_wind),
        .load       (fir_load),
        .in_valid   (fir_start),
        .data       (data_in),
        .out_valid  (fir_done),
        .out        (fir_data_out)

    );

endmodule