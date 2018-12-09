module out_form(datain,hex0,hex1);
	input [31:0] datain;
	output [6:0] hex0,hex1;
	
	reg [3:0] num1,num0;
	
	sevenseg disp0(num0,hex0);
	sevenseg disp1(num1,hex1);
	
	always @ (datain)
	begin
		num1 = datain/10;
		num0 = datain%10;
	end
endmodule