module transceiver_tb ();

    logic clk, rstb;

    logic [7:0] ms_data;
    logic ms_data_valid;
    logic ser_mosi, ms_done;

    logic [15:0] slv_data_recv;
    logic slv_data_recv_valid;

    always #10 clk = ~clk;

    initial begin
        
        clk = 0;
        rstb = 1;

        #0 rstb = 0;
        #0 rstb = 1;

        @(posedge clk)

        ms_data = 15;
        ms_data_valid = 1;

        @(posedge clk)

        ms_data_valid = 0;

        @(negedge ms_done)

        @(posedge clk)

        ms_data = 15;
        ms_data_valid = 1;

        @(posedge clk)

        ms_data_valid = 0;

        @(negedge ms_done)

        @(posedge clk)

        ms_data = 15;
        ms_data_valid = 1;

        @(posedge clk)

        ms_data_valid = 0;

        @(negedge ms_done)

        @(posedge clk)

        #260400

        $finish;

    end


    UART_TX #(
		.CLKS_PER_BIT(434)
    ) UTx_master (
	
		.i_Rst_L		(rstb),
   		.i_Clock		(clk),
   		.i_TX_DV		(ms_data_valid),
   		.i_TX_Byte		(ms_data), 
   		.o_TX_Active	(),
   		.o_TX_Serial	(ser_mosi),
   		.o_TX_Done		(ms_done)
	
	);

    transceiver uTRX (

        .ser_in             (ser_mosi),
        .ser_out            (),
        .data_send          (slv_data_recv),
        .data_send_valid    (slv_data_recv_valid),
        .data_recv          (slv_data_recv),
        .data_recv_valid    (slv_data_recv_valid),
        .clk                (clk),
        .rstb               (rstb)

);

endmodule