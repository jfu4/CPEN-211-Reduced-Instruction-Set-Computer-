module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);
  // your implementation here

	reg [2:0] w_addr_wire;
	reg [2:0] r_addr_wire;

	reg[15:0] sximm8_wire;
	reg[15:0] sximm5_wire;

	reg[1:0] shift_op_wire;
	reg[1:0] ALU_op_wire;
	reg[2:0] opcode_wire;

	assign w_addr = w_addr_wire;
	assign r_addr = r_addr_wire;

	assign sximm8 = sximm8_wire;
	assign sximm5 = sximm5_wire;

	assign shift_op = shift_op_wire;
	assign ALU_op = ALU_op_wire;
	assign opcode = opcode_wire;

	always_comb begin

	shift_op_wire = ir[4:3];
	ALU_op_wire = ir[12:11];
	opcode_wire = ir[15:13];

	case(reg_sel)

		2'b00: begin 
				w_addr_wire = ir[2:0];
				r_addr_wire = ir[2:0];
			end
		2'b01: begin
				w_addr_wire = ir[7:5];
				r_addr_wire = ir[7:5];
			end
		2'b10: begin 
				w_addr_wire = ir[10:8];
				r_addr_wire = ir[10:8];
			end

		default:begin 
				w_addr_wire = ir[2:0];
				r_addr_wire = ir[2:0];
			end

	endcase

	casex(ir[7:0])
	
		8'b1xxxxxxx: sximm8_wire = {8'b11111111,ir[7:0]};		
		8'b0xxxxxxx: sximm8_wire = {8'b00000000,ir[7:0]};

		default: sximm8_wire = {8'b00000000, ir[7:0]};		

	endcase

	casex(ir[4:0])

		5'b1xxxx: sximm5_wire = {11'b11111111111,ir[4:0]};
		5'b0xxxx: sximm5_wire = {11'b00000000000,ir[4:0]};

		default: sximm5_wire = {11'b00000000000, ir[4:0]};

	endcase

	end

endmodule: idecoder
