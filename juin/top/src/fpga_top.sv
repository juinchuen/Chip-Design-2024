module fpga_top #(
    parameter CLKS_PER_BIT = 64 // for 50 MHz clk, 115200 baud rate
)(

    // serial
    input logic ser_in,

    output logic ser_out,

    // debug
    output logic[7:0] led,

    // global
    input logic rstb,
	input logic clk,

	output logic gnd

);

    // rx signals
    logic [15:0]    rx_data;
    logic           rx_data_valid;

    // tx signals
    logic [15:0]    tx_data;
    logic           tx_data_valid;
    logic           tx_done;

    // debug led signals
    logic [7:0]  debug_rx_data;
    logic        debug_rx_data_valid;
	
    assign gnd = 0;

    always @ (negedge clk or negedge rstb) begin
        if (!rstb) begin
            led <= 8'haa;
        end else begin
            if (debug_rx_data_valid) led <= debug_rx_data;
        end
    end
	 
    UART_RX #(
		.CLKS_PER_BIT(CLKS_PER_BIT)
	) uRecv (
		.i_Rst_L        (rstb),
		.i_Clock        (clk),
		.i_RX_Serial	(ser_in),
		.o_RX_DV        (debug_rx_data_valid),
		.o_RX_Byte		(debug_rx_data)
	);

    // UART_TX #(
	// 	.CLKS_PER_BIT(CLKS_PER_BIT)
	// ) uTrans (
	
	// 	.i_Rst_L		(rstb),
   	// 	.i_Clock		(clk),
   	// 	.i_TX_DV		(debug_rx_data_valid),
   	// 	.i_TX_Byte		(debug_rx_data), 
   	// 	.o_TX_Active	(),
   	// 	.o_TX_Serial	(ser_out),
   	// 	.o_TX_Done		()
	
	// );

    transceiver #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uTRX (
        .ser_in             (ser_in),
        .ser_out            (ser_out),
        .data_send          (tx_data),
        .data_send_valid    (tx_data_valid),
        .data_send_done     (tx_done),    
        .data_recv          (rx_data),
        .data_recv_valid    (rx_data_valid),
        .clk                (clk),
        .rstb               (rstb)
    );

    core uCore(
        .data_in        (rx_data),
        .data_in_valid  (rx_data_valid),
        .tx_done        (tx_done),
        .data_out       (tx_data),
        .data_out_valid (tx_data_valid),
        .core_busy      (),
        .clk            (clk),
        .rstb           (rstb)
    );

endmodule