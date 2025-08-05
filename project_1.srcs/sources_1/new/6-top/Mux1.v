module Mux1(
    input        sel1,
    input  [3:0] A1,
    input  [3:0] B1,
    output [3:0] Mux1_out
);
    assign Mux1_out = sel1 ? B1 : A1;
endmodule 