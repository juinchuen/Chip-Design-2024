module tester (
    input logic [2:0]       index,
    output logic [37:0]     data
);

    // map test bench to index
    // valid_true [36:21]decoded_true [20:0]encoded
    assign data = index == 0 ? 37'h2001400052 :
                    index == 1 ? 37'h2948092400 :
                    index == 2 ? 37'h2948092480 :
                    index == 3 ? 37'h2948092440 :
                    index == 4 ? 37'h2948012400 :
                    index == 5 ? 37'h35c235E18C :
                    index == 6 ? 37'h35c235E10C :
                    37'h0;

endmodule

// valid_true - 1
// decoded - 16
// encoded - 21

// index 0: b'1 10 82
// index 1: b'1 19008 599040
// index 2: b'1 19008 599168
// index 3: b'1 19008 599104
// index 4: b'1 19008 74752
// index 5: b'1 44561 1433996
// index 6: b'1 44561 1433868
