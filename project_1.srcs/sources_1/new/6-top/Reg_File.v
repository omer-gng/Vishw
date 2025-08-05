module Reg_File(
    input        clk,
    input        reset,
    input        RegWrite,
    input  [1:0] Rs1,          
    input  [1:0] Rs2,
    input  [1:0] Rd,
    input  [3:0] Write_data,
    output [3:0] read_data1,
    output [3:0] read_data2
);
    reg [3:0] Registers [0:3];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1)
                Registers[i] <= 4'b0;
        end else if (RegWrite) begin
            Registers[Rd] <= Write_data;
        end
    end

    assign read_data1 = Registers[Rs1];
    assign read_data2 = Registers[Rs2];
endmodule 