`include "twiddle_factor_mux.sv"

module fft #(
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input [((16 * D_WIDTH) - 1) : 0] input_sig,
    input clk, rst,
    output [((16 * D_WIDTH) - 1) : 0] output_sig
);
    wire [((16 * D_WIDTH) - 1) : 0] seperated_sig;


    generate
    for (genvar i = 0; i < D_WIDTH; i++) begin 
        reg [LOG_2_WIDTH-1:0] ii;
        reg [LOG_2_WIDTH-1:0] x;

        initial begin
            x = i;
            ii = 0;
            for (int j = 0; j < LOG_2_WIDTH; j++) begin
                ii <<= 1;
                ii |= (x & 1);
                x >>= 1;
            end
        end

        DFF_16Bit dff_instance (
            .D(input_sig[(16*i + 15) -: 16]),
            .clk(clk),
            .rst(rst),
            .Q(seperated_sig[(16*i + 15) -: 16])
        );
    end
    assign output_sig = seperated_sig;
endgenerate

endmodule

module Butterfly#( 
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input [((16 * D_WIDTH) - 1) : 0] input_sig,
    input start, clk, rst,
    output [((16 * D_WIDTH) - 1) : 0] output_sig
);
  wire [((16 * D_WIDTH) - 1) : 0] reff_in, reff_out, imff_in, imff_out;
  wire [(D_WIDTH - 1) : 0] count, stage, twiddle_index;
  wire [8:0] re_twiddle, im_twiddle;

  StageClock StageCount(.start(start), .shift(~(|count)), .rst(rst), .out(stage));
  // Might need to delay start for these two
  CountTo64 Counter(.start(start), .clk(clk), .rst(rst), .out(count));
  TwiddleFactorIndex TwiddleIndex(.stage(stage), .start(start), .clk(clk), .rst(rst), .out(twiddle_index));

  generate
    for (genvar i = 0; i < D_WIDTH; i++) begin 
      DFF_16Bit dff_instance (
        .D(reff_in[(16*i + 15) -: 16]),
        .clk(clk & ((i == count) | start)), // Prolly need to do this in a better way
        .rst(rst),
        .Q(reff_out[(16*i + 15) -: 16])
      );

      DFF_16Bit dff_instance (
        .D(imff_in[(16*i + 15) -: 16]),
        .clk(clk & ((i == count) | start)), // Prolly need to do this in a better way
        .rst(rst),
        .Q(imff_out[(16*i + 15) -: 16])
      );
    end
  endgenerate
  //Get twiddle factor
  ReTwiddleMux ReTwiddleMux(.select(twiddle_index), .out(re_twiddle));
  ImTwiddleMux ImTwiddleMux(.select(twiddle_index), .out(im_twiddle));
  
  //

// Apply_Twiddle UpdateRe(.upper_sig(), .lower_sigRe(), .lower_sigIm(), 
//     .twiddle_factorRe(), .twiddle_factorIm(), .re_out(), .out());

  assign output_sig = ff_out;

endmodule

module Apply_Twiddle( 
    parameter D_WIDTH = 64,
    parameter LOG_2_WIDTH = 6
) (
    input [(D_WIDTH - 1) : 0] upper_sig, lower_sigRe, lower_sigIm,
    input [9:0] twiddle_factorRe, twiddle_factorIm,
    input re_out,
    output [((16 * D_WIDTH) - 1) : 0] out
);
  wire [24:0] multi_inRe, multi_inIm, multi_outRe, multi_outIm, after_twiddle;
  
  assign multi_inRe = re_out ? lower_sigRe : lower_sigIm;
  assign multi_inIm = re_out ? lower_sigIm : lower_sigRe;

  assign multi_outRe = multi_inRe * lower_sigRe; 
  assign multi_outIM = multi_inIm * lower_sigIm; 
  
  // This should really just be an adder where u invert the input and change carryout to 1
  assign after_twiddle = re_out ? (multi_outRe - multi_outIM) : (multi_outRe + multi_outIM); 
  assign out = after_twiddle + upper_sig; 
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

module DFF_16Bit (
  input wire [15:0] D, 
  input wire clk, rst,
  output wire [15:0] Q
);
  logic [15:0] data;
  
  always_ff @(negedge clk or negedge rst) begin
    if (~rst) begin
      data <= 16'b0;
      // Qn <= 16'b1111111111111111;
    end else begin
      data <= D;
    end
  end

  assign Q = data;
endmodule

module DFF_16Bit (
  input wire [15:0] D, 
  input wire clk, rst,
  output wire [15:0] Q
);
  logic [15:0] data;
  
  always_ff @(negedge clk or negedge rst) begin
    if (~rst) begin
      data <= 16'b0;
      // Qn <= 16'b1111111111111111;
    end else begin
      data <= D;
    end
  end

  assign Q = data;
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