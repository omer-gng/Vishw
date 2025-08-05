module PC_plus4(
    input [31:0] fromPC,
    output [31:0] NextoPC
);
    assign NextoPC = fromPC + 4;

endmodule
