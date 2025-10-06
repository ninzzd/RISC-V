module l1_instr_cache #(parameter size = 8192, parameter Clen = $clog2(size))(
    input [31:0] addr,
    output [31:0] instr;
);
endmodule