module datapath #(
    parameter pcmux_N = 2,
    parameter ifuresctl_N = 2
) (
    input clk,
    input [$clog2(pcmux_N)-1:0] pcmuxctl, // select/control signal for pcmux
    input pcnextctl, // control signal for updating/asserting new value onto pc
    input instrre, // control signal to fetch new instruction (instruction read enable)
    input regwe, // register write-enable
    input regre, // register read-enable
    input mulstart, // enable signal for MU
    input [3:0] aluctl, // control signal for ALU
    input [1:0] mulctl, // control signal for MU 
    input [$clog2(ifuresctl_N)-1:0] ifuresctl, // control signal for ifuresmux

    output [6:0] opcode,
    output [2:0] func3,
    output [1:0] func7b50, // For R-type, func7 = 0x00 (b5 is 0) or 0x20 (b5 is 1) 
    output exdone // valid signal from EX stage
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
    wire mudone;
    wire qrudone;
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // Stage 1: Instruction Fetch (IF)
    instr_mem #(
        .N(2**10)
    ) imem ( // simple instruction memory with clocked LUT
        .a(pc),
        .rd(instr),
        .re(instrre),
        .clk(clk)
    );
    assign opcode = instr[6:0];
    assign func3 = instr[14:12];
    assign func7b50 = {instr[30],instr[25]};
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // Stage 2: Instruction Decode (ID)
    // regfile
    regfile_int rfi(
        .clk(clk),
        .ra1(instr[19:15]), // rs1
        .ra2(instr[24:20]), // rs2
        .rd1(a), // value at rs1
        .rd2(b), // value at rs2
        .wa1(instr[11:7]), // rd
        .wd1(regwrite), // Stage 5: Write Back (WB)
        .we(regwe),
        .re(regre)
    );
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // Stage 3: Execute (EX)
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
        .clk(clk),
        .start(mulstart),
        .a(a),
        .b(b),
        .mulctl(mulctl),
        .mulres(mulres),
        .done(mudone)
    );
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // QRU (Divider or Quotient and Reminder Unit)
        // must add rohan's divider module instance
        // div32 divunit (
        //     .clk(clk),
        //     .rst(1'b0), // no reset
        //     .start(1'b0), // not used currently
        //     .is_signed(1'b0), // unsigned division
        //     .dividend_in(a),
        //     .divisor_in(b),
        //     .quotient(divres),
        //     .remainder() // remainder not used currently
        // );
        // Some issue still persists, must debug later
    // -----------------------------------------------------------

    mux #(
        .W(32),
        .N(2)
    ) ifuresmux( // mux for integer functional unit (IFU = ALU + MU + QRU)
        .in({mulres,alures}),
        .sel(ifuresctl), // 0 => ALU, 1 => MU
        .out(regwrite)
    );
    mux #(
        .W(1),
        .N(2)
    ) exdonemux( // mux for EX stage done signal
        .in({mudone,1'b1}), // ALU is combinational (for now, can be pipelined later if necessary)
        .sel(ifuresctl),
        .out(exdone)
    );
    
    // -----------------------------------------------------------
    // Stage 5: Write Back (WB)
    // logic for pcnext
    add32 pc_adder (
        .a(pc),
        .b(32'd4),
        .c_1(1'b0),
        .s(pcadd4)
    );
    mux #(.W(32), .N(pcmux_N)) pc_mux (
        .in({{32{1'b0}},pcadd4}), // for now, only allows pcadd4 (testing R-type instructions only)
        .sel(pcmuxctl), // (for now) pcsrc = 0 => pcadd4
        .out(pcnext)
    );
    // pc update
    always @(posedge clk) begin
        if(pcnextctl)
            pc <= pcnext;
    end
    // -----------------------------------------------------------
endmodule