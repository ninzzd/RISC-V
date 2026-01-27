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
    integer i;
    integer j;
    
    always #5 clk = ~clk; // 10ns clock period

    riscv uut (
        .clk(clk)
    );

    initial begin
        $dumpfile("riscv_tb.vcd");
        $dumpvars(0, riscv_tb);
        for (i = 0; i < 32; i = i + 1) begin // dump all registers
            $dumpvars(0, uut.dp.rfi.x[i]);
        end
        for (j = 0; j < 10; j = j + 1) begin // dump instruction memory (will need only the first one for this test)
            $dumpvars(0, uut.dp.imem.instr[j]);
        end
        clk = 0;
        // Additional testbench initialization and stimulus can be added here
        #1000; // Run simulation for 1000ns
        $finish;
    end
endmodule
