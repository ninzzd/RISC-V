`timescale  1ns /1ps
module slt32_tb;
    reg [31:0] x1;
    reg [31:0] x2;
    wire [31:0] out;
    slt_32 uut(.x1(x1),.x2(x2),.out(out));
    initial begin
        $timeformat(-9, 2, " ns", 6);
        $monitor("Time = %t, x1 = %d, x2 = %d, out = %d", $realtime, x1, x2, out);

        $timeformat(-9, 2, " ns", 6);
        $monitor("Time = %t, x1 = %d, x2 = %d, out = %d", $realtime, x1, x2, out);

         // Test case 1: x1 < x2
        x1 = 10; x2 = 20;
        #5;

        // Test case 2: x1 == x2
        x1 = 15; x2 = 15;
        #5;

        // Test case 3: x1 > x2
        x1 = 25; x2 = 5;
        #5;

        // Test case 4: x1 = 0, x2 = max unsigned
        x1 = 0; x2 = 32'hFFFFFFFF;
        #5;

        // Test case 5: x1 = max unsigned, x2 = 0
        x1 = 32'hFFFFFFFF; x2 = 0;
        #5;

        // Test case 6: x1 = 0x80000000, x2 = 0x7FFFFFFF
        x1 = 32'h80000000; x2 = 32'h7FFFFFFF;
        #5;

        // Test case 7: x1 = 0x7FFFFFFF, x2 = 0x80000000
        x1 = 32'h7FFFFFFF; x2 = 32'h80000000;
        #5;

        $display("End of Simulation");
        $finish;
    end
endmodule