module EX_Stage(
    // Pipeline inputs
    input [63:0] ReadData1,
    input [63:0] ReadData2,
    input [63:0] ImmExt,
    input [63:0] PC_in,
    input [3:0] ALU_Control,
    input ALUSrc,

    // Pipeline outputs
    output [63:0] ALU_Result,
    output zero,
    output [63:0] PC_Branch,

    // Debug outputs
    output [63:0] A_out,
    output [63:0] B_out,
    output [63:0] ALU_out
);

    wire [63:0] ALU_input2;

    // Select second operand based on ALUSrc control signal
    assign ALU_input2 = ALUSrc ? ImmExt : ReadData2;

    // Debug outputs
    assign A_out = ReadData1;
    assign B_out = ALU_input2;

    // ALU operation
    ALU_Unit alu (
        .A(ReadData1),
        .B(ALU_input2),
        .PC(PC_in),
        .ImmExt(ImmExt),
        .ALU_Control(ALU_Control),
        .opcode(), // provide this signal in top module
        .ALU_Result(ALU_Result),
        .zero(zero)
    );

    // Branch target address calculation: PC + Immediate
    Adder branch_adder (
        .in_1(PC_in),
        .in_2(ImmExt),
        .Sum_out(PC_Branch)
    );

    // Debug output
    assign ALU_out = ALU_Result;

endmodule
