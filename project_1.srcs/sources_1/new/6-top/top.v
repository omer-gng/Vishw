module top(
    input  clk,
    input  reset,
    output [7:0] instr_out,
    output [3:0] A,
    output [3:0] B,
    output [3:0] ALU_Result
);
    // IF Stage signals
    wire [3:0] PC_IF;
    wire [7:0] instruction_IF;

    // IF/ID pipeline registers
    reg [3:0] PC_ID;
    reg [7:0] instruction_ID;

    // ID Stage signals
    wire [1:0] Rs1_ID, Rs2_ID, Rd_ID;
    wire [3:0] Imm_ID;
    wire [3:0] ALU_Control_ID;
    wire       ALUSrc_ID, Branch_ID, MemRead_ID, MemWrite_ID, MemtoReg_ID, RegWrite_ID;

    // ID/EX pipeline registers
    reg [3:0] PC_EX;
    reg [3:0] Imm_EX;
    reg [3:0] RD1_EX, RD2_EX;
    reg [1:0] Rd_EX;
    reg [3:0] ALU_Control_EX;
    reg       ALUSrc_EX, Branch_EX, MemRead_EX, MemWrite_EX, MemtoReg_EX, RegWrite_EX;

    // EX Stage signals
    wire [3:0] ALU_Result_EX;
    wire       zero_EX;
    wire [3:0] PC_Branch_EX;
    wire       branch_taken_EX;
    wire [3:0] A_EX;
    wire [3:0] B_EX;

    // EX/MEM pipeline registers
    reg       Branch_MEM;
    reg       MemRead_MEM;
    reg       MemWrite_MEM;
    reg       MemtoReg_MEM;
    reg       RegWrite_MEM;
    reg [3:0] ALU_Result_MEM;
    reg [3:0] Write_Data_MEM;
    reg [1:0] Rd_MEM;

    // MEM Stage signals
    wire [3:0] Mem_Data_MEM;

    // MEM/WB pipeline registers
    reg       MemtoReg_MEM_WB;
    reg       RegWrite_MEM_WB;
    reg [3:0] ALU_Result_MEM_WB;
    reg [3:0] Mem_Data_MEM_WB;
    reg [1:0] Rd_MEM_WB;

    // WB Stage signals
    wire [3:0] WriteBack_Data_WB;

    // Register File read data wires
    wire [3:0] ReadData1_ID;
    wire [3:0] ReadData2_ID;

    // PC plus4 for WB (just use PC_EX + 4)
    wire [3:0] PC_plus4_EX;
    //PC_plus4 pc_plus4_inst (.fromPC(PC_EX), .NextoPC(PC_plus4_EX));

    // Branch control for IF Stage
    wire take_branch = branch_taken_EX;
    wire sel2 = take_branch;
    wire [3:0] branch_target = PC_Branch_EX;

    // Instantiate IF Stage
    IF_Stage if_stage (
        .clk(clk),
        .reset(reset),
        .sel2(sel2),
        .branch_target(branch_target),
        .PC_out(PC_IF),
        .instruction_out(instruction_IF)
    );

    // IF/ID pipeline register update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC_ID <= 4'b0;
            instruction_ID <= 8'b0;
        end else begin
            PC_ID <= PC_IF;
            instruction_ID <= instruction_IF;
        end
    end

    // Instantiate ID Stage
    ID_Stage id_stage (
        .instruction(instruction_ID),
        .PC_in(PC_ID),

        .Rs1(Rs1_ID),
        .Rs2(Rs2_ID),
        .Rd(Rd_ID),
        .Imm(Imm_ID),
        .ALU_Control(ALU_Control_ID),
        .ALUSrc(ALUSrc_ID),
        .Branch(Branch_ID),
        .MemRead(MemRead_ID),
        .MemWrite(MemWrite_ID),
        .MemtoReg(MemtoReg_ID),
        .RegWrite(RegWrite_ID),
        .PC_out() // not needed outside ID, ignore
    );

    // Instantiate Register File
    Reg_File reg_file (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite_MEM_WB),
        .Rs1(Rs1_ID),
        .Rs2(Rs2_ID),
        .Rd(Rd_MEM_WB),
        .Write_data(WriteBack_Data_WB),
        .read_data1(ReadData1_ID),
        .read_data2(ReadData2_ID)
    );

    // ID/EX pipeline registers update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC_EX <= 4'b0;
            Imm_EX <= 4'b0;
            RD1_EX <= 4'b0;
            RD2_EX <= 4'b0;
            Rd_EX <= 2'b0;
            ALU_Control_EX <= 4'b0;
            ALUSrc_EX <= 1'b0;
            Branch_EX <= 1'b0;
            MemRead_EX <= 1'b0;
            MemWrite_EX <= 1'b0;
            MemtoReg_EX <= 1'b0;
            RegWrite_EX <= 1'b0;
        end else begin
            PC_EX <= PC_ID;
            Imm_EX <= Imm_ID;
            RD1_EX <= ReadData1_ID;
            RD2_EX <= ReadData2_ID;
            Rd_EX <= Rd_ID;
            ALU_Control_EX <= ALU_Control_ID;
            ALUSrc_EX <= ALUSrc_ID;
            Branch_EX <= Branch_ID;
            MemRead_EX <= MemRead_ID;
            MemWrite_EX <= MemWrite_ID;
            MemtoReg_EX <= MemtoReg_ID;
            RegWrite_EX <= RegWrite_ID;
        end
    end

    // Instantiate EX Stage
    EX_Stage ex_stage (
        .ReadData1(RD1_EX),
        .ReadData2(RD2_EX),
        .Imm(Imm_EX),
        .PC_in(PC_EX),
        .ALU_Control(ALU_Control_EX),
        .ALUSrc(ALUSrc_EX),
        .Branch(Branch_EX),

        .ALU_Result(ALU_Result_EX),
        .zero(zero_EX),
        .PC_Branch(PC_Branch_EX),
        .branch_taken(branch_taken_EX),
        .A_out(A_EX),
        .B_out(B_EX)
    );

    // EX/MEM pipeline registers update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Branch_MEM <= 0;
            MemRead_MEM <= 0;
            MemWrite_MEM <= 0;
            MemtoReg_MEM <= 0;
            RegWrite_MEM <= 0;
            ALU_Result_MEM <= 0;
            Write_Data_MEM <= 0;
            Rd_MEM <= 0;
        end else begin
            Branch_MEM <= Branch_EX;
            MemRead_MEM <= MemRead_EX;
            MemWrite_MEM <= MemWrite_EX;
            MemtoReg_MEM <= MemtoReg_EX;
            RegWrite_MEM <= RegWrite_EX;
            ALU_Result_MEM <= ALU_Result_EX;
            Write_Data_MEM <= B_EX;
            Rd_MEM <= Rd_EX;
        end
    end

    // Instantiate MEM Stage
    MEM_Stage mem_stage (
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite_MEM),
        .MemRead(MemRead_MEM),
        .ALU_Result(ALU_Result_MEM),
        .Write_Data(Write_Data_MEM),
        .Mem_Data_Out(Mem_Data_MEM)
    );

    // MEM/WB pipeline registers update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MemtoReg_MEM_WB <= 0;
            RegWrite_MEM_WB <= 0;
            ALU_Result_MEM_WB <= 0;
            Mem_Data_MEM_WB <= 0;
            Rd_MEM_WB <= 0;
        end else begin
            MemtoReg_MEM_WB <= MemtoReg_MEM;
            RegWrite_MEM_WB <= RegWrite_MEM;
            ALU_Result_MEM_WB <= ALU_Result_MEM;
            Mem_Data_MEM_WB <= Mem_Data_MEM;
            Rd_MEM_WB <= Rd_MEM;
        end
    end

    // Instantiate WB Stage
    WB_Stage wb_stage (
        .ALU_result(ALU_Result_MEM_WB),
        .Mem_Data(Mem_Data_MEM_WB),
        .sel1(MemtoReg_MEM_WB),
        .sel3(1'b0),    // no PC+4 forwarding, sel3=0 for now
        .PC_plus4(PC_plus4_EX),
        .WriteBack_Data(WriteBack_Data_WB)
    );

    // Output signals for waveform viewing
    assign instr_out = instruction_IF;
    assign A = A_EX;
    assign B = B_EX;
    assign ALU_Result = ALU_Result_EX;

endmodule 