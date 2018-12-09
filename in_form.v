module in_form(sw0,sw1,sw2,sw3,sw4,out);

	input sw0,sw1,sw2,sw3,sw4;
	output [31:0] out;

	assign out[4] = sw4;
	assign out[3] = sw3;
	assign out[2] = sw2;
	assign out[1] = sw1;
	assign out[0] = sw0;
endmodule