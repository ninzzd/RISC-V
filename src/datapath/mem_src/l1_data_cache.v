 /*
    Author: Ninaad Desai
    Description: Simple, behavioral implementation of the L1 Data Cache (inferred BRAM). Single read and write lines with common address decoder
 */
module #(parameter N = 1024) l1_data_cache(
    input clk,          // Clock
    input [31:0] a,     // Address
    input [31:0] wd,    // Write-data
    input we,           // Write-enable

    output [31:0] rd    // Read-data
);
    reg [31:0] mem [0:N-1]; // Memory block (Cache)
    always @(posedge clk)
    begin
        if(we)
            rd <= mem[a];
        else
            mem[a] <= wd;
    end
endmodule 