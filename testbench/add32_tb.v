`timescale  1ns /1ns
module add32_tb;
    reg [31:0] a;
    reg [31:0] b;
    reg c_1;
    wire [31:0] sum;
    wire c31;
    add32 uut(.a(a),.b(b),.c_1(c_1),.s(sum),.c31(c31));
    initial begin
        $monitor("Time = %t, Sum = 0x%h, Carry= %d\n",$time,sum,c31);
        c_1 = 0;
        a = 32'h00000000;
        b = 32'h00000000;
        #10
        a = 32'h00000001;
        b = 32'h00000004;
        #10
        a = 32'h00000001;
        b = 32'hFFFFFFFF;
        #10
        $display("End of Simulation\n");
        $finish;
    end
endmodule