`include "twiddle_factor_mux.sv"

module fft #(
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input [15:0] input_sig_Re [((D_WIDTH) - 1):0],
    input [15:0] input_sig_Im [((D_WIDTH) - 1):0],
    input clk, rst,
    output [15:0] output_sig_Re [((D_WIDTH) - 1):0]
    output [15:0] output_sig_Im [((D_WIDTH) - 1):0]
);
    // Correctly route the input signal

    //wire [15:0] fft_data [((D_WIDTH) - 1):0]
    generate
    
    for (genvar i = 0; i < D_WIDTH; i++) begin 
        genvar [LOG_2_WIDTH-1:0] ii;
        genvar [LOG_2_WIDTH-1:0] x;
          x = i;
          ii = 0;
          for (int j = 0; j < LOG_2_WIDTH; j++) begin
              ii <<= 1;
              ii |= (x & 1);
              x >>= 1;
          end
        assign output_sig[ii] = input_sig[i];
    end
  endgenerate
endmodule

module Butterfly#( 
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input [15:0] input_Re, input_Im [((D_WIDTH) - 1):0],
    input start, clk, rst,
    output [15:0] output_Re, output_Im [((D_WIDTH) - 1):0]
);
  wire [15:0] reff_in [((D_WIDTH) - 1):0];
  wire [15:0] reff_out [((D_WIDTH) - 1):0];
  wire [15:0] imff_in [((D_WIDTH) - 1):0];
  wire [15:0] imff_out [((D_WIDTH) - 1):0];
  wire [15: 0] count, stage, twiddle_index;
  wire twiddle_second;
  wire [8:0] re_twiddle, im_twiddle;

  wire [15:0] curr_reg_Re, other_reg_Re, curr_reg_Im, other_reg_Im, new_Re, new_Im;

  // Fix this to not interact with clock
  StageClock StageCount(.start(start), .shift(~(|count)), .rst(rst), .out(stage));
  // Might need to delay start for these two

  CountTo64 Counter(.start(start), .clk(clk), .rst(rst), .out(count));
  TwiddleFactorIndex TwiddleIndex(.stage(stage), .start(start), .clk(clk), .rst(rst), .out(twiddle_index));
  assign twiddle_second = ~((count[5] & stage[0]) | (count[4] & stage[1]) | (count[3] & stage[2]) | (count[2] & stage[3]) | (count[1] & stage[4]) | (count[0] & stage[5]));

  //Get twiddle factor
  ReTwiddleMux ReTwiddleMux(.select(twiddle_index), .out(re_twiddle));
  ImTwiddleMux ImTwiddleMux(.select(twiddle_index), .out(im_twiddle));

  //Get the output from the Twiddle factors
  Apply_Twiddle Apply_Twiddle(.curr_reg_RE(curr_reg_Re), .other_reg_RE(other_reg_Re), .curr_reg_IM(curr_reg_Im), .other_reg_IM(other_reg_Im),
    .twiddle_factorRe(re_twiddle), .twiddle_factorIm(im_twiddle), .twiddle_second(twiddle_second), .out_RE(new_Re), .out_IM(new_Im));

  //Handle all of the differnet values 
  reg [15:0] Re_reg [((D_WIDTH) - 1):0];
  reg [15:0] Im_reg [((D_WIDTH) - 1):0];
  assign output_Re = Re_reg;
  assign output_Im = Im_reg;
  generate 
    for (genvar i = 0; i < D_WIDTH; i++) begin 
      assign output_Re[i] = Re_reg[i];
      assign output_Im[i] = Im_reg[i];
      always_ff @(negedge clk or negedge rst) begin
        if (~rst) begin
          Re_reg[i] <= 16'b0;
          Im_reg[i] <= 16'b0;
        end else if(start) begin
          Re_reg[i] <= input_sig_Re[i];
          Im_reg[i] <= input_sig_Im[i];
        end else begin
          Re_reg[i] <= (count == i) ? new_Re : Re_reg[i];
          Im_reg[i] <= (count == i) ? new_Im : Im_reg[i];
        end
      end
    end
  endgenerate
endmodule

module Apply_Twiddle( 
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input [15:0] curr_reg_RE, other_reg_RE, curr_reg_IM, other_reg_IM,
    input [9:0] twiddle_factorRe, twiddle_factorIm,
    input twiddle_second,
    output [15:0] out_RE, out_IM
);
  wire [24:0] multi_inRe, multi_inIm, add_inRe, add_inIm, RE_out_PreChop, IM_out_PreChop;
  
  assign multi_inRe = twiddle_second ? other_reg_RE : curr_reg_RE;
  assign multi_inIm = twiddle_second ? other_reg_IM : curr_reg_IM;
  assign add_inRe = twiddle_second ? curr_reg_RE : other_reg_RE; 
  assign add_inIm = twiddle_second ? curr_reg_IM : other_reg_IM;

  assign RE_out_PreChop = (multi_inRe * twiddle_factorRe) - (multi_inIm * twiddle_factorIm) + add_inRe;
  assign IM_out_PreChop = (multi_inRe * twiddle_factorIm) + (multi_inIm * twiddle_factorRe) + add_inIm;
  
  assign out_RE = RE_out_PreChop[15:0];
  assign out_IM = IM_out_PreChop[15:0];
  // This should really just be an adder where u invert the input and change carryout to 1
  
endmodule

module CountTo64(
  input wire start, clk, rst,
  output wire [5:0] out
);
  wire [5:0] A, B, C;
  assign B = A + 1'b1;
  assign C = start ? 6'b0 : B;  
  DFF_6Bit FF(.D(C), .clk(clk), .rst(rst), .Q(A));

  assign out = ~(|C);
endmodule

module TwiddleFactorIndex(
  input wire [5:0] stage,  
  input wire start, clk, rst,
  output wire [5:0] out
);
  wire [5:0] A, B, C;
  // TwiddleAdder ADD1(A, stage, B);
  assign B = stage + A;
  assign C = start ? 6'b0 : B;  
  DFF_6Bit FF(.D(C), .clk(clk), .rst(rst), .Q(A));

  assign out = C;
endmodule

// module TwiddleAdder(
//   input wire [5:0] A, B,
//   output wire [5:0] out
// );
// wire [6:0] temp;
// assign out = temp[5:0];

// endmodule


module StageClock(
  input wire start, shift, rst,
  output wire [5:0] out
);
  wire in;
  wire [5:0] B;

  assign in = start & ~(|B);

  DFF_Bit FF0(.D(in), .clk(shift), .rst(rst), .Q(B[5]));
  DFF_Bit FF1(.D(B[5]), .clk(shift), .rst(rst), .Q(B[4]));
  DFF_Bit FF2(.D(B[4]), .clk(shift), .rst(rst), .Q(B[3]));
  DFF_Bit FF3(.D(B[3]), .clk(shift), .rst(rst), .Q(B[2]));
  DFF_Bit FF4(.D(B[2]), .clk(shift), .rst(rst), .Q(B[1]));
  DFF_Bit FF5(.D(B[1]), .clk(shift), .rst(rst), .Q(B[0]));

  assign out = B;

endmodule 



module DFF_Bit (
  input wire D, clk, rst,
  output wire Q
);
  logic data;
  
  always_ff @(negedge clk or negedge rst) begin
    if (~rst) begin
      data <= 1'b0;
      // Qn <= 16'b1111111111111111;
    end else begin
      data <= D;
    end
  end

  assign Q = data;
endmodule

module DFF_6Bit (
  input wire [5:0] D, 
  input wire clk, rst,
  output wire [5:0] Q
);
  logic [5:0] data;
  
  always_ff @(negedge clk or negedge rst) begin
    if (~rst) begin
      data <= 6'b0;
    end else begin
      data <= D;
    end
  end
  assign Q = data;
endmodule