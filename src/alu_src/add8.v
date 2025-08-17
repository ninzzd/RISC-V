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
    assign g = a & b;
    assign p = a | b;
    assign c[0] = g[0] | p[0]&c_1;
    assign c[1] = g[1] | p[1]&g[0] | p[1]&p[0]&c_1;
    assign c[2] = g[2] | p[2]&g[1] | p[2]&p[1]&g[0] | p[2]&p[1]&p[0]&c_1;
    assign c[3] = g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0] | p[3]&p[2]&p[1]&p[0]&c_1;
    assign c[4] = g[4] | p[4]&g[3] | p[4]&p[3]&g[2] | p[4]&p[3]&p[2]&g[1] | p[4]&p[3]&p[2]&p[1]&g[0] | p[4]&p[3]&p[2]&p[1]&p[0]&c_1;
    assign c[5] = g[5] | p[5]&g[4] | p[5]&p[4]&g[3] | p[5]&p[4]&p[3]&g[2] | p[5]&p[4]&p[3]&p[2]&g[1] | p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&c_1;
    assign c[6] = g[6] | p[6]&g[5] | p[6]&p[5]&g[4] | p[6]&p[5]&p[4]&g[3] | p[6]&p[5]&p[4]&p[3]&g[2] | p[6]&p[5]&p[4]&p[3]&p[2]&g[1] | p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&c_1;
    assign c[7] = g[7] | p[7]&g[6] | p[7]&p[6]&g[5] | p[7]&p[6]&p[5]&g[4] | p[7]&p[6]&p[5]&p[4]&g[3] | p[7]&p[6]&p[5]&p[4]&p[3]&g[2] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&g[1] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&c_1;
    assign c7 = c[7];
    assign s[0] = a[0] ^ b[0] ^ c_1;
    assign s[7:1] = a[7:1] ^ b[7:1] ^ c[6:0];
endmodule