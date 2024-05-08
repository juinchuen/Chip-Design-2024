// `define PRINT_IO

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

    typedef enum logic[3:0] {IDLE, RECEIVE_FFT, WINDOW_FFT, COMPUTE_FFT, TRANSMIT_FFT} core_state_t;

    core_state_t core_state;

    // fft signals
    logic           fft_start, fft_done;
    logic [15:0]    fft_output      [127:0];

    logic [15:0]    fft_cache_real  [64:0];
    logic [15:0]    fft_cache_imag  [64:0];
    logic [7:0]     cache_counter;

    // ram  signals
    logic [13:0]    ram_addr, ram_addr_start, ram_addr_end;
    logic           rst;
    assign          rst = ~rstb;
    logic [15:0]    ram_data_in, ram_data_out;
    logic           ram_wr_en;

    genvar i;

    generate : set_imag_zero

        for (i = 0; i < 64; i = i + 1) begin

            assign fft_cache_imag[i] = 16'h0;

        end
    
    endgenerate

    logic data_in_valid_prev;
    logic tx_done_prev;

/*
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
*/

    always @ (negedge clk or negedge rstb) begin

        if (!rstb) begin

            core_state      <= IDLE;
            fft_start       <= 0;
            cache_counter   <= 0;
            data_out_valid  <= 0;

            ram_addr        <= 0;
            ram_addr_start  <= 0;
            ram_addr_end    <= 63;

            ram_wr_en       <= 0;

        end else begin

            data_in_valid_prev  <= data_in_valid;
            tx_done_prev        <= tx_done;

            case (core_state)

                IDLE: begin

                    cache_counter <= 0;

                    if (data_in_valid && data_in == 16'h0) begin

                        core_state <= RECEIVE_FFT; // FFT mode: 00

                    end

                end

                RECEIVE_FFT: begin

                    ram_wr_en <= 0;

                    if (data_in_valid & ~data_in_valid_prev) begin // on rising edge of data_in_valid

                        if (ram_addr == 4991) begin

                            ram_wr_en   <= 1;
                               
                        
                            fft_init        <= 1;
                            fft_start       <= 1;
                            core_busy       <= 1;
                            core_state      <= COMPUTE_FFT;

                        end else begin
                            
                            ram_wr_en   <= 1;
                            ram_addr    <= ram_addr + 1;

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