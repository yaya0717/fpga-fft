module divider #(
	parameter		A_LEN = 8,
	parameter		B_LEN = 4)(
	input								CLK,						// 时钟信号
	input								RSTN,                // 复位信号，低有效
	input								EN,                  // 输入数据有效,使能信号
	input [A_LEN-1:0]				Dividend,				//被除数
	input	[B_LEN-1:0]				Divisor,					//除数
	
	output [A_LEN-1:0]			Quotient,				//商
	output [B_LEN-1:0]			Mod,						//余
	output							RDY);
	
	wire [A_LEN-1:0]				Quotient_reg		[A_LEN-1:0];
	wire [B_LEN-1:0] 				Mod_reg				[A_LEN-1:0];
	wire [A_LEN-1:0]				Dividend_ini_reg	[A_LEN-1:0];
	wire [A_LEN-1:0]				rdy;
	wire [B_LEN-1:0]				Divisor_reg			[A_LEN-1:0];
	
	// 初始化第一个Div_cell模块，处理最初的被除数和除数
	Div_cell	#(.A_LEN(A_LEN),.B_LEN(B_LEN))	Divider(
		.CLK(CLK),
		.RSTN(RSTN),
		.EN(EN),
		.Dividend({{(B_LEN){1'b0}}, Dividend[A_LEN-1]}),		// 将被除数的最高位与0拼接
		.Divisor(Divisor),	
		.Dividend_i(Dividend),
		.Quotient_i('b0),
 
		.Quotient(Quotient_reg[A_LEN-1]),
		.Mod(Mod_reg[A_LEN-1]),		
		.Dividend_o(Dividend_ini_reg[A_LEN-1]),
		.Divisor_o(Divisor_reg[A_LEN-1]),
		.RDY(rdy[A_LEN-1])
		);
	
	// 生成多个Div_cell模块，构成流水线计算结构
	genvar i;
	
	generate 
		for(i=A_LEN-2;i>=0;i=i-1) begin : Div_flow_loop
			Div_cell	#(.A_LEN(A_LEN),.B_LEN(B_LEN))	Divider(
				.CLK(CLK),
				.RSTN(RSTN),
				.EN(rdy[i+1]),
				.Dividend({Mod_reg[i+1], Dividend_ini_reg[i+1][i]}),	// 当前余数与下一个被除数位拼接
				.Divisor(Divisor_reg[i+1]),	
				.Dividend_i(Dividend_ini_reg[i+1]),
				.Quotient_i(Quotient_reg[i+1]),
		
				.Quotient(Quotient_reg[i]),
				.Mod(Mod_reg[i]),		
				.Dividend_o(Dividend_ini_reg[i]),
				.Divisor_o(Divisor_reg[i]),
				.RDY(rdy[i])
				);	
		end
	endgenerate
	
	assign RDY=rdy[0];
	assign Quotient = Quotient_reg[0];
	assign Mod = Mod_reg[0]; 
	
endmodule
 
 
module Div_cell#(
	parameter						A_LEN = 8,
	parameter						B_LEN = 4
	)(
	input											CLK,						// 时钟信号
	input											RSTN,						// 复位信号，低有效
	input											EN,						// 输入数据有效,使能信号
	input [B_LEN:0]							Dividend,				//被除数,由上一级传递的余数加上外部模块拼接的原始被除数的下一位
	input	[B_LEN-1:0]							Divisor,					//上一级传递的除数
	input [A_LEN-1:0]							Dividend_i,				//原始被除数
	input [A_LEN-1:0]							Quotient_i,				//上一级传递的商
	
	output reg [A_LEN-1:0]					Quotient,				//商,传递到下一级
	output reg [B_LEN-1:0]					Mod,						//余,也是下一级的被除数
	output reg [A_LEN-1:0]					Dividend_o,				//原始被除数
	output reg [B_LEN-1:0]					Divisor_o,				//原始除数								
	output reg									RDY);
	
	always @(posedge CLK or negedge RSTN) begin
		if(!RSTN) begin													// 异步复位，清零所有寄存器
			Quotient <=	'b0;
			Mod <= 'b0;	
			Dividend_o <= 'b0;
			Divisor_o <= 'b0;
			RDY <= 'b0;	
		end else if(EN) begin											// 当使能信号有效时，进行除法运算
			RDY <= 1'b1;
			Dividend_o <= Dividend_i;
			Divisor_o <= Divisor;
			if(Dividend>={1'b0,Divisor}) begin						// 当前被除数大于等于除数时，商加1，余数更新
				Quotient <= (Quotient_i<<1)+1'b1;
				Mod <= Dividend-{1'b0,Divisor};
			end else begin																
				Quotient <= (Quotient_i<<1)+1'b0;					// 当前被除数小于除数时，商不变，余数不变
				Mod <= Dividend;
			end
		end else begin														// 当使能信号无效时，清零所有寄存器
			Quotient <=	'b0;
			Mod <= 'b0;	
			Dividend_o <= 'b0;
			Divisor_o <= 'b0;
			RDY <= 'b0;
		end
	end
	
endmodule