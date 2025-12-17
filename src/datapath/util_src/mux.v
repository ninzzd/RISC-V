module mux #(
    parameter W = 32,
    parameter N = 2
)
(
    input [N*W-1:0] in,
    input [$clog2(N)-1:0] sel,
    output reg [W-1:0] out
);
    genvar i;
    generate
        for(i = 0; i < W; i = i + 1) begin: mux_loop
            bitmux #(.N(N)) bmux (
                .in(in[i +: N]),
                .sel(sel),
                .out(out[i])
            );
        end
    endgenerate
endmodule