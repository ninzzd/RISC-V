// Author: Ninaad Desai
// Description: Describese the part of the controller that handles the execution (EX) stage control signals combinatorially
module ex_controller #(
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
        case(opcode): // RV32IM
            7'b0110011: // R-Type
            begin
                case(funct3)
                    3'b000:
                    begin
                        if(func7b50 == 2'b10) // sub
                        begin
                            aluctl <= 4'b0001;
                            ifuresctl <= 1'b0;
                        end
                        else if(func7b50 == 2'b00) // add
                        begin
                            aluctl <= 4'b0000;
                            ifuresctl <= 1'b0;
                        end   
                        else if(func7b50 == 2'b01) // mul
                        begin
                            mulctl <= 2'b00;
                            ifuresctl <= 1'b1;
                        end
                    end
                    3'b001:
                        if(func7b50[0]) // mulh
                        begin
                            mulctl <= 2'b01;
                            ifuresctl <= 1'b1;
                        end
                        else // sll
                        begin
                            aluctl <= 4'b0101;
                            ifuresctl <= 1'b0;
                        end
                    3'b010:
                        if(func7b50[0]) // mulhsu
                        begin
                            mulctl <= 2'b10;
                            ifuresctl <= 1'b1;
                        end
                        else // slt
                        begin
                            aluctl <= 4'b1000;
                            ifuresctl <= 1'b0;
                        end
                    3'b011:
                        if(func7b50[0]) // mulhu
                        begin
                            mulctl <= 2'b11;
                            ifuresctl <= 1'b1;
                        end
                        else // sltu
                        begin
                            aluctl <= 4'b1001;
                            ifuresctl <= 1'b0;
                        end
                    3'b100:
                        if(func7b50[0]) // div
                        ; // to be implemented
                        else // xor
                        begin
                            aluctl <= 4'b0010;
                            ifuresctl <= 1'b0;
                        end
                    3'b101:
                        if(func7b50 == 2'b10) // sra
                        begin
                            aluctl <= 4'b0111;
                            ifuresctl <= 1'b0;
                        end
                        else if(func7b50 == 2'b00)    // srl
                        begin
                            aluctl <= 4'b0110;
                            ifuresctl <= 1'b0;
                        end
                        else if(func7b50 == 2'b01) // divu
                        ; // to be implemented
                    3'b110:
                        if(func7b50[0]) // rem
                        ; // to be implemented
                        else // or
                        begin
                            aluctl <= 4'b0011;
                            ifuresctl <= 1'b0;
                        end
                    3'b111:
                        if(func7b50[0]) // remu
                        ; // to be implemented
                        else // and
                        begin
                            aluctl <= 4'b0100;
                            ifuresctl <= 1'b0;
                        end
                endcase
            end
        endcase
    end
endmodule