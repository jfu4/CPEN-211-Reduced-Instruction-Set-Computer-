module cpu(input clk, input rst_n, input load, input start, input [15:0] instr,
           output waiting, output [15:0] out, output N, output V, output Z);


	reg [2:0] opcode;
	reg [1:0] ALU_op;
	reg [1:0] shift_op;
	reg [1:0] reg_sel;
	reg [1:0] wb_sel;
	reg w_en;
	reg en_A;
	reg en_B;
	reg en_C;
	reg en_status;
	reg sel_A;
	reg sel_B;
	
	reg [15:0] ir;
        reg [15:0] sximm5;
	reg [15:0] sximm8;
        reg [2:0] r_addr;
	reg [2:0] w_addr; 

	reg [15:0] mdata;
	reg [7:0] pc;
        reg [15:0] datapath_out;
	reg Z_out;
	reg N_out; 
	reg V_out;
	
	assign out = datapath_out;
	assign N = N_out;
	assign V = V_out;
	assign Z = Z_out;

	controller c(.clk, .rst_n, .start, .opcode, .ALU_op, .shift_op, .Z, .N, .V, .waiting, .reg_sel, .wb_sel,
			.w_en, .en_A, .en_B, .en_C, .en_status, .sel_A, .sel_B);

	idecoder i(.ir, .reg_sel, .opcode, .ALU_op, .shift_op, .sximm5, .sximm8, .r_addr, .w_addr);

	datapath d(.clk, .mdata, .pc, .wb_sel, .w_addr, .w_en, .r_addr, .en_A, .en_B, .shift_op, .sel_A, .sel_B, .ALU_op, .en_C, .en_status, .sximm8, .sximm5, .datapath_out, .Z_out, .N_out, .V_out);

	always_ff @(posedge clk) begin

		if (load == 1) begin
			ir <= instr;
		end else begin
			ir <= ir;
		end

	end

endmodule: cpu
