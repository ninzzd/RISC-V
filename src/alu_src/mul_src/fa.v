module fa(
    input [2:0] i,
    output [1:0] o
);
    assign o[0] = i[0] ^ i[1] ^ i[2];
    assign o[1] = i[0]&i[1] | i[1]&i[2] | i[0]&i[2];
endmodule