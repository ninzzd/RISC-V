 /*
    Author: Ninaad Desai
    Description: Simple, behavioral implementation of the register file (inferred BRAM). Two read lines, one write line
 */
module regfile_int(
    input clk,
    input [31:0] ra1,       // Read-address 1
    input [31:0] ra2,       // Read-address 2
    input [31:0] wa1,       // Write-address 1
    input [31:0] wd1,       // Write-data 1
    input we,               // Write-enable (LOGIC HIGH)
    input [31:0] pcnext,    // Program-counter next

    output reg [31:0] rd1,  // Read-data 1
    output reg [31:0] rd2,  // Read-data 2
    output reg [31:0] pc    // Program-counter
);
    reg [31:0] x[0:31];     // 32-bit registers (x32)

    // Write
    always @(posedge clk)
    begin
        if(we)
        begin
            x[wa1] <= wd1;
        end
        pc <= pcnext;
    end
    // Read
    always @(posedge clk)
    begin
        if(~we || (wa1 != ra1 && wa1 != ra2)) // To prevent race conditions when trying to write to and read from the same address
        begin
            // Separate address decoders for dr1 and dr2
            rd1 <= x[ra1]; 
            rd2 <= x[ra2];
        end
    end
endmodule