module Reg_File(
    input clk,
    input reset,
    input RegWrite,
    input [4:0] Rs1, Rs2, Rd,
    input [31:0] Write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] Registers [0:31];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize all to zero first
            for (i = 0; i < 32; i = i + 1)
                Registers[i] <= 32'b0;

            // Then assign specific values to selected registers
            Registers[1]  <= 5;
            Registers[2]  <= 10;
            Registers[3]  <= 15;
            Registers[4]  <= 20;
            Registers[5]  <= 25;
            Registers[6]  <= 30;
            Registers[7]  <= 35;
            Registers[8]  <= 40;
            Registers[9]  <= 45;
            Registers[10] <= 50;
            Registers[11] <= 55;
            Registers[12] <= 60;
            Registers[13] <= 65;
            Registers[14] <= 70;
            Registers[15] <= 75;
            Registers[16] <= 80;
            Registers[17] <= 85;
            Registers[18] <= 90;
            Registers[19] <= 95;
            Registers[20] <= 100;
            Registers[21] <= 105;
            Registers[22] <= 110;
            Registers[23] <= 115;
            Registers[24] <= 120;
            Registers[25] <= 125;
            Registers[26] <= 130;
            Registers[27] <= 135;
            Registers[28] <= 140;
            Registers[29] <= 145;
            Registers[30] <= 150;
            Registers[31] <= 155;
        end else if (RegWrite && Rd != 0) begin
            Registers[Rd] <= Write_data;
        end
    end

    assign read_data1 = Registers[Rs1];
    assign read_data2 = Registers[Rs2];

endmodule
