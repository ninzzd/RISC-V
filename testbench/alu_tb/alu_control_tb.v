`timescale 1ns/1ps

module alu_control_tb();

reg [31:0] a, b;
reg [3:0] alu_op;
wire [31:0] result;

// Instantiate the ALU control module
alu_control uut(
    .a(a),
    .b(b),
    .alu_op(alu_op),
    .result(result)
);

initial begin
    // Display headers
    $display("Time  a                   b                   alu_op  result");
    $display("----  ------------------- ------------------- ------ -------------------");

    // Test cases for each alu_op
    a = 32'd10; b = 32'd20; alu_op = 4'b0000; // add
    #10 $display("%4dns %d %d  %b  %d", $time, a, b, alu_op, result);
    alu_op = 4'b0001; // sub
    #10 $display("%4dns %d %d  %b  %d", $time, a, b, alu_op, result);
    alu_op = 4'b0010; // xor
    #10 $display("%4dns %d %d  %b  %d", $time, a, b, alu_op, result);
    alu_op = 4'b0011; // or
    #10 $display("%4dns %d %d  %b  %d", $time, a, b, alu_op, result);
    alu_op = 4'b0100; // and
    #10 $display("%4dns %d %d  %b  %d", $time, a, b, alu_op, result);
    alu_op = 4'b0101; // sll
    #10 $display("%4dns %d %d  %b  %d", $time, a, b, alu_op, result);
    alu_op = 4'b0110; // srl
    #10 $display("%4dns %d %d  %b  %d", $time, a, b, alu_op, result);
    alu_op = 4'b0111; // sra
    #10 $display("%4dns %d %d  %b  %d", $time, a, b, alu_op, result);
    alu_op = 4'b1000; // sltu
    #10 $display("%4dns %d %d  %b  %d", $time, a, b, alu_op, result);

    // Test an unknown alu_op code
    alu_op = 4'b1111;
    #10 $display("%4dns %d %d  %b  %d", $time, a, b, alu_op, result);

    $finish;
end

endmodule
