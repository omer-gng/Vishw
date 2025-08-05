module ALU_Word(
    input  [3:0] A,
    input  [3:0] B,
    input  [3:0] Imm,
    input  [2:0] ALU_Control, // 3'b100=SLL, 3'b101=SRL, 3'b111=SRA
    input        is_imm_op,
    output reg [3:0] ALU_Result
);
    wire [1:0] shamt = is_imm_op ? Imm[1:0] : B[1:0]; 

    always @(*) begin
        case (ALU_Control)
            4'b0100: ALU_Result = A << shamt;       // SLL or SLLI
            4'b0101: ALU_Result = A >> shamt;       // SRL or SRLI
            4'b0111: ALU_Result = $signed(A) >>> shamt; // SRA or SRAI
            default: ALU_Result = 4'h0000;
        endcase
    end
endmodule
