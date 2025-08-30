module mux32t1_tb;
    reg [4:0] sel;
    reg [31:0] in;
    wire out;
    mux32t1 uut(.sel(sel),.in(in),.out(out));
    initial begin  
        $monitor("In: %b, Sel: %b, Out: %b",in,sel,out);
        in <= 32'hDEADBEEF;
        sel <= 5'b01000;
    end
endmodule