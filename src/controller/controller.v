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

    output [$clog2(pcmux_N)-1:0] pcctl, // select/control signal for pcmux
    output regwe, // register write-enable
    output [3:0] aluctl, // control signal for ALU
    output [1:0] mulctl, // control signal for MU 
    output [$clog2(ifuresctl_N)-1:0] ifuresctl // control signal for ifuresmux
);  
    
endmodule