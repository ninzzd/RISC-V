// Author: Ninaad Desai
// Description: Parameterized programmeable linear feedback shift register (fibonacci form)
module lfsr #(parameter N = 32)(
    input [N-1:0] seed,
    input [N-1:0] mask,
    input rst,
    input clk,

    output [N-1:0] q
);
    wire [N-1:0] xors;
    reg [N-1:0] mask_;
    reg [N-1:0] dff;
    genvar i;
    assign q = dff;
    generate
        for(i = 0;i < N;i = i+1)
        begin
            if(i == 0)
                assign xors[i] = mask[i]&dff[i];
            else
            begin
                assign xors[i] = xors[i-1]^(mask[i]&dff[i]);
            end 
        end
    endgenerate
    always @(posedge clk)
    begin
        if(rst)
        begin
            dff <= seed;
            mask_ <= mask;
        end
        else
        begin
            dff <= {dff[N-2:0],xors[N-1]};
        end
    end
endmodule