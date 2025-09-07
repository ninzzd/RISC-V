 /*
    Author: Ninaad Desai
    Description: Simple, behavioral implementation of the register file (inferred BRAM)
 */
module regfile_int(
    input clk,
    input wr_en,
    input rd_en,
    input [4:0] wr_addr, // 1 write line
    input [31:0] wr_data,

    input [4:0] rs1_addr, // 2 read lines
    output reg [31:0] rs1_data,

    input [4:0] rs2_addr,
    output reg [31:0] rs2_data
);
    reg [31:0] x[0:31];
    always @(*)
    begin
        x[0] <= 32'h00000000;
    end
    always @(posedge clk)
    begin
        if(wr_en)
        begin
            x[wr_addr] <= wr_data;
        end
        if(rd_en)
        begin
            rs1_data <= x[rs1_addr];
            rs2_data <= x[rs2_addr];
        end
    end
endmodule