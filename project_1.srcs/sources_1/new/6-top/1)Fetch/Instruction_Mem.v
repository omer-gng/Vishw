module Instruction_Mem (
    input  wire       clk,
    input  wire       reset,
    input  wire [3:0] read_address,
    output reg  [7:0] instruction_out
);
    reg [7:0] memory [0:15];
    reg [7:0] instr_reg;

    initial begin
        // Example program: you can fill these with encodings
        // Layout: [7:6]=opcode (2b), [5:4]=rd, [3:2]=rs1, [1:0]=rs2/imm
        memory[0]  = 8'b10_00_01_01; // ADD r0, r1, r1
        memory[1]  = 8'b11_01_10_01; // SUB r1, r2, r1
        memory[2]  = 8'b01_10_11_00; // AND r2, r3, r0
        memory[3]  = 8'b00_00_00_00; // NOP
        memory[4]  = 8'b10_11_01_10; // ADD r3, r1, r2
        memory[5]  = 8'b11_10_00_11; // SUB r2, r0, r3
        memory[6]  = 8'b01_01_01_01; // AND r1, r1, r1
        memory[7]  = 8'b10_00_10_01; // ADD r0, r2, r1
        memory[8]  = 8'b00_00_00_00;
        memory[9]  = 8'b00_00_00_00;
        memory[10] = 8'b00_00_00_00;
        memory[11] = 8'b00_00_00_00;
        memory[12] = 8'b00_00_00_00;
        memory[13] = 8'b00_00_00_00;
        memory[14] = 8'b00_00_00_00;
        memory[15] = 8'b00_00_00_00;
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            instr_reg <= 8'b0;
        else
            instr_reg <= memory[read_address];
    end

    always @(*) begin
        instruction_out = instr_reg;
    end
endmodule 