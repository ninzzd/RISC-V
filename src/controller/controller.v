 /*
    Author: Rohan Singh
    Description: Boiler-plate for the control_unit module
 */
module controller #(
    parameter pcmux_N = 2;
    parameter ifuresctl_N = 2;
)(
    input clk,
    input [6:0] opcode,
    input [2:0] func3,
    input func7b5, // For R-type, func7 = 0x00 (b5 is 0) or 0x20 (b5 is 1) 

    output reg [$clog2(pcmux_N)-1:0] pcmuxctl, // select/control signal for pcmux
    output reg pcnextctl, // control signal for updating pc
    output reg instrre, // instruction read enable
    output reg regwe, // register write-enable
    output reg [3:0] aluctl, // control signal for ALU
    output reg [1:0] mulctl, // control signal for MU 
    output reg [$clog2(ifuresctl_N)-1:0] ifuresctl // control signal for ifuresmux
);  
   reg [2:0] state;
   initial begin
    state <= 3'b000;
   end
   always @(posedge clk) // Main controller FSM 
   begin
    case(state):
        3'b000: // IF
        begin
            instrre <= 1'b1;
        end
        3'b001: // ID
        begin
            regre <= 1'b1;
        end
        3'b010: // EX
        begin

        end
        3'b011: // WB
        begin
            regwe <= 1'b1;
        end
    endcase
   end  
endmodule
