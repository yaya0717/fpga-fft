module thd_measure(
input clk,
input rst,
input [11:0] data,
input [9:0] addr,
input valid,
output [9:0] thd,
output reg [9:0] addr_out
    );
    
reg [11:0] fjw_data[0:1023];
reg [9:0] h1_addr,h2_addr,h3_addr,h4_addr,h5_addr,addr_in/* synthesis PAP_MARK_DEBUG="true" */;
reg [11:0] h1_num,h2_num,h3_num,h4_num,h5_num/* synthesis PAP_MARK_DEBUG="true" */;
reg [23:0] h2_square,h3_square,h4_square,h5_square/* synthesis PAP_MARK_DEBUG="true" */;
reg [23:0] square,square1,square2/* synthesis PAP_MARK_DEBUG="true" */;
wire [11:0] h/* synthesis PAP_MARK_DEBUG="true" */;
reg [5:0] state/* synthesis PAP_MARK_DEBUG="true" */;
reg [31:0] timer/* synthesis PAP_MARK_DEBUG="true" */;
integer i;
always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        h1_addr<=0;
        h2_addr<=0;
        h3_addr<=0;
        h4_addr<=0;
        h5_addr<=0;
        addr_in<=0;
        h1_num<=0;
        h2_num<=0;
        h3_num<=0;
        h4_num<=0;
        h5_num<=0;
        h2_square<=0;
        h3_square<=0;
        h4_square<=0;
        h5_square<=0;
        square<=0;
        square1<=0;
        square2<=0;
        state<=0;
        timer<=0;
        for(i=0;i<1024;i=i+1)
        begin
            fjw_data[i]<=0;
        end
    end
    else
    begin
        if(timer==10000)
        begin
            case(state)
            0:
            begin
                addr_in<=0;  
                h1_num<=0;
                h1_addr<=0;     
                state<=state+1;     
            end
            1:
            begin
                addr_in<=addr_in+1;    
                if(fjw_data[addr_in]>h1_num)
                begin
                    h1_num<=fjw_data[addr_in];
                    h1_addr<=addr_in;
                end                  
                if(addr_in==1022)
                begin
                    state<=state+1;
                end     
            end
            2:
            begin
                addr_out<=h1_addr;
                h2_addr<=h1_addr*2;
                h3_addr<=h1_addr*3;
                h4_addr<=h1_addr*4;
                h5_addr<=h1_addr*5;
                state<=state+1;
            end
            3:
            begin
                h2_num<=fjw_data[h2_addr];
                h3_num<=fjw_data[h3_addr];
                h4_num<=fjw_data[h4_addr];
                h5_num<=fjw_data[h5_addr];     
                state<=state+1;       
            end
            4:
            begin
                h2_square <= h2_num * h2_num;
                state<=state+1;
            end
            5:
            begin
                h3_square <= h3_num * h3_num;
                state<=state+1;
            end
            6:
            begin
                h4_square <= h4_num * h4_num;
                state<=state+1;
            end
            7:
            begin
                h5_square <= h5_num * h5_num;
                state<=state+1;
            end
            8:
            begin
                square1<=h2_square+h3_square;
                square2<=h4_square+h5_square;
                state<=state+1;
            end
            9:
            begin
                square<=square1+square2;
                state<=state+1;              
            end
            10:
            begin
                timer<=0;
                state<=0;
            end
            endcase
        end
        else
        begin
            timer<=timer+1;
            if(addr<=1023 && valid)
            begin
                fjw_data[addr]<=data;
            end
        end
    end
end
    
 
square_root#( 	
.d_width(24)
)square_root(
.clk(clk),
.rst(!rst),
.i_vaild(1),
.data_i(square), //输入
.data_o(h)
    );
  
divider#(
.A_LEN(12),
.B_LEN(12)
)divider(
.CLK(clk),						// 时钟信号
.RSTN(rst),                // 复位信号，低有效
.EN(1),                  // 输入数据有效,使能信号
.Dividend(h),				//被除数
.Divisor(h1_num),					//除数
.Quotient(thd)
);
 
endmodule