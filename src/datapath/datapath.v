module datapath #(
    parameter pcmux_N = 2;
) (
    input clk,
    input [$clog2(pcmux_N)-1:0] pcsrc
);
    // -----------------------------------------------------------
    // Regs
    reg [31:0] pc;
    // Wires
    wire [31:0] pcadd4;
    wire [31:0] pcnext;
    wire [31:0] instr;
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // logic for pcnext
    add32 pc_adder (
        .a(pc),
        .b(32'd4),
        .c_1(1'b0),
        .s(pcadd4)
    );
    mux #(.W(32), .N(pcmux_N)) pc_mux (
        .in({pcadd4}), // TODO: add other inputs for branch/jump
        .sel(pcsrc), // (for now) pcsrc = 0 => pcadd4
        .out(pcnext)
    );
    // pc update
    always @(posedge clk) begin
        pc <= pcnext;
    end
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // instruction fetch
    instr_mem imem ( // simple instruction memory with clocked LUT
        .a(pc),
        .rd(instr),
        // .re(instr_mem_re),
        .clk(clk)
    );
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // regfile
    regfile_int rfi(
        .clk(clk),
        .ra1(),
        .ra2(),
        .rd1(),
        .rd2(),
        .wa1(),
        .wd1(),
        .we()
    );
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // ALU
    alu alu1(
        .a(),
        .b(),
        .aluop(),
        .result(),
        .zero()
    )
    // -----------------------------------------------------------
endmodule