module fpga_top #(
    parameter CLKS_PER_BIT = 434 // for 50 MHz clk, 115200 baud rate
)(

    // serial
    input logic ser_in,

    output logic ser_out,

    // debug
    output logic[7:0] led,

    // global
    input logic rstb,
	  input logic clk,

	  output logic gnd,

);

    logic [15:0] data;
    logic valid;

    logic [7:0]  debug_rx_data;
    logic        debug_rx_data_valid;
	
    assign gnd = 0;

    always @ (negedge clk or negedge rstb) begin
        if (!rstb) begin
            led <= 8'haa;
        end else begin
            if (rx_data_valid) led <= debug_rx_data;
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

  transceiver #(
      .CLKS_PER_BIT(CLKS_PER_BIT)
  ) uTRX (
      .ser_in             (ser_in),
      .ser_out            (ser_out),
      .data_send          (data),
      .data_send_valid    (valid),    
      .data_recv          (data),
      .data_recv_valid    (valid),
      .clk                (clk),
      .rstb               (rstb)
  );

endmodule