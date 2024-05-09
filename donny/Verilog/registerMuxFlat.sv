module registerMux(
  input logic [5:0] index,
  input logic [1023:0] regs,
  output logic [15:0] out
);
reg [15:0] registerValue;

always_comb begin
  case(index)
    6'd0: registerValue = regs[16*0 +: 16];
    6'd1: registerValue = regs[16*1 +: 16];
    6'd2: registerValue = regs[16*2 +: 16];
    6'd3: registerValue = regs[16*3 +: 16];
    6'd4: registerValue = regs[16*4 +: 16];
    6'd5: registerValue = regs[16*5 +: 16];
    6'd6: registerValue = regs[16*6 +: 16];
    6'd7: registerValue = regs[16*7 +: 16];
    6'd8: registerValue = regs[16*8 +: 16];
    6'd9: registerValue = regs[16*9 +: 16];
    6'd10: registerValue = regs[16* 10  +: 16];
    6'd11: registerValue = regs[16* 11  +: 16];
    6'd12: registerValue = regs[16* 12  +: 16];
    6'd13: registerValue = regs[16* 13  +: 16];
    6'd14: registerValue = regs[16* 14  +: 16];
    6'd15: registerValue = regs[16* 15  +: 16];
    6'd16: registerValue = regs[16* 16  +: 16];
    6'd17: registerValue = regs[16* 17  +: 16];
    6'd18: registerValue = regs[16* 18  +: 16];
    6'd19: registerValue = regs[16* 19  +: 16];
    6'd20: registerValue = regs[16* 20  +: 16];
    6'd21: registerValue = regs[16* 21  +: 16];
    6'd22: registerValue = regs[16* 22  +: 16];
    6'd23: registerValue = regs[16* 23  +: 16];
    6'd24: registerValue = regs[16* 24  +: 16];
    6'd25: registerValue = regs[16* 25  +: 16];
    6'd26: registerValue = regs[16* 26  +: 16];
    6'd27: registerValue = regs[16* 27  +: 16];
    6'd28: registerValue = regs[16* 28  +: 16];
    6'd29: registerValue = regs[16* 29  +: 16];
    6'd30: registerValue = regs[16* 30  +: 16];
    6'd31: registerValue = regs[16* 31  +: 16];
    6'd32: registerValue = regs[16* 32  +: 16];
    6'd33: registerValue = regs[16* 33  +: 16];
    6'd34: registerValue = regs[16* 34  +: 16];
    6'd35: registerValue = regs[16* 35  +: 16];
    6'd36: registerValue = regs[16* 36  +: 16];
    6'd37: registerValue = regs[16* 37  +: 16];
    6'd38: registerValue = regs[16* 38  +: 16];
    6'd39: registerValue = regs[16* 39  +: 16];
    6'd40: registerValue = regs[16* 40  +: 16];
    6'd41: registerValue = regs[16* 41  +: 16];
    6'd42: registerValue = regs[16* 42  +: 16];
    6'd43: registerValue = regs[16* 43  +: 16];
    6'd44: registerValue = regs[16* 44  +: 16];
    6'd45: registerValue = regs[16* 45  +: 16];
    6'd46: registerValue = regs[16* 46  +: 16];
    6'd47: registerValue = regs[16* 47  +: 16];
    6'd48: registerValue = regs[16* 48  +: 16];
    6'd49: registerValue = regs[16* 49  +: 16];
    6'd50: registerValue = regs[16* 50  +: 16];
    6'd51: registerValue = regs[16* 51  +: 16];
    6'd52: registerValue = regs[16* 52  +: 16];
    6'd53: registerValue = regs[16* 53  +: 16];
    6'd54: registerValue = regs[16* 54  +: 16];
    6'd55: registerValue = regs[16* 55  +: 16];
    6'd56: registerValue = regs[16* 56  +: 16];
    6'd57: registerValue = regs[16* 57  +: 16];
    6'd58: registerValue = regs[16* 58  +: 16];
    6'd59: registerValue = regs[16* 59  +: 16];
    6'd60: registerValue = regs[16* 60  +: 16];
    6'd61: registerValue = regs[16* 61  +: 16];
    6'd62: registerValue = regs[16* 62  +: 16];
    6'd63: registerValue = regs[16* 63  +: 16];
  endcase
end

assign out = registerValue;

endmodule