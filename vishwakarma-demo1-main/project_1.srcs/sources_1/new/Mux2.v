module Mux2(
        input sel2,
        input [31:0] A2, B2,
        output [31:0] Mux2_out
);
        assign Mux2_out = (sel2 == 1'b0) ? A2 : B2;
    
endmodule
