module registerMux(
  input logic [5:0] index,
  input logic [15:0] regs [63:0],
  output logic [15:0] out
);
reg [15:0] registerValue;

always_comb begin
  case(index)
    6'd0: registerValue = regs[0];
    6'd1: registerValue = regs[1];
    6'd2: registerValue = regs[2];
    6'd3: registerValue = regs[3];
    6'd4: registerValue = regs[4];
    6'd5: registerValue = regs[5];
    6'd6: registerValue = regs[6];
    6'd7: registerValue = regs[7];
    6'd8: registerValue = regs[8];
    6'd9: registerValue = regs[9];
    6'd10: registerValue = regs[10];
    6'd11: registerValue = regs[11];
    6'd12: registerValue = regs[12];
    6'd13: registerValue = regs[13];
    6'd14: registerValue = regs[14];
    6'd15: registerValue = regs[15];
    6'd16: registerValue = regs[16];
    6'd17: registerValue = regs[17];
    6'd18: registerValue = regs[18];
    6'd19: registerValue = regs[19];
    6'd20: registerValue = regs[20];
    6'd21: registerValue = regs[21];
    6'd22: registerValue = regs[22];
    6'd23: registerValue = regs[23];
    6'd24: registerValue = regs[24];
    6'd25: registerValue = regs[25];
    6'd26: registerValue = regs[26];
    6'd27: registerValue = regs[27];
    6'd28: registerValue = regs[28];
    6'd29: registerValue = regs[29];
    6'd30: registerValue = regs[30];
    6'd31: registerValue = regs[31];
    6'd32: registerValue = regs[32];
    6'd33: registerValue = regs[33];
    6'd34: registerValue = regs[34];
    6'd35: registerValue = regs[35];
    6'd36: registerValue = regs[36];
    6'd37: registerValue = regs[37];
    6'd38: registerValue = regs[38];
    6'd39: registerValue = regs[39];
    6'd40: registerValue = regs[40];
    6'd41: registerValue = regs[41];
    6'd42: registerValue = regs[42];
    6'd43: registerValue = regs[43];
    6'd44: registerValue = regs[44];
    6'd45: registerValue = regs[45];
    6'd46: registerValue = regs[46];
    6'd47: registerValue = regs[47];
    6'd48: registerValue = regs[48];
    6'd49: registerValue = regs[49];
    6'd50: registerValue = regs[50];
    6'd51: registerValue = regs[51];
    6'd52: registerValue = regs[52];
    6'd53: registerValue = regs[53];
    6'd54: registerValue = regs[54];
    6'd55: registerValue = regs[55];
    6'd56: registerValue = regs[56];
    6'd57: registerValue = regs[57];
    6'd58: registerValue = regs[58];
    6'd59: registerValue = regs[59];
    6'd60: registerValue = regs[60];
    6'd61: registerValue = regs[61];
    6'd62: registerValue = regs[62];
    6'd63: registerValue = regs[63];
  endcase
end

assign out = registerValue;

endmodule