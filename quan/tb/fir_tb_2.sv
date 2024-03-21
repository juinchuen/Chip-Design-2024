/*
	- Push 1-16 to d0-d15
	- Push 1-16 to w0-w15
*/

module fir_tb ();
localparam time CLK_PERIOD = 5 * 2;

// Inputs
logic clk = 0;
logic rst = 0;
logic wind = 0;
logic load = 0;
logic in_valid = 0;
logic [15:0] data = 0;

// Outpus
logic out_valid;
logic [15:0] out;

// Unit Under Test
fir UUT (
	.clk(clk),
	.rst(rst),
	.wind(wind),
	.load(load),
	.in_valid(in_valid),
	.data(data),
	.out_valid(out_valid),
	.out(out)
);

// Simulate Inputs
initial begin
	rst = 1;
	#(CLK_PERIOD)

	rst = 0;
	wind = 1;

	data = 16'd1;
	#(CLK_PERIOD)

  data = 16'd2;
	#(CLK_PERIOD)

  data = 16'd3;
	#(CLK_PERIOD)

  data = 16'd4;
	#(CLK_PERIOD)

  data = 16'd5;
	#(CLK_PERIOD)

  data = 16'd6;
	#(CLK_PERIOD)

  data = 16'd7;
	#(CLK_PERIOD)

  data = 16'd8;
	#(CLK_PERIOD)

  data = 16'd9;
	#(CLK_PERIOD)

  data = 16'd10;
	#(CLK_PERIOD)

  data = 16'd11;
	#(CLK_PERIOD)

  data = 16'd12;
	#(CLK_PERIOD)

  data = 16'd13;
	#(CLK_PERIOD)

  data = 16'd14;
	#(CLK_PERIOD)

  data = 16'd15;
	#(CLK_PERIOD)

  data = 16'd16;
	#(CLK_PERIOD)

	wind = 0;
	load = 1;

	data = 16'd1;
	#(CLK_PERIOD)

	data = 16'd2;
	#(CLK_PERIOD)

	data = 16'd3;
	#(CLK_PERIOD)

	data = 16'd4;
	#(CLK_PERIOD)

	data = 16'd5;
	#(CLK_PERIOD)

	data = 16'd6;
	#(CLK_PERIOD)

	data = 16'd7;
	#(CLK_PERIOD)

	data = 16'd8;
	#(CLK_PERIOD)

	data = 16'd9;
	#(CLK_PERIOD)

	data = 16'd10;
	#(CLK_PERIOD)

	data = 16'd11;
	#(CLK_PERIOD)

	data = 16'd12;
	#(CLK_PERIOD)

	data = 16'd13;
	#(CLK_PERIOD)

	data = 16'd14;
	#(CLK_PERIOD)

	data = 16'd15;
	#(CLK_PERIOD)

	data = 16'd16;
	#(CLK_PERIOD)
	#(CLK_PERIOD / 2)

	in_valid = 1;
	load = 0;
	#(CLK_PERIOD * 6)

	in_valid = 0;
end

// Simulate Clock
always begin
	#(CLK_PERIOD / 2)
	clk = ~clk;
end

initial begin
	#(CLK_PERIOD * 60)
	$finish;
end

endmodule