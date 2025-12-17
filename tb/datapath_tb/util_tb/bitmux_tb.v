module bitmux_tb;
    parameter N = 3;
    reg [N-1:0] in;
    reg [$clog2(N)-1:0] sel;
    wire out;
    bitmux #(.N(N)) uut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    initial begin
        $monitor("Time = %t, in = %b, sel = %b, out = %b",$realtime,in,sel,out);
        // Test all combinations
        in = 3'b101; sel = 2'b00; #10;
        in = 3'b101; sel = 2'b01; #10;
        in = 3'b101; sel = 2'b10; #10;
        in = 3'b011; sel = 2'b00; #10;
        in = 3'b011; sel = 2'b01; #10;
        in = 3'b011; sel = 2'b10; #10;
        $finish;
    end
endmodule