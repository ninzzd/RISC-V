 /*
    Author: Ninaad Desai
    Description: Simple, behavioral implementation of byte-addressable data memory, to be replaced with structural code later
 */
module data_mem #(parameter N = 1024) (
    input clk,          // Clock
    input [31:0] a,     // Address
    input [31:0] wd,    // Write-data
    input we,           // Write-enable
    input [2:0] ctl,      
    //  ctl = 000 => byte-unsigned
    //  ctl = 001 => half-unsigned
    //  ctl = 010 => word
    //  ctl = 100 => byte
    //  ctl = 101 => half
    
    output reg [31:0] rd    // Read-data
);
    parameter K = $clog2(N);
    reg [8:0] dmem [0:N-1]; // Memory block (Cache)
    wire [K-1:0] trunc_addr;

    assign trunc_addr = a[K-1:0];

    always @(posedge clk)
    begin
        if(we)
        begin // Store
            case(ctl[1:0])
                2'b00: // sb
                begin
                    dmem[trunc_addr] <= wd[7:0];
                end
                2'b01: // sh
                begin
                    dmem[trunc_addr] <= wd[7:0];
                    dmem[trunc_addr+1] <= wd[15:8];
                end
                2'b10: // sw
                begin
                    dmem[trunc_addr] <= wd[7:0];
                    dmem[trunc_addr+1] <= wd[15:8];
                    dmem[trunc_addr+2] <= wd[23:16]; 
                    dmem[trunc_addr+3] <= wd[31:24];
                end       
            endcase
        end
        else
        begin // Load
            case(ctl[1:0])
                2'b00: rd <= {{24{ctl[1]&dmem[trunc_addr][7]}}, dmem[trunc_addr]}; // byte
                2'b01: rd <= {{16{ctl[1]&dmem[trunc_addr+1][7]}}, dmem[trunc_addr+1], dmem[trunc_addr]}; // half
                2'b10: rd <= {dmem[trunc_addr+3], dmem[trunc_addr+2], dmem[trunc_addr+1], dmem[trunc_addr]}; // word
            endcase
        end
    end
endmodule 