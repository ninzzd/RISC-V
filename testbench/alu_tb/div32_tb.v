`timescale 1ns/1ps
module div32_tb;
    reg clk;
    reg rst;
    reg start;
    reg is_signed;
    reg [31:0] dividend_in;
    reg [31:0] divisor_in;
    wire [31:0] quotient;
    wire [31:0] remainder;
    wire done;

    // Instantiate the divider module
    div32 uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .is_signed(is_signed),
        .dividend_in(dividend_in),
        .divisor_in(divisor_in),
        .quotient(quotient),
        .remainder(remainder),
        .done(done)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        $display("Starting test...\n");
        // Reset
        rst = 1; start = 0; dividend_in = 0; divisor_in = 0; is_signed = 0;
        #20;
        rst = 0;

        // Test 1: Unsigned division 100 / 3
        dividend_in = 100;
        divisor_in = 3;
        is_signed = 0;
        start_division();
        wait_for_done();
        $display("Test1: Unsigned 100 / 3");
        $display("  Quotient  = %d", quotient);
        $display("  Remainder = %d\n", remainder);

        // Test 2: Signed division -100 / 3
        dividend_in = -100;
        divisor_in = 3;
        is_signed = 1;
        start_division();
        wait_for_done();
        $display("Test2: Signed -100 / 3");
        $display("  Quotient  = %0d", $signed(quotient));
        $display("  Remainder = %0d\n", $signed(remainder));

        // Test 3: Signed division -100 / -7
        dividend_in = -100;
        divisor_in = -7;
        is_signed = 1;
        start_division();
        wait_for_done();
        $display("Test3: Signed -100 / -7");
        $display("  Quotient  = %0d", $signed(quotient));
        $display("  Remainder = %0d\n", $signed(remainder));

        // Test 4: Division by zero
        dividend_in = 1234;
        divisor_in = 0;
        is_signed = 0;
        start_division();
        wait_for_done();
        $display("Test4: Division by zero");
        $display("  Quotient  = %0d", quotient);
        $display("  Remainder = %0d\n", remainder);

        // Test 5: Overflow case INT_MIN / -1
        dividend_in = 32'h80000000;
        divisor_in = 32'hFFFFFFFF; // -1 for signed
        is_signed = 1;
        start_division();
        wait_for_done();
        $display("Test5: Overflow INT_MIN / -1");
        $display("  Quotient  = %0d", $signed(quotient));
        $display("  Remainder = %0d\n", $signed(remainder));

        $display("All tests complete.");
        $stop;
    end

    task start_division;
        begin
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
        end
    endtask

    task wait_for_done;
        begin
            wait (done == 1);
            @(posedge clk); // wait one more cycle for outputs to stabilize
        end
    endtask

endmodule
