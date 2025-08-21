module mul32(
    input [31:0] a,
    input [31:0] b,
    output [31:0] hi,
    output [31:0] lo
);
    wire s0[0:63][0:31];
    genvar i;
    genvar j;
    generate
        for(i = 0;i <= 62;i = i+1)
        begin
            for(j = 0;j <= i;j = j+1)
            begin
                if(i-j <= 31)
                    assign s0[i][j] = a[j]&b[i-j];  
            end
        end
    endgenerate
endmodule