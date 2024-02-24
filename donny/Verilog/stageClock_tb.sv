module stageClock_tb;

// declare stimuli
reg start, shift, rst, clk;
wire [5:0] out;
wire debugIn;

// instantiate uut
StageClock uut(
  .start(start),
  .shift(shift),
  .clk(clk),
  .rst(rst),
  .out(out),
  .debugIn(debugIn)
);

// clock gen
always begin
  #5
  clk = ~clk;
end

// begin simulation
initial begin
  // begin monitoring
  $monitor("start = %b, shift = %b, rst = %b, out = %b, clk = %b", start, shift, rst, out, clk);

  // set stimuli
  rst = 1;
  #5
  rst = 0;

  clk = 0;
  start = 1;
  shift = 1;

  // end simulation
  #1000 $finish;
end
endmodule