module mux_tb;
    parameter W = 32;
    parameter N = 2;
    reg [63:0] in;
    reg sel;
    wire [31:0] out;
    mux #(.W(W), .N(N)) uut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    initial begin
        $monitor("Time = %t, in = %d, sel = %b, out = %d",$realtime,in,sel,out);
        // Test all combinations
        in = {32'd1, 32'd5}; sel = 1'b0; #10;
        in = {32'd1, 32'd5}; sel = 1'b1; #10;
    end
endmodule