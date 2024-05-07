// this module helps the core transmit 16 bit values

module transceiver #(
    parameter CLKS_PER_BIT = 434
)(

    // world side pins
    input logic ser_in,

    output logic ser_out,

    // fpga side pins
    input logic [15:0]  data_send,
    input logic         data_send_valid,

    output logic        data_send_done,    

    output logic [15:0] data_recv,
    output logic        data_recv_valid,

    // global pins
    input logic clk,
    input logic rstb

);

    // receiver variables
    logic [1:0] recv_counter;

    // transmitter variables
    typedef enum logic[2:0] {idle, send_first, send_second} tx_state_t;
    tx_state_t tx_state;

    logic [7:0] tx_data;
    logic       tx_data_valid;
    logic       tx_done;

    logic [7:0] rx_data;
    logic       rx_data_valid;

    always @ (negedge clk or negedge rstb) begin : rx_block

        if (!rstb) begin

            recv_counter <= 0;

            data_recv_valid <= 0;

        end else begin

            if (rx_data_valid) begin

                recv_counter    <= recv_counter == 2 ? 1 : recv_counter + 1;
                data_recv       <= data_recv << 8 | {8'b0, rx_data};

                data_recv_valid <= recv_counter == 1;

            end else begin

                data_recv_valid <= 0;

            end

        end

    end

    always @ (negedge clk or negedge rstb) begin : tx_block

        if  (!rstb) begin

            tx_state <= idle;

            tx_data_valid <= 0;

            data_send_done <= 0;

        end else begin

            case (tx_state)

                idle: begin

                    data_send_done <= 0;

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

                        data_send_done <= 1;

                    end

                end

            endcase

        end

    end

    UART_RX #(
		.CLKS_PER_BIT(CLKS_PER_BIT)
	) uRecv (
	
		.i_Rst_L        (rstb),
		.i_Clock        (clk),
		.i_RX_Serial	(ser_in),
		.o_RX_DV        (rx_data_valid),
		.o_RX_Byte		(rx_data)
	
	);

    UART_TX #(
		.CLKS_PER_BIT(CLKS_PER_BIT)
	) uTrans (
	
		.i_Rst_L		(rstb),
   		.i_Clock		(clk),
   		.i_TX_DV		(tx_data_valid),
   		.i_TX_Byte		(tx_data), 
   		.o_TX_Active	(),
   		.o_TX_Serial	(ser_out),
   		.o_TX_Done		(tx_done)
	
	);

endmodule