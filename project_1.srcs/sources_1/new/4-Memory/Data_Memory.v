module Data_Memory(
    input clk,
    input reset,
    input Memwrite,
    input Memread,
    input [63:0] read_address,
    input [63:0] write_data,
    output [63:0] MemData_out
);

    reg [63:0] D_memory[63:0];
    integer k;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (k = 0; k < 64; k = k + 1) begin
                D_memory[k] <= 64'b0;
            end
        end
        else if (Memwrite) begin
            D_memory[read_address] <= write_data;
        end
    end

    assign MemData_out = (Memread) ? D_memory[read_address] : 64'b0;

endmodule
