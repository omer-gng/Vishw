module Adder(
    input  [3:0] in_1,
    input  [3:0] in_2,
    output [3:0] Sum_out
);
    assign Sum_out = in_1 + in_2;
endmodule