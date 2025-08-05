module IF_Stage(
    input  wire       clk,
    input  wire       reset,
    input  wire       sel2,             // branch control
    input  wire [3:0] branch_target,    // branch target address
    output wire [3:0] PC_out,           // current PC
    output wire [7:0] instruction_out   // fetched instruction
);
    wire [3:0] pc_current;
    wire [3:0] pc_plus;
    wire [3:0] next_PC;

    Program_Counter PC (
        .clk(clk),
        .reset(reset),
        .PC_in(next_PC),
        .PC_out(pc_current)
    );

    assign PC_out = pc_current;

    Instruction_Mem Inst_Mem (
        .clk(clk),
        .reset(reset),
        .read_address(pc_current),
        .instruction_out(instruction_out)
    );

  //  PC_plus4 pc_plus4_inst (
    //    .fromPC(pc_current),
      //  .NextoPC(pc_plus)
    //);

    Mux2 PC_mux (
        .sel2(sel2),
        .A2(pc_plus),
        .B2(branch_target),
        .Mux2_out(next_PC)
    );
endmodule 