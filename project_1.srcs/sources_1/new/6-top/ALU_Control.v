module ALU_Control(
    input  wire [6:0] fun7,       // funct7 field
    input  wire [2:0] fun3,       // funct3 field
    input  wire [1:0] ALUOp,      // from main control unit
    output reg  [3:0] Control_out // ALU operation code
);

    // Define encoding for ALU operations (you can adjust to match downstream ALU)
    localparam ADD  = 4'b0010;
    localparam SUB  = 4'b0110;
    localparam AND  = 4'b0000;
    localparam OR   = 4'b0001;
    localparam XOR  = 4'b0100;
    localparam SLL  = 4'b0101;
    localparam SRL  = 4'b1000;
    localparam SRA  = 4'b1001;
    localparam INVALID = 4'b1111;

    always @(*) begin
        casez ({ALUOp, fun7, fun3})
            // Load/Store: ALUOp = 00 -> ADD for address calc; fun7/fun3 don't matter
            {2'b00, 7'b???????, 3'b???}: Control_out = ADD;

            // Branch: ALUOp = 01 -> SUB for comparison (e.g., BEQ)
            {2'b01, 7'b???????, 3'b???}: Control_out = SUB;

            // R-type: ALUOp = 10, need to distinguish via funct7 and funct3
            {2'b10, 7'b0000000, 3'b000}: Control_out = ADD;
            {2'b10, 7'b0100000, 3'b000}: Control_out = SUB;
            {2'b10, 7'b0000000, 3'b111}: Control_out = AND;
            {2'b10, 7'b0000000, 3'b110}: Control_out = OR;
            {2'b10, 7'b0000000, 3'b100}: Control_out = XOR;
            {2'b10, 7'b0000000, 3'b001}: Control_out = SLL;
            {2'b10, 7'b0000000, 3'b101}: Control_out = SRL;
            {2'b10, 7'b0100000, 3'b101}: Control_out = SRA;

            default: Control_out = INVALID;
        endcase
    end

endmodule