module risc_v #(parameter T = 0.000)(

);

wire [31:0] PCF', PCF, PCPlus4F,InstrD,RD1E,RD2E, PCD, PCE, Rs1D, Rs1E, Rs2D, Rs2E, RdD, RdE, RdM, ImmExtD, ImmExtE;
wire [31:0] PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
wire [31:0] SrcAE, SrcBE, WriteDataE, WriteDataM, ALUResultE, ALUResultM, ALUResultW, ReadDataM, ReadDataW, ResultW;
wire ZeroE;
wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
wire [2:0] ALUControlD, ALUControlE;
wire [1:0] ImmSrcD, ResultSrcD, ResultSrcE, ResultSrcM, ResultSrcW;
wire RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
wire RegWriteM,MemWriteM, RegWriteW;
wire [31:0] StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE;
wire PCSrcE;

wire [31:0] InstrRD, RD1RD, RD2RD;

//Control Unit
control_unit CU (
    .op(InstrD[6:0]),
    .funct3(InstrD[14:12]),
    .funct7(InstrD[30]),
    .RegWriteD(RegWriteD),
    .MemWriteD(MemWriteD),
    .JumpD(JumpD),
    .BranchD(BranchD),
    .ALUSrcD(ALUSrcD),
    .ImmSrcD(ImmSrcD),
    .ResultSrcD(ResultSrcD),
    .ALUControlD(ALUControlD)
);

//l1 instruction cache
l1_instr_cache #(.size(8192)) L1I (
    .addr(PCF),
    .instr(InstrRD)
);

//PC + 4 adder
add32 #(.T(T)) pc_add4 (
    .a(PCF),
    .b(32'd4),
    .c_1(1'b0),
    .s(PCPlus4F)
);

//Register File
regfile_int RegFile (
    .clk(clk),
    .ra1(InstrD[19:15]),
    .ra2(InstrD[24:20]),
    .wa1(RdW),
    .dw1(ResultW),
    .we(RegWriteW),
    // .pcnext(PCPlus4W),
    .dr1(RD1E),
    .dr2(RD2E)
);

// Sign Extend

//#TODO: Implement sign extension module

//SrcA Forward Mux
mux3 #(.width(32)) SrcAMux (
    .in0(RD1E),
    .in1(ResultW),
    .in2(ALUResultM),
    .sel(ForwardAE),
    .out(SrcAE)
);

//SrcB Forward Mux
mux3 #(.width(32)) SrcBMux (
    .in0(RD2E),
    .in1(ResultW),
    .in2(ALUResultM),
    .sel(ForwardBE),
    .out(WriteDataE)
);

//SrcB Mux

mux2 #(.width(32)) SrcBMux2 (
    .in0(WriteDataE),
    .in1(ImmExtE),
    .sel(ALUSrcE),
    .out(SrcBE)
);

//ALU
alu_control #(.T(T)) ALU (
    .a(SrcAE),
    .b(SrcBE),
    .alu_op(ALUControlE),
    .result(ALUResultE),
    .zero(ZeroE)
);

//PC Target adder
add32 #(.T(T)) pc_target (
    .a(PCPlus4E),
    .b(ImmExtE),
    .c_1(1'b0),
    .s(PCTargetE)
);

//Data Memory
data_mem #(.size(8192)) DataMem (
    .clk(clk),
    .addr(ALUResultM),
    .we(MemWriteM),
    .wd(WriteDataM),
    .rd(ReadDataM)
);

//Result Mux
mux3 #(.width(32)) ResultMux (
    .in0(ALUResultW),
    .in1(ReadDataW),
    .in2(PCPlus4W),
    .sel(ResultSrcW),
    .out(ResultW)
);
endmodule
