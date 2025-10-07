`timescale 1 ns/ 1 ps
module lfsr_tb;
reg [3:0] seed;
reg [3:0] mask;
reg rst;
reg clk;
wire [3:0] q;
always #5.000 clk = ~clk;
lfsr #(.N(4)) uut(.clk(clk),.rst(rst),.seed(seed),.mask(mask),.q(q));

initial 
begin
    $timeformat(-9,2," ns",6);
    $monitor("Time = %t, Value = %b",$realtime,q);
    clk <= 0;
    mask <= 4'b0110;
    seed <= 4'b0101;
    rst <= 1;
    #10.000
    rst <= 0;
    #100.000
    $finish;
end
endmodule