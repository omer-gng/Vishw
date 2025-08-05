module ALU_Control(
    input  wire [6:0] fun7,       // funct7 from instruction (7 bits)
    input  wire [2:0] fun3,       // funct3 from instruction (3 bits)
    input  wire [1:0] ALUOp,      // ALUOp control from main control unit
    output reg  [3:0] Control_out // ALU operation output
);

always @(*) begin
    case ({ALUOp, fun7, fun3})
        // ALUOp = 00 (Load/Store - just do addition)
        {2'b00, 7'bxxxxxxx, 3'b000}: Control_out <= 4'b0010; // ADD

        // ALUOp = 01 (Branch - use subtraction)
        {2'b01, 7'bxxxxxxx, 3'b000}: Control_out <= 4'b0110; // SUB

        // ALUOp = 10 (R-type - depends on funct7 + funct3)
        {2'b10, 7'b0000000, 3'b000}: Control_out <= 4'b0010; // ADD
        {2'b10, 7'b0100000, 3'b000}: Control_out <= 4'b0110; // SUB
        {2'b10, 7'b0000000, 3'b111}: Control_out <= 4'b0000; // AND
        {2'b10, 7'b0000000, 3'b110}: Control_out <= 4'b0001; // OR

        default: Control_out <= 4'b1111; // Invalid
    endcase
end

endmodule
