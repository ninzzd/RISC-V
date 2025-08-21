module regfile(

);
    reg [31:0] registers [0:31];
    always @(*)
    begin
        registers[0] <= 32'h00000000;
    end
endmodule