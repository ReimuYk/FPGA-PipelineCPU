module reg_E(dwreg, dm2reg, dwmem, daluc, daluimm, da, db, dimm, drn, dshift,
djal, dpc4, clock, resetn, ewreg, em2reg, ewmem, ealuc, ealuimm,
ea, eb, eimm, ern0, eshift, ejal, epc4);
	input         dwreg, dm2reg, dwmem, daluimm, dshift, djal, clock, resetn;
	input  [3:0]  daluc;
	input  [4:0]  drn;
	input  [31:0] da, db, dimm, dpc4;
	output        ewreg, em2reg, ewmem, ealuimm, eshift, ejal;
	output [3:0]  ealuc;
	output [4:0]  ern0;
	output [31:0] ea, eb, eimm, epc4;
	
	/* need to complete */
	
endmodule
