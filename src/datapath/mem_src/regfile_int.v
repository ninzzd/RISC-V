 /*
    Author: Ninaad Desai
    Description: Simple, behavioral implementation of the register file (inferred BRAM). Two read lines, one write line
 */
module regfile_int(
    input clk,
    input [31:0] ra1,       // Read-address 1
    input [31:0] ra2,       // Read-address 2
    input [31:0] wa1,       // Write-address 1
    input [31:0] dw1,       // Data-write 1
    input we,               // Write-enable
    input [31:0] pcnext,    // Program-counter next

    output reg [31:0] dr1,  // Data-read 1
    output reg [31:0] dr2,  // Data-read 2
    output reg [31:0] pc    // Program-counter
);
    reg [31:0] x[0:31];     // 32-bit registers (x32)

    // Write
    always @(posedge clk)
    begin
        if(we)
        begin
            x[wa1] <= dw1;
        end
        pc <= pcnext;
    end
    // Read
    always @(posedge clk)
    begin
        if(~we || (wa1 != ra1 && wa1 != ra2)) // To prevent race conditions when trying to write to and read from the same address
        begin
            // Separate address decoders for dr1 and dr2
            dr1 <= x[ra1]; 
            dr2 <= x[ra2];
        end
    end
endmodule