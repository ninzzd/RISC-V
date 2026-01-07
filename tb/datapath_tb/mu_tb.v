`timescale 1ns/1ps
/* To run: 
    iverilog -o mu_tb.vvp tb/datapath_tb/mu_tb.v \
    src/datapath/ifu_src/mul_src/src/add8.v \
    src/datapath/ifu_src/mul_src/src/add32.v \
    src/datapath/ifu_src/mul_src/src/buffer.v \
    src/datapath/ifu_src/mul_src/src/fa.v \
    src/datapath/ifu_src/mul_src/src/ha.v \
    src/datapath/ifu_src/mul_src/src/mul32p.v \
    src/datapath/ifu_src/mu.v \
    src/datapath/util_src/*.v
*/
module mu_tb;
    reg clk;
    reg [31:0] counter;
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] mulctl;
    reg strb;
    wire [31:0] res;
    wire valid;

    always #5 clk <= ~clk;

    mu uut(
        .clk(clk),
        .strb(strb),
        .a(a),
        .b(b),
        .mulctl(mulctl),
        .mulres(res),
        .valid(valid)
    );

    always @(posedge clk)
    begin
        counter <= counter + 1;
        $write("Sr.No = %2d, Time = %6t, a = %2d, b = %2d, strb = %b, mulctl_buffered = %2b, res = %d, valid = %b\n",counter, $realtime,$signed(a),$signed(b), strb,mulctl,$signed(res), valid);
    end

    initial begin
        $dumpfile("mu_tb.vcd");
        $dumpvars(0, mu_tb);
        counter <= 1;
        clk <= 0;

        a <= -3;
        b <= -4;
        mulctl <= 2'b00;
        strb <= 1'b1;
        #7
        strb <= 1'b0;

        #3
        mulctl <= 2'b01;
        strb <= 1'b1;
        #7
        strb <= 1'b0;

        #3
        mulctl <= 2'b10;
        strb <= 1'b1;
        #7
        strb <= 1'b0;

        #3
        mulctl <= 2'b11;
        strb <= 1'b1;
        #7
        strb <= 1'b0;

        #3
        a <= 32'd16;
        b <= 32'd48;
        mulctl <= 2'b00;
        strb <= 1'b1;
        #7
        strb <= 1'b0;

        #100
        $finish;
    end
endmodule