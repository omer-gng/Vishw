module Control_Unit(
    input [6:0] instruction,
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp
);

// Control signal encoding: 
// {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp}

always @(*) begin
    case (instruction)
        // R-type instructions (add, sub, sll, slt, sltu, xor, srl, sra, or, and)
        7'b0110011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b001000_10;

        // I-type arithmetic instructions (addi, slti, sltiu, xori, ori, andi, slli, srli, srai)
        7'b0010011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b101000_10;

        // I-type load instructions (lb, lh, lw, lbu, lhu, lwu)
        7'b0000011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b111100_00;

        // S-type store instructions (sb, sh, sw, sd)
        7'b0100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b100010_00;

        // B-type branch instructions (beq, bne, blt, bge, bltu, bgeu)
        7'b1100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b000001_01;

        // J-type jump instruction: jal
        7'b1101111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b101000_00;

        // I-type jump instruction: jalr
        7'b1100111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b101000_00;

        // U-type: LUI (Load Upper Immediate)
        7'b0110111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b101000_00;

        // U-type: AUIPC (Add Upper Immediate to PC)
        7'b0010111: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b101000_00;

        default:    {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b000000_00; // NOP
    endcase
end

endmodule
