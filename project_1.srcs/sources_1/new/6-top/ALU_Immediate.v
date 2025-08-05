module ALU_Immediate (
    input [3:0] A,
    input [1:0] Imm,
    input [3:0] ALU_Control,
    output reg [3:0] ALU_Result
);

    always @(*) begin
        case (ALU_Control)
            4'b0000: ALU_Result = A & Imm;          // andi
            4'b0001: ALU_Result = A | Imm;          // ori
            4'b0010: ALU_Result = A + Imm;          // addi
            4'b0011: ALU_Result = A ^ Imm;          // xori
            4'b0111: ALU_Result = $signed(A) >>> Imm[1:0]; // srai
            4'b1000: ALU_Result = ($signed(A) < $signed(Imm)) ? 4'd1 : 4'd0; // slti
            4'b1001: ALU_Result = (A < Imm) ? 4'd1 : 4'd0; // sltiu
            default: ALU_Result = 0000;
        endcase
    end
endmodule