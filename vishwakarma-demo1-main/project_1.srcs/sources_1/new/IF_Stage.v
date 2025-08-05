module IF_Stage(
    input clk,
    input reset,
    input sel2,                 // Select line for Mux2
    input [31:0] branch_target, // Input B for Mux2, used in branches
    output [31:0] PC_out,
    output [31:0] instruction_out
);

    wire [31:0] PC_current;
    wire [31:0] PC_plus4;
    wire [31:0] PC_next;

    // PC = PC + 4
    PC_plus4 pc_add(
        .fromPC(PC_current),
        .NextoPC(PC_plus4)
    );

    // Mux to choose between PC+4 and branch target
    Mux2 pc_mux(
        .sel2(sel2),
        .A2(PC_plus4),
        .B2(branch_target),
        .Mux2_out(PC_next)
    );

    // Program Counter
    Program_Counter pc_reg(
        .clk(clk),
        .reset(reset),
        .PC_in(PC_next),
        .PC_out(PC_current)
    );

    // Instruction Memory
    Instruction_Mem instr_mem(
        .clk(clk),
        .reset(reset),
        .read_address(PC_current),
        .instruction(instruction_out)
    );

    assign PC_out = PC_current;

endmodule 
