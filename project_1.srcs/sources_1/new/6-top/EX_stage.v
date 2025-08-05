module EX_Stage(
    input  [3:0] ReadData1,
    input  [3:0] ReadData2,
    input  [3:0] Imm,
    input  [3:0] PC_in,
    input  [3:0] ALU_Control,
    input        ALUSrc,
    input        Branch,

    output [3:0] ALU_Result,
    output       zero,
    output [3:0] PC_Branch,
    output       branch_taken,
    output [3:0] A_out,
    output [3:0] B_out
);
    wire [3:0] operand_b = ALUSrc ? Imm : ReadData2;
    wire [3:0] alu_res;
    wire z;
    wire lt_s, lt_u;

    ALU alu (
        .A(ReadData1),
        .B(operand_b),
        .alu_ctrl(ALU_Control),
        .result(alu_res),
        .zero(z),
        .lt_signed(lt_s),
        .lt_unsigned(lt_u)
    );

    assign ALU_Result    = alu_res;
    assign zero          = z;
    assign A_out         = ReadData1;
    assign B_out         = operand_b;
    assign branch_taken  = Branch & z; // BEQ style
    assign PC_Branch     = PC_in + Imm; // target = PC + immediate
endmodule 