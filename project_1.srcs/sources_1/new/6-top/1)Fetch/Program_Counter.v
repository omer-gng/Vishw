module Program_Counter(
    input  clk,
    input  reset,
    input  [3:0] PC_in,
    output reg [3:0] PC_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC_out <= 4'b0000;
        else
            PC_out <= PC_in;
    end
endmodule 