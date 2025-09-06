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
        // Max depth: 28 (27:0)
        for(w = 0;w <= 2*N-2;w = w+1)
        begin
            case(w)
                28:
                begin
                    ha ha1(.i(s0[w][1:0]),.o({s1[w+1][0],s1[w][0]}));
                    assign s1[w][27:1] = s0[w][28:2];
                end
                29:
                begin
                    fa fa1(.i(s0[w][2:0]),.o({s1[w+1][0],s1[w][1]}));
                    ha ha2(.i(s0[w][4:3]),.o({s1[w+1][1],s1[w][2]}));
                    assign s1[w][27:3] = s0[w][29:5];
                end
                30:
                begin
                    fa fa2(.i(s0[w][2:0]),.o({s1[w+1][0],s1[w][2]}));
                    fa fa3(.i(s0[w][5:3]),.o({s1[w+1][1],s1[w][3]}));
                    ha ha3(.i(s0[w][7:6]),.o({s1[w+1][2],s1[w][4]}));
                    assign s1[w][27:5] = s0[w][30:8];
                end
                31:
                begin
                    fa fa4(.i(s0[w][2:0]),.o({s1[w+1][0],s1[w][3]}));
                    fa fa5(.i(s0[w][5:3]),.o({s1[w+1][1],s1[w][4]}));
                    fa fa6(.i(s0[w][8:6]),.o({s1[w+1][2],s1[w][5]}));
                    ha ha4(.i(s0[w][10:9]),.o({s1[w+1][3],s1[w][6]}));
                    assign s1[w][27:7] = s0[w][31:11];
                end
                32:
                begin
                    fa fa7(.i(s0[w][2:0]),.o({s1[w+1][0],s1[w][4]}));
                    fa fa8(.i(s0[w][5:3]),.o({s1[w+1][1],s1[w][5]}));
                    fa fa9(.i(s0[w][8:6]),.o({s1[w+1][2],s1[w][6]}));
                    ha ha5(.i(s0[w][10:9]),.o({s1[w+1][3],s1[w][7]}));
                    assign s1[w][27:8] = s0[w][30:11];
                end
                33:
                begin
                    fa fa10(.i(s0[w][2:0]),.o({s1[w+1][0],s1[w][4]}));
                    fa fa11(.i(s0[w][5:3]),.o({s1[w+1][1],s1[w][5]}));
                    fa fa12(.i(s0[w][8:6]),.o({s1[w+1][2],s1[w][6]}));
                    assign s1[w][27:7] = s0[w][29:9];
                end
                34:
                begin
                    fa fa13(.i(s0[w][2:0]),.o({s1[w+1][0],s1[w][3]}));
                    fa fa14(.i(s0[w][5:3]),.o({s1[w+1][1],s1[w][4]}));
                    assign s1[w][27:5] = s0[w][28:6];
                end
                35:
                begin
                    fa fa15(.i(s0[w][2:0]),.o({s1[w+1][0],s1[w][2]}));
                    assign s1[w][27:3] = s0[w][27:3];
                end
                36:
                begin
                    assign s1[w][27:1] = s0[w][26:0];
                end
                default:
                    assign s1[w] = s0[w];
            endcase 
        end
        // Stage 2
        // Max depth: 20 (19:0)
        for(w = 0;w <= 2*N-2;w = w+1)
        begin
            case(w)
                19:
                begin
                    // fa - 0, ha - 1
                    ha ha1(.i(s0[w][1:0]),.o({s1[w+1][0],s1[w][0]}));
                    assign s1[w][19:1] = s0[w][20:2];
                end
                20:
                begin
                    // fa - 1, ha - 1
                end
                21:
                begin
                    // fa - 2, ha - 1
                end
                22:
                begin
                    // fa - 3, ha - 1
                end
                23:
                begin
                    // fa - 4, ha - 1
                end
                24:
                begin
                    // fa - 5, ha - 1
                end
                25:
                begin
                    // fa - 6, ha - 1
                end
                26:
                begin
                    // fa - 7, ha - 1
                end
                27:
                begin
                    // fa - 8, ha - 1
                end
                28:
                begin
                    // fa - 9, ha - 0
                end
                29:
                begin
                    // fa - 9, ha - 0
                end
                30:
                begin
                    // fa - 9, ha - 0
                end
                31:
                begin
                    // fa - 9, ha - 0
                end
                32:
                begin
                    // fa - 9, ha - 0
                end
                33:
                begin
                    // fa - 9, ha - 0
                end
                34:
                begin
                    // fa - 9, ha - 0
                end
                35:
                begin
                    // fa - 9, ha - 0
                end
                36:
                begin
                    // fa - 9, ha - 0
                end
                37:
                begin
                    // fa - 8, ha - 0
                end
                38:
                begin
                    // fa - 7, ha - 0
                end
                39:
                begin
                    // fa - 6, ha - 0
                end
                40:
                begin
                    // fa - 5, ha - 0
                end
                41:
                begin
                    // fa - 4, ha - 0
                end
                42:
                begin
                    // fa - 3, ha - 0
                end
                43:
                begin
                    // fa - 2, ha - 0
                end
                44:
                begin
                    // fa - 1, ha - 0
                end
                45:
                begin
                    // carry
                end
                default:
                    assign s1[w] = s0[w];
            endcase 
        end
    endgenerate
endmodule