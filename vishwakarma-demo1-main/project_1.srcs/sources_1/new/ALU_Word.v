module ALU_Word(
    input [63:0] A,
    input [63:0] B,
    input [31:0] Imm,
    input [3:0] ALU_Control,
    input       is_imm_op,
    output reg [63:0] ALU_Result
);

    wire [5:0] shamt = is_imm_op ? Imm[5:0] : B[5:0];

    always @(*) begin
        case (ALU_Control)
            4'b0100: ALU_Result = A << shamt;       // SLL or SLLI
            4'b0101: ALU_Result = A >> shamt;       // SRL or SRLI
            4'b0111: ALU_Result = $signed(A) >>> shamt; // SRA or SRAI
            default: ALU_Result = 64'hDEAD_BEEF_DEAD_BEEF;
        endcase
    end
endmodule
