/*
    To Run:
        iverilog -o riscv_tb.vvp \
        tb/riscv_tb.v \
        src/riscv.v \
        src/controller/*.v \
        src/datapath/util_src/*.v \
        src/datapath/mem_src/*.v \
        src/datapath/ifu_src/add_src/*.v \
        src/datapath/ifu_src/logical_src/*.v \
        src/datapath/ifu_src/div_src/src/*.v \
        src/datapath/ifu_src/mul_src/src/fa.v src/datapath/ifu_src/mul_src/src/ha.v src/datapath/ifu_src/mul_src/src/mul32p.v \
        src/datapath/ifu_src/mu.v \
        src/datapath/ifu_src/alu.v \
        src/datapath/datapath.v
*/
`timescale 1ns/1ps
module riscv_tb;
    // Testbench code for RISC-V processor would go here
    reg clk;
    
    always #5 clk = ~clk; // 10ns clock period

    riscv uut (
        .clk(clk)
    );

    initial begin
        $dumpfile("riscv_tb.vcd");
        $dumpvars(0, riscv_tb);
        $dumpvars(0, uut.dp.imem.instr);
        $dumpvars(0, uut.dp.rfi.x);
        clk = 0;
        // Additional testbench initialization and stimulus can be added here
        #1000; // Run simulation for 1000ns
        $finish;
    end
endmodule
