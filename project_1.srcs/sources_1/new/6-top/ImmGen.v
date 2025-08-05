module ImmGen(
    input  [6:0] opcode,
    input  [3:0] instruction,  // 4-bit instruction slice (for demo)
    output reg [3:0] Imm
);

    always @(*) begin
        case (opcode)
            // Load Instructions (I-type)
            7'b0000011: Imm = {{1{instruction[3]}}, instruction[3:0]};  // sign-extend 4-bit immediate

            // Store Instructions (S-type)
            7'b0100011: Imm = {{1{instruction[3]}}, instruction[3:0]};  // simplified for 4 bits

            // Branch Instructions (B-type)
            7'b1100011: Imm = {{1{instruction[3]}}, instruction[3:0]};  // simplified

            // Immediate ALU Operations (I-type)
            7'b0010011: Imm = {{1{instruction[3]}}, instruction[3:0]};  // sign-extend

            // JALR Instruction (I-type)
            7'b1100111: Imm = {{1{instruction[3]}}, instruction[3:0]};  // sign-extend

            // JAL Instruction (J-type)
            7'b1101111: Imm = {{1{instruction[3]}}, instruction[3:0]};  // simplified

            // LUI and AUIPC Instructions (U-type)
            7'b0110111,
            7'b0010111: Imm = instruction;  // just pass 4 bits

            default: Imm = 4'b0000;
        endcase
    end

endmodule