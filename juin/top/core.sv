module core (

    // receive channel
    input logic[15:0]   data_in,
    input logic         data_in_valid,

    // transmit channel
    input logic         tx_done,

    output logic[15:0]  data_out,
    output logic        data_out_valid,

    // status
    output logic        core_busy

);

    typedef enum logic[2:0] {idle, receive_fft, compute_fft, transmit_fft, receive_fir, compute_fir, transmit_fir} core_state_t;

    core_state_t core_state;

    logic [3:0] fir_counter;
    logic [15:0] fir_data_in;

    logic fft_init_flag;
    logic fft_done_flag;

    logic [15:0] fft_cache [127:0];
    logic [7:0]  cache_counter;

    logic data_in_valid_prev; // used for detecting data_in_valid's rising edge
    logic tx_done_prev; // used to create an edge for data_out_valid

    always @ (negedge clk or negedge rstb) begin

        if (!rstb) begin

            core_state <= idle;

            fir_init_flag <= 0;
            fft_init_flag <= 0;

            cache_counter <= 0;
            data_in_valid_prev <= 0;

        end else begin

          case (core_state)
            idle: begin
              fir_init_flag <= 0;
              fft_init_flag <= 0;
              cache_counter <= 0;
              data_in_valid_prev <= 0;
              assign core_busy = 0;

              if (data_in_valid && data_in[1:0] == 2'b00) begin
                core_state <= receive_fft; // FFT mode: 00
              end else if (data_in_valid && data_in[1:0] == 2'b01) begin
                core_state <= receive_fir; // FIR mode: 01
              end
            end

            receive_fft: begin
              if (data_in_valid && !data_in_valid_prev) begin // on rising edge of data_in_valid
                // write the input data to the current cache position
                fft_cache[cache_counter] <= data_in;
                
                if (cache_counter == 63) begin
                  cache_counter <= 0;
                  fft_init_flag <= 1; // assert for one clock cycle
                  core_state <= compute_fft;
                end else begin
                  cache_counter <= cache_counter + 1;
                end
              end

              data_in_valid_prev <= data_in_valid;
            end

            compute_fft: begin
              assign core_busy = 1;
              fft_init_flag <= 0; // unassert after one clock cycle
              if (fft_done_flag) begin
                core_state <= transmit_fft;
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

            transmit_fft: begin
              if (tx_done && !tx_done_prev) begin // rising edge of tx_done
                data_out <= fft_cache[cache_counter];
                assign data_out_valid = 1;

                if (cache_counter == 127) begin // transmit zero to 127
                  core_state <= idle;
                end 
                else begin
                  cache_counter <= cache_counter + 1;
                end
              end 
              else begin
                assign data_out_valid = 0;
              end

              tx_done_prev <= tx_done;
            end

            transmit_fir: begin
            end

          endcase
        end

    end

endmodule