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
	
	assign gnd = 0;

    always @ (negedge clk) begin
        
        if (!rst) begin

            led <= 15;

        end else begin

            if (valid) led <= led + 1;

        end

    end

    transceiver uTRX (

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