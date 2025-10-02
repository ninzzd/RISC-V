module mux32t1 #(parameter T = 0.000)(
    input [31:0] in,
    input [4:0] sel,
    output out
);
    assign #(2*T) out = (~sel[4] & ~sel[3] & ~sel[2] & ~sel[1] & ~sel[0])&in[0]
                    |   (~sel[4] & ~sel[3] & ~sel[2] & ~sel[1] &  sel[0])&in[1]
                    |   (~sel[4] & ~sel[3] & ~sel[2] &  sel[1] & ~sel[0])&in[2]
                    |   (~sel[4] & ~sel[3] & ~sel[2] &  sel[1] &  sel[0])&in[3]
                    |   (~sel[4] & ~sel[3] &  sel[2] & ~sel[1] & ~sel[0])&in[4]
                    |   (~sel[4] & ~sel[3] &  sel[2] & ~sel[1] &  sel[0])&in[5]
                    |   (~sel[4] & ~sel[3] &  sel[2] &  sel[1] & ~sel[0])&in[6]
                    |   (~sel[4] & ~sel[3] &  sel[2] &  sel[1] &  sel[0])&in[7] 
                    |   (~sel[4] &  sel[3] & ~sel[2] & ~sel[1] & ~sel[0])&in[8]
                    |   (~sel[4] &  sel[3] & ~sel[2] & ~sel[1] &  sel[0])&in[9]
                    |   (~sel[4] &  sel[3] & ~sel[2] &  sel[1] & ~sel[0])&in[10]
                    |   (~sel[4] &  sel[3] & ~sel[2] &  sel[1] &  sel[0])&in[11]
                    |   (~sel[4] &  sel[3] &  sel[2] & ~sel[1] & ~sel[0])&in[12]
                    |   (~sel[4] &  sel[3] &  sel[2] & ~sel[1] &  sel[0])&in[13]
                    |   (~sel[4] &  sel[3] &  sel[2] &  sel[1] & ~sel[0])&in[14]
                    |   (~sel[4] &  sel[3] &  sel[2] &  sel[1] &  sel[0])&in[15]
                    |   ( sel[4] & ~sel[3] & ~sel[2] & ~sel[1] & ~sel[0])&in[16]
                    |   ( sel[4] & ~sel[3] & ~sel[2] & ~sel[1] &  sel[0])&in[17]
                    |   ( sel[4] & ~sel[3] & ~sel[2] &  sel[1] & ~sel[0])&in[18]
                    |   ( sel[4] & ~sel[3] & ~sel[2] &  sel[1] &  sel[0])&in[19]
                    |   ( sel[4] & ~sel[3] &  sel[2] & ~sel[1] & ~sel[0])&in[20]
                    |   ( sel[4] & ~sel[3] &  sel[2] & ~sel[1] &  sel[0])&in[21]
                    |   ( sel[4] & ~sel[3] &  sel[2] &  sel[1] & ~sel[0])&in[22]
                    |   ( sel[4] & ~sel[3] &  sel[2] &  sel[1] &  sel[0])&in[23] 
                    |   ( sel[4] &  sel[3] & ~sel[2] & ~sel[1] & ~sel[0])&in[24] 
                    |   ( sel[4] &  sel[3] & ~sel[2] & ~sel[1] &  sel[0])&in[25]
                    |   ( sel[4] &  sel[3] & ~sel[2] &  sel[1] & ~sel[0])&in[26]
                    |   ( sel[4] &  sel[3] & ~sel[2] &  sel[1] &  sel[0])&in[27]
                    |   ( sel[4] &  sel[3] &  sel[2] & ~sel[1] & ~sel[0])&in[28]
                    |   ( sel[4] &  sel[3] &  sel[2] & ~sel[1] &  sel[0])&in[29]
                    |   ( sel[4] &  sel[3] &  sel[2] &  sel[1] & ~sel[0])&in[30]
                    |   ( sel[4] &  sel[3] &  sel[2] &  sel[1] &  sel[0])&in[31];
endmodule