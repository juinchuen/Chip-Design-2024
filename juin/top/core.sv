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

    typedef enum logic[2:0] {idle, receive_fft, compute_fft, transmit_fft, receive_fir, compute_fir, transmit_fir} core_state_t;

    core_state_t core_state;

    // logic [3:0] fir_counter;
    // logic [15:0] fir_data_in;

    // fft signals
    logic fft_init, fft_start, fft_done;
    logic [15:0] fft_output [127:0];

    // fir signals
    logic fir_init, fir_start, fir_done;

    logic [15:0] fft_cache [127:0];
    logic [7:0]  cache_counter;

    // OHJUINC: Not sure why we need to detect the rising edge
    // logic data_in_valid_prev; // used for detecting data_in_valid's rising edge
    // logic tx_done_prev; // used to create an edge for data_out_valid

    always @ (negedge clk or negedge rstb) begin

        if (!rstb) begin

            core_state      <= idle;

            fir_init        <= 0;
            fir_start       <= 0;

            fft_init        <= 0;
            fft_start       <= 0;

            cache_counter   <= 0;

        end else begin

            case (core_state)

                idle: begin

                    // OHJUINC: We usually reset in the departing state,
                    //          so that the variables are already reset
                    //          when we enter the idle state
                    // 
                    // fir_init      <= 0;
                    // fft_init      <= 0;
                    // cache_counter <= 0;
                    // data_in_valid_prev <= 0;

                    if (data_in_valid && data_in[1:0] == 2'b00) begin

                        core_state <= receive_fft; // FFT mode: 00

                    end else if (data_in_valid && data_in[1:0] == 2'b01) begin

                        core_state <= receive_fir; // FIR mode: 01

                    end

                end

                receive_fft: begin

                    if (data_in_valid) begin // on rising edge of data_in_valid

                        // write the input data to the current cache position
                        fft_cache[cache_counter] <= data_in;

                        if (cache_counter == 63) begin

                            cache_counter   <= 0;
                            fft_init        <= 1;
                            fft_start       <= 1;
                            core_busy       <= 1;
                            core_state      <= compute_fft;

                        end else begin
                            
                            cache_counter <= cache_counter + 1;

                        end
                    end

                    data_in_valid_prev <= data_in_valid;
                end

                compute_fft: begin

                    // OHJUINC: assign statements are not allowed in sequential blocks
                    //          assign statements are purely combinational constructs

                    fft_start <= 0;

                    if (fft_done) begin

                        core_state      <= transmit_fft;

                        data_out        <= fft_output[0];
                        data_out_valid  <= 1;
                        cache_counter   <= 1;

                    end
                end

                transmit_fft: begin

                    data_out_valid <= 0;

                    if (tx_done) begin

                        data_out        <= fft_output[cache_counter];
                        data_out_valid  <= 1;
                        cache_counter   <= cache_counter + 1;
                        
                        if (cache_counter == 128) begin

                            cache_counter   <= 0;
                            core_state      <= idle;
                            core_busy       <= 0;

                        end

                    end
                end

            receive_fir: begin
              assign fir_data_in = data_in;
              assign fir_data_valid = data_in_valid;

              if (fir_counter == 15) begin
                fir_counter <= 0;
                core_state <= compute_fir
              end else begin
                fir_counter <= fir_counter + 1;
              end
            end

            compute_fir: begin
              assign core_busy = 1;
              if (fir_done) begin
                core_state <= transmit_fir;
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

endmodule