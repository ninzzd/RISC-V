 /*
    Author: Ninaad Desai
    Description: Simple, behavioral implementation of the L1 Data Cache (inferred BRAM). Single read and write lines with common address decoder
 */
module data_mem #(parameter N = 1024)(
    input clk,          // Clock
    input [$clog2(N)-1:0] a,     // Address
    input [31:0] wd,    // Write-data
    input we,           // Write-enable

    output reg [31:0] rd    // Read-data
);
    reg [31:0] mem [0:N-1]; // Memory block (Cache)
    always @(posedge clk)
    begin
        if(we)
            rd <= mem[a]; // For now, assume single cycle read
        else
            mem[a] <= wd;
    end
endmodule 