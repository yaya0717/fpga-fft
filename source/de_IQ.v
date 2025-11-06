module de_IQ(
input clk,
input rst,
input signed [11:0] data,
input [25:0] fre,
input [9:0] phase,

output signed [15:0] result
   );

wire [31:0] freq = fre*159;
wire [11:0] sin,sin_data = sin-2048;
dds dds(
.clk(clk),
.rst(rst),
.freq(freq),
.phase(phase),
.dataout(sin)
);

wire signed [23:0] mix = data * sin_data;
wire signed [15:0] fir_in = mix>>8;

endmodule