`include "twiddle_factor_mux.sv"
`include "registerMux.sv"

module fft ( 
  input logic [15:0] input_sig_Re [((D_WIDTH) - 1):0],
  input logic [15:0] input_sig_Im [((D_WIDTH) - 1):0],
  input start, clk, rst,
  output logic [15:0] output_sig_Re [((D_WIDTH) - 1):0],
  output logic [15:0] output_sig_Im [((D_WIDTH) - 1):0]
  );
  wire [15:0] Re_into_butterfly [((D_WIDTH) - 1):0];
  wire [15:0] Im_into_butterfly [((D_WIDTH) - 1):0];
  InputSignalRouter MovSignals( .input_sig_Re(input_sig_Re),
                                .input_sig_Im(input_sig_Im), 
                                .output_sig_Re(Re_into_butterfly),
                                .output_sig_Im(Im_into_butterfly));

  Butterfly Butterfly(.input_Re(Re_into_butterfly),
                      .input_Im(Im_into_butterfly),
                      .start(start) 
                      .clk(clk)
                      .rst(rst)
                      .output_Re(output_sig_Re),
                      .output_Im(output_sig_Im));

endmodule

module InputSignalRouter #(
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input logic [15:0] input_sig_Re [((D_WIDTH) - 1):0],
    input logic [15:0] input_sig_Im [((D_WIDTH) - 1):0],
    output logic [15:0] output_sig_Re [((D_WIDTH) - 1):0],
    output logic [15:0] output_sig_Im [((D_WIDTH) - 1):0]
);
    // Correctly route the input signal

    wire [15:0] fft_Re [((D_WIDTH) - 1):0];
    wire [15:0] fft_Im [((D_WIDTH) - 1):0];
 generate
    for (genvar i = 0; i < D_WIDTH; i++) begin 
        int ii;
        int  x;

        initial begin
            x = i;
            ii = 0;
            for (int j = 0; j < LOG_2_WIDTH; j++) begin
                ii <<= 1;
                ii |= (x & 1);
                x >>= 1;
            end
        end
        assign fft_Re[i] = input_sig_Re[ii];
        assign fft_Im[i] = input_sig_Im[ii];
    end
    assign output_sig_Re = fft_Re;
    assign output_sig_Im = fft_Im;
endgenerate

endmodule

module Butterfly#( 
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input [15:0] input_Re [((D_WIDTH) - 1):0],
    input [15:0] input_Im [((D_WIDTH) - 1):0],
    input start, clk, rst,
    output [15:0] output_Re [((D_WIDTH) - 1):0],
    output [15:0] output_Im [((D_WIDTH) - 1):0]
);
  wire [15:0] reff_in [((D_WIDTH) - 1):0];
  wire [15:0] reff_out [((D_WIDTH) - 1):0];
  wire [15:0] imff_in [((D_WIDTH) - 1):0];
  wire [15:0] imff_out [((D_WIDTH) - 1):0];
  wire [5:0] count, stage, index2;
  wire [5:0] twiddle_index_1_Re, twiddle_index_2_Re, twiddle_index_1_Im, twiddle_index_2_Im;
  wire [8:0] re_twiddle_curr, im_twiddle_curr, re_twiddle_other, im_twiddle_other;
  wire [15:0] curr_reg_Re, other_reg_Re, curr_reg_Im, other_reg_Im, new_Re_Curr, new_Im_Curr, new_Re_Oth, new_Im_Oth;
  wire [5:0] reverse_stage; 
  wire new_stage;
  assign reverse_stage = {stage[0], stage[1], stage[2], stage[3], stage[4], stage[5]};
  // Fix this to not interact with clock
  StageClock StageCount(.start(start), .shift(new_stage), .rst(rst), .out(stage));
  // Might need to delay start for these two

  CountTo64 Counter(.start(start), .stage(stage), .clk(clk), .rst(rst), .new_stage(new_stage), .out(count));
  TwiddleFactorIndex TwiddleIndex(.stage(stage), .start(start), .clk(clk), .rst(rst), .out(twiddle_index_1));
  assign twiddle_index_2_Im = twiddle_index_1_Im + reverse_stage; 

  assign twiddle_index_1_Re = twiddle_index_1_Im + 'b10000; 
  assign twiddle_index_2_Re = twiddle_index_2_Im + 'b10000;
  //Get twiddle factor
  TwiddleMux ReTwiddleMux1(.select(twiddle_index_1_Re), .out(re_twiddle_curr));
  TwiddleMux ImTwiddleMux1(.select(twiddle_index_1_Im), .out(im_twiddle_curr));
  
  TwiddleMux ReTwiddleMux2(.select(twiddle_index_2_Re), .out(re_twiddle_other));
  TwiddleMux ImTwiddleMux2(.select(twiddle_index_2_Im), .out(im_twiddle_other));

  //Get the correct Registers
  assign index2 = count + reverse_stage; 
  reg [15:0] Re_reg [((D_WIDTH) - 1):0];
  reg [15:0] Im_reg [((D_WIDTH) - 1):0];
  registerMux Get_Re_Reg1(.index(count), .regs(Re_reg), .out(curr_reg_Re));
  registerMux Get_Re_Reg2(.index(index2), .regs(Re_reg), .out(other_reg_Re));
  registerMux Get_Im_Reg1(.index(count), .regs(Im_reg), .out(curr_reg_Im));
  registerMux Get_Im_Reg2(.index(index2), .regs(Im_reg), .out(other_reg_Im));
  //Get the output from the Twiddle factors
  Apply_Twiddle_Curr Apply_Twiddle1(.curr_reg_RE(curr_reg_Re), .other_reg_RE(other_reg_Re), .curr_reg_IM(curr_reg_Im), .other_reg_IM(other_reg_Im),
    .twiddle_factorRe(re_twiddle_curr), .twiddle_factorIm(im_twiddle_curr), .out_RE(new_Re_Curr), .out_IM(new_Im_Curr));

Apply_Twiddle_Oth Apply_Twiddle2(.curr_reg_RE(curr_reg_Re), .other_reg_RE(other_reg_Re), .curr_reg_IM(curr_reg_Im), .other_reg_IM(other_reg_Im),
    .twiddle_factorRe(re_twiddle_other), .twiddle_factorIm(im_twiddle_other), .out_RE(new_Re_Oth), .out_IM(new_Im_Oth));


  //Handle all of the differnet values 

  assign output_Re = Re_reg;
  assign output_Im = Im_reg;

  // Might need to use a normal for loop
  generate 
    for (genvar i = 0; i < D_WIDTH; i++) begin 
      assign output_Re[i] = Re_reg[i];
      assign output_Im[i] = Im_reg[i];
      always_ff @(negedge clk or negedge rst) begin
        if (~rst) begin
          Re_reg[i] <= 16'b0;
          Im_reg[i] <= 16'b0;
        end else if(start) begin
          Re_reg[i] <= input_Re[i];
          Im_reg[i] <= input_Im[i];
        end else  if(count == i) begin
          Re_reg[i] <= new_Re_Curr;
          Im_reg[i] <= new_Im_Curr;
        end else  if(index2 == i) begin
          Re_reg[i] <= new_Re_Oth;
          Im_reg[i] <= new_Im_Oth;
        end else begin
          Re_reg[i] <= Re_reg[i];
          Im_reg[i] <= Im_reg[i];
        end
      end
    end
  endgenerate
endmodule


module Apply_Twiddle_Curr(
    input logic [15:0] curr_reg_RE, other_reg_RE, curr_reg_IM, other_reg_IM,
    input logic [9:0] twiddle_factorRe, twiddle_factorIm,
   
    output logic [15:0] out_RE, out_IM
);
  wire [33:0] multi_inRe, multi_inIm, add_inRe, add_inIm, RE_out_PreChop, IM_out_PreChop;
  
  assign multi_inRe = curr_reg_RE;
  assign multi_inIm = curr_reg_IM;
  assign add_inRe = other_reg_RE; 
  assign add_inIm = other_reg_IM;

  assign RE_out_PreChop = (multi_inRe * twiddle_factorRe) - (multi_inIm * twiddle_factorIm) + add_inRe;
  assign IM_out_PreChop = (multi_inRe * twiddle_factorIm) + (multi_inIm * twiddle_factorRe) + add_inIm;
  
  assign out_RE = RE_out_PreChop[15:0];
  assign out_IM = IM_out_PreChop[15:0];
  // This should really just be an adder where u invert the input and change carryout to 1
  
endmodule

module Apply_Twiddle_Oth(
    input logic [15:0] curr_reg_RE, other_reg_RE, curr_reg_IM, other_reg_IM,
    input logic [9:0] twiddle_factorRe, twiddle_factorIm,
   
    output logic [15:0] out_RE, out_IM
);
  wire [24:0] multi_inRe, multi_inIm, add_inRe, add_inIm, RE_out_PreChop, IM_out_PreChop;
  
  assign multi_inRe = curr_reg_RE;
  assign multi_inIm = curr_reg_IM;
  assign add_inRe = other_reg_RE; 
  assign add_inIm = other_reg_IM;

  assign RE_out_PreChop = (multi_inRe * twiddle_factorRe) - (multi_inIm * twiddle_factorIm) + add_inRe;
  assign IM_out_PreChop = (multi_inRe * twiddle_factorIm) + (multi_inIm * twiddle_factorRe) + add_inIm;
  
  assign out_RE = RE_out_PreChop[15:0];
  assign out_IM = IM_out_PreChop[15:0];
  // This should really just be an adder where u invert the input and change carryout to 1
  
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
  input wire start, shift, rst, clk,
  output wire [5:0] out
);
  wire in;
  wire [5:0] B;

  assign in = start & ~(|B);

  DFF_Bit FF0(.D(shift ? in : B[5]), .clk(clk), .rst(rst), .Q(B[5]));
  DFF_Bit FF1(.D(shift ? B[5] : B[4]), .clk(clk), .rst(rst), .Q(B[4]));
  DFF_Bit FF2(.D(shift ? B[4] : B[3]), .clk(clk), .rst(rst), .Q(B[3]));
  DFF_Bit FF3(.D(shift ? B[3] : B[2]), .clk(clk), .rst(rst), .Q(B[2]));
  DFF_Bit FF4(.D(shift ? B[2] : B[1]), .clk(clk), .rst(rst), .Q(B[1]));
  DFF_Bit FF5(.D(shift ? B[1] : B[0]), .clk(clk), .rst(rst), .Q(B[0]));

  assign out = B;

endmodule 

module CountTo64(
  input wire [5:0] stage,
  input wire start, clk, rst,
  output wire new_stage,
  output wire [5:0] out
);
  wire [5:0] reverse_stage; 
  wire [5:0] next_before, next_val;
  reg [5:0] curr;
  wire [6:0] next_after;
  assign next_before = curr + 1'b1;
  assign sel = ((next_before[5] & stage[0]) | (next_before[4] & stage[1]) | (next_before[3] & stage[2]) 
    | (next_before[2] & stage[3]) | (next_before[1] & stage[4]) | (next_before[0] & stage[5]));
  assign reverse_stage = {stage[0], stage[1], stage[2], stage[3], stage[4], stage[5]};
  assign next_after = (sel) ? reverse_stage + next_before : next_before;
  assign new_stage = next_after[6];
  assign next_val = start ? 6'b0 : next_after[5:0];  
  
  always_ff @(negedge clk or negedge rst) begin
    if (~rst) begin
      curr <= 6'b0;
    end else begin
      curr <= next_val;
    end
  end

  assign out = curr;
endmodule

module DFF_Bit (
  input wire D, clk, rst,
  output wire Q
);
  logic data;
  
  always_ff @(negedge clk or negedge rst) begin
    if (~rst) begin
      data <= 1'b0;
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