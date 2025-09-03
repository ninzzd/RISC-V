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
    reg [34:0] remainder_ext; //to allow us to store 35 bit remainder while computing
    reg [31:0] divisor_abs, dividend_abs;
    reg [3:0] count;//=11;
    reg busy;
    reg sign_quotient, sign_remainder;
    reg [2:0] q_digit;
    wire [37:0] remainder_shifted = remainder_ext<<3;
    // Start handling and input absolute value conversion
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            remainder_ext <= 0;
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
            count <= 11;               // 11 cycles required as 3 bit division at once

            // Signed or unsigned absolute values
            if (is_signed) begin
                sign_quotient <= dividend_in[31] ^ divisor_in[31];
                sign_remainder <= dividend_in[31];

                // Take absolute values of the number
                dividend_abs <= (dividend_in[31]) ? (~dividend_in + 1) : dividend_in;
                divisor_abs <= (divisor_in[31]) ? (~divisor_in + 1) : divisor_in;
            end else begin
                dividend_abs <= dividend_in;
                divisor_abs <= divisor_in;
                sign_quotient <= 0;
                sign_remainder <= 0;
            end
            remainder_ext <= {3'b0, dividend_abs};  // Extend dividend by 3 bits
            quotient <= 0;
            $display("----- New Division Start -----");
            $display("Dividend = %0d, Divisor = %0d (signed=%0d)", 
                     (is_signed ? $signed(dividend_in) : dividend_in),
                     (is_signed ? $signed(divisor_in) : divisor_in),
                     is_signed);
        end else if (busy && count > 0) begin
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
                if (remainder_shifted >= divisor_abs * 7) q_digit = 3'd7;
                else if (remainder_shifted >= (divisor_abs<<1+divisor_abs<<2)) q_digit = 3'd6;
                else if (remainder_shifted >= (divisor_abs<<2+divisor_abs)) q_digit = 3'd5;
                else if (remainder_shifted >= (divisor_abs<<2)) q_digit = 3'd4;
                else if (remainder_shifted >= (divisor_abs<<1+divisor_abs)) q_digit = 3'd3;
                else if (remainder_shifted >= (divisor_abs<<1)) q_digit = 3'd2;
                else if (remainder_shifted >= divisor_abs) q_digit = 3'd1;
                else q_digit = 3'd0;
                
                remainder_ext <= (remainder_ext<<3) - q_digit * divisor_abs;
                quotient <= (quotient << 3) | q_digit;
                count <= count - 1;
                $display("Cycle %0d: q_digit=%0d, quotient=%0d, remainder_ext=%0d",
                         (12 - count), q_digit, quotient, remainder_shifted - q_digit * divisor_abs);
            end
        end else if(count==0 && busy) begin
            if (is_signed && dividend_in == 32'h80000000 && divisor_in == 32'hFFFFFFFF) begin
                quotient <= 32'h80000000;
                remainder <= 0;
            end else begin
                // sign correction
                if (is_signed && sign_quotient) begin
                    quotient <= ~quotient + 1;
                    remainder <= (is_signed && sign_remainder)? ~remainder_ext[34:3] + 1: remainder_ext[34:3];
                end else begin
                    remainder <= remainder_ext[34:3];
                end
                done <=1;
                busy <=0;
                $display("----- Final Result -----");
                $display("Quotient = %0d", (is_signed ? $signed(quotient) : quotient));
                $display("Remainder = %0d", (is_signed ? $signed(remainder) : remainder));
                $display("-------------------------\n");
            end
        end
    end
endmodule
