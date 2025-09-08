`timescale 1ns/1ps
module mul_tb();
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] res;
    wire [63:0] exp_res;
    mul32 #(.T(0.150)) uut(
        .a(a),
        .b(b),
        .lo(res[31:0]),
        .hi(res[63:32])
    );
    assign exp_res = a*b;
    // task display;
    // endtask
    integer w;
    integer i;
    initial
    begin
        $timeformat(-9,2," ns",6);
        $monitor("Time = %t, a = %d, b = %d, exp_res = %d, res = %d",$realtime,a,b,exp_res,res);
        #10.000
        a <= 292;
        b <= 6785;
        #1.000
        // ----- Stage-wise debugging -----
        // $write("\n");
        // for(w = 63;w >= 0;w = w-1)
        // begin
        //     if(w == 63)
        //     begin
        //         $write("   ");
        //     end
        //     else
        //     $write("%02d ",w);
        // end
        // $write("\n");
        // for(i = 0; i < 32; i = i+1)
        // begin
        //     for(w = 63;w >= 0;w = w-1)
        //     begin
        //         if(w == 63)
        //         begin
        //             $write("%2d ",i);
        //         end
        //         else
        //         $write("%2b ",uut.s5[w][i]);
        //     end
        //     $write("\n");
        // end
        // --------------------------------
        #10.000
        $finish;
    end
endmodule