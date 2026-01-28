/*
    Author: Rohan Singh
    Description: Boiler-plate for the control_unit module
*/
module controller #(
    parameter pcmux_N = 2,
    parameter ifuresctl_N = 2
)(
    input clk,
    input [6:0] opcode,
    input [2:0] func3,
    input [1:0] func7b50, // For ALU R-type, func7 = 0x00 (b5 is 0) or 0x20 (b5 is 1) 
    input exdone, // valid signal from EX stage
                        // For M extension R-type, func7 = 0x01 (b0 is 1) 
    output reg [$clog2(pcmux_N)-1:0] pcmuxctl, // select/control signal for pcmux
    output reg pcnextctl, // control signal for updating pc
    output reg instrre, // instruction read enable
    output reg regwe, // register write-enable
    output reg regre, // register read-enable
    output reg bmuxctl,
    output [3:0] aluctl, // control signal for ALU
    output mulstart, // enable signal for MU
    output [1:0] mulctl, // control signal for MU 
    output [$clog2(ifuresctl_N)-1:0] ifuresctl // control signal for ifuresmux
);  
    reg [2:0] state;
    reg id_counter;
    initial begin
        state <= 3'b000;
        id_counter <= 1'b0;
    end

    ex_controller #(
            .ifuresctl_N(ifuresctl_N)
    ) exc (
            .opcode(opcode),
            .func3(func3),
            .func7b50(func7b50),
            .aluctl(aluctl),
            .mulctl(mulctl),
            .ifuresctl(ifuresctl),
            .mulstart(mulstart)
    ); // control signals for the EX stage are ready in the first clock cycle itself

    always @(posedge clk) // Main controller FSM 
    begin
        case(state)
            3'b000: // IF
            begin
                regwe <= 1'b0;
                instrre <= 1'b1;
                state <= 3'b001;
            end
            3'b001: // ID
            begin
                regre <= 1'b1;
                if(id_counter == 1'b1)begin
                    regre <= 1'b0;
                    casez(opcode)
                        7'b0z10011: // Issue with casez
                        begin
                            bmuxctl <= opcode[5];
                            // $write("test\n");
                        end
                        default:
                            bmuxctl <= 1'b1; // default to breg
                    endcase
                    state <= 3'b010; // should be made such that it stalls when the instruction is not valid (garbage)
                    pcnextctl <= 1'b1; // Need to find an optimal location for updating pc 
                    pcmuxctl <= 0;
                end
                id_counter <= ~id_counter;
            end
            3'b010: // EX
            begin
                pcnextctl <= 1'b0;
                instrre <= 1'b0;
                regre <= 1'b0;
                if(exdone)
                begin
                    state <= 3'b011;
                end
            end
            3'b011: // WB
            begin
                regwe <= 1'b1;
                state <= 3'b000;
            end
        endcase
    end  
endmodule
