module mu(
    input clk,
    input strb,
    input [31:0] a,
    input [31:0] b,
    input [1:0] mulctl,
    output [31:0] mulres,
    output valid
);
    // mulctl - control signal for the type of multiply instruction
    // 00 - mul
    // 01 - mulh
    // 10 - mulsu
    // 11 - mulhu
    reg [31:0] a_;
    reg [31:0] b_;
    reg [1:0] mulctl_;
    reg desired_op;

    wire [31:0] lo;
    wire [31:0] hi;
    reg [1:0] mode;
    wire mulresctl; // 0 - lo, 1 - hi
    wire mulresctl_buffered;

    // Buffer inputs to determine validity
    always @(posedge clk)
    begin
        if(strb) 
        begin
            a_ <= a;
            b_ <= b;
            mulctl_ <= mulctl;
        end
        desired_op <= strb;
    end
    // LUT for multiplier mode (sign interpretation)
    always @(*)
    begin
        case(mulctl_)
            2'b00: mode <= 2'b01; // signed, lo
            2'b01: mode <= 2'b01; // signed, hi
            2'b10: mode <= 2'b10; // signed a unsigned b, hi
            2'b11: mode <= 2'b00; // unsigned, hi
        endcase
    end

    // mulresmux sel/ctl line
    assign mulresctl = mulctl_[1] | mulctl_[0];

    buffer #(
        .W(2),
        .L(8) // multiplier latency
    ) mulresctl_buff(
        .clk(clk),
        .in({desired_op,mulresctl}),
        .out({valid,mulresctl_buffered})
    );

    mul32p mul(
        .clk(clk),
        .a(a_),
        .b(b_),
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