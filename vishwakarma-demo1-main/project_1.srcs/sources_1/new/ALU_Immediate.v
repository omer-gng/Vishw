module ALU_Immediate(
    input [31:0] A,
    input [31:0] Imm,
    input [3:0] ALU_Control,
    output reg [31:0] ALU_Result
);

    always @(*) begin
        case (ALU_Control)
            4'b0000: ALU_Result = A & Imm;          // andi
            4'b0001: ALU_Result = A | Imm;          // ori
            4'b0010: ALU_Result = A + Imm;          // addi
            4'b0011: ALU_Result = A ^ Imm;          // xori
            4'b0100: ALU_Result = A << Imm[4:0];    // slli
            4'b0101: ALU_Result = A >> Imm[4:0];    // srli
            4'b0111: ALU_Result = $signed(A) >>> Imm[4:0]; // srai
            4'b1000: ALU_Result = ($signed(A) < $signed(Imm)) ? 1 : 0; // slti
            4'b1001: ALU_Result = (A < Imm) ? 1 : 0; // sltiu
            default: ALU_Result = 32'hBAD_F00D;
        endcase
    end
endmodule 
