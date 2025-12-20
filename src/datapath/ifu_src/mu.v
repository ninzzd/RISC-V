module mu(
    input clk,
    input [31:0] a,
    input [31:0] b,
    input [1:0] mulctl,
    output [31:0] mulres
);
    // mulctl - control signal for the type of multiply instruction
    // 00 - mul
    // 01 - mulh
    // 10 - mulsu
    // 11 - mulu
    wire [31:0] lo;
    wire [31:0] hi;
    reg [1:0] mode;
    wire mulresctl; // 0 - lo, 1 - hi
    wire mulresctl_buffered;

    // LUT for multiplier mode (sign interpretation)
    always @(*)
    begin
        case(mulctl)
            2'b00: mode <= 2'b01; // signed, lo
            2'b01: mode <= 2'b01; // signed, hi
            2'b10: mode <= 2'b10; // signed a unsigned b, hi
            2'b11: mode <= 2'b00; // unsigned, hi
        endcase
    end

    // mulresmux sel/ctl line
    assign mulresctl = ~(mulctl[1] | mulctl[0]);

    buffer #(
        .W(1),
        .L(8) // multiplier latency
    ) mulresctl_buff(
        .clk(clk),
        .in(mulresctl),
        .out(mulresctl_buffered)
    );

    mul32p mul(
        .clk(clk),
        .a(a),
        .b(b),
        .mode(mode),
        .hi(hi),
        .lo(lo)
    );

    mux #(
        .W(32),
        .N(2)
    ) mulresmux (
        .in({hi,lo}),
        .sel(mulresctl_buffered),
        .out(mulres)
    );
endmodule