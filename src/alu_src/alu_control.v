//Author: Rohan Singh
//Descriptions: ALU control unit for RISC-V 32I
module alu_control(
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
    // 1000 - sltu
    output [31:0] result
);

    wire [31:0] add_b;
    wire        add_cin;
    wire [31:0] add_result;

    // Select b and cin for add/sub
    assign add_b  = (alu_op[0]) ? ~b : b;      // ~b for subtraction
    assign add_cin = (alu_op[0]) ? 1'b1 : 1'b0; // 1 for subtraction

    // Instantiate the adder
    add32 u_add32 (
        .a(a),
        .b(add_b),
        .c_1(add_cin),
        .s(add_result)
    );

    reg [31:0] result_reg;
    always @(*) begin
        case (alu_op)
            4'b0000: result_reg = add_result; // add
            4'b0001: result_reg = add_result; // sub
            4'b0010: result_reg = a ^ b;
            4'b0011: result_reg = a | b;
            4'b0100: result_reg = a & b;
            4'b0101: result_reg = b << a[4:0];
            4'b0110: result_reg = b >> a[4:0];
            4'b0111: result_reg = $signed(b) >>> a[4:0];
            4'b1000: result_reg = (a < b) ? 32'b1 : 32'b0;
            default: result_reg = 32'b0;
        endcase
    end

    assign result = result_reg;

    
endmodule