`define UART_TX_MACRO(TX_BUSY, TX_DATA_VALID, CLK)\
            wait(!TX_BUSY)\
            @(posedge CLK)\
            TX_DATA_VALID = 1;\
            @(posedge CLK)\
            TX_DATA_VALID = 0;\
            wait(!TX_BUSY)\
            @(posedge CLK)

`define CLKS_PER_BIT 16

`define CLK_HALF_PERIOD 10

module top_tb();

    logic clk, rstb;

    logic [7:0] debug_led;

    logic ms_busy, ms_data_valid, ms_ser_out;
    logic [7:0] ms_data;
    logic [7:0] ms_data_var;

    logic slv_ser_out;

    logic [7:0] checker_data, checker_data_clocked;
    logic       checker_data_valid;

    always #`CLK_HALF_PERIOD clk = ~clk;

    initial begin

        clk = 0;
        ms_data_valid = 0;
        ms_data = 0;

        #10 rstb = 1;
        #10 rstb = 0;
        #10 rstb = 1;

        ms_data = 2;

        `UART_TX_MACRO(ms_busy, ms_data_valid, clk)
        `UART_TX_MACRO(ms_busy, ms_data_valid, clk)

        ms_data_var = 1;

        // load weight loop (wind)
        for (int i = 0; i < 16; i++) begin

            ms_data = 0;

            `UART_TX_MACRO(ms_busy, ms_data_valid, clk)

            ms_data = ms_data_var;

            `UART_TX_MACRO(ms_busy, ms_data_valid, clk)

            ms_data_var = ms_data_var + 1;

        end

        ms_data = 3;

        `UART_TX_MACRO(ms_busy, ms_data_valid, clk)
        `UART_TX_MACRO(ms_busy, ms_data_valid, clk)

        ms_data_var = 1;

        // load input loop (load)
        for (int i = 0; i < 16; i++) begin

            ms_data = 0;

            `UART_TX_MACRO(ms_busy, ms_data_valid, clk)

            ms_data = ms_data_var;

            `UART_TX_MACRO(ms_busy, ms_data_valid, clk)

            ms_data_var = ms_data_var + 1;

        end

        ms_data = 1;

        `UART_TX_MACRO(ms_busy, ms_data_valid, clk)
        `UART_TX_MACRO(ms_busy, ms_data_valid, clk)

        ms_data = 8'hf;

        `UART_TX_MACRO(ms_busy, ms_data_valid, clk)

        ms_data = 8'ha;

        `UART_TX_MACRO(ms_busy, ms_data_valid, clk)

        #100000

        $finish;

    end

    always @ (negedge clk) begin

        if (checker_data_valid) begin

            checker_data_clocked <= checker_data;

        end
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

    fpga_top #(
        .CLKS_PER_BIT   (`CLKS_PER_BIT)
    ) uTop (
        .ser_in     (ms_ser_out),
        .ser_out    (slv_ser_out),
        .led        (debug_led),
        .rstb       (rstb),
	    .clk        (clk),
	    .gnd        ()
    );

    UART_RX #(
		.CLKS_PER_BIT(`CLKS_PER_BIT)
    ) uart_checker (
	
		.i_Rst_L        (rstb),
		.i_Clock        (clk),
		.i_RX_Serial	(slv_ser_out),
		.o_RX_DV        (checker_data_valid),
		.o_RX_Byte		(checker_data)
	
	);

endmodule