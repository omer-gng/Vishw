module Control_Unit(
    input  [6:0] instruction,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg [1:0] ALUOp
);

    // Opcodes
    localparam R_TYPE   = 7'b0110011;
    localparam LOAD      = 7'b0000011;
    localparam STORE     = 7'b0100011;
    localparam BRANCH    = 7'b1100011;
    localparam ADDI      = 7'b0010011;
    localparam LUI       = 7'b0110111;
    localparam AUIPC     = 7'b0010111;
    localparam JAL       = 7'b1101111;
    localparam JALR      = 7'b1100111;

    always @(*) begin
        // Defaults: no operations
        Branch    = 1'b0;
        MemRead   = 1'b0;
        MemtoReg  = 1'b0;
        MemWrite  = 1'b0;
        ALUSrc    = 1'b0;
        RegWrite  = 1'b0;
        ALUOp     = 2'b00;

        case (instruction)
            R_TYPE: begin
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b10; // R-type ALU control
            end

            LOAD: begin
                ALUSrc   = 1'b1; // immediate offset
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b00; // add for address calc
            end

            STORE: begin
                ALUSrc   = 1'b1; // immediate offset
                MemtoReg = 1'b0; // don't care
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                Branch   = 1'b0;
                ALUOp    = 2'b00; // add for address calc
            end

            BRANCH: begin
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b1;
                ALUOp    = 2'b01; // branch comparison
            end

            ADDI: begin
                ALUSrc   = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b10; // add immediate
            end

            LUI: begin
                ALUSrc   = 1'b1; // immediate is upper
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                ALUOp    = 2'b11; // custom for LUI
            end

            AUIPC: begin
                ALUSrc   = 1'b1;
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                ALUOp    = 2'b00; // PC + imm (add)
            end

            JAL: begin
                ALUSrc   = 1'b0;
                MemtoReg = 1'b0;
                RegWrite = 1'b1; // write return addr
                Branch   = 1'b0; // handled separately as jump
                ALUOp    = 2'b00;
            end

            JALR: begin
                ALUSrc   = 1'b1; // uses immediate
                MemtoReg = 1'b0;
                RegWrite = 1'b1;
                Branch   = 1'b0;
                ALUOp    = 2'b00;
            end

            default: begin
                // keep defaults (NOP / illegal)
            end
        endcase
    end

endmodule