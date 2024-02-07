module ReTwiddleMux (
    input [5:0] select,
    output [8:0] out
);
reg [8:0] twiddle;
always_comb begin
    case(select)
		9'b0: twiddle = 9'd256;
		9'b1: twiddle = 9'd255;
		9'b10: twiddle = 9'd251;
		9'b11: twiddle = 9'd245;
		9'b100: twiddle = 9'd237;
		9'b101: twiddle = 9'd226;
		9'b110: twiddle = 9'd213;
		9'b111: twiddle = 9'd198;
		9'b1000: twiddle = 9'd181;
		9'b1001: twiddle = 9'd162;
		9'b1010: twiddle = 9'd142;
		9'b1011: twiddle = 9'd121;
		9'b1100: twiddle = 9'd98;
		9'b1101: twiddle = 9'd74;
		9'b1110: twiddle = 9'd50;
		9'b1111: twiddle = 9'd25;
		9'b10000: twiddle = 9'd0;
		9'b10001: twiddle = -9'd25;
		9'b10010: twiddle = -9'd50;
		9'b10011: twiddle = -9'd74;
		9'b10100: twiddle = -9'd98;
		9'b10101: twiddle = -9'd121;
		9'b10110: twiddle = -9'd142;
		9'b10111: twiddle = -9'd162;
		9'b11000: twiddle = -9'd181;
		9'b11001: twiddle = -9'd198;
		9'b11010: twiddle = -9'd213;
		9'b11011: twiddle = -9'd226;
		9'b11100: twiddle = -9'd237;
		9'b11101: twiddle = -9'd245;
		9'b11110: twiddle = -9'd251;
		9'b11111: twiddle = -9'd255;

    endcase
end

assign out = twiddle;

endmodule



module ImTwiddleMux (
    input [5:0] select,
    output [8:0] out
);
reg [8:0] twiddle;
always_comb begin
    case(select)
			9'b0: twiddle = 9'd0;
			9'b1: twiddle = -9'd25;
			9'b10: twiddle = -9'd50;
			9'b11: twiddle = -9'd74;
			9'b100: twiddle = -9'd98;
			9'b101: twiddle = -9'd121;
			9'b110: twiddle = -9'd142;
			9'b111: twiddle = -9'd162;
			9'b1000: twiddle = -9'd181;
			9'b1001: twiddle = -9'd198;
			9'b1010: twiddle = -9'd213;
			9'b1011: twiddle = -9'd226;
			9'b1100: twiddle = -9'd237;
			9'b1101: twiddle = -9'd245;
			9'b1110: twiddle = -9'd251;
			9'b1111: twiddle = -9'd255;
			9'b10000: twiddle = -9'd256;
			9'b10001: twiddle = -9'd255;
			9'b10010: twiddle = -9'd251;
			9'b10011: twiddle = -9'd245;
			9'b10100: twiddle = -9'd237;
			9'b10101: twiddle = -9'd226;
			9'b10110: twiddle = -9'd213;
			9'b10111: twiddle = -9'd198;
			9'b11000: twiddle = -9'd181;
			9'b11001: twiddle = -9'd162;
			9'b11010: twiddle = -9'd142;
			9'b11011: twiddle = -9'd121;
			9'b11100: twiddle = -9'd98;
			9'b11101: twiddle = -9'd74;
			9'b11110: twiddle = -9'd50;
			9'b11111: twiddle = -9'd25;

    endcase
end

assign out = twiddle;

endmodule



