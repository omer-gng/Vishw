module ALU_LoadStore (
    input  [3:0] addr,            // computed memory address
    input  [3:0] mem_data_in,     // from memory for load
    input  [3:0] B,               // register value to store
    input  [2:0]  funct3,          // load/store subtype
    input         is_load,        // 1 = load, 0 = store
    output reg [3:0] load_result, // result of load
    output reg [3:0] store_data   // data to write to memory
);

    always @(*) begin
        load_result = 4'b0;
        store_data  = 4'b0;

       if (is_load) begin
	   case (funct3)
               3'b000: load_result = {4{mem_data_in[3]}}; // Sign-extend the 4-bit value (like lb)
               3'b001: load_result = mem_data_in;          // Just load 4-bit data (like lh/lw simplification)
               3'b010: load_result = mem_data_in;          // Same as above (lw)
               3'b011: load_result = mem_data_in;          // Same as above (ld)
               3'b100: load_result = mem_data_in;          // Zero-extend 4-bit unsigned load (lbu)
               3'b101: load_result = mem_data_in;          // Same for lhu
               3'b110: load_result = mem_data_in;          // Same for lwu
               default: load_result = 4'b0000;
    	   endcase
      end else begin
    	   case (funct3)
      	       3'b000: store_data = B; // Store 4-bit sb
               3'b001: store_data = B; // Store 4-bit sh (same in 4-bit context)
      	       3'b010: store_data = B; // Store 4-bit sw
               3'b011: store_data = B; // Store 4-bit sd
               default: store_data = 4'b0000;
    	   endcase
	end
    end
endmodule 