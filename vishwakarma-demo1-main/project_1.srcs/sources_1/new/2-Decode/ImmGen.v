module ImmGen(
    input  [6:0]  opcode,
    input  [31:0] instruction,
    output reg [31:0] ImmExt
);

    always @(*) begin
        case (opcode)
            // Load Instructions (I-type)
            7'b0000011: ImmExt <= {{20{instruction[31]}}, instruction[31:20]};

            // Store Instructions (S-type)
            7'b0100011: ImmExt <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // Branch Instructions (B-type)
            7'b1100011: ImmExt <= {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

            // Immediate ALU Operations (I-type)
            7'b0010011: ImmExt <= {{20{instruction[31]}}, instruction[31:20]};

            // JALR Instruction (I-type)
            7'b1100111: ImmExt <= {{20{instruction[31]}}, instruction[31:20]};

            // JAL Instruction (J-type)
            7'b1101111: ImmExt <= {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

            // LUI and AUIPC Instructions (U-type)
            7'b0110111,
            7'b0010111: ImmExt <= {instruction[31:12], 12'b0};

            default: ImmExt <= 32'b0;
        endcase
    end

endmodule
