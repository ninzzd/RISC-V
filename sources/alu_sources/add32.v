// Author: Ninaad Desai
// Description: Group Carry Adder with four 8-bit CLAs
module add32(
    input[31:0] a,
    input[31:0] b,
    input c_1,
    output[31:0] s,
    output c31
);
    wire c7,c15,c23;
    add8 a7_0( .a(a[7:0]) , .b(b[7:0]) , .s(s[7:0]) , .c_1(c_1) , .c7(c7));
    add8 a15_8( .a(a[15:8]) , .b(b[15:8]) , .s(s[15:8]) , .c_1(c7) , .c7(c15));
    add8 a23_16( .a(a[23:16]) , .b(b[23:16]) , .s(s[23:16]) , .c_1(c15) , .c7(c23));
    add8 a31_24( .a(a[31:24]) , .b(b[31:24]) , .s(s[31:24]) , .c_1(c23) , .c7(31));
endmodule