module reg_M(ewreg, em2reg, ewmem, 
ealu, eb, ern, 
clock, resetn, 
mwreg, mm2reg, mwmem, malu, mb, mrn);
	input         ewreg, em2reg, ewmem, clock, resetn;
	input  [4:0]  ern;
	input  [31:0] ealu, eb;
	output        mwreg, mm2reg, mwmem;
	output [4:0]  mrn;
	output [31:0] malu, mb;
	
	/* need to complete */
endmodule
