module reg_D(pc4, ins, wpcir, clock, resetn, dpc4, dins);
	input	[31:0]	pc4, ins;
	input				wpcir, clock, resetn;
	output[31:0]	dpc4, dins;
	
	dffe32 pc4_r_d(pc4, clock, resetn, wpcir, dpc4);
	dffe32 ins_r_d(ins, clock, resetn, wpcir, inst);
endmodule
