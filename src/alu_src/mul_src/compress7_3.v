module compress7_3( // Max propagation delay: 0.45 ns
    input [6:0] in,
    output [2:0] out
);
    wire [1:0] b;
    wire [1:0] c;
    wire [1:0] d;
    compress3_2 s1a(.in({in[0],in[1],in[2]}),.out({b[1],b[0]}));
    compress3_2 s1b(.in({in[3],in[4],in[5]}),.out({c[1],c[0]}));
    compress3_2 s2(.in({b[0],c[0],in[6]}),.out({d[1],d[0]}));
    compress3_2 s3(.in({d[1],b[1],c[1]}),.out({out[2],out[1]}));
    assign out[0] = d[0];
endmodule