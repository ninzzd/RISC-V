module mux #(
    parameter W = 32,
    parameter N = 2
)
(
    input [N*W-1:0] in,
    input [$clog2(N)-1:0] sel,
    output [W-1:0] out
);
    wire [N-1:0] bitmux_in [0:W-1];
    genvar i;
    genvar j;
    generate
        for(i = 0; i < W; i = i + 1) begin: mux_loop
            for(j = 0; j < N; j = j + 1) begin: bitmux_in_loop
                assign bitmux_in[i][j] = in[i + j*W];
            end
            bitmux #(.N(N)) bmux (
                .in(bitmux_in[i]),
                .sel(sel),
                .out(out[i])
            );
        end
    endgenerate
endmodule