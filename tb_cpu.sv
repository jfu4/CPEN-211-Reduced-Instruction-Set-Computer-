module tb_cpu(output err);
  // your implementation here


	reg clk;
	reg rst_n;
	reg load;
	reg start;
	reg [15:0] instr;
	reg waiting;
	reg [15:0] out;
	reg N;
	reg V;
	reg Z;

	reg error;
	assign err = error;

	cpu DUT(.clk, .rst_n, .load, .start, .instr, .waiting, .out, .N, .V, .Z);

	initial begin
		forever begin 
			clk = 0;
			#10;
			clk = 1;
			#10;
		end
	end

	initial begin
	error = 0;
	rst_n = 1'b0;
		
	#20;
	rst_n = 1'b1;
	//adding operation
	//waiting signal is 1 while instructions are executed
	//R0 = 0000000000000001
	instr = 16'b1101000000000001;
	load = 1;
	#20;

	//start signal asserted for one cycle
	start = 1;
	#20;
	
	//MVN 1 cycle
	#20;

	//R1 = 0000000000000010
	instr = 16'b1101000100000010;
	load = 1;
	#20;

	start = 1;
	#20;

	#20;
	
	//R2 = R1 + R0
	instr = 16'b1010000001000001;
	load = 1;
	#20;
	
	start = 1;
	#20;

	#20;

	start = 0;
	#80;
	assert(waiting === 1 && out === 16'b0000000000000011 && N === 0 && Z === 0 && V === 0) $display ("[PASS] 1 + 2 = 3");
	else begin 
		$error ("[FAIL] 1 + 2 = 3");
		error = 1;
	end
	

	//anding operation
	//waiting signal is 1 while instructions are executed
	//R3 = 0000000001010101
	instr = 16'b1101001101010101;
	load = 1;
	#20;

	//start signal asserted for one cycle
	start = 1;
	#20;

	//let CPU execute instruction for one cycle
	#20;
	
	//R4 = 1111111111011011
	instr = 16'b1101010011011011;
	load = 1;
	#20;

	start = 1;
	#20;

	#20;
	
	//R5 = R3 & R4 left shifted
	instr = 16'b1011001110101100;
	load = 1;
	#20;
	
	start = 1;
	#20;

	#20;
	start = 0;
	#80;

	assert(waiting === 1 && out === 16'b0000000000010100 && N === 0 && Z === 0 && V === 0) $display ("[PASS] 85 & -37 left shifted = 20");
	else begin 
		$error ("[FAIL] 85 & -37 left shifted = 20");
		error = 1;
	end

	
	//negation operation
	//waiting signal is 1 while instructions are executed
	//R6 = 1111111111110000
	instr = 16'b1101011011110000;
	load = 1;
	#20;

	//start signal asserted for one cycle
	start = 1;
	#20;

	//let CPU execute instruction for one cycle
	#20;
	
	//R7 = ~R6 logical right shifted
	instr = 16'b1011100011110110;
	load = 1;
	#20;
	
	start = 1;
	#20;

	#20;
	start = 1'b0;
	#80;

	assert(waiting === 1 && out === 16'b1000000000000111 && N === 1 && Z === 0 && V === 0) $display ("[PASS] -16 logical right shifted then negated = 32761");
	else begin 
		$error ("[FAIL] 16 logical right shifted then negated = 32761");
		error = 1;
	end

	//compare operation
    //waiting signal is 1 while instructions are executed
    //R0 = 0000000000000001
    instr = 16'b1101000000000001;
    load = 1;
    #20;

    //start signal asserted for one cycle
    start = 1;
    #20;

    //let CPU execute instruction for one cycle
    #20;

    //R1 = 0000000000000010
    instr = 16'b1101000100000010;
    load = 1;
    #20;

    start = 1;
    #20;

    #20;

    //CMP R1 and R0 by subtracting R1 from R0 then looking at status values
    instr = 16'b1010100100000000;
    load = 1;
    #20;

    start = 1;
    #20;

    #20;
    start = 1'b0;
    #80;

    assert(waiting === 1 && N === 1 && Z === 0 && V === 0) $display ("[PASS] 1 - 2 = -1 and N = 1 since second number is bigger");
    else begin 
        $error ("[FAIL] 1 - 2 = -1 and N = 1 since second number is bigger");
        error = 1;
    end



	$stop;
  end
	
endmodule: tb_cpu
