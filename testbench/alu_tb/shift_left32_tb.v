`timescale  1ns /1ps
module shift_left32_tb;
    reg [31:0] inp;
    reg [4:0] shamt;
    wire [31:0] out;
    shift_left32 uut(.inp(inp),.shamt(shamt),.res(out));
    initial begin
        $timeformat(-9,2," ns",6);
        $monitor("Time = %t, Input = %d, Shift Amount = %d, Output = %d\n",$realtime,inp,shamt,out);
        inp <= 1;
        shamt <= 8;
        #10.000
        inp <= 5;
        shamt <= 10;
        $display("End of Simulation\n");
        $finish;
    end
endmodule