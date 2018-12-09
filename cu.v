module cu(pcsource,wpcir,
op,func,rs,rt,
mrn,mm2reg,mwreg,ern,em2reg,
wreg,m2reg,wmem,jal,aluc,aluimm,shift,rsrtequ,regrt,sext,fwdb,fwda);
	input            rsrtequ, ewreg, em2reg, mwreg, mm2reg;
	input      [4:0] rs, rt, ern, mrn;
	input      [5:0] op, func;
	output           wpcir, wreg, m2reg, wmem, jal, aluimm, shift, regrt, sext;
	output     [1:0] pcsource;
	output reg [1:0] fwda, fwdb;
	output     [3:0] aluc;
	
	/* need to complete */
	
endmodule