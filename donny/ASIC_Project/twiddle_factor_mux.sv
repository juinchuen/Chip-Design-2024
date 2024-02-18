module ReTwiddleMux (
    input [5:0] select,
    output [8:0] out
);
reg [8:0] twiddle;
always_comb begin
    case(select)
			6'b0: twiddle = 9'd256;
			6'b1: twiddle = 9'd255;
			6'b10: twiddle = 9'd251;
			6'b11: twiddle = 9'd245;
			6'b100: twiddle = 9'd237;
			6'b101: twiddle = 9'd226;
			6'b110: twiddle = 9'd213;
			6'b111: twiddle = 9'd198;
			6'b1000: twiddle = 9'd181;
			6'b1001: twiddle = 9'd162;
			6'b1010: twiddle = 9'd142;
			6'b1011: twiddle = 9'd121;
			6'b1100: twiddle = 9'd98;
			6'b1101: twiddle = 9'd74;
			6'b1110: twiddle = 9'd50;
			6'b1111: twiddle = 9'd25;
			6'b10000: twiddle = 9'd0;
			6'b10001: twiddle = -9'd25;
			6'b10010: twiddle = -9'd50;
			6'b10011: twiddle = -9'd74;
			6'b10100: twiddle = -9'd98;
			6'b10101: twiddle = -9'd121;
			6'b10110: twiddle = -9'd142;
			6'b10111: twiddle = -9'd162;
			6'b11000: twiddle = -9'd181;
			6'b11001: twiddle = -9'd198;
			6'b11010: twiddle = -9'd213;
			6'b11011: twiddle = -9'd226;
			6'b11100: twiddle = -9'd237;
			6'b11101: twiddle = -9'd245;
			6'b11110: twiddle = -9'd251;
			6'b11111: twiddle = -9'd255;

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
			6'b0: twiddle = 9'd0;
			6'b1: twiddle = -9'd25;
			6'b10: twiddle = -9'd50;
			6'b11: twiddle = -9'd74;
			6'b100: twiddle = -9'd98;
			6'b101: twiddle = -9'd121;
			6'b110: twiddle = -9'd142;
			6'b111: twiddle = -9'd162;
			6'b1000: twiddle = -9'd181;
			6'b1001: twiddle = -9'd198;
			6'b1010: twiddle = -9'd213;
			6'b1011: twiddle = -9'd226;
			6'b1100: twiddle = -9'd237;
			6'b1101: twiddle = -9'd245;
			6'b1110: twiddle = -9'd251;
			6'b1111: twiddle = -9'd255;
			6'b10000: twiddle = -9'd256;
			6'b10001: twiddle = -9'd255;
			6'b10010: twiddle = -9'd251;
			6'b10011: twiddle = -9'd245;
			6'b10100: twiddle = -9'd237;
			6'b10101: twiddle = -9'd226;
			6'b10110: twiddle = -9'd213;
			6'b10111: twiddle = -9'd198;
			6'b11000: twiddle = -9'd181;
			6'b11001: twiddle = -9'd162;
			6'b11010: twiddle = -9'd142;
			6'b11011: twiddle = -9'd121;
			6'b11100: twiddle = -9'd98;
			6'b11101: twiddle = -9'd74;
			6'b11110: twiddle = -9'd50;
			6'b11111: twiddle = -9'd25;

    endcase
end

assign out = twiddle;

endmodule



