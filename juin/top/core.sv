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

    typedef enum logic[2:0] {idle, receive, compute_fft, compute_fir, transmit} core_state_t;

    core_state_t core_state;

    logic fir_init_flag;
    logic fft_init_flag;

    logic [15:0] fft_cache [127:0];
    logic [7:0]  cache_counter;

    always @ (negedge clk or negedge rstb) begin

        if (!rstb) begin

            core_state <= idle;

            fir_init_flag <= 0;
            fft_init_flag <= 0;

            cache_counter <= 0;

        end else begin

        end

    end

endmodule