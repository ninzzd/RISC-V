`timescale 1ns/1ps
module riscv_tb;
    // Testbench code for RISC-V processor would go here
    reg clk;
    reg rst;
    
    riscv uut (
        .clk(clk),
        .rst(rst)
    );
    initial 
    begin
        // Initialize signals, apply test vectors, monitor outputs
    end
endmodule
