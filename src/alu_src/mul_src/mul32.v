module mul32 #(parameter N = 32)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] hi,
    output [N-1:0] lo
);
    wire [N-1:0] s0 [2*N-2:0];
    wire [N-1:0] s1 [2*N-2:0];
    wire [N-1:0] s2 [2*N-2:0];
    wire [N-1:0] s3 [2*N-2:0];
    wire [N-1:0] s4 [2*N-2:0];
    wire [N-1:0] s5 [2*N-2:0];
    wire [N-1:0] s6 [2*N-2:0];
    wire [N-1:0] s7 [2*N-2:0];
    genvar w;
    genvar j;
    genvar k;
    generate
        // Stage 0: Partial-products generation
        for(w = 0;w <= 2*N-2;w = w+1)
        begin
            if(w < N)
            begin
                for(j = 0;j <= w;j = j+1)
                    assign s0[w][j] = a[w-j]&b[j];
            end
            else
            begin
                for(j = 0;j <= 2*N - 1 - w;j = j+1)
                    assign s0[w][j] = a[N-1-j]&b[w+j+1-N];
            end
        end
        // Stage 1
        for(w = 0;w <= 2*N-2;w = w+1){
            case(i)
                28:
                begin
                    
                end
                29:
                begin
                    
                end
                30:
                begin
                    
                end
                31,32:
                begin
                    
                end
                33:
                begin
                    
                end
                34:
                begin
                    
                end
                35:
                begin
                    
                end
                default:
                    s1[w] = s0[w];

            endcase 
        }
    endgenerate
endmodule