`timescale 1 ns/1 ps
module ha #(parameter T = 0.300)(
    input [1:0] i,
    output[1:0] o
);
    assign #(T) o[0] = i[0] ^ i[1];
    assign #(T) o[1] = i[0] & i[1];
endmodule 