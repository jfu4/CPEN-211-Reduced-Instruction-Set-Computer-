module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z, output N, output V);
  // your implementation here
	
	reg signed [15:0] ALU_out_wire;
	reg Z_wire;
	reg N_wire;
	reg V_wire;
		
	
	assign ALU_out = ALU_out_wire;
	assign Z = Z_wire;

	assign N = N_wire;
	

	assign V = V_wire;
	
	always_comb begin

	case(ALU_op)

		2'b00: begin
			ALU_out_wire[15:0] = val_A[15:0] + val_B[15:0];
			if(val_A[15] == 1 && val_B[15]==1 && ALU_out_wire[15] == 0) begin
				V_wire = 1;
		        end
			else if (val_A[15] == 0 && val_B[15]== 0 && ALU_out_wire[15] == 1)begin 
				V_wire = 1;
			end
			else begin 
				V_wire = 0;
			end
		       end
		2'b01: begin 
			 ALU_out_wire = val_A - val_B;
			 V_wire = (ALU_out_wire[15] == val_B[15]) ? 1:0;
		       end 
		2'b10: ALU_out_wire = val_A & val_B;
		2'b11: ALU_out_wire = ~val_B;

	default: ALU_out_wire = val_A + val_B;
	
	endcase


	if(ALU_out_wire == 16'b0000000000000000) begin
		Z_wire = 1;
	end 
	else begin
		Z_wire = 0;
	end


	casex(ALU_out_wire)

		16'b1xxxxxxxxxxxxxxx: N_wire = 1;
	
	default: N_wire = 0;

	endcase 	


	end

endmodule: ALU
