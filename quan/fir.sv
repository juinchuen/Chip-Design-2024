module fir (
  input logic clk,
  input logic rst,
  input logic wind,
  input logic load,
  input logic in_valid,
  input logic [15:0] data,
  output logic out_valid,
  output logic [15:0] out
);
  typedef enum logic [2:0] {SU, S0, S1, S2, S3} FSM_State;
  
  // Data (D) shift registers
  logic [15:0] d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15;  
  halfword_shift #(
    .LENGTH(16)
  ) D (
    .clk(clk),
    .rst(rst),
    .ena(load),
    .data(data),
    .out0(d0),
    .out1(d1),
    .out2(d2),
    .out3(d3),
    .out4(d4),
    .out5(d5),
    .out6(d6),
    .out7(d7),
    .out8(d8),
    .out9(d9),
    .out10(d10),
    .out11(d11),
    .out12(d12),
    .out13(d13),
    .out14(d14),
    .out15(d15)
  );

  // Weight (W) shift registers
  logic [15:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;  
  halfword_shift #(
    .LENGTH(16)
  ) W (
    .clk(clk),
    .rst(rst),
    .ena(wind),
    .data(data),
    .out0(w0),
    .out1(w1),
    .out2(w2),
    .out3(w3),
    .out4(w4),
    .out5(w5),
    .out6(w6),
    .out7(w7),
    .out8(w8),
    .out9(w9),
    .out10(w10),
    .out11(w11),
    .out12(w12),
    .out13(w13),
    .out14(w14),
    .out15(w15)
  );

  // Muxes
  logic [15:0] D0, W0, D1, W1, D2, W2, D3, W3;
  logic [1:0] S;
  always_comb begin
    case (S)
      2'b00: begin
        D0 = d0;
        W0 = w0;
        D1 = d1;
        W1 = w1;
        D2 = d2;
        W2 = w2;
        D3 = d3;
        W3 = w3;
      end

      2'b01: begin
        D0 = d4;
        W0 = w4;
        D1 = d5;
        W1 = w5;
        D2 = d6;
        W2 = w6;
        D3 = d7;
        W3 = w7;
      end

      2'b10: begin
        D0 = d8;
        W0 = w8;
        D1 = d9;
        W1 = w9;
        D2 = d10;
        W2 = w10;
        D3 = d11;
        W3 = w11;
      end

      2'b11: begin
        D0 = d12;
        W0 = w12;
        D1 = d13;
        W1 = w13;
        D2 = d14;
        W2 = w14;
        D3 = d15;
        W3 = w15;
      end

      default: begin
        D0 = d0;
        W0 = w0;
        D1 = d1;
        W1 = w1;
        D2 = d2;
        W2 = w2;
        D3 = d3;
        W3 = w3;
      end
    endcase
  end

  // T0
  logic [31:0] P0, P1, P2, P3;
  logic in_valid_0;
  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      P0 <= 0;
      P1 <= 0;
      P2 <= 0;
      P3 <= 0;
      in_valid_0 <= 0;
    end else begin
      P0 <= in_valid_0 ? D0 * W0 : 0;
      P1 <= in_valid_0 ? D1 * W1 : 0;
      P2 <= in_valid_0 ? D2 * W2 : 0;
      P3 <= in_valid_0 ? D3 * W3 : 0;
      in_valid_0 <= in_valid;
    end
  end
  
  // T1
  logic [32:0] A0, A1;
  logic in_valid_1;
  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      A0 <= 0;
      A1 <= 0;
      in_valid_1 <= 0;
    end else begin
      A0 <= in_valid_1 ? P0 + P1 : 0;
      A1 <= in_valid_1 ? P2 + P3 : 0;
      in_valid_1 <= in_valid_0;
    end
  end
  
  // T2
  logic [35:0] A2, AC;
  logic [5:0] in_valid_2;
  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      A2 <= 0;
      AC <= 0;
      in_valid_2 <= 0;
    end else begin
      A2 <= in_valid_1 ? A0 + A1 : 0;
      AC <= in_valid_1 ? AC + A2 : 0;
      in_valid_2 <= {in_valid_1, in_valid_2[5:1]};
    end
  end
  
  // Sequence Detector
  // out_valid if in_valid_2 is 1111
  assign out_valid = &in_valid_2;
  assign out = AC[15:0];
  

  // FSM
  FSM_State state, next_state;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      state <= SU;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    case (state)
      SU: begin
        S = 00;
        next_state = in_valid ? S1 : SU;
      end

      S0: begin
        S = 00;
        next_state = S1;
      end

      S1: begin
        S = 01;
        next_state = S2;
      end

      S2: begin
        S = 10;
        next_state = S3;
      end

      S3: begin
        S = 11;
        next_state = in_valid ? S1 : SU;
      end
    endcase
  end
endmodule

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