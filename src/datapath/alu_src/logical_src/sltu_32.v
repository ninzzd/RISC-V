module sltu_32 #(parameter T = 0.000)(
    input  [31:0] x1,
    input  [31:0] x2,
    output [31:0] out
);
wire c_out;
add32 #(T) u_add32 (
    .a(x1),
    .b(~x2),
    .c_1(1'b1),
    .s(),
    .c31(c_out)
);
assign out = c_out?32'b0:32'b1;
endmodule