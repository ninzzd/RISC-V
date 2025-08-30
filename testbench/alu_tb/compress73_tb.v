`timescale  1ns /1ps
module compress73_tb;
    reg [6:0] in;
    wire [2:0] out;
    wire [2:0] exp_out; 
    integer i;
    assign exp_out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6];
    compress7_3 uut73(.in(in),.out(out));
    initial begin
        $timeformat(-9,2," ns",6);
        $monitor("Time= %t, In (7:3)= %b, Out (7:3)= %b, Expected Out= %b",$realtime,in,out,exp_out);
        for (i = 0;i < 128;i = i+1)
        begin
            in = i;
            #10;
        end
    end
endmodule
