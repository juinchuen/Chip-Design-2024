module twiddleFactorIndex_tb;

// declare stimuli
reg [5:0] stage;
reg start, clk, rst;
wire [5:0] out;

// instantiate uut
TwiddleFactorIndex uut(
  .stage(stage),
  .start(start),
  .clk(clk),
  .rst(rst),
  .out(out)
);

// clock gen
always begin
  #5
  clk = ~clk;
end

// begin simulation
initial begin
  // initialize stimuli
  clk = 0;
  rst = 0;
  #5
  rst = 1;

  stage = 6'b001000;
  start = 1;
  #10
  start = 0;

  #1000 $finish;
end

endmodule