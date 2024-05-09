`include "twiddle_factor_mux.sv"
`include "registerMuxFlat.sv"
`include "signal_router_flat.sv"

module fft #(
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
)( 
  input logic [1023 :0] inputRe,
  input logic [1023 :0] inputIm,
  input logic start, clk, rst,
  output wire [1023 :0] outputRe,
  output wire [1023 :0] outputIm,
  output wire done
  );
  wire [1023 :0] reButterflyIn;
  wire [1023 :0] imButterflyIn;
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
                      .outputIm(outputIm),
                      .done(done));
endmodule

module Butterfly#( 
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input [1023 :0] inputRe,
    input [1023 :0] inputIm,
    input  wire start, clk, rst,
    output wire [1023 :0] outputRe,
    output wire [1023 :0] outputIm,
    output wire done
);
  wire [5:0] count, stage, pairIndex;
  wire [5:0] twiddleIndexRe, twiddleIndexIm;
  wire [9:0] reTwiddle, imTwiddle;
  wire [15:0] primaryRegRe, pairRegRe, primaryRegIm, pairRegIm, newPrimaryRe, newImPair, newPairRe, newPairIm;
  wire [5:0] reverseStage; 
  wire newStage;
  wire skip;

    logic doneData;

    always_ff @(negedge clk or negedge rst) begin
      if (~rst) begin
        doneData <= 1'b0;
      end else begin
        doneData <= stage[0] & newStage;
      end
    end

  assign done = doneData;

  assign reverseStage = {stage[0], stage[1], stage[2], stage[3], stage[4], stage[5]};

  StageClock StageCount(.start(start), .shift(newStage | start), .clk(clk), .done(done), .rst(rst), .out(stage));
  CountTo64 Counter(.start(start), .stage(stage), .clk(clk), .rst(rst), .newStage(newStage), .out(count), .skip(skip));
  TwiddleFactorIndex TwiddleIndex(.stage(stage), .start(start | newStage), .skip(skip), .clk(clk), .rst(rst), .out(twiddleIndexIm));

  assign twiddleIndexRe = twiddleIndexIm + 'b110000;

  //Get twiddle factor
  TwiddleMux ReTwiddleMux(.select(twiddleIndexRe), .out(reTwiddle));
  TwiddleMux ImTwiddleMux(.select(twiddleIndexIm), .out(imTwiddle));

  assign pairIndex = count + reverseStage; 
  reg [1023 :0] reReg;
  reg [1023 :0] imReg;

  registerMux Get_Re_Reg1(.index(count), .regs(reReg), .out(primaryRegRe));
  registerMux Get_Re_Reg2(.index(pairIndex), .regs(reReg), .out(pairRegRe));
  registerMux Get_Im_Reg1(.index(count), .regs(imReg), .out(primaryRegIm));
  registerMux Get_Im_Reg2(.index(pairIndex), .regs(imReg), .out(pairRegIm));

  //Get the output from the Twiddle factors
  Apply_Twiddle Apply_Twiddle1(.primaryRegRe(primaryRegRe), .pairRegRe(pairRegRe), .primaryRegIm(primaryRegIm), .pairRegIm(pairRegIm),
    .twiddleFactorRe(reTwiddle), .twiddle_factorIm(imTwiddle), .primaryRe(newPrimaryRe), .primaryIm(newImPair), 
    .pairRe(newPairRe), .pairIm(newPairIm));

  wire wrEnable = |stage;
  assign outputRe = reReg;
  assign outputIm = imReg;

  always_ff @(negedge clk or negedge rst) begin
  if (~rst) begin
    for(int i = 0; i < 64; i++) begin
      reReg[i * 16 +: 16] <= 16'b0;
      imReg[i * 16 +: 16] <= 16'b0;
    end
  end else if(start) begin
    for(int i = 0; i < 64; i++) begin
      reReg[i * 16 +: 16] <= inputRe[i * 16 +: 16];
      imReg[i * 16 +: 16] <= inputIm[i * 16 +: 16];
    end
  end else begin
    if(wrEnable) begin
      for(int i = 0; i < 64; i++) begin
        if(count == i) begin
          reReg[i * 16 +: 16] <= newPrimaryRe;
          imReg[i * 16 +: 16] <= newImPair;
        end
        if(pairIndex == i) begin
          reReg[i * 16 +: 16] <= newPairRe;
          imReg[i * 16 +: 16]  <= newPairIm;
        end
      end
    end
  end
end
endmodule

module Apply_Twiddle(
    input logic [15:0] primaryRegRe, pairRegRe, primaryRegIm, pairRegIm,
    input logic [9:0] twiddleFactorRe, twiddle_factorIm,
    output logic [15:0] primaryRe, primaryIm, pairRe, pairIm
);

  wire signed [32:0] ReOutMulti, ImOutMulti;
  wire signed [15:0] multiReIn, multiImIn, addReIn, addImIn, roundedRe, roundedIm;

  assign multiReIn =  pairRegRe;
  assign multiImIn = pairRegIm;
  assign addReIn =  primaryRegRe; 
  assign addImIn =  primaryRegIm;

  assign ReOutMulti =  (multiReIn * $signed({{6{twiddleFactorRe[9]}}, twiddleFactorRe})) - (multiImIn * $signed({{6{twiddle_factorIm[9]}}, twiddle_factorIm}));
  assign ImOutMulti = (multiReIn * $signed({{6{twiddle_factorIm[9]}}, twiddle_factorIm})) + (multiImIn * $signed({{6{twiddleFactorRe[9]}}, twiddleFactorRe}));
  
  assign roundedRe = {ReOutMulti[32], ReOutMulti[22:8]} + ReOutMulti[7];
  assign roundedIm = {ImOutMulti[32], ImOutMulti[22:8]} + ImOutMulti[7];
  assign primaryRe =  addReIn + roundedRe;
  assign primaryIm =  addImIn + roundedIm;

  assign pairRe = addReIn - roundedRe;
  assign pairIm = addImIn - roundedIm;

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
  input wire start, shift, rst, clk, done,
  output wire [5:0] out
);
  reg [5:0] shiftReg;
  wire in;
  assign in = start & ~(|shiftReg);

  always_ff @(negedge clk or negedge rst) begin
    if (~rst) begin
        // Reset the register to all zeros
        shiftReg <= 6'b0;
    end else if (shift) begin
      shiftReg <= {in, shiftReg[5:1]};
    end
  end

  assign out = shiftReg;

endmodule 

module CountTo64(
  input wire [5:0] stage,
  input wire start, clk, rst,
  output wire newStage, skip,
  output wire [5:0] out 
);
  wire [5:0] reverseStage; 
  wire [5:0] incremented, nextNum;
  reg [5:0] curr;
  wire [6:0] tempNum;
  assign incremented = curr + 1'b1;
  assign skip = ((incremented[5] & stage[0]) | (incremented[4] & stage[1]) | (incremented[3] & stage[2]) 
    | (incremented[2] & stage[3]) | (incremented[1] & stage[4]) | (incremented[0] & stage[5]));
  assign reverseStage = {stage[0], stage[1], stage[2], stage[3], stage[4], stage[5]};
  assign tempNum = (skip) ? reverseStage + incremented : incremented;
  assign newStage = tempNum[6];
  assign nextNum = start ? 6'b0 : tempNum[5:0];  
  
  always_ff @(negedge clk or negedge rst) begin
    if (~rst) begin
      curr <= 6'b0;
    end else begin
      curr <= nextNum;
    end
  end

  assign out = curr;
endmodule
