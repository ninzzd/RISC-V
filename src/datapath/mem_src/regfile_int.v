 /*
    Author: Ninaad Desai
    Description: Simple, behavioral implementation of the register file (inferred BRAM). Two read lines, one write line
    TODO: Structural implementation
 */
module regfile_int(
    input clk,
    input [4:0] ra1,       // Read-address 1
    input [4:0] ra2,       // Read-address 2
    input [4:0] wa1,       // Write-address 1
    input [31:0] wd1,       // Write-data 1
    input we,               // Write-enable (LOGIC HIGH)
    input re,               // Read-enable (LOGIC HIGH)

    output reg [31:0] rd1,  // Read-data 1
    output reg [31:0] rd2   // Read-data 2
);
    reg [31:0] x[0:31];     // 32-bit registers (x32)
    initial
    begin
        x[0] <= 32'd0;  // x0 is zero

        // For testing purposes
        x[1] <= 32'd2;
        x[2] <= 32'd3;
    end
    // Write
    always @(posedge clk)
    begin
        if(we && wa1 != 5'd0) // x0 must not be updated
        begin
            x[wa1] <= wd1;
        end
        // pc <= pcnext;
    end
    // Read
    always @(posedge clk)
    begin
        if(re && (~we || (wa1 != ra1 && wa1 != ra2))) // To prevent race conditions when trying to write to and read from the same address
        begin
            // Separate address decoders for dr1 and dr2
            rd1 <= x[ra1]; 
            rd2 <= x[ra2];
        end
    end
endmodule