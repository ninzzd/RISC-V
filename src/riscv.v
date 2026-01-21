module riscv #(parameter T = 0.000)(
    input clk
);
    wire exdone;
    wire instrre;
    wire pcnextctl;
    wire [$clog2(2)-1:0] pcmuxctl;
    wire regwe;
    wire regre;
    wire [3:0] aluctl;
    wire [1:0] mulctl;
    wire [$clog2(2)-1:0] ifuresctl;

    datapath dp (
        .clk(clk),
        .instr(instr),
        .instrre(instrre),
        .pcnextctl(pcnextctl),
        .pcmuxctl(pcmuxctl),
        .regwe(regwe),
        .regre(regre),
        .aluctl(aluctl),
        .mulctl(mulctl),
        .ifuresctl(ifuresctl),
        .exdone(exdone)
    );

    controller ctrl (
        .clk(clk),
        .opcode(instr[6:0]),
        .func3(instr[14:12]),
        .func7b50({instr[30],instr[25]}),
        .exdone(exdone),
        .pcmuxctl(pcmuxctl),
        .pcnextctl(pcnextctl),
        .instrre(instrre),
        .regwe(regwe),
        .aluctl(aluctl),
        .mulctl(mulctl),
        .ifuresctl(ifuresctl)
    );
    
endmodule
