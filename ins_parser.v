module ins_parser(inst,dpc4,op,func,rs,rt,rd,sa,imm,sa_imm,jpc,boff);
	input [31:0] inst,dpc4;
	output [5:0] op;
	output [5:0] func;
	output [4:0] rs,rt,rd,sa;
	output [15:0] imm;
	output       sa_imm;
	output [31:0] jpc,boff;
	
	assign op = inst[31:26];
	assign func = inst[5:0];
	assign rs = inst[25:21];
	assign rt = inst[20:16];
	assign rd = inst[15:11];
	assign sa = inst[10:6];
	assign imm = inst[15:0];
	assign sa_imm = (op==6'b000000);
	assign jpc = {dpc4[31:28],inst[25:0],2'b00};
	assign boff = {14'b0,imm,2'b0};
	
endmodule
