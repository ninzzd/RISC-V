 /*
    Author: Ninaad Desai
    Description: Simple, behavioral implementation of the L1 Instruction ROM (direct LUT)
 */
module instr_mem #(parameter N = 1024)( // N : Total number of instructions
    input re, //  Read enable
    input clk,
    input [31:0] a,
    output reg [31:0] rd
);
    reg [7:0] mem[0:4*N-1]; // Memory is always byte-addressable
    integer i;
    integer addr;
    integer word;
    integer file;
    integer r;
    // Initial memory loading (for simulation purposes)
    initial
    begin
        file = $fopen("asm-test/ex1.hex", "r"); // stores instructions in little endian format
        addr = 0;
        // $readmemh("asm-test/ex1.hex", instr); // Does not work for byte addressing, works for 32-bit addresses
        while (!$feof(file))
        begin
            r = $fscanf(file, "%h\n", word);
            if (r == 1) begin
                mem[addr + 3] <= $itor(word[31:24]); // little-endian to big-endian conversion
                mem[addr + 2] <= $itor(word[23:16]);
                mem[addr + 1] <= $itor(word[15:8]);
                mem[addr] <= $itor(word[7:0]);
            end
            addr = addr + 4;
        end
    end

    always @(posedge clk)
    begin
        if (re)
            rd <= {mem[a[$clog2(N)-1:0]], mem[a[$clog2(N)-1:0]+1], mem[a[$clog2(N)-1:0]+2], mem[a[$clog2(N)-1:0]+3]}; // Big-endian access (MSB at lowest address, goes to MSB of output word)
    end
endmodule