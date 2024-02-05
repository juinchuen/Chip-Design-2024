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
    for (genvar i = 0; i < D_WIDTH; i++) begin : gen_dff_instances
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