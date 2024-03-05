module halfword_shift #(
  parameter LENGTH = 16
) (
  input  logic			clk,
  input  logic 			rst,
  input  logic 			ena,
  input  logic	[15:0]	data,
  output logic 	[15:0]  out0,
  output logic 	[15:0]  out1,
  output logic 	[15:0]  out2,
  output logic 	[15:0]  out3,
  output logic 	[15:0]  out4,
  output logic 	[15:0]  out5,
  output logic 	[15:0]  out6,
  output logic 	[15:0]  out7,
  output logic 	[15:0]  out8,
  output logic 	[15:0]  out9,
  output logic 	[15:0]  out10,
  output logic 	[15:0]  out11,
  output logic 	[15:0]  out12,
  output logic 	[15:0]  out13,
  output logic 	[15:0]  out14,
  output logic 	[15:0]  out15
);
  logic [15:0] q [0:LENGTH - 1];
  
  always_ff @ (posedge clk, posedge rst) begin
    if (rst) begin
      for (int i = 0; i < LENGTH; i = i + 1) begin
        q[i] <= '0;
      end
    end else if (~ena) begin
      for (int i = 0; i < LENGTH; i = i + 1) begin
        q[i] <= q[i];
      end
    end else begin
      q[0] <= data;
      for (int i = 1; i < LENGTH; i = i + 1) begin
        q[i] <= q[i - 1];
      end
    end
  end
  
  assign out0 = q[0];
  assign out1 = q[1];
  assign out2 = q[2];
  assign out3 = q[3];
  assign out4 = q[4];
  assign out5 = q[5];
  assign out6 = q[6];
  assign out7 = q[7];
  assign out8 = q[8];
  assign out9 = q[9];
  assign out10 = q[10];
  assign out11 = q[11];
  assign out12 = q[12];
  assign out13 = q[13];
  assign out14 = q[14];
  assign out15 = q[15];
  

endmodule