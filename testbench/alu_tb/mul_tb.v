`timescale 1ns/1ps
module mul_tb();
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] res;
    mul32 uut(
        .a(a),
        .b(b),
        .lo(res[31:0]),
        .hi(res[63:32])
    );
    initial
    begin
        $timeformat(-9,2," ns",6);
        $monitor("Time = %t, a = %b, b = %b, res = %b",$realtime,a,b,res);
        #10.000
        a <= 2;
        b <= 3;
        #10.000
        a <= 5;
        b <= 6;
        #10.000
        $finish;
    end
endmodule