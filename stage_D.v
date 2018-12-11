module pipe_D_stage(mwreg, mrn, ern, ewreg, em2reg, mm2reg, dpc4,
	op, func, rs, rt, rd, sa, imm, sa_imm, addr,
	wrn, wdi, ealu, malu, mmo, wwreg, clock, resetn,
	pcsource, wpcir, dwreg, dm2reg, dwmem, daluc,
	daluimm, da, db, dimm, drn, dshift, djal);
	input         mwreg, ewreg, em2reg, mm2reg, wwreg, clock, resetn;
	input  [4:0]  mrn, ern, wrn;
	input  [31:0] dpc4, wdi, ealu, malu, mmo;
	input  [5:0]  op, func;
	input  [4:0]  rs, rt, rd;
	input  [31:0] sa;
	input  [15:0] imm;
	input  [25:0] addr;
	input 		  sa_imm;
	output        wpcir, dwreg, dm2reg, dwmem, daluimm, dshift, djal;
	output [1:0]  pcsource;
	output [3:0]  daluc;
	output [4:0]  drn;
	output [31:0] da, db, dimm;

	wire          rsrtequ, regrt, sext;
	wire   [1:0]  fwda, fwdb;
	wire   [31:0] qa, qb;

	wire          e = sext & imm[15]; // the bit to extend
	wire   [15:0] imm_ext = {16{e}}; // high 16 sign bit when sign extend (otherwise 0)
	wire   [31:0] immediate = {imm_ext, imm}; // extend immediate to high 16

	assign rsrtequ = da == db;
	assign dimm = op == 6'b000000 ? sa : immediate; // combine sa and immediate to one signal

	pipe_cu cu(op, func, rs, rt, ern, mrn, rsrtequ, ewreg, em2reg, mwreg, mm2reg,
		wpcir, dwreg, dm2reg, dwmem, djal, daluimm, dshift, regrt, sext, pcsource, fwda, fwdb, daluc);
	regfile rf(rs, rt, wdi, wrn, wwreg, clock, resetn, qa, qb);
	mux4x32 selecta(qa, ealu, malu, mmo, fwda, da);
	mux4x32 selectb(qb, ealu, malu, mmo, fwdb, db);
	mux2x5 selectrn(rd, rt, regrt, drn);
endmodule
