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
    input bmuxctl, // control signal for B input mux to ALU
    input [3:0] aluctl, // control signal for ALU
    input mulstart, // enable signal for MU
    input [1:0] mulctl, // control signal for MU 
    input [$clog2(ifuresctl_N)-1:0] ifuresctl, // control signal for ifuresmux
    input dmemwe, // data memory write enable
    input [2:0] dmctl, // control signal for data memory
    input regwctl, // control signal for regwmux

    output [6:0] opcode,
    output [2:0] func3,
    output [1:0] func7b50, // For R-type, func7 = 0x00 (b5 is 0) or 0x20 (b5 is 1) 
    output exdone // valid signal from EX stage
);
    // -----------------------------------------------------------
    // Regs
    reg [31:0] pc; // must be intiliazed for testing (to 0x00000000)
    initial begin
        pc <= 32'd0;
    end
    // -----------------------------------------------------------

    // Wires
    wire [31:0] pcadd4;
    wire [31:0] pcnext;
    wire [31:0] instr;
    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] breg;
    wire [31:0] bimm;
    wire [31:0] regw;
    wire [31:0] alures;
    wire aluzero;
    wire [31:0] mulres;
    wire [31:0] divres;
    wire mudone;
    wire qrudone;
    wire [31:0] dmres;
    wire [31:0] ifures;
    wire [11:0] store_imm;
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
    assign store_imm = {instr[31:25], instr[11:7]}; // for S-type store instructions, not used for now
    // -----------------------------------------------------------

    // -----------------------------------------------------------
    // Stage 2: Instruction Decode (ID)
    // regfile
    regfile_int rfi(
        .clk(clk),
        .ra1(instr[19:15]), // rs1
        .ra2(instr[24:20]), // rs2
        .rd1(a), // value at rs1
        .rd2(breg), // value at rs2
        .wa1(instr[11:7]), // rd
        .wd1(regw), // Stage 5: Write Back (WB)
        .we(regwe),
        .re(regre)
    );
    sign_ext se ( // input must be multiplexed later (I-type vs S-type)
        .in(instr[31:20]), // I-type immediate
        .out(bimm) // not used for R-type instructions
    );
    mux #(
        .W(32),
        .N(2)
    ) bmux( // mux for selecting between register value and immediate for B input to ALU
    /* 
        Note: In case of I-type, instr[24:20] may not correspond to any valid address, causing breg to be X
        Even with bmuxctl = 0, b = X.0 + bimm.1 = X (not bimm)
        X is not treated as garbage values
    */
        .in({(breg === 32'dx ? 32'd0 : breg),bimm}), // ternary condition is only for simulation, to handle X values
        .sel(bmuxctl), // 1 => register value, 0 => immediate (justification for this choice: directly equals opcode[5])
        .out(b)
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
        .b(breg), // path through MU is active for R-type instructions only
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
    data_mem dmem(
        .clk(clk),
        .a(alures),
        .wd(breg),
        .we(dmemwe),
        .ctl(dmctl),
        .rd(dmres)
    );

    mux #(
        .W(32),
        .N(2)
    ) ifuresmux( // mux for integer functional unit (IFU = ALU + MU + QRU)
        .in({mulres,alures}),
        .sel(ifuresctl), // 0 => ALU, 1 => MU
        .out(ifures)
    );
    mux #(
        .W(1),
        .N(2)
    ) exdonemux( // mux for EX stage done signal
        .in({mudone,1'b1}), // ALU is combinational (for now, can be pipelined later if necessary)
        .sel(ifuresctl),
        .out(exdone)
    );
    
    mux #(
        .W(32),
        .N(2)
    ) regwmux( // mux for WB stage (input from MEM or EX)
        .in({dmres,ifures}), 
        .sel(regwctl),
        .out(regw)
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