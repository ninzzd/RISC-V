 /*
    Author: Ninaad Desai
    Description: Boiler-plate for the instruction_decoder module
 */
module instruction_decoder(
    input clk,
    input [31:0] instr_data,
    input instr_en,
    output [3:0] alu_ctrl,
    output []
);
    reg [31:0] instr;

    // Saves the current instruction
    always @(posedge clk)
    begin
        if(instr_en)
        begin
            instr <= instr_data;
        end
    end
    

endmodule