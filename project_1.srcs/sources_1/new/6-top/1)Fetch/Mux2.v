module Mux2(
    input        sel2,
    input  [3:0] A2,
    input  [3:0] B2,
    output [3:0] Mux2_out
);
    assign Mux2_out = sel2 ? B2 : A2;
endmodule 