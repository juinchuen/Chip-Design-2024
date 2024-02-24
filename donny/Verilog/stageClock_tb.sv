module stageClock_tb;

// declare stimuli
reg start, shift, rst;
wire [5:0] out;

// instantiate uut
StageClock uut(
  .start(start),
  .shift(shift),
  .rst(rst),
  .out(out)
);

// clock gen
always begin
  #5
  shift = ~shift;
end

// begin simulation
initial begin
  // begin monitoring
  $monitor("start = %b, shift = %b, rst = %b, out = %b", start, shift, rst, out);

  // set stimuli
  rst = 1;
  #5
  rst = 0;

  start = 1;
  shift = 0;

  // end simulation
  #1000 $finish;
end
endmodule