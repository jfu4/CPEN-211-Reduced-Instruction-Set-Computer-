module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);
	reg waiting_out;
	reg[1:0] reg_sel_out;
	reg w_en_out;
	reg[1:0] wb_sel_out;

	reg en_A_out;
	reg en_B_out;
	reg en_C_out;
	reg en_status_out;
	reg sel_A_out;
	reg sel_B_out;
	
	assign waiting = waiting_out;
	assign reg_sel = reg_sel_out;
	assign w_en = w_en_out;
	assign wb_sel = wb_sel_out;

	assign en_A = en_A_out;
	assign en_B = en_B_out;
	assign en_C = en_C_out;
	assign en_status = en_status_out;
	assign sel_A = sel_A_out;
	assign sel_B = sel_B_out;
	
	reg [2:0] state_cycle;
	
	parameter cycle_one = 3'b000; //reading to A/B
	parameter cycle_two = 3'b001; //reading to B
	parameter cycle_three = 3'b010; //doing the ALU/shifting and store in C
	parameter cycle_four = 3'b011; //writeback
	parameter waiting_state = 3'b100; //waiting state


	parameter Rm = 2'b00;
	parameter Rd = 2'b01;
	parameter Rn = 2'b10;

	always_ff @(posedge clk) begin 

		if (~rst_n) begin

				state_cycle <= waiting_state;

		end else begin 
				case(state_cycle) 
					cycle_one: begin
							if (start == 1'b1) begin //start is only asserted once
		
								if (ALU_op == 2'b11) begin //ALU_op is MVN(no need to store in A)
									state_cycle <= cycle_three;
								end else if (opcode == 3'b110 && ALU_op == 2'b00) begin //if move normal (no need to store in A)
									state_cycle <= cycle_three;	
								end else begin //ADD, CMP, AND
									state_cycle <= cycle_two;
								end

							end else begin 
								state_cycle <= cycle_one; //if start != 1
							end
							
							end
							
					cycle_two: begin //store in B
							state_cycle <= cycle_three;
							end
					cycle_three: begin //store in C
							if (opcode == 3'b101 && ALU_op == 2'b01) begin //if doing CMP
								state_cycle <= waiting_state;

							end else begin
								state_cycle <= cycle_four;
							end
							end
					cycle_four: state_cycle <= waiting_state;			
					waiting_state: begin 
							//reset everything								
							if (start == 1'b1) begin
								if (opcode == 3'b110 && ALU_op == 2'b10) begin //if move immediate (just need 1 clk cycle)
									
									
									state_cycle <= waiting_state;

								end else begin 
								
									state_cycle <= cycle_one;
								end
								
							end else begin 
								state_cycle <= waiting_state;


							end
							end

					default: state_cycle <= cycle_one;
					endcase
			end

	end



	always_comb begin

		case(state_cycle)

			cycle_one: begin if (start == 1'b1) begin
						waiting_out = 1'b0;
						if (ALU_op == 2'b11) begin //ALU_op is MVN(no need to store in A)
							reg_sel_out = Rm; //read from Rm
							en_A_out = 1'b0;
							en_B_out = 1'b1;
						
							waiting_out = 1'b0;
							en_C_out = 1'b0;
							sel_A_out = 1'b0;
							sel_B_out = 1'b0;
							w_en_out = 1'b0;
							en_status_out = 1'b0;
							wb_sel_out = 2'b00;
						end else if (opcode == 3'b110 && ALU_op == 2'b00) begin //if move normal (no need to store in A)
							reg_sel_out = Rm; //read from Rm
							en_A_out = 1'b0;
							en_B_out = 1'b1;
		

							waiting_out = 1'b0;
							en_C_out = 1'b0;
							sel_A_out = 1'b0;
							sel_B_out = 1'b0;
							w_en_out = 1'b0;
							en_status_out = 1'b0;
							wb_sel_out = 2'b00;
						end else begin //ADD, CMP, AND
							reg_sel_out = Rn; //read from Rn
							en_A_out = 1'b1; 
							en_B_out = 1'b0;


							waiting_out = 1'b0;
							en_C_out = 1'b0;
							sel_A_out = 1'b0;
							sel_B_out = 1'b0;
							w_en_out = 1'b0;
							en_status_out = 1'b0;
							wb_sel_out = 2'b00;
						end
					end else begin 
						
						en_A_out = 1'b0;
						en_B_out = 1'b0;
						en_C_out = 1'b0;
						sel_A_out = 1'b0;
						sel_B_out = 1'b0;
						w_en_out = 1'b0;
						en_status_out = 1'b0;
						reg_sel_out = Rn;
						wb_sel_out = 2'b00;
						waiting_out = 1'b0;
					end
					end
			cycle_two: begin //store in B
					reg_sel_out = Rm;//read from Rm
							
					en_A_out = 1'b0;
					en_B_out = 1'b1;

					waiting_out = 1'b0;
					en_C_out = 1'b0;
					sel_A_out = 1'b0;
					sel_B_out = 1'b0;
					w_en_out = 1'b0;
					en_status_out = 1'b0;
					wb_sel_out = 2'b00;

					end
			cycle_three: begin //store in C
					en_A_out = 1'b0;
					en_B_out = 1'b0;
					en_C_out = 1'b1;
					sel_A_out = 1'b0;
					sel_B_out = 1'b0;
					en_status_out = 1'b1;
					
					w_en_out = 1'b0;
					reg_sel_out = Rn;
					waiting_out = 1'b0;
					wb_sel_out = 2'b00;
					end


			cycle_four: begin 
					en_A_out = 1'b0;
					en_B_out = 1'b0;
					sel_A_out = 1'b0;
					sel_B_out = 1'b0;

					en_C_out = 1'b0;
					en_status_out = 1'b0;
					wb_sel_out = 2'b00;
					w_en_out = 1'b1;
					reg_sel_out = Rd;	
					waiting_out = 1'b0;						
					end
			waiting_state: begin 
					//reset everything
					en_A_out = 1'b0;
					en_B_out = 1'b0;
					en_C_out = 1'b0;
					sel_A_out = 1'b0;
					sel_B_out = 1'b0;
					w_en_out = 1'b0;
					en_status_out = 1'b0;
					wb_sel_out = 2'b00;
					reg_sel_out = Rn;
					waiting_out = 1'b1;
					if (start == 1'b1) begin
						if (opcode == 3'b110 && ALU_op == 2'b10) begin //if move immediate (just need 1 clk cycle)
							en_A_out = 1'b0;		
							w_en_out = 1'b1;
							reg_sel_out = Rn; //read and write from Rn
							wb_sel_out = 2'b10; //choose sximm8

							en_B_out = 1'b0;
							en_C_out = 1'b0;
							sel_A_out = 1'b0;
							sel_B_out = 1'b0;
							en_status_out = 1'b0;
							waiting_out = 1'b1;
						end else begin
							en_A_out = 1'b0;
							waiting_out = 1'b0;
							en_B_out = 1'b0;
							en_C_out = 1'b0;
							sel_A_out = 1'b0;
							sel_B_out = 1'b0;
							w_en_out = 1'b0;
							en_status_out = 1'b0;
							wb_sel_out = 2'b00;
							reg_sel_out = Rn;
	
						end 
					end else begin 
						en_A_out = 1'b0;
						en_B_out = 1'b0;
						en_C_out = 1'b0;
						sel_A_out = 1'b0;
						sel_B_out = 1'b0;
						w_en_out = 1'b0;
						en_status_out = 1'b0;
						wb_sel_out = 2'b00;
						reg_sel_out = Rn;
						waiting_out = 1'b1;

					end
					end
				default: begin 
						waiting_out = 1'b1;
						en_A_out = 1'b0;
						en_B_out = 1'b0;
						en_C_out = 1'b0;
						sel_A_out = 1'b0;
						sel_B_out = 1'b0;
						w_en_out = 1'b0;
						en_status_out = 1'b0;
						reg_sel_out = Rn;
						wb_sel_out = 2'b00;
						end
		endcase


	end



endmodule: controller
