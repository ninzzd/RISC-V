`timescale 1ns/1ps
/* To run: 
    iverilog -o qru_tb.vvp tb/datapath_tb/qru_tb.v \
    src/datapath/ifu_src/div_src/src/div32.v \
    src/datapath/ifu_src/qru.v \
    src/datapath/util_src/*.v
*/
module qru_tb;
    reg clk;
    reg [31:0] counter;
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] divctl;
    reg en;
    wire [31:0] res;
    wire done;

    always #5 clk <= ~clk;

    qru uut(
        .clk(clk),
        .en(en),
        .a(a),
        .b(b),
        .divctl(divctl),
        .res(res),
        .done(done)
    );

    always @(posedge clk)
    begin
        counter <= counter + 1;
        $write("Sr.No = %2d, Time = %6t, a = %2d, b = %2d, en = %b, divctl_buffered = %2b, res = %d, done = %b\n",counter, $realtime,$signed(a),$signed(b),en,divctl,$signed(res), done);
    end

    initial begin
        $dumpfile("qru_tb.vcd");
        $dumpvars(0, qru_tb);
        counter <= 1;
        clk <= 0;

        a <= -3;
        b <= -4;
        divctl <= 2'b00;
        en <= 1'b1;
        #7
        en <= 1'b0;

        #3
        divctl <= 2'b01;
        en <= 1'b1;
        #7
        en <= 1'b0;

        #3
        divctl <= 2'b10;
        en <= 1'b1;
        #7
        en <= 1'b0;

        #3
        divctl <= 2'b11;
        en <= 1'b1;
        #7
        en <= 1'b0;

        #3
        a <= 32'd16;
        b <= 32'd48;
        divctl <= 2'b00;
        en <= 1'b1;
        #7
        en <= 1'b0;

        #100
        $finish;
    end
endmodule