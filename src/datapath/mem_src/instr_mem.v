 /*
    Author: Ninaad Desai
    Description: Simple, behavioral implementation of the L1 Instruction ROM (direct LUT)
 */
module instr_mem #(parameter N = 1024)(
    input re, //  Read enable
    input clk,
    input [$clog2(N)-1:0] a,
    output [31:0] rd
);
    reg [31:0] instr [0:N-1];
    always @(posedge clk)
    begin
        if (re)
            rd <= instr[a];
    end
endmodule