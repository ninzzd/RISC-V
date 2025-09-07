`timescale 1 ns / 1 ps
module fa #(parameter T = 0.300)(
    input [2:0] i,
    output [1:0] o
);
    assign #(T) o[0] = i[0] ^ i[1] ^ i[2];
    assign #(T) o[1] = i[0]&i[1] | i[1]&i[2] | i[0]&i[2];
endmodule