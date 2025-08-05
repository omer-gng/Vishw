module PC_plus4(
    input  [3:0] fromPC,
    output [3:0] NextoPC
);
    assign NextoPC = fromPC + 4'd1;
endmodule 