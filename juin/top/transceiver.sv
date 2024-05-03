// this module helps the core transmit 16 bit values

module transceiver (

    // world side pins
    input logic ser_in,

    output logic ser_out,

    // fpga side pins
    input logic [15:0]  data_send,
    input logic         data_send_valid,    

    output logic [15:0] data_recv,
    output logic        data_recv_valid,

    // global pins
    input logic clk,
    input logic rstb

);

    // receiver variables
    logic [1:0] recv_counter;
    logic [23:0] recv_buffer;

    logic [7:0] rx_data;
    logic       rx_data_valid;

    logic dec_start;

    // transmitter variables
    typedef enum logic[2:0] {idle, send_first, send_second} tx_state_t;
    tx_state_t tx_state;

    logic [7:0] tx_data;
    logic       tx_data_valid;
    logic       tx_done;

    always @ (negedge clk or negedge rstb) begin : rx_block

        if (!rstb) begin

            recv_counter <= 0;

        end else begin
		  
				dec_start <= 0;

            if (rx_data_valid) begin

                recv_counter    <= recv_counter == 3 ? 1 : recv_counter + 1;
                recv_buffer     <= recv_buffer << 8 | {16'b0, rx_data};

                dec_start       <= recv_counter == 2;

            end

        end

    end

    always @ (negedge clk or negedge rstb) begin : tx_block

        if  (!rstb) begin

            tx_state <= idle;

            tx_data_valid <= 0;

        end else begin

            case (tx_state)

                idle: begin

                    if (data_send_valid) begin

                        tx_data_valid <= 1;
                        tx_data <= data_send[15:8];

                        tx_state <= send_first;

                    end 
                    
                end
                
                send_first: begin

                    tx_data_valid <= 0;

                    if (tx_done) begin

                        tx_data_valid <= 1;
                        tx_data <= data_send[7:0];

                        tx_state <= send_second;

                    end

                end

                send_second: begin

                    tx_data_valid <= 0;

                    if (tx_done) begin

                        tx_state <= idle;

                    end

                end

            endcase

        end

    end

    UART_RX #(
		.CLKS_PER_BIT(434)
	) uRecv (
	
		.i_Rst_L        (rstb),
		.i_Clock        (clk),
		.i_RX_Serial	(ser_in),
		.o_RX_DV        (rx_data_valid),
		.o_RX_Byte		(rx_data)
	
	);

    UART_TX #(
		.CLKS_PER_BIT(434)
	) uTrans (
	
		.i_Rst_L		(rstb),
   		.i_Clock		(clk),
   		.i_TX_DV		(tx_data_valid),
   		.i_TX_Byte		(tx_data), 
   		.o_TX_Active	(),
   		.o_TX_Serial	(ser_out),
   		.o_TX_Done		(tx_done)
	
	);

    decode #(
        .data_width     (16),
        .encoding_width (21)
    ) uDec (
        .clk            (clk),
        .rstb           (rstb),
        .encoded_data   (recv_buffer[20:0]),
        .valid_in       (dec_start),
        .decoded_data   (data_recv),
        .valid_out      (data_recv_valid)    
    );

endmodule