module riscv #(parameter T = 0.000)(
    input clk
);
    wire exdone;
    wire instrre;
    wire mulstart;
    wire [6:0] opcode;
    wire [2:0] func3;
    wire [1:0] func7b50;
    wire pcnextctl;
    wire [$clog2(2)-1:0] pcmuxctl;
    wire regwe;
    wire regre;
    wire [3:0] aluctl;
    wire [1:0] mulctl;
    wire [$clog2(2)-1:0] ifuresctl;

    datapath dp (
        .clk(clk),
        .pcmuxctl(pcmuxctl),
        .pcnextctl(pcnextctl),
        .instrre(instrre),
        .regwe(regwe),
        .regre(regre),
        .aluctl(aluctl),
        .mulstart(mulstart),
        .mulctl(mulctl),
        .ifuresctl(ifuresctl),
        .opcode(opcode),
        .func3(func3),
        .func7b50(func7b50),
        .exdone(exdone)
    );

    controller ctrl (
        .clk(clk),
        .opcode(opcode),
        .func3(func3),
        .func7b50(func7b50),
        .exdone(exdone),
        .pcmuxctl(pcmuxctl),
        .pcnextctl(pcnextctl),
        .instrre(instrre),
        .regwe(regwe),
        .regre(regre),
        .aluctl(aluctl),
        .mulstart(mulstart),
        .mulctl(mulctl),
        .ifuresctl(ifuresctl)
    );
    
endmodule
