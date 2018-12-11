module ext2dimm(sa,imm,sa_imm,sext,dimm);
	input [31:0] sa;
	input [15:0] imm;
	input sa_imm, sext;
	output [31:0] dimm;
	
	wire          e = sext & imm[15]; // the bit to extend
	wire   [15:0] imm_ext = {16{e}}; // high 16 sign bit when sign extend (otherwise 0)
	wire   [31:0] immediate = {imm_ext, imm}; // extend immediate to high 16
	
	assign dimm = sa_imm ? sa : immediate;
endmodule
