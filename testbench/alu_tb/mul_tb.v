`timescale 1ns/1ps
module mul_tb();
    reg signed [31:0] a;
    reg signed [31:0] b;
    wire [31:0] a_;
    wire [31:0] b_;
    wire signed [63:0] res_signed;
    wire [63:0] res_unsigned;
    wire signed [63:0] exp_res_signed;
    wire [63:0] exp_res_unsigned;
    reg mode;

    mul32 #(.T(0.150)) uut(
        .a(a),
        .b(b),
        .mode(mode),
        .lo(res_signed[31:0]),
        .hi(res_signed[63:32])
    );
    assign a_ = a;
    assign b_ = b;
    assign exp_res_signed = a*b;
    assign exp_res_unsigned = a_*b_;
    assign res_unsigned = res_signed;
    // task display;
    // endtask
    integer w;
    integer i;
    initial
    begin
        $timeformat(-9,2," ns",6);
        $monitor("Time = %t, a = %d, b = %d, mode = %b, exp_res_unsigned = %d, exp_res_signed = %d, res_unsigned = %d, reg_signed",$realtime,a,b,mode,exp_res_unsigned,exp_res_signed,res_unsigned,res_signed);
        #10.000
        mode <= 0;
        a <= 292;
        b <= 6785;
        #10.000
        mode <= 0;
        a <= 32'h8FA4B672;
        b <= 32'h6C3F8132;
        #10.000
        mode <= 1;
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