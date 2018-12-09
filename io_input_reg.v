module io_input_reg(addr,io_clk,io_read_data,in_port0,in_port1);

input [31:0] addr;
input        io_clk;
input [31:0] in_port0,in_port1;
output [31:0] io_read_data;

reg [31:0]    in_reg0;
reg [31:0]    in_reg1;

io_input_mux  io_input_mux2x32(in_reg0,in_reg1,addr[7:2],io_read_data);

always @ (posedge io_clk)
begin
    in_reg0 <= in_port0;
    in_reg1 <= in_port1;
end
endmodule

module io_input_mux(a0,a1,se1_addr,y);
input [31:0] a0,a1;
input [5:0]  se1_addr;
output [31:0]  y;
reg[31:0]     y;

always @ *
case(se1_addr)
    6'b110000: y=a0;
    6'b110001: y=a1;
endcase
endmodule