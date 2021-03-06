module pipe_cu(op, func, rs, rt, ern, mrn, rsrtequ, ewreg, em2reg, mwreg, mm2reg,
	wpcir, wreg, m2reg, wmem, jal, aluimm, shift, regrt, sext, pcsource, fwda, fwdb, aluc);
	input            rsrtequ, ewreg, em2reg, mwreg, mm2reg;
	input      [4:0] rs, rt, ern, mrn;
	input      [5:0] op, func;
	output           wpcir, wreg, m2reg, wmem, jal, aluimm, shift, regrt, sext;
	output     [1:0] pcsource;
	output reg [1:0] fwda, fwdb;
	output     [3:0] aluc;

	 wire r_type = ~|op;
   wire i_add = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] & ~func[1] & ~func[0];          //100000
   wire i_sub = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] &  func[1] & ~func[0];          //100010
      
   //  please complete the deleted code.
   
   wire i_and = r_type & func[5] & ~func[4] & ~func[3] &
                func[2] & ~func[1] & ~func[0];          //100100
   wire i_or  = r_type & func[5] & ~func[4] & ~func[3] &
                func[2] & ~func[1] & func[0];          //100101

   wire i_xor = r_type & func[5] & ~func[4] & ~func[3] &
                func[2] & func[1] & ~func[0];          //100110
   wire i_sll = r_type & ~func[5] & ~func[4] & ~func[3] &
                ~func[2] & ~func[1] & ~func[0];          //000000
   wire i_srl = r_type & ~func[5] & ~func[4] & ~func[3] &
                ~func[2] & func[1] & ~func[0];          //000010
   wire i_sra = r_type & ~func[5] & ~func[4] & ~func[3] &
                ~func[2] & func[1] & func[0];          //000011
   wire i_jr  = r_type & ~func[5] & ~func[4] & func[3] &
                ~func[2] & ~func[1] & ~func[0];          //001000
                
   wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0]; //001000
   wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0]; //001100
   
   wire i_ori  = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] &  op[0]; //001101
   wire i_xori = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] & ~op[0]; //001110
   wire i_lw   =  op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0]; //100011
   wire i_sw   =  op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] &  op[0]; //101011
   wire i_beq  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0]; //000100
   wire i_bne  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0]; //000101
   wire i_lui  = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] &  op[0]; //001111
   wire i_j    = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] & ~op[0]; //000010
   wire i_jal  = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0]; //000011

	// Determine which instructions use rs/rt.
	wire urs = i_add | i_sub | i_and | i_or | i_xor | i_jr | i_addi | i_andi | i_ori | i_xori
		| i_lw | i_sw | i_beq | i_bne;
	wire urt = i_add | i_sub | i_and | i_or | i_xor | i_sll | i_srl | i_sra | i_sw | i_beq | i_bne;

	wire LUhazard = ewreg & em2reg & (ern != 0) & ((urs & (ern == rs)) | (urt & (ern == rt)));

	// When load/use hazard happens, stall F and D registers (stall PC),
	// and generate a bubble to E register (by forbidding writing registers and memory).
	assign wpcir = ~LUhazard;
	assign wreg = (i_add | i_sub | i_and | i_or | i_xor | i_sll | i_srl | i_sra
		| i_addi | i_andi | i_ori | i_xori | i_lw | i_lui | i_jal) & ~LUhazard;
	assign m2reg = i_lw;
	assign wmem = i_sw & ~LUhazard;
	assign jal = i_jal;
	assign aluimm = i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_lui;
	assign shift = i_sll | i_srl | i_sra;
	assign regrt = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui;
	assign sext = i_addi | i_lw | i_sw | i_beq | i_bne;

	assign pcsource[1] = i_jr | i_j | i_jal;
	assign pcsource[0] = (i_beq & rsrtequ) | (i_bne & ~rsrtequ) | i_j | i_jal;

	assign aluc[3] = i_sra;
	assign aluc[2] = i_sub | i_or | i_srl | i_sra | i_ori | i_beq | i_bne | i_lui;
	assign aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori | i_lui;
	assign aluc[0] = i_and | i_or | i_sll | i_srl | i_sra | i_andi | i_ori;

	// Forwarding logic.
	// Forward priority: Look for E stage first, then M stage.
	// Also, we should not forward r0.
	always @(*) begin
		if (ewreg & ~em2reg & (ern != 0) & (ern == rs))
			fwda = 2'b01; // ealu.
		else if (mwreg & ~mm2reg & (mrn != 0) & (mrn == rs))
			fwda = 2'b10; // malu.
		else if (mwreg & mm2reg & (mrn != 0) & (mrn == rs))
			fwda = 2'b11; // mmo.
		else
			fwda = 2'b00; 
	end

	always @(*) begin
		if (ewreg & ~em2reg & (ern != 0) & (ern == rt))
			fwdb = 2'b01; // ealu.
		else if (mwreg & ~mm2reg & (mrn != 0) & (mrn == rt))
			fwdb = 2'b10; // malu.
		else if (mwreg & mm2reg & (mrn != 0) & (mrn == rt))
			fwdb = 2'b11; // mmo.
		else
			fwdb = 2'b00; 
	end
endmodule
