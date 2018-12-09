module extimm(sa,imm,sext,sa_imm,dimm);
	input [4:0] sa;
	input [15:0] imm;
	input sext;
	input sa_imm;
	output [31:0] dimm;
	
	wire e = sext & imm[15];
	wire [31:0] out_sa = {27'b0,sa};
	wire [31:0] out_imm = {16{e},imm};
	assign dimm = sa_imm ?  out_sa : out_imm;
endmodule
