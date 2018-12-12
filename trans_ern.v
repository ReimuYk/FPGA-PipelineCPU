module trans_ern(ern0,ejal,ern);
	input [4:0] ern0;
	input ejal;
	output [4:0] ern;
	
	assign ern = ern0 | {5{ejal}};
endmodule
