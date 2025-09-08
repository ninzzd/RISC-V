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
    // task display;
    // endtask
    integer w;
    integer i;
    initial
    begin
        $timeformat(-9,2," ns",6);
        $monitor("Time = %t, a = %b, b = %b, res = %b",$realtime,a,b,res);
        #10.000
        a <= 2;
        b <= 3;
        #1.000
        // Error in partial product generation (stage 0)
        // For weight w = 32,33, 'X' is appearing near the base of the column
        $write("\n");
        for(w = 62;w >= 0;w = w-1)
        begin
            $write("%02d ",w);
        end
        $write("\n");
        for(i = 0; i < 32; i = i+1)
        begin
            for(w = 62;w >= 0;w = w-1)
            begin
                $write("%2b ",uut.s1[w][i]);
            end
            $write("\n");
        end
        #10.000
        $finish;
    end
endmodule