module shifter(input [15:0] shift_in, input [1:0] shift_op, output reg [15:0] shift_out);
	
	reg [15:0] out;

	assign shift_out = out;

	always_comb begin
		case (shift_op) 
			2'b00: out = shift_in;
			2'b01: out = shift_in << 1;
			2'b10: out = shift_in >> 1;
			2'b11: out = {shift_in[15] ,shift_in[15:1]};
			default: out = shift_in;
		endcase
	end

endmodule: shifter
