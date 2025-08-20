`timescale  1ns /1ps
module compress32_tb;
    reg [2:0] in;
    wire [1:0] out;

    integer i;

    compress3_2 uut32(.in(in),.out(out));
    initial begin
        $timeformat(-9,2," ns",6);
        $monitor("Time= %t, In (3:2)= %b, Out (3:2)= %b",$realtime,in,out);
        for (i = 0;i < 4;i = i+1)
        begin
            in <= i;
            #10;
        end
    end
endmodule