module alu_example (

    input logic [7:0] opA,
    input logic [7:0] opB,

    input logic [7:0] opSel,

    output logic [7:0] out

);

    assign out =    opSel == 8'h0 ? opA + opB :
                    opSel == 8'h1 ? opA - opB :
                    opSel == 8'h2 ? opA * opB :
                    opSel == 8'h3 ? opA & opB :
                    opSel == 8'h4 ? (opA | opB) + 1:
                    opSel == 8'h5 ? opA ^ opB :
                    opSel == 8'h6 ? ~opA      :
                    8'h0;

endmodule