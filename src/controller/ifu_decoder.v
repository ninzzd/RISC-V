module ifu_decoder #(
    parameter ifuresctl_N = 2;
)(
    input [6:0] opcode,
    input [2:0] func3,
    input func7b5,
    output reg [3:0] aluctl,
    output reg [1:0] mulctl,
    output reg [$clog2(ifuresctl_N)-1:0] ifuresctl // control signal for ifuresmux
);
    always @(*)
    begin
        case(opcode):
            7'b0110011: // ALU R-Type
            begin
                case(funct3)
                    3'b000: // add and sub
                    begin
                        if(func7b5) // sub
                        ;
                        else    // add
                        ;
                    end
                    3'b001: // sll

                    3'b010: // slt
                    3'b011: // sltu
                    3'b100: // xor
                    3'b101: // srl and sra
                        if(func7b5) // sra
                        ;
                        else    // srl
                        ;
                    3'b110: // or
                    3'b111: // and
                endcase
            end
        endcase
    end
endmodule