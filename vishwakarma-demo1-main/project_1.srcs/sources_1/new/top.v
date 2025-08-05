module top(
    input clk,
    input reset,
    output [31:0] instr_out,
    output [31:0] A,
    output [31:0] B,
    output [31:0] ALU_Result
);
    // Pipeline registers
    reg [31:0] PC_IF_ID, instr_IF_ID;
    reg [31:0] PC_ID_EX, Imm_ID_EX, RD1_ID_EX, RD2_ID_EX;
    reg [3:0]  ALU_ctrl_ID_EX;
    reg [2:0]  funct3_ID_EX;
    reg        Branch_ID_EX, MemRead_ID_EX, MemWrite_ID_EX, ALUSrc_ID_EX, RegWrite_ID_EX, MemtoReg_ID_EX;
    reg [31:0] ALU_result_EX_MEM, WriteData_EX_MEM;
    reg [2:0]  funct3_EX_MEM;
    reg        MemRead_EX_MEM, MemWrite_EX_MEM, RegWrite_EX_MEM, MemtoReg_EX_MEM;
    reg [31:0] Mem_Data_MEM_WB, ALU_result_MEM_WB;
    reg        RegWrite_MEM_WB, MemtoReg_MEM_WB;

    // Wires
    wire [31:0] PC_IF, instr_IF;
    wire [31:0] Imm_ID, RD1_ID, RD2_ID;
    wire [3:0]  ALU_ctrl_ID;
    wire [2:0]  funct3_ID;
    wire        Branch_ID, MemRead_ID, MemWrite_ID, ALUSrc_ID, RegWrite_ID, MemtoReg_ID, branch_taken_ID;
    wire [31:0] ALU_result_EX, PC_branch_EX;
    wire        zero_EX;
    wire [31:0] Mem_Data_MEM;
    wire [31:0] Result_WB;
    wire        stall;

    // Debug outputs
    assign instr_out = instr_IF_ID;
    assign A = RD1_ID_EX;
    assign B = ALUSrc_ID_EX ? Imm_ID_EX : RD2_ID_EX;
    assign ALU_Result = ALU_result_EX;

    // IF Stage
    wire sel2 = Branch_ID_EX & zero_EX;
    
    IF_Stage if_stage(
        .clk(clk),
        .reset(reset),
        .sel2(sel2),
        .branch_target(PC_branch_EX),
        .PC_out(PC_IF),
        .instruction_out(instr_IF)
    );

    // IF/ID Pipeline Register
    always @(posedge clk or posedge reset) begin
        if (reset || (Branch_ID_EX && zero_EX)) begin
            PC_IF_ID <= 0;
            instr_IF_ID <= 0;
        end else if (~stall) begin
            PC_IF_ID <= PC_IF;
            instr_IF_ID <= instr_IF;
        end
    end

    // ID Stage
    ID_Stage id_stage(
        .clk(clk),
        .reset(reset),
        .instruction(instr_IF_ID),
        .PC_in(PC_IF_ID),
        .RegWrite_WB(RegWrite_MEM_WB),
        .Rd_WB(instr_IF_ID[11:7]),
        .Result_WB(Result_WB),
        .ImmExt(Imm_ID),
        .ReadData1(RD1_ID),
        .ReadData2(RD2_ID),
        .PC_out(),
        .ALU_Control(ALU_ctrl_ID),
        .Branch(Branch_ID),
        .MemRead(MemRead_ID),
        .MemWrite(MemWrite_ID),
        .ALUSrc(ALUSrc_ID),
        .RegWrite(RegWrite_ID),
        .MemtoReg(MemtoReg_ID),
        .branch_taken(branch_taken_ID)
    );
    
    assign funct3_ID = instr_IF_ID[14:12];

    // ID/EX Pipeline Register
    always @(posedge clk or posedge reset) begin
        if (reset || (Branch_ID_EX && zero_EX)) begin
            PC_ID_EX <= 0;
            Imm_ID_EX <= 0;
            RD1_ID_EX <= 0;
            RD2_ID_EX <= 0;
            ALU_ctrl_ID_EX <= 0;
            funct3_ID_EX <= 0;
            Branch_ID_EX <= 0;
            MemRead_ID_EX <= 0;
            MemWrite_ID_EX <= 0;
            ALUSrc_ID_EX <= 0;
            RegWrite_ID_EX <= 0;
            MemtoReg_ID_EX <= 0;
        end else if (~stall) begin
            PC_ID_EX <= PC_IF_ID;
            Imm_ID_EX <= Imm_ID;
            RD1_ID_EX <= RD1_ID;
            RD2_ID_EX <= RD2_ID;
            ALU_ctrl_ID_EX <= ALU_ctrl_ID;
            funct3_ID_EX <= funct3_ID;
            Branch_ID_EX <= Branch_ID;
            MemRead_ID_EX <= MemRead_ID;
            MemWrite_ID_EX <= MemWrite_ID;
            ALUSrc_ID_EX <= ALUSrc_ID;
            RegWrite_ID_EX <= RegWrite_ID;
            MemtoReg_ID_EX <= MemtoReg_ID;
        end
    end

    // EX Stage
    EX_Stage ex_stage(
        .ReadData1(RD1_ID_EX),
        .ReadData2(RD2_ID_EX),
        .ImmExt(Imm_ID_EX),
        .PC_in(PC_ID_EX),
        .ALU_Control(ALU_ctrl_ID_EX),
        .funct3(funct3_ID_EX),
        .ALUSrc(ALUSrc_ID_EX),
        .is_word_op(1'b0),      // Adjust based on instruction
        .is_imm_op(1'b0),       // Adjust based on instruction
        .is_branch(Branch_ID_EX),
        .is_jump(1'b0),         // Adjust based on instruction
        .is_loadstore(MemRead_ID_EX | MemWrite_ID_EX),
        .is_u_type(1'b0),       // Adjust based on instruction
        .is_jalr(1'b0),         // Adjust based on instruction
        .sel_u_type(1'b0),      // Adjust based on instruction
        .is_load(MemRead_ID_EX),
        .ALU_Result(ALU_result_EX),
        .zero(zero_EX),
        .PC_Branch(PC_branch_EX),
        .A_out(),
        .B_out(),
        .ALU_out()
    );

    // EX/MEM Pipeline Register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ALU_result_EX_MEM <= 0;
            WriteData_EX_MEM <= 0;
            funct3_EX_MEM <= 0;
            MemRead_EX_MEM <= 0;
            MemWrite_EX_MEM <= 0;
            RegWrite_EX_MEM <= 0;
            MemtoReg_EX_MEM <= 0;
        end else begin
            ALU_result_EX_MEM <= ALU_result_EX;
            WriteData_EX_MEM <= RD2_ID_EX;
            funct3_EX_MEM <= funct3_ID_EX;
            MemRead_EX_MEM <= MemRead_ID_EX;
            MemWrite_EX_MEM <= MemWrite_ID_EX;
            RegWrite_EX_MEM <= RegWrite_ID_EX;
            MemtoReg_EX_MEM <= MemtoReg_ID_EX;
        end
    end

    // MEM Stage
    MEM_Stage mem_stage(
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite_EX_MEM),
        .MemRead(MemRead_EX_MEM),
        .ALU_Result(ALU_result_EX_MEM),
        .Write_Data(WriteData_EX_MEM),
        .Mem_Data_Out(Mem_Data_MEM)
    );

    // MEM/WB Pipeline Register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Mem_Data_MEM_WB <= 0;
            ALU_result_MEM_WB <= 0;
            RegWrite_MEM_WB <= 0;
            MemtoReg_MEM_WB <= 0;
        end else begin
            Mem_Data_MEM_WB <= Mem_Data_MEM;
            ALU_result_MEM_WB <= ALU_result_EX_MEM;
            RegWrite_MEM_WB <= RegWrite_EX_MEM;
            MemtoReg_MEM_WB <= MemtoReg_EX_MEM;
        end
    end

    // WB Stage
    WB_Stage wb_stage(
        .ALU_result(ALU_result_MEM_WB),
        .Mem_Data(Mem_Data_MEM_WB),
        .sel1(1'b0),
        .sel3(MemtoReg_MEM_WB),
        .PC_plus4(32'd0),
        .WriteBack_Data(Result_WB)
    );

endmodule
