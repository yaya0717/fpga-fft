module wave_judge(
input clk,
input rst,
input signed [11:0] data,

output reg [1:0] wave
    );
    
reg [6:0] addr;
wire [7:0] data_sin,data_square,data_tria;  
wire signed [7:0] sin =   data_sin - 128;
wire signed [7:0] square =   data_square - 128;
wire signed [7:0] tria =   data_tria - 128;

//正弦波 方波 三角波的模板
ROM_sin128 ROM_sin128 (
  .addr(addr),          // input [6:0]
  .clk(clk),            // input
  .rst(!rst),            // input
  .rd_data(data_sin)     // output [7:0]
);  
ROM_square128 ROM_square128 (
  .addr(addr),          // input [6:0]
  .clk(clk),            // input
  .rst(!rst),            // input
  .rd_data(data_square)     // output [7:0]
); 
ROM_tria128 ROM_tria128 (
  .addr(addr),          // input [6:0]
  .clk(clk),            // input
  .rst(!rst),            // input
  .rd_data(data_tria)     // output [7:0]
);     
    
wire signed [19:0] x_y_sin,x_y_square,x_y_tria;    
reg signed [26:0] x_y_sin_all,x_y_square_all,x_y_tria_all,dividend1,dividend2,dividend3;
wire [23:0] x_x;  
reg [31:0] x_x_all;
reg [49:0] divisor1,divisor2,divisor3;

//正弦波 方波 三角波的总离均差平方和
localparam y_y_sin_all = 1040258;
localparam y_y_square_all = 2080800;
localparam y_y_tria_all = 693559;
   

//计算波形与三个模板的皮尔逊相关系数
reg valid;   
always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        addr<=0;
        valid<=0;
        x_y_sin_all<=0;
        x_y_square_all<=0;
        x_y_tria_all<=0;
        x_x_all<=0;
    end else begin
        if(addr == 0)
        begin
            valid<=~valid;
            if(valid == 0)
            begin
                x_y_sin_all<=0;
                x_y_square_all<=0;
                x_y_tria_all<=0;
                x_x_all<=0;
            end
            else if(valid == 1)
            begin
                dividend1 <= x_y_sin_all;
                dividend2 <= x_y_square_all;
                dividend3 <= x_y_tria_all;
                divisor1 <= x_x_all * y_y_sin_all;
                divisor2 <= x_x_all * y_y_square_all;
                divisor3 <= x_x_all * y_y_tria_all;
            end
        end
        if(valid)
        begin
            x_y_sin_all<=x_y_sin_all+x_y_sin;
            x_y_square_all<=x_y_square_all+x_y_square;
            x_y_tria_all<=x_y_tria_all+x_y_tria;
            x_x_all<=x_x_all+x_x;
        end
        addr<=addr+1;
    end
end   
    
assign x_y_sin = data * sin;
assign x_y_square = data * square;
assign x_y_tria = data * tria;
assign x_x = data * data;

wire [24:0] div1,div2,div3;
square_root#(     
.d_width(50)
)root1(
.clk(clk),
.rst(!rst),
.i_vaild(1),
.data_i(divisor1),
.data_o(div1)
    );
square_root#(     
.d_width(50)
)root2(
.clk(clk),
.rst(!rst),
.i_vaild(1),
.data_i(divisor2),
.data_o(div2)
    );
square_root#(     
.d_width(50)
)root3(
.clk(clk),
.rst(!rst),
.i_vaild(1),
.data_i(divisor3),
.data_o(div3)
    );
wire signed [27:0] result1,result2,result3;

divider#(
.A_LEN(27),
.B_LEN(25)
)divider1(
.CLK(clk),						// 时钟信号
.RSTN(rst),                // 复位信号，低有效
.EN(1),                  // 输入数据有效,使能信号
.Dividend(dividend1),				//被除数
.Divisor(div1),					//除数
	
.Quotient(result1)
);

divider#(
.A_LEN(27),
.B_LEN(25)
)divider2(
.CLK(clk),						// 时钟信号
.RSTN(rst),                // 复位信号，低有效
.EN(1),                  // 输入数据有效,使能信号
.Dividend(dividend2),				//被除数
.Divisor(div2),					//除数
	
.Quotient(result2)
);

divider#(
.A_LEN(27),
.B_LEN(25)
)divider3(
.CLK(clk),						// 时钟信号
.RSTN(rst),                // 复位信号，低有效
.EN(1),                  // 输入数据有效,使能信号
.Dividend(dividend3),				//被除数
.Divisor(div3),					//除数
	
.Quotient(result3)
);


//相关系数越大 越接近哪种波形
always@(posedge clk)
begin
    if(result1>result2 && result1>result3)
        wave<=0;
    else if(result2>result1 && result2 > result3)
        wave<=1;
    else if(result3>result1 && result3 > result2)
        wave<=2;
    else
        wave<=3;
end

endmodule