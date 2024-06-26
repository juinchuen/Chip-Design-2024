module TwiddleMux (
    input [5:0] select,
    output [9:0] out
);
reg [9:0] twiddle;
always_comb begin
    case(select)

			6'b0: twiddle <= 10'd0;
			6'b1: twiddle <= -10'd25;
			6'b10: twiddle <= -10'd50;
			6'b11: twiddle <= -10'd74;
			6'b100: twiddle <= -10'd98;
			6'b101: twiddle <= -10'd121;
			6'b110: twiddle <= -10'd142;
			6'b111: twiddle <= -10'd162;
			6'b1000: twiddle <= -10'd181;
			6'b1001: twiddle <= -10'd198;
			6'b1010: twiddle <= -10'd213;
			6'b1011: twiddle <= -10'd226;
			6'b1100: twiddle <= -10'd237;
			6'b1101: twiddle <= -10'd245;
			6'b1110: twiddle <= -10'd251;
			6'b1111: twiddle <= -10'd255;
			6'b10000: twiddle <= -10'd256;
			6'b10001: twiddle <= -10'd255;
			6'b10010: twiddle <= -10'd251;
			6'b10011: twiddle <= -10'd245;
			6'b10100: twiddle <= -10'd237;
			6'b10101: twiddle <= -10'd226;
			6'b10110: twiddle <= -10'd213;
			6'b10111: twiddle <= -10'd198;
			6'b11000: twiddle <= -10'd181;
			6'b11001: twiddle <= -10'd162;
			6'b11010: twiddle <= -10'd142;
			6'b11011: twiddle <= -10'd121;
			6'b11100: twiddle <= -10'd98;
			6'b11101: twiddle <= -10'd74;
			6'b11110: twiddle <= -10'd50;
			6'b11111: twiddle <= -10'd25;
			6'b100000: twiddle <= 10'd0;
			6'b100001: twiddle <= 10'd25;
			6'b100010: twiddle <= 10'd50;
			6'b100011: twiddle <= 10'd74;
			6'b100100: twiddle <= 10'd98;
			6'b100101: twiddle <= 10'd121;
			6'b100110: twiddle <= 10'd142;
			6'b100111: twiddle <= 10'd162;
			6'b101000: twiddle <= 10'd181;
			6'b101001: twiddle <= 10'd198;
			6'b101010: twiddle <= 10'd213;
			6'b101011: twiddle <= 10'd226;
			6'b101100: twiddle <= 10'd237;
			6'b101101: twiddle <= 10'd245;
			6'b101110: twiddle <= 10'd251;
			6'b101111: twiddle <= 10'd255;
			6'b110000: twiddle <= 10'd256;
			6'b110001: twiddle <= 10'd255;
			6'b110010: twiddle <= 10'd251;
			6'b110011: twiddle <= 10'd245;
			6'b110100: twiddle <= 10'd237;
			6'b110101: twiddle <= 10'd226;
			6'b110110: twiddle <= 10'd213;
			6'b110111: twiddle <= 10'd198;
			6'b111000: twiddle <= 10'd181;
			6'b111001: twiddle <= 10'd162;
			6'b111010: twiddle <= 10'd142;
			6'b111011: twiddle <= 10'd121;
			6'b111100: twiddle <= 10'd98;
			6'b111101: twiddle <= 10'd74;
			6'b111110: twiddle <= 10'd50;
			6'b111111: twiddle <= 10'd25;

    endcase
end

assign out = twiddle;

endmodule



