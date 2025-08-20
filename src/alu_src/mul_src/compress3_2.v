`timescale 1 ns / 1 ps
module compress3_2( //Average propagation delay:0.3 ns
    input [2:0] in,
    output [1:0] out
);
    assign #0.300 out[1] = in[0]&in[1] | in[1]&in[2] | in[0]&in[2];
    assign #0.150 out[0] = in[0] ^ in[1] ^ in[2];
endmodule