`timescale  1ns /1ps
module add32_tb;
    reg [31:0] a;
    reg [31:0] b;
    reg c_1;
    wire [31:0] sum;
    wire c31;
    add32 uut(.a(a),.b(b),.c_1(c_1),.s(sum),.c31(c31));
    initial begin
        $timeformat(-9,2," ns",6);
        $monitor("Time = %t, Sum = %d, Carry= %d\n",$realtime,sum,c31);
        c_1 = 0;
        a <= 1;
        b <= 5;
        #10.000
        a <= 24;
        b <= 79;
        #10.000
        a <= 84762388;
        b <= 983453876;
        #10.000
        $display("End of Simulation\n");
        $finish;
    end
endmodule