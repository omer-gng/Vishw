module MEM_Stage (
    input clk,
    input reset,
    input MemWrite,
    input MemRead,
    input [63:0] ALU_Result,    // Address
    input [63:0] Write_Data,    // Data to write
    output [63:0] Mem_Data_Out  // Data read from memory
);

    Data_Memory mem (
        .clk(clk),
        .reset(reset),
        .Memwrite(MemWrite),
        .Memread(MemRead),
        .read_address(ALU_Result),
        .write_data(Write_Data),
        .MemData_out(Mem_Data_Out)
    );

endmodule 
