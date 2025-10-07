 /*
    Author: Rohan Singh
    Description: Boiler-plate for the control_unit module
 */
module control_unit(
    input [6:0] op,
    input [2:0] funct3,
    input funct7,
    output RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD,
    output [1:0] ImmSrcD, ResultSrcD,
    output [2:0] ALUControlD
);
    // reg [31:0] instr;

    // Saves the current instruction
    // always @(posedge clk)
    // begin
    //     if(instr_en)
    //     begin
    //         instr <= instr_data;
    //     end
    // end
    

endmodule