`timescale  1ns /1ps
module sltu32_tb;
    reg [31:0] x1;
    reg [31:0] x2;
    wire [31:0] out;
    sltu_32 uut(.x1(x1),.x2(x2),.out(out));
    initial begin
        $timeformat(-9, 2, " ns", 6);
        $monitor("Time = %t, x1 = %d, x2 = %d, out = %d", $realtime, x1, x2, out);

        // Test case 1: x1 < x2
        x1 = 10;
        x2 = 20;
        #10;

        // Test case 2: x1 == x2
        x1 = 15;
        x2 = 15;
        #10;

        // Test case 3: x1 > x2
        x1 = 25;
        x2 = 5;
        #10;

        // Test case 4: x1 = 0, x2 = max
        x1 = 0;
        x2 = 32'hFFFFFFFF;
        #10;

        // Test case 5: x1 = max, x2 = 0
        x1 = 32'hFFFFFFFF;
        x2 = 0;
        #10;

        $display("End of Simulation");
        $finish;
    end
endmodule