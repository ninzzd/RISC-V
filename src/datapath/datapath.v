module datapath #(
    parameter pcmux_N = 2;
    parameter ifuresctl_N = 2;
) (
    input clk,
    input [$clog2(pcmux_N)-1:0] pcctl, // select/control signal for pcmux
    input regwe, // register write-enable
    input [3:0] aluctl, // control signal for ALU
    input [1:0] mulctl, // control signal for MU 
    input [$clog2(ifuresctl_N)-1:0] ifuresctl // control signal for ifuresmux

    output [6:0] opcode,
    output [2:0] func3,
    output func7b5 // For R-type, func7 = 0x00 (b5 is 0) or 0x20 (b5 is 1) 
);
    // -----------------------------------------------------------
    // Regs
    reg [31:0] pc;

    // Wires
    wire [31:0] pcadd4;
    wire [31:0] pcnext;
    wire [31:0] instr;
    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] regwrite;
    wire [31:0] alures;
    wire aluzero;
    wire [31:0] mulres;
    wire [31:0] divres;
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
        .in({{32{1'b0}},pcadd4}), // for now, only allows pcadd4 (testing R-type instructions only)
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
    assign func3 = instr[14:12];
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // regfile
    regfile_int rfi(
        .clk(clk),
        .ra1(instr[19:15]), // rs1
        .ra2(instr[24:20]), // rs2
        .rd1(a), // value at rs1
        .rd2(b), // value at rs2
        .wa1(instr[11:7]), // rd
        .wd1(regwrite),
        .we(regwe)
    );
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // ALU
    alu ALU(
        .a(a),
        .b(b),
        .aluop(aluctl),
        .result(alures),
        .zero(aluzero)
    );
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // MU (Multiply Unit)
    mu MU(
        .clk(clk)
        .a(a),
        .b(b),
        .mulctl(mulctl),
        .mulres(mulres)
    );
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // QRU (Divider or Quotient and Reminder Unit)
        // must add rohan's divder module instance
    // -----------------------------------------------------------

    mux #(
        .W(32),
        .N(2)
    ) ifuresmux( // mux for integer functional unit (IFU = ALU + MU + QRU)
        .in({mulres,alures}),
        .sel(ifuresctl),
        .out(regwrite)
    );
    
endmodule