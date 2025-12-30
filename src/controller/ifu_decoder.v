module ifu_decoder #(
    parameter ifuresctl_N = 2;
)(
    input [6:0] opcode,
    input [2:0] func3,
    input func7b5,
    output [3:0] aluctl,
    output [1:0] mulctl,
    output [$clog2(ifuresctl_N)-1:0] ifuresctl // control signal for ifuresmux
);
endmodule