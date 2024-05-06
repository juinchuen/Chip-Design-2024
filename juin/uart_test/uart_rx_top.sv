module uart_rx_top (

	input logic rst,
	input logic clk,
	input logic ser_in,
	
	output logic[7:0] led,
	output logic gnd,
	output logic ser_out

);

   logic [15:0] data;
   logic valid;

   logic [7:0]  rx_data;
   logic        rx_data_valid;
	
    assign gnd = 0;

   always @ (negedge clk) begin
        
        if (!rst) begin

            led <= 15;

        end else begin

            if (rx_data_valid) begin

                led <= rx_data;
                
            end

        end

    end
	 
    UART_RX #(
		.CLKS_PER_BIT(434)
	) uRecv (
	
		.i_Rst_L        (rst),
		.i_Clock        (clk),
		.i_RX_Serial	(ser_in),
		.o_RX_DV        (rx_data_valid),
		.o_RX_Byte		(rx_data)
	
	);

    transceiver uTRX (

        .ser_in             (ser_in),
        .ser_out            (ser_out),
        .data_send          (data),
        .data_send_valid    (valid),    
        .data_recv          (data),
        .data_recv_valid    (valid),
        .clk                (clk),
        .rstb               (rst)

    );

endmodule