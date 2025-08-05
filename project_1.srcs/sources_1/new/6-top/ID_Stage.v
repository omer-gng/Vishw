module ID_Stage(
    input clk,
    input reset,
    input [31:0] instruction,
    input [31:0] PC_in,
    input RegWrite_WB,
    input [4:0] Rd_WB,
    input [31:0] Result_WB,

    output reg [31:0] ImmExt,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2,
    output reg [31:0] PC_out,
    output reg [3:0] ALU_Control,
    output reg Branch,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg MemtoReg,
    output reg branch_taken
);

    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];

    wire [31:0] imm_ext, rdata1, rdata2;
    wire [3:0] alu_ctrl_out;
    wire zero = (rdata1 == rdata2);  // Compare ReadData1 and ReadData2 for branch decisions
    wire branch_out, memread_out, memwrite_out, alusrc_out, regwrite_out, memtoreg_out;
    wire [1:0] alu_op;
    wire branch_taken_wire = branch_out & zero;  // Branch taken only if condition met

    // Instantiate components
    Control_Unit ctrl_unit (
        .instruction(opcode),
        .Branch(branch_out),
        .MemRead(memread_out),
        .MemtoReg(memtoreg_out),
        .MemWrite(memwrite_out),
        .ALUSrc(alusrc_out),
        .RegWrite(regwrite_out),
        .ALUOp(alu_op)
    );

    Reg_File reg_file (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite_WB),
        .Rs1(rs1),
        .Rs2(rs2),
        .Rd(Rd_WB),
        .Write_data(Result_WB),
        .read_data1(rdata1),
        .read_data2(rdata2)
    );

    ImmGen imm_gen (
        .instruction(instruction),
        .ImmExt(imm_ext)
    );

    ALU_Control alu_ctrl (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALU_Control(alu_ctrl_out)
    );
    
    AND_logic and_logic(
        .Branch(branch_out),
        .zero(zero),
        .branch_taken(branch_taken_wire)
    );

    // Pipeline register behavior
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ImmExt      <= 0;
            ReadData1   <= 0;
            ReadData2   <= 0;
            PC_out      <= 0;
            ALU_Control <= 0;
            Branch      <= 0;
            MemRead     <= 0;
            MemWrite    <= 0;
            ALUSrc      <= 0;
            RegWrite    <= 0;
            MemtoReg    <= 0;
            branch_taken<= 0;
        end else begin
            ImmExt      <= imm_ext;
            ReadData1   <= rdata1;
            ReadData2   <= rdata2;
            PC_out      <= PC_in;
            ALU_Control <= alu_ctrl_out;
            Branch      <= branch_out;
            MemRead     <= memread_out;
            MemWrite    <= memwrite_out;
            ALUSrc      <= alusrc_out;
            RegWrite    <= regwrite_out;
            MemtoReg    <= memtoreg_out;
            branch_taken<= branch_taken_wire;
        end
    end
endmodule