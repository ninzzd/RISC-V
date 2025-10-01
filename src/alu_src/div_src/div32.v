//Author: Rohan Singh
//Descriptions: Radix 8 divider for 32I with signed and unsigned support
module div32 (
    input wire clk,
    input wire rst,
    input wire start,
    input wire is_signed,               // 1 for signed div/rem, 0 for unsigned
    input wire [31:0] dividend_in,
    input wire [31:0] divisor_in,
    output reg [31:0] quotient,
    output reg [31:0] remainder,
    output reg done
);
    reg [35:0] remainder_calc;
    reg [31:0] divisor_abs;
    reg [31:0] dividend_abs;
    reg [3:0] count;
    reg busy;
    reg sign_quotient, sign_remainder;
    reg [3:0] q_digit;

    // reg [2:0] q_digit;
    // reg [34:0] remainder_calc; //to allow us to store 35 bit remainder while computing
    // reg [31:0] divisor_abs;
    // reg [3:0] count;//=11;
    // reg busy;
    // reg sign_quotient, sign_remainder;
    // reg [2:0] q_digit;
    // wire [37:0] remainder_shifted = remainder_calc<<3;
    // reg [31:0]dividend_abs;
    // Start handling and input absolute value conversion
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            remainder_calc <= 0;
            divisor_abs <= 0;
            dividend_abs <= 0;
            count <= 0;
            done <= 0;
            busy <= 0;
            sign_quotient <= 0;
            sign_remainder <= 0;
        end else if (start && !busy) begin
            done <= 0;
            busy <= 1;
            count <=8;               // 8 cycles required as 4 bit division at once
            // Signed or unsigned absolute values
            if (is_signed) begin
                sign_quotient = dividend_in[31] ^ divisor_in[31];
                sign_remainder = dividend_in[31];
                // Take absolute values of the number
                divisor_abs = (divisor_in[31]) ? (~divisor_in + 1) : divisor_in;
                dividend_abs = sign_remainder ? (~dividend_in + 1) : dividend_in;    
            end else begin
                divisor_abs = divisor_in;
                dividend_abs = dividend_in;
                sign_quotient = 0;
                sign_remainder = 0;
            end
            remainder_calc = {31'b0, dividend_abs[31:28]}; 
            dividend_abs = dividend_abs<<4;
            quotient <= 0;
            $display("----- New Division Start -----");
            $display("Dividend = %0d, Divisor = %0d (signed=%0d)", 
                     (is_signed ? $signed(dividend_in) : dividend_in),
                     (is_signed ? $signed(divisor_in) : divisor_in),
                     is_signed);
        end else if (busy && count > 0) begin //&& dividend_abs > 0
            if (divisor_abs == 0) begin
                // division by zero case
                quotient  <= 32'hFFFFFFFF;
                remainder <= dividend_in;
                done      <= 1;
                busy      <= 0;
                count     <= 0;
                $display("Division by zero detected!");
            end else begin
                // Quotient digit selection (unsigned trial)
                if (remainder_calc >= (divisor_abs << 4) - divisor_abs)                             q_digit = 4'd15;
                else if (remainder_calc >= (divisor_abs << 4) - (divisor_abs << 1))                 q_digit = 4'd14;
                else if (remainder_calc >= (divisor_abs << 4) - (divisor_abs << 1) - divisor_abs)   q_digit = 4'd13;
                else if (remainder_calc >= (divisor_abs << 3) + (divisor_abs << 2))                 q_digit = 4'd12;
                else if (remainder_calc >= (divisor_abs << 3) + (divisor_abs << 1) + divisor_abs)   q_digit = 4'd11;
                else if (remainder_calc >= (divisor_abs << 3) + (divisor_abs << 1))                 q_digit = 4'd10;
                else if (remainder_calc >= (divisor_abs << 3) + divisor_abs)                        q_digit = 4'd9;
                else if (remainder_calc >= (divisor_abs << 3))                                      q_digit = 4'd8;
                else if (remainder_calc >= (divisor_abs << 2) + (divisor_abs << 1) + divisor_abs)   q_digit = 4'd7;
                else if (remainder_calc >= (divisor_abs << 2) + (divisor_abs << 1))                 q_digit = 4'd6;
                else if (remainder_calc >= (divisor_abs << 2) + divisor_abs)                        q_digit = 4'd5;
                else if (remainder_calc >= (divisor_abs << 2))                                      q_digit = 4'd4;
                else if (remainder_calc >= (divisor_abs << 1) + divisor_abs)                        q_digit = 4'd3;
                else if (remainder_calc >= (divisor_abs << 1))                                      q_digit = 4'd2;
                else if (remainder_calc >= divisor_abs)                                             q_digit = 4'd1;
                else                                                                                q_digit = 4'd0;
                
                // Update remainder and quotient
                if(count>1)
                    remainder_calc <= (remainder_calc - q_digit * divisor_abs)<<4|dividend_abs[31:28];
                else
                    remainder_calc <= (remainder_calc - q_digit * divisor_abs);
                dividend_abs <= dividend_abs<<4;
                quotient <= (quotient << 4) | q_digit;
                count <= count - 1;
                $display("Cycle %0d: q_digit=%0d, quotient=%0d, remainder_calc=%0d",
                         (8 - count), q_digit, quotient, remainder_calc);
                // $display("dividend_abs=%b",dividend_abs);
            end
        end else if((count==0) && busy) begin //||dividend_abs==0
            if (is_signed && dividend_in == 32'h80000000 && divisor_in == 32'hFFFFFFFF) begin
                quotient <= 32'h80000000;
                remainder <= 0;
            end else begin
                // sign correction
                if (is_signed && sign_quotient) 
                    quotient <= ~quotient + 1;
                remainder <= (is_signed && sign_remainder)? ~remainder_calc + 1: remainder_calc;
            end
            done <=1;
            busy <=0;
            $display("Cycle %0d: q_digit=%0d, quotient=%0d, remainder_calc=%0d",
                         (8 - count), q_digit, quotient, remainder_calc);
            $display("----- Division End -----");
        end
    end
    
endmodule
