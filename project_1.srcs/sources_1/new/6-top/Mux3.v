module Mux3(
    input        sel3,
    input  [3:0] A3,
    input  [3:0] B3,
    output [3:0] Mux3_out
);
    assign Mux3_out = sel3 ? B3 : A3;
endmodule 