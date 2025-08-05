module ALU_Jump (
    input  [3:0] PC,
    input  [3:0] A,             // Used for JALR: rs1
    input  [1:0] Imm,           // JAL: immediate, JALR: I-type immediate
    input         is_jalr,       // 1 for JALR, 0 for JAL
    output [3:0] target_addr,
    output [3:0] link_addr
);
    wire [3:0] imm_ext = {{1{Imm[1]}}, Imm};

    assign target_addr = is_jalr ? (A + imm_ext) & ~4'b1 : PC + imm_ext;
    assign link_addr   = PC + 4'd4;  // Address to return to
endmodule 