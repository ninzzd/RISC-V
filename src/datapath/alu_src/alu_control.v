//Author: Rohan Singh
//Descriptions: ALU control unit for RISC-V 32I
module alu_control #(parameter T = 0.000)(
    input [31:0] a,b,
    input [3:0] alu_op,
    //alu_op 
    // 0000 - add
    // 0001 - sub
    // 0010 - xor
    // 0011 - or
    // 0100 - and   
    // 0101 - sll
    // 0110 - srl
    // 0111 - sra
    // 1000 - slt
    // 1001 - sltu
    output [31:0] result
);

    wire [31:0] add_b;
    wire        add_cin;
    wire [31:0] add_result;
    wire [31:0] sl_result;
    wire [31:0] sr_result;
    wire sr_mode;
    // wire [31:0] mul_lo;
    // wire [31:0] mul_hi;

    // Select b and cin for add/sub
    assign add_b  = (alu_op[0]) ? ~b : b;      // ~b for subtraction
    assign add_cin = (alu_op[0]) ? 1'b1 : 1'b0; // 1 for subtraction
    assign sr_mode = alu_op[0];

    // Instantiate the adder
    add32 #(.T(T)) u_add32 (
        .a(a),
        .b(add_b),
        .c_1(add_cin),
        .s(add_result)
    );
    shift_left32 #(.T(T)) sl32 (
        .inp(a),
        .shamt(b[4:0]),
        .res(sl_result)
    );
    shift_right32 #(.T(T)) sr32 (
        .inp(a),
        .shamt(b[4:0]),
        .mode(sr_mode),
        .res(sr_result)
    );
    slt_32 #(.T(T)) slt32 (
        .x1(a),
        .x2(b),
        .out(slt_result)
    );
    sltu_32 #(.T(T)) sltu32 (
        .x1(a),
        .x2(b),
        .out(sltu_result)
    );
    // mul32 #(.T(T)) u_mul32 (
    //     .a(a),
    //     .b(b),
    //     .lo(mul_lo),
    //     .hi(mul_hi),
    // )

    reg [31:0] result_reg;
    always @(*) begin
        casez (alu_op)
            4'b0000: result_reg = add_result; // add (structural)
            4'b0001: result_reg = add_result; // sub (structural)
            4'b0010: result_reg = a ^ b;
            4'b0011: result_reg = a | b;
            4'b0100: result_reg = a & b;
            4'b0101: result_reg = sl_result; // sll (structural)
            4'b011?: result_reg = sr_result; // srl/a (structural)
            4'b1000: result_reg = slt_result; //slt (structural)
            4'b1001: result_reg = sltu_result; //sltu (structural)
            default: result_reg = 32'b0;
        endcase
    end

    assign result = result_reg;

    
endmodule