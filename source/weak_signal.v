module weak_signal(
input clk,
input rst,
input signed [11:0] data,
input [25:0] fre,

output signed [11:0] data_out
   );

assign data_out = result>>4;
wire [15:0] result;
wire signed [15:0]I_road,Q_road;

de_IQ de_I(
.clk(clk),
.rst(rst),
.data(data),
.fre(fre),
.phase(0),

.result(I_road)
   );

de_IQ de_Q(
.clk(clk),
.rst(rst),
.data(data),
.fre(fre),
.phase(512),

.result(Q_road)
   );

wire [31:0] I_square = I_road * I_road;
wire [31:0] Q_square = Q_road * Q_road;
wire [31:0] square = I_square + Q_square;

square_root#( 	
.d_width(32)
)square_root(
.clk(clk),
.rst(!rst),
.i_vaild(1),
.data_i(square),
.data_o(result)
    );

endmodule