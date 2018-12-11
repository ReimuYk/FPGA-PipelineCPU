module equ(da, db, rsrtequ);
	input [31:0] da, db;
	output rsrtequ;
	
	assign rsrtequ = (da==db);
endmodule
