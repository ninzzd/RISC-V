// Author: Ninaad Desai
// Description: Describes the part of the controller that handles the execution (EX) stage control signals combinatorially
module ex_controller #(
    parameter ifuresctl_N = 2
)(
    input [6:0] opcode,
    input [2:0] func3,
    input [1:0] func7b50,
    // input alu_done, // Not required, ALU is combinatorial and not internally pipelined
    output reg [3:0] aluctl,
    output reg [1:0] mulctl,
    output reg mulstart,
    output reg [$clog2(ifuresctl_N)-1:0] ifuresctl // control signal for ifuresmux
);

    wire [3:0] aluop;
    wire [1:0] mulop;


    always @(*) // Deciding ctl sig for alu
    begin
        casez(opcode) // RV32IM
            7'b0?10011: // R- and I-Type ALU operations
            begin
                case(func3)
                    3'b000: aluctl <= {3'b000,func7b50[1]};// add, sub
                    3'b001: aluctl <= 4'b0101; // sll 
                    3'b010: aluctl <= 4'b1000; // slt
                    3'b011: aluctl <= 4'b1001; // sltu
                    3'b100: aluctl <= 4'b0010; // xor
                    3'b101: aluctl <= {3'b011,func7b50[1]}; // srl, sra
                    3'b110: aluctl <= 4'b0011; // or
                    3'b111: aluctl <= 4'b0100; // and
                    default: aluctl <= 4'b0100; // and (reason: shorter critical path)
                endcase
            end
        endcase
    end

    always @(*) // Deciding ctl sig for mu/qru
    begin
        case(opcode) // RV32IM
            7'b0110011: // R-Type
            begin
                mulstart <= ~func7b50[1]&func7b50[0]&~func3[2]; // start MU when func7 = 0x01
                case(func3)
                    3'b000: mulctl <= 2'b00; // mul
                    3'b001: mulctl <= 2'b01; // mulh
                    3'b010: mulctl <= 2'b10; // mulsu
                    3'b011: mulctl <= 2'b11; // mulhu
                    // 3'b100: divctl <= 2'b00; // div
                    // 3'b101: divctl <= 2'b01; // divu
                    // 3'b110: divctl <= 2'b10; // rem
                    // 3'b111: divctl <= 2'b11; // remu
                    default: 
                    begin
                        // mulctl <= 2'b00; // mul (reason: shorter critical path)
                        // divctl <= 2'b00; // div (reason: shorter critical path)
                    end
                endcase
            end
        endcase
    end

    always @(*) // Deciding ifuresctl
    begin
        casez(opcode) // RV32IM
            7'b0?10011: // R- and I-Type 
            begin
                case(func7b50) // Be careful about this for I-type
                    2'b00: ifuresctl <= 0; // ALU output
                    2'b01: ifuresctl <= 1; // MU output
                    default: ifuresctl <= 0; // ALU output
                endcase
                // ifuresctl <= ~func7b50[1]&func7b50[0]; // ALU output
            end
            default: ifuresctl <= 0; // ALU output
        endcase
    end
endmodule