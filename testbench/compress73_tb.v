`timescale  1ns /1ps
module compress73_tb;
    reg [6:0] in;
    wire [2:0] out;

    integer i;

    compress7_3 uut73(.in(in),.out(out));
    initial begin
        $timeformat(-9,2," ns",6);
        $monitor("Time= %t, In (3:2)= %b, Out (3:2)= %b",$realtime,in,out);
        for (i = 0;i < 128;i = i+1)
        begin
            in <= i;
            #10; 
        end
    end
endmodule