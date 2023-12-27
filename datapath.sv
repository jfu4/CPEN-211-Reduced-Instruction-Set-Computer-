module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
		input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);

	reg [15:0] w_data;
	reg [15:0] r_data;

	reg [15:0] A_data;
	reg [15:0] shift_in;
	reg [15:0] shift_out;

	reg [15:0] val_A;
	reg [15:0] val_B;

	reg [15:0] ALU_out;
	reg Z;
	reg N;
	reg V;
	reg Z_out_wire;
	reg N_out_wire;
	reg V_out_wire;
	reg [15:0] C_data;
	
	
	assign Z_out = Z_out_wire;
	assign N_out = N_out_wire;
	assign V_out = V_out_wire;
	assign datapath_out = C_data;


	regfile r(.w_data, .w_addr, .w_en, .r_addr, .clk, .r_data);
	shifter s(.shift_in, .shift_op, .shift_out);
	ALU a(.val_A, .val_B, .ALU_op, .ALU_out, .Z, .N, .V);

	always_ff @(posedge clk) begin
		
		
		if (en_A == 1) begin
			A_data <= r_data;
		end else begin
			A_data <= A_data;	
		
		end

		if (en_B == 1) begin
			shift_in <= r_data;
		end else begin
			shift_in <= shift_in;	
		end

		
		if (en_C == 1) begin
			C_data <= ALU_out;
		end else begin
			C_data <= C_data;	
		end

		if (en_status == 1) begin
			Z_out_wire <= Z;
			N_out_wire <= N;
			V_out_wire <= V;
		end else begin
			Z_out_wire <= Z_out_wire;	
			N_out_wire <= N_out_wire;
			V_out_wire <= V_out_wire;
		end

	end

	always_comb begin
	
		case(sel_A)
			1'b1: val_A = 16'b0000000000000000;
			1'b0: val_A = A_data;
			default: val_A = A_data;
		endcase


		case(sel_B)
			1'b1: val_B = sximm5; //changed from lab 5 datapath
			1'b0: val_B = shift_out;
			default: val_B = shift_out;
		endcase

		case (wb_sel)
			2'b00: w_data = C_data;
			2'b01: w_data = {8'b0,pc}; //next lab
			2'b10: w_data = sximm8; 
			2'b11: w_data = mdata; ///next lab
			default: w_data = C_data;
		endcase

	end
endmodule: datapath



