module CountTo64_Tb;

logic [5:0] stage;
logic start, clk, rst;
wire new_stage;
wire [5:0] count;
CountTo64 Counter(.start(start), .stage(stage), .clk(clk), .rst(rst), .new_stage(new_stage), .out(count));

    initial begin
        clk = 1'b0;
        start = 1'b1;
        rst = 1'b1;
        #2;
        rst = 1'b0;
        start = 1'b0;
        
    $finish();
    end

    always begin
        #5 clk = ~clk;
    end

endmodule