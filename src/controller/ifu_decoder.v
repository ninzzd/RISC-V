module ifu_decoder #(
    parameter ifuresctl_N = 2;
)(
    input [6:0] opcode,
    input [2:0] func3,
    input [1:0] func7b50,
    output reg [3:0] aluctl,
    output reg [1:0] mulctl,
    output reg [$clog2(ifuresctl_N)-1:0] ifuresctl // control signal for ifuresmux
);
    always @(*)
    begin
        case(opcode):
            7'b0110011: // R-Type (RV32IM)
            begin
                case(funct3)
                    3'b000:
                    begin
                        if(func7b50 == 2'b10) // sub
                        ;
                        else if(func7b50 == 2'b00)    // add
                        ;
                        else if(func7b50 == 2'b01) // mul
                        ;
                    end
                    3'b001:
                        if(func7b50[0]) // mulh
                        ;
                        else // sll
                        ;
                    3'b010:
                        if(func7b50[0]) // mulhsu
                        ;
                        else // slt
                        ;
                    3'b011:
                        if(func7b50[0]) // mulhu
                        ;
                        else // sltu
                        ;
                    3'b100:
                        if(func7b50[0]) // div
                        ;
                        else // xor
                        ;
                    3'b101:
                        if(func7b50 == 2'b10) // sra
                        ;
                        else if(func7b50 == 2'b00)    // srl
                        ;
                        else if(func7b50 == 2'b01) // divu
                        ;
                    3'b110:
                        if(func7b50[0]) // rem
                        ;
                        else // or
                        ;
                    3'b111:
                        if(func7b50[0]) // remu
                        ;
                        else // and
                        ;
                endcase
            end
        endcase
    end
endmodule