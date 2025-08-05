module EX_Stage(
    // Pipeline inputs
    input [63:0] ReadData1,
    input [63:0] ReadData2,
    input [31:0] ImmExt,
    input [63:0] PC_in,
    input [3:0]  ALU_Control,
    input [2:0]  funct3,
    input        ALUSrc,
    
    // Control signals
    input is_word_op,
    input is_imm_op,
    input is_branch,
    input is_jump,
    input is_loadstore,
    input is_u_type,
    input is_jalr,
    input sel_u_type,
    input is_load,

    // Pipeline outputs
    output [63:0] ALU_Result,
    output        zero,
    output [63:0] PC_Branch,

    // Debug outputs
    output [63:0] A_out,
    output [63:0] B_out,
    output [63:0] ALU_out
);

    wire [63:0] ALU_input2;
    wire [63:0] branch_target_internal;
    wire [63:0] store_data;
    wire [63:0] link_addr;
    wire        branch_taken;

    // Operand selection
    assign ALU_input2 = ALUSrc ? {{32{ImmExt[31]}}, ImmExt} : ReadData2;

    // Debug outputs
    assign A_out = ReadData1;
    assign B_out = ALU_input2;

    // ALU Unit instantiation
    ALU_Unit alu (
        .A(ReadData1),
        .B(ALU_input2),
        .Imm(ImmExt),
        .ALU_Control(ALU_Control),
        .funct3(funct3),
        .PC(PC_in),
        .is_word_op(is_word_op),
        .is_imm_op(is_imm_op),
        .is_branch(is_branch),
        .is_jump(is_jump),
        .is_loadstore(is_loadstore),
        .is_u_type(is_u_type),
        .is_jalr(is_jalr),
        .sel_u_type(sel_u_type),
        .is_load(is_load),
        .ALU_result(ALU_Result),
        .zero(zero),
        .branch_taken(branch_taken),
        .branch_target(branch_target_internal),
        .store_data(store_data),
        .link_addr(link_addr)
    );

    // Use Adder to compute PC + ImmExt as PC_Branch
    Adder branch_adder (
        .in_1(PC_in),
        .in_2({{32{ImmExt[31]}}, ImmExt}),  // Sign-extend ImmExt to 64 bits
        .Sum_out(PC_Branch)
    );

    // ALU output for debug
    assign ALU_out = ALU_Result;

endmodule
