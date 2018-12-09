module reg_F(pc_src, wpcir, clock, resetn, pc);
	input  [31:0]	pc_src;
	input				wpcir, clock, resetn;
	output [31:0]  pc;
	
	dffe32pc ip(pc_src, clock, resetn, wpcir, pc);
endmodule
