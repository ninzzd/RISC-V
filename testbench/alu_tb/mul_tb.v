`timescale 1ns/1ps
module mul_tb();
    reg mode;
    reg signed [31:0] a;
    reg signed [31:0] b;
    wire eq_u;
    wire eq;
    wire [31:0] a_;
    wire [31:0] b_;
    wire signed [63:0] res_signed;
    wire [63:0] res_unsigned;
    wire signed [63:0] exp_res_signed;
    wire [63:0] exp_res_unsigned;

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
    assign eq = (exp_res_signed == res_signed) ? 1'b1 : 1'b0;
    assign eq_u = (exp_res_unsigned == res_unsigned) ? 1'b1 : 1'b0;
    // task display;
    // endtask
    integer w;
    integer i;
    integer log;
    initial
    begin
        log = $fopen("log/mul_tb_log.csv","w");
        #1.000
        forever
        begin
            #0.500
            $fwrite(log,"%0t,%0b,%0d,%0d,%0d,%0d,%0b,%0d,%0d,%0d,%0d,%0b\n",$realtime,mode,a_,b_,exp_res_unsigned,res_unsigned,eq_u,a,b,exp_res_signed,res_signed,eq);
        end
    end
    initial
    begin
        $timeformat(-9,2," ns",6);
        #0.500
        $fwrite(log,"Time,Mode,a_u,b_u,exp_res_u,res_u,eq_u,a,b,exp_res,res,eq\n");
        #0.499
        mode <= 0;
        a <= 292;
        b <= 6785;
        #5.000
        mode <= 0;
        a <= 32'h8FA4B672;
        b <= 32'h6C3F8132;
        #5.000
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
        #5.000
        $fclose(log);
        $finish;
    end

endmodule