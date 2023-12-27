module tb_idecoder(output err);
  
	reg [15:0] ir;
 	reg [1:0] reg_sel;
        reg [2:0] opcode;
	reg [1:0] ALU_op; 
	reg [1:0] shift_op;
	reg [15:0] sximm5;
	reg [15:0] sximm8;
        reg [2:0] r_addr;
	reg [2:0] w_addr;

	reg error;
	assign err = error;

	idecoder DUT(.ir, .reg_sel, .opcode, .ALU_op, .shift_op, .sximm5, .sximm8, .r_addr, .w_addr);

	initial begin 
	error = 0;

	#5;

	ir = 16'b1010101010101010;
	reg_sel = 2'b00;
	#5;
	assert(opcode === 3'b101 && ALU_op === 2'b01 && sximm5 === 16'b0000000000001010 && sximm8 === 16'b1111111110101010 && 
	shift_op === 2'b01 && r_addr === 3'b010 && w_addr === 3'b010) $display ("[PASS] test 1 with reg_sel = 00");
	else begin
		$error ("[FAIL] test 1 with reg_sel = 00");
		error = 1;
	end

	#5;

	ir = 16'b1101101101101101;
	reg_sel = 2'b01;
	#5;
	assert(opcode === 3'b110 && ALU_op === 2'b11 && sximm5 === 16'b0000000000001101 && sximm8 === 16'b0000000001101101
	&& shift_op === 2'b01 && r_addr === 3'b011 && w_addr === 3'b011) $display ("[PASS] test 2 with reg_sel == 01");
	else begin 
		$error ("[FAIL] test 2 with reg_sel = 01");
		error = 1;
	end

	#5;

	ir = 16'b0100010001000100;
	reg_sel = 2'b10;
	#5;
	assert(opcode === 3'b010 && ALU_op === 2'b00 && sximm5 === 16'b0000000000000100 && sximm8 === 16'b0000000001000100
	&& shift_op === 2'b00 && r_addr === 3'b100 && w_addr === 3'b100) $display ("[PASS] test 3 with reg_sel == 10");
	else begin 
		$error ("[FAIL] test 2 with reg_sel = 10");
		error = 1;
	end

	#5;

	end

endmodule: tb_idecoder
