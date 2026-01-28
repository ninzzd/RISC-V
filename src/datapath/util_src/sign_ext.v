module sign_ext(
    input [11:0] in,
    output [31:0] out
);
    assign out = {{20{in[11]}},in[11:0]};
endmodule