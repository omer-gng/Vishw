module ALU_Unit (
    input  [3:0] A,
    input  [3:0] B,
    input  [3:0] Imm,           // 4-bit immediate
    input  [3:0] ALU_Control,
    input  [2:0] funct3,
    input  [3:0] PC,
    input        is_word_op,
    input        is_imm_op,
    input        is_branch,
    input        is_jump,
    input        is_loadstore,
    input        is_u_type,
    input        is_jalr,         // for ALU_Jump
    input        sel_u_type,      // 0 = LUI, 1 = AUIPC
    input        is_load,         // for load/store

    output [3:0] ALU_result,
    output       zero,
    output       branch_taken,
    output [3:0] branch_target,
    output [3:0] store_data,
    output [3:0] link_addr
);

    // Internal wires for submodule outputs
    wire [3:0] reg_result;
    wire [3:0] imm_result;
    wire [3:0] word_result;
    wire       z_flag;
    wire       br_taken;
    wire [3:0] j_target;
    wire [3:0] j_link;
    wire [3:0] u_result;
    wire [3:0] load_res;
    wire [3:0] store_res;

    // Sign extend Imm to 4 bits (if needed)
    // Here Imm is already 4 bits, so use directly

    // Calculate load/store address = A + Imm (4 bits add)
    wire [3:0] ls_addr = A + Imm;

    // Instantiate ALU_Register (R-type ALU ops)
    ALU_Register alu_r (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .ALU_Result(reg_result),
        .zero(z_flag)
    );

    // Instantiate ALU_Immediate (I-type ALU ops)
    ALU_Immediate alu_i (
        .A(A),
        .Imm(Imm[1:0]), // Assuming this uses lower 2 bits of Imm, adjust as needed
        .ALU_Control(ALU_Control),
        .ALU_Result(imm_result)
    );

    // Instantiate ALU_Word (word operations)
    ALU_Word alu_w (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .ALU_Result(word_result)
    );

    // Instantiate ALU_Branch (branch condition checker)
    ALU_Branch alu_b (
        .A(A),
        .B(B),
        .funct3(funct3),
        .branch_taken(br_taken)
    );

    // Instantiate ALU_Jump (jump address and link)
    ALU_Jump alu_j (
        .PC(PC),
        .A(A),
        .Imm(Imm[1:0]),   // Using 2 bits immediate here, adjust as needed
        .is_jalr(is_jalr),
        .target_addr(j_target),
        .link_addr(j_link)
    );

    // Instantiate ALU_UType (LUI, AUIPC)
    ALU_UType alu_u (
        .PC(PC),
        .imm_u(Imm[1:0]), // Using 2 bits immediate here, adjust as needed
        .sel(sel_u_type),
        .result(u_result)
    );

    // Instantiate ALU_LoadStore (load/store address calc and data)
    ALU_LoadStore alu_ls (
        .addr(ls_addr),
        .mem_data_in(64'b0),  // unused here
        .B(B),
        .funct3(funct3),
        .is_load(is_load),
        .load_result(load_res),
        .store_data(store_res)
    );

    // Output selection logic
    assign ALU_result =
        is_jump       ? j_link       :  // Link address on jump
        is_branch     ? 4'b0000      :  // Branch does not produce ALU result here
        is_loadstore  ? (is_load ? load_res : ls_addr) :  // Load returns loaded data, store returns address
        is_u_type     ? u_result     :  // U-type (LUI/AUIPC)
        is_word_op    ? word_result  :  // Word operations
        is_imm_op     ? imm_result   :  // Immediate operations
                        reg_result;     // Register-register operations (R-type)

    assign zero          = z_flag;
    assign branch_taken  = br_taken;
    assign branch_target = j_target;
    assign store_data    = store_res;
    assign link_addr     = j_link;

endmodule