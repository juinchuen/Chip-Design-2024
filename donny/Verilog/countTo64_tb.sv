module countTo64_tb;

// declare stimuli
logic [5:0] stage;
logic start, clk, rst;
wire new_stage;
wire [5:0] count;

// clock gen
always begin
    #5 clk = ~clk;
end

// instantiate uut
CountTo64 Counter(.start(start), .stage(stage), .clk(clk), .rst(rst), .new_stage(new_stage), .out(count));

initial begin
    stage = 6'b001000;
    clk = 1'b0;
    start = 1'b1;
    rst = 1'b0;
    #10;
    rst = 1'b1;
    start = 1'b0;
    
    #1000 $finish;
end

endmodule