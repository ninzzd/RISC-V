`timescale 1 ns/ 1 ps
// Author: Ninaad Desai
// Descriptions: 8-bit CLA Adder
module add8( 
    input[7:0] a,
    input[7:0] b,
    input c_1,
    output[7:0] s,
    output c7
);
    wire [7:0] c;
    wire [7:0] g;
    wire [7:0] p;
    // Assumption: Xilinx FPGAs have an LUT delay of 150 ps. An AND-OR stage is assumed to comprise 2 cascaded LUTs.

    // Pre-calculation of G and P signals (Stage 1)
    assign #0.150 g = a & b;
    assign #0.150 p = a | b;

    // Parallel carry calculations (Stage 2)
    assign #0.300 c[0] = g[0] | p[0]&c_1;
    assign #0.300 c[1] = g[1] | p[1]&g[0] | p[1]&p[0]&c_1;
    assign #0.300 c[2] = g[2] | p[2]&g[1] | p[2]&p[1]&g[0] | p[2]&p[1]&p[0]&c_1;
    assign #0.300 c[3] = g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0] | p[3]&p[2]&p[1]&p[0]&c_1;
    assign #0.300 c[4] = g[4] | p[4]&g[3] | p[4]&p[3]&g[2] | p[4]&p[3]&p[2]&g[1] | p[4]&p[3]&p[2]&p[1]&g[0] | p[4]&p[3]&p[2]&p[1]&p[0]&c_1;
    assign #0.300 c[5] = g[5] | p[5]&g[4] | p[5]&p[4]&g[3] | p[5]&p[4]&p[3]&g[2] | p[5]&p[4]&p[3]&p[2]&g[1] | p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&c_1;
    assign #0.300 c[6] = g[6] | p[6]&g[5] | p[6]&p[5]&g[4] | p[6]&p[5]&p[4]&g[3] | p[6]&p[5]&p[4]&p[3]&g[2] | p[6]&p[5]&p[4]&p[3]&p[2]&g[1] | p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&c_1; // Multi-input AND gates -> m n-to-1 LUTs (m are in parallel), multi-input OR gates -> 1 m-to-1 LUT (Double LUT Stage)
    assign #0.300 c[7] = g[7] | p[7]&g[6] | p[7]&p[6]&g[5] | p[7]&p[6]&p[5]&g[4] | p[7]&p[6]&p[5]&p[4]&g[3] | p[7]&p[6]&p[5]&p[4]&p[3]&g[2] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&g[1] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&c_1;
    assign c7 = c[7];

    // Sum generation (Stage 3)
    assign #0.150 s[0] = a[0] ^ b[0] ^ c_1; // 3-to-1 LUT (Single LUT Stage)
    assign #0.150 s[7:1] = a[7:1] ^ b[7:1] ^ c[6:0]; // 7 3-to-1 LUTs (Single LUT Stage)
endmodule