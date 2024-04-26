`include "twiddle_factor_mux.sv"
`include "registerMux.sv"
`include "signal_router.sv"

module FFT #(
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
)( 
  input logic [15:0] inputRe [((D_WIDTH) - 1):0],
  input logic [15:0] inputIm [((D_WIDTH) - 1):0],
  input logic start, clk, rst, ifft,
  output wire [15:0] outputRe [((D_WIDTH) - 1):0],
  output wire [15:0] outputIm [((D_WIDTH) - 1):0]
  );
  wire [15:0] reButterflyIn [((D_WIDTH) - 1):0];
  wire [15:0] imButterflyIn [((D_WIDTH) - 1):0];
  InputSignalRouter MovSignals( .inputRe(inputRe),
                                .inputIm(inputIm), 
                                .outputRe(reButterflyIn),
                                .outputIm(imButterflyIn));

  Butterfly Butterfly(.inputRe(reButterflyIn),
                      .inputIm(imButterflyIn),
                      .start(start), 
                      .clk(clk),
                      .rst(rst),
                      .outputRe(outputRe),
                      .outputIm(outputIm));

endmodule

module Butterfly#( 
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input [15:0] inputRe [((D_WIDTH) - 1):0],
    input [15:0] inputIm [((D_WIDTH) - 1):0],
    input start, clk, rst,
    output wire [15:0] outputRe [((D_WIDTH) - 1):0],
    output wire [15:0] outputIm [((D_WIDTH) - 1):0]
);
  wire [5:0] count, stage, pairIndex;
  wire [5:0] twiddleIndexRe, twiddleIndexIm;
  wire [9:0] reTwiddle, imTwiddle;
  wire [15:0] primaryRegRe, pairRegRe, primaryRegIm, pairRegIm, newPrimaryRe, newImPair, newPairRe, newPairIm;
  wire [5:0] reverseStage; 
  wire newStage;
  wire skip;
  assign reverseStage = {stage[0], stage[1], stage[2], stage[3], stage[4], stage[5]};

  StageClock StageCount(.start(start), .shift(newStage | start), .clk(clk), .rst(rst), .out(stage));
  CountTo64 Counter(.start(start), .stage(stage), .clk(clk), .rst(rst), .newStage(newStage), .out(count), .skip(skip));
  TwiddleFactorIndex TwiddleIndex(.stage(stage), .start(start | newStage), .skip(skip), .clk(clk), .rst(rst), .out(twiddleIndexIm));

  assign twiddleIndexRe = twiddleIndexIm + 'b110000;

  //Get twiddle factor
  TwiddleMux ReTwiddleMux(.select(twiddleIndexRe), .out(reTwiddle));
  TwiddleMux ImTwiddleMux(.select(twiddleIndexIm), .out(imTwiddle));

  assign pairIndex = count + reverseStage; 
  reg [15:0] reReg [((D_WIDTH) - 1):0];
  reg [15:0] imReg [((D_WIDTH) - 1):0];

  registerMux Get_Re_Reg1(.index(count), .regs(reReg), .out(primaryRegRe));
  registerMux Get_Re_Reg2(.index(pairIndex), .regs(reReg), .out(pairRegRe));
  registerMux Get_Im_Reg1(.index(count), .regs(imReg), .out(primaryRegIm));
  registerMux Get_Im_Reg2(.index(pairIndex), .regs(imReg), .out(pairRegIm));

  //Get the output from the Twiddle factors
  Apply_Twiddle Apply_Twiddle1(.primaryRegRe(primaryRegRe), .pairRegRe(pairRegRe), .primaryRegIm(primaryRegIm), .pairRegIm(pairRegIm),
    .twiddleFactorRe(reTwiddle), .twiddle_factorIm(imTwiddle), .primaryRe(newPrimaryRe), .primaryIm(newImPair), 
    .pairRe(newPairRe), .pairIm(newPairIm), .ifft(ifft));

  wire wrEnable = |stage;
  assign outputRe = reReg;
  assign outputIm = imReg;

  always_ff @(negedge clk or negedge rst) begin
  if (~rst) begin
    for(int i = 0; i < 64; i++) begin
      reReg[i] <= 16'b0;
      imReg[i] <= 16'b0;
    end
  end else if(start) begin
    for(int i = 0; i < 64; i++) begin
      reReg[i] <= inputRe[i];
      imReg[i] <= inputIm[i];
    end
  end else begin
    if(wrEnable) begin
      for(int i = 0; i < 64; i++) begin
        if(count == i) begin
          reReg[i] <= newPrimaryRe;
          imReg[i] <= newImPair;
        end
        if(pairIndex == i) begin
          reReg[i] <= newPairRe;
          imReg[i] <= newPairIm;
        end
      end
    end
  end
end
endmodule

module Apply_Twiddle(
    input logic [15:0] primaryRegRe, pairRegRe, primaryRegIm, pairRegIm,
    input logic [9:0] twiddleFactorRe, twiddle_factorIm,
    input wire ifft,
    output logic [15:0] primaryRe, primaryIm, pairRe, pairIm
);

  wire signed [32:0] ReOutMulti, ImOutMulti;
  wire signed [15:0] ReTemp, ImTemp, multi_inRe, multi_inIm, add_inRe, add_inIm, temp1, temp2, roundedRe, roundedIm;

  assign multi_inRe =  pairRegRe;
  assign multi_inIm = pairRegIm;
  assign add_inRe =  primaryRegRe; 
  assign add_inIm =  primaryRegIm;

  assign ReOutMulti =  (multi_inRe * $signed({{6{twiddleFactorRe[9]}}, twiddleFactorRe})) - (multi_inIm * $signed({{6{twiddle_factorIm[9]}}, twiddle_factorIm}));
  assign ImOutMulti = (multi_inRe * $signed({{6{twiddle_factorIm[9]}}, twiddle_factorIm})) + (multi_inIm * $signed({{6{twiddleFactorRe[9]}}, twiddleFactorRe}));
  
  assign roundedRe = {ReOutMulti[32], ReOutMulti[22:8]} + ReOutMulti[7];
  assign roundedIm = {ImOutMulti[32], ImOutMulti[22:8]} + ImOutMulti[7];
  assign primaryRe =  add_inRe + roundedRe;
  assign primaryIm =  add_inIm + roundedIm;

  assign pairRe = add_inRe - roundedRe;
  assign pairIm = add_inIm - roundedIm;

endmodule

module TwiddleFactorIndex(
  input wire [5:0] stage,  
  input wire skip, start, clk, rst, 
  output wire [5:0] out
);
  wire [5:0] newTwiddle, twiddleIncremented;
  logic [5:0] currTwiddle;

  assign twiddleIncremented = stage + currTwiddle;
  assign newTwiddle = start | skip ? 6'b0 : twiddleIncremented[5:0];  
  
  always_ff @(negedge clk or negedge rst) begin
    if (~rst) begin
      currTwiddle <= 6'b0;
    end else begin
      currTwiddle <= newTwiddle;
    end
  end

  assign out = currTwiddle;

endmodule

module StageClock(
  input wire start, shift, rst, clk,
  output wire [5:0] out
);
  reg [5:0] shift_reg;
  assign in = start & ~(|shift_reg);

  always_ff @(negedge clk or negedge rst) begin
    if (~rst) begin
        // Reset the register to all zeros
        shift_reg <= 6'b0;
    end else if (shift) begin
      shift_reg <= {in, shift_reg[5:1]};
    end
  end
  assign out = shift_reg;

endmodule 

module CountTo64(
  input wire [5:0] stage,
  input wire start, clk, rst,
  output wire newStage, skip,
  output wire [5:0] out 
);
  wire [5:0] reverseStage; 
  wire [5:0] next_before, next_val;
  reg [5:0] curr;
  wire [6:0] next_after;
  assign next_before = curr + 1'b1;
  assign skip = ((next_before[5] & stage[0]) | (next_before[4] & stage[1]) | (next_before[3] & stage[2]) 
    | (next_before[2] & stage[3]) | (next_before[1] & stage[4]) | (next_before[0] & stage[5]));
  assign reverseStage = {stage[0], stage[1], stage[2], stage[3], stage[4], stage[5]};
  assign next_after = (skip) ? reverseStage + next_before : next_before;
  assign newStage = next_after[6];
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
