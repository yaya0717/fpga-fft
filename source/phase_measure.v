module phase_measure(
input clk,
input rst,
input signed [15:0] img,
input signed [15:0] rel,

output signed [11:0] phase
);

wire signed [15:0] theta;

cordic_arctan cordic_arctan(
.clk(clk),
.rst_n(rst),
.cordic_req(1),
.X(rel),
.Y(img),
    
.theta(theta) 
);

wire signed [19:0] phase_bu =  theta*18;
assign phase = phase_bu>>>8;

endmodule