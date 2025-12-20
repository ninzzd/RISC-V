module slt_32 #(parameter T = 0.000)(
    input  [31:0] x1,
    input  [31:0] x2,
    output [31:0] out
);
wire c_out;
wire out_bit;
add32 #(T) comp_add32 (
    .a(x1),
    .b(~x2),
    .c_1(1'b1),
    .s(),
    .c31(c_out)
);
assign out_bit = (x1[31]==x2[31])?~c_out:x1[31];
assign out = out_bit?32'b1:32'b0;
endmodule