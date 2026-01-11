module qru(
    input clk,
    input [31:0] a,
    input [31:0] b,
    input en,
    input [1:0] divctl,
    output [31:0] res,
    output done
);
    // divctl - control signal for the type of divide instruction
    // 00 - div
    // 01 - divu
    // 10 - rem
    // 11 - remu
    reg [31:0] a_;
    reg [31:0] b_;
    reg desired_op;

    wire resmuxctl;
    wire [31:0] quotient;
    wire [31:0] remainder;
    
    // To buffer inputs to determine validity
    always @(posedge clk)
    begin
        if(en)
        begin
            a_ <= a;
            b_ <= b;
        end
        desired_op <= en;
    end

    // resmuxctl and done buffers
    buffer #(
        .W(2),
        .L(16) // divider latency
    ) resctl_buff(
        .clk(clk),
        .in({desired_op,divctl[1]}), 
        .out({done,resmuxctl})
    );

    div32 divunit (
        .clk(clk),
        .rst(1'b0), // no reset
        .start(en),
        .is_signed(divctl[0]), // signed or unsigned division
        .dividend_in(a),
        .divisor_in(b),
        .quotient(res),
        .remainder() // remainder not used currently
    );

    // resmux sel/ctl line
    mux #(
        .W(32),
        .N(2)
    ) resmux (
        .sel(resmuxctl),
        .in({remainder, quotient}),
        .out(res)
    );
endmodule