`timescale  1ns /1ps
module shift_left32_tb;
    reg signed [31:0] inp;
    reg signed [4:0] shamt;
    reg mode;
    wire signed [31:0] out;
    wire signed [31:0] exp_out;
    assign exp_out = mode ? (inp >>> shamt) : (inp >> shamt);
    shift_right32 uut(.inp(inp),.shamt(shamt),.mode(mode),.res(out));
    initial begin
        $timeformat(-9,2," ns",6);
        $monitor("Time = %t, Input = %d, Shift Amount = %d, Mode (0-SRL,1-SRA) = %d, Output = %d, Expected Output = %d\n",$realtime,inp,shamt,mode,out,exp_out);
        inp <= 150;
        shamt <= 2;
        mode <= 0;
        #10
        inp <= 150;
        shamt <= 2;
        mode <= 1;
        #10
        inp <= -13;
        shamt <= 3;
        mode <= 0;
        #10
        inp <= -13;
        shamt <= 3;
        mode <= 1;
        #10
        inp <= 92;
        shamt <= 4;
        mode <= 0;
        #10
        inp <= 92;
        shamt <= 4;
        mode <= 1;
        #10
        inp <= -127;
        shamt <= 5;
        mode <= 0;
        #10
        inp <= -127;
        shamt <= 5;
        mode <= 1;
        #10
        inp <= 127;
        shamt <= 1;
        mode <= 0;
        #10
        inp <= 127;
        shamt <= 1;
        mode <= 1;
        #10
        $display("End of Simulation\n");
        $finish;
    end
endmodule