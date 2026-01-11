module buffer #(parameter W = 32, L = 8)(
    input clk,
    input [W-1:0] in,
    output [W-1:0] out
);
    reg [W-1:0] dff [0:L-1];
    integer i;
    assign out = dff[L-1];
    always @(posedge clk)
    begin
        dff[0] <= in;
        for(i = 1;i <= L-1;i=i+1)
        begin
            dff[i] <= dff[i-1];
        end
    end
endmodule