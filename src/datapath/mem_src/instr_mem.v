 /*
    Author: Ninaad Desai
    Description: Simple, behavioral implementation of the L1 Instruction ROM (direct LUT)
 */
module instr_mem #(parameter N = 1024)(
    input re, //  Read enable
    input clk,
    input [31:0] a,
    output reg [31:0] rd
);
    reg [31:0] instr [0:N-1];
    
    // Initial memory loading (for simulation purposes)
    initial
    begin
        $readmemh("asm-test/ex1.hex", instr);
    end

    always @(posedge clk)
    begin
        if (re)
            rd <= instr[a[$clog2(N)-1:0]];
    end
endmodule