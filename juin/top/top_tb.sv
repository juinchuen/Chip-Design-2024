`define UART_TX_MACRO(TX_BUSY, TX_DATA_VALID, CLK)\
            wait(!TX_BUSY)\
            @(posedge CLK)\
            TX_DATA_VALID = 1;\
            @(posedge CLK)\
            TX_DATA_VALID = 0;\
            wait(!TX_BUSY)\
            @(posedge CLK)

`define CLKS_PER_BIT 434

`define CLK_HALF_PERIOD 10

module top_tb();

    logic clk, rstb;

    logic ms_busy, ms_data_valid, ms_ser_out;
    logic [7:0] ms_data, ms_data_var;

    always #`CLK_HALF_PERIOD clk = ~clk;

    initial begin

        clk = 0;
        ms_data_valid = 0;
        ms_data = 0;
        ms_data_var = 0;

        #10 rstb = 1;
        #10 rstb = 0;
        #10 rstb = 1;

        for (int i = 0; i < 10; i++) begin

            `UART_TX_MACRO(ms_busy, ms_data, ms_data_valid, clk, ms_data_var)

            ms_data_var = ms_data_var + 1;

        end

        $finish;

    end

    UART_TX #(
		.CLKS_PER_BIT(`CLKS_PER_BIT)
    ) uart_master (
	
		.i_Rst_L		(rstb),
   		.i_Clock		(clk),
   		.i_TX_DV		(ms_data_valid),
   		.i_TX_Byte		(ms_data), 
   		.o_TX_Active	(ms_busy),
   		.o_TX_Serial	(ms_ser_out),
   		.o_TX_Done		()
	
	);

endmodule