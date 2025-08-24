module regfile(
    input wr_en,
    input [4:0] wr_addr,
    input [31:0] wr_data,
    output pc
);
    reg [31:0] registers [0:31];
    reg pc;
    always @(*)
    begin
        registers[0] <= 32'h00000000;
    end
endmodule