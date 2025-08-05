module MEM_Stage (
    input        clk,
    input        reset,
    input        MemWrite,
    input        MemRead,
    input  [3:0] ALU_Result,
    input  [3:0] Write_Data,
    output [3:0] Mem_Data_Out
);
    wire [1:0] addr = ALU_Result[1:0];
    Data_Memory mem (
        .clk(clk),
        .reset(reset),
        .Memwrite(MemWrite),
        .Memread(MemRead),
        .address(addr),
        .write_data(Write_Data),
        .MemData_out(Mem_Data_Out)
    );
endmodule 