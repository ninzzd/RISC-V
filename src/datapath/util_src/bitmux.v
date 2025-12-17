 /*
    Author: Ninaad Desai
    Description: Parameterized mux for single bit inputs
 */
module bitmux #(
    parameter N = 2
)(
    input [N-1:0] in,
    input [$clog2(N)-1:0] sel,
    output out
);
    wire [N-1:0] out_;
    wire [N-1:0] m; // minterms
    genvar i;
    generate
        for(i = 0; i < N; i = i + 1) begin: bitmux_loop
            assign m[i] = &(~sel ^ i[$clog2(N)-1:0]); // minterm generation using reduction AND (AND reduced bitwise XNOR can be replaced with sel == i)
            assign out_[i] = in[i]&m[i]; // using shannon's expansion
        end
    endgenerate
    assign out = |out_; // reduction OR to realize boolean function
endmodule