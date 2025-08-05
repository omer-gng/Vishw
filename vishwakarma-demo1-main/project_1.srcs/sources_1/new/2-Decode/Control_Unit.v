module Control_Unit(
    input  [6:0] instruction,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg [1:0] ALUOp
);

always @(*) begin
    // Default value
    {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b000000_00;

    case(instruction)
        // R-type: add, sub, and, or, sll, srl, sra
        7'b0110011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b001000_10;

        // Load (I-type): lw, lh, lb, etc.
        7'b0000011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b111100_00;

        // Store (S-type): sw, sh, sb, etc.
        7'b0100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b1x0010_00;

        // Branch (B-type): beq, bne, etc.
        7'b1100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b0x0001_01;

        // Add Immediate (I-type ALU)
        7'b0010011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b101000_10;

        // LUI
        7'b0110111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b1x1000_00;

        // AUIPC
        7'b0010111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b1x1000_00;

        // JAL
        7'b1101111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b0x1001_00;

        // JALR
        7'b1100111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = 8'b1x1001_00;
    endcase
end

endmodule
