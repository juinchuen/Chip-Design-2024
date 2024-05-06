module fpga_tb (

	input logic clk,
	input logic rst,
	
	output logic [7:0] led

);

	wire [31:0] test_bits;
	
	reg [2:0] test_i; // test selector
	
	wire [7:0] opA, opB, opSel, out_truth, out_test;
	
	assign opA   		= test_bits[ 7: 0];
	assign opB   		= test_bits[15: 8];
	assign opSel 		= test_bits[23:16];
	assign out_truth	= test_bits[31:24];
	
	always @ (posedge clk or posedge rst) begin
	
		if (rst) begin
		
			test_i <= 0;
			
			led <= 0;
			
		end else begin
		
			test_i <= test_i + 1;
			
			led[test_i] <= out_test == out_truth;
		
		end
	
	end
	
	alu_example DUT (
	
		.opA		(opA),
		.opB		(opB),
		.opSel	(opSel),
		.out		(out_test)
		
	);

	test_mem TESTER (
		.test_i 	(test_i),
		.test_bits	(test_bits)
	);

endmodule