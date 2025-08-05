module Data_Memory(
    input        clk,
    input        reset,
    input        Memwrite,
    input        Memread,
    input  [1:0] address,
    input  [3:0] write_data,
    output [3:0] MemData_out
);
    reg [3:0] D_memory [0:3];
    integer k;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (k = 0; k < 4; k = k + 1)
                D_memory[k] <= 4'b0;
        end else if (Memwrite) begin
            D_memory[address] <= write_data;
        end
    end

    assign MemData_out = (Memread) ? D_memory[address] : 4'b0000;
endmodule 