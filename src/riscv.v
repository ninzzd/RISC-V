module riscv #(parameter T = 0.000)(
    input wire clk,
    input wire rst
);
    wire exdone;
    wire [31:0] instr;
    wire instrre;
    wire pcnextctl;
    wire [$clog2(2)-1:0] pcmuxctl;
    wire regwe;
    wire [3:0] aluctl;
    wire [1:0] mulctl;
    wire [$clog2(2)-1:0] ifuresctl;

    datapath dp (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .instrre(instrre),
        .pcnextctl(pcnextctl),
        .pcmuxctl(pcmuxctl),
        .regwe(regwe),
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
