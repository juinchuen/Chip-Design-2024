module stageClock_tb;

// declare stimuli
reg start, shift, rst, clk;
wire [5:0] out;

// instantiate uut
StageClock uut(
  .start(start),
  .shift(shift),
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
  // begin monitoring
  //$monitor("start = %b, shift = %b, rst = %b, out = %b, clk = %b", start, shift, rst, out, clk);

  // set stimuli
  rst = 0;
  #5
  rst = 1;

  clk = 0;
  start = 1;
  shift = 1;

  // end simulation
  #1000 $finish;
end
endmodule