`timescale 1ns/1ps
// To run: iverilog -o mu_tb.vvp tb/datapath_tb/mu_tb.v src/datapath/ifu_src/mul_src/src/*.v src/datapath/ifu_src/mu.v src/datapath/util_src/*.v
module mu_tb;
    reg clk;
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] mulctl;
    wire [31:0] res;

    always #5 clk <= ~clk;

    mu uut(
        .clk(clk),
        .a(a),
        .b(b),
        .mulctl(mulctl),
        .mulres(res)
    );

    always @(posedge clk)
    begin
        $write("Time = %t, a = %d, b = %d, mulctl_buffered = %2b, res = %d\n",$realtime,$signed(a),$signed(b),mulctl,$signed(res));
    end

    initial begin
        clk <= 0;

        a <= -3;
        b <= -4;
        mulctl <= 2'b00;

        #10
        mulctl <= 2'b01;

        #10
        mulctl <= 2'b10;

        #10
        mulctl <= 2'b11;

        #10
        a <= 32'hzzzzzzzz;
        b <= 32'hzzzzzzzz;
        mulctl <= 2'bzz;

        #100
        $finish;
    end
endmodule