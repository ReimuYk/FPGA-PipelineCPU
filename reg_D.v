module pipe_D_reg(pc4, ins, wpcir, clock, resetn, dpc4,
op,func,rs,rt,rd,sa,imm,sa_imm,addr,
jpc,bpc
);
	input  [31:0] pc4, ins;
	input         wpcir, clock, resetn;
	output [5:0]  op,func;
	output [4:0]  rs,rt,rd;
	output [15:0] imm;
	output [25:0] addr;
	output [31:0] jpc,bpc,sa;
	output		  sa_imm;
	output [31:0] dpc4;
	
	wire   [31:0] inst;
	wire   [31:0] boffset = {{14{imm[15]}},imm, 2'b00}; // branch addr offset
		
	assign op = inst[31:26];
	assign func = inst[5:0];
	assign rs = inst[25:21];
	assign rt = inst[20:16];
	assign rd = inst[15:11];
	assign imm = inst[15:0];
	assign addr = inst[25:0];
	assign sa = {27'b0, inst[10:6]}; // zero extend sa to 32 bits for shift instruction
	
	assign jpc = {dpc4[31:28], addr, 2'b00};
	assign bpc = dpc4 + boffset;
	assign sa_imm = (op==6'b000000); // combine sa and immediate to one signal

	dffe32 pc4_r_d(pc4, clock, resetn, wpcir, dpc4);
	dffe32 ins_r_d(ins, clock, resetn, wpcir, inst);
endmodule
