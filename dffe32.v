// 32bit D flip-flop with an enable signal.
module dffe32(d, clk, clrn, e, q);
	input      [31:0] d;
	input             clk, clrn, e;
	output reg [31:0] q;

	always @(negedge clrn or posedge clk)
		if (clrn == 0) begin
			q <= 0;
		end else begin
			if (e == 1)
				q <= d;
		end
endmodule
