module adc_sample(
input i_aclk,
input i_aresetn,

input signed [11:0] ext_data/* synthesis PAP_MARK_DEBUG="true" */,   // 外部输入采样值
input [10:0] addr_in,
input ext_valid,  // 外部采样有效信号
input adc_valid,
input adc_last,
output signed [11:0] m_axis_tdata,//12位有符号数据
output reg m_axis_tvalid,//输出有效信号
output reg m_axis_tlast,//当采样计数达到FFT_LEN-1时，输出一个周期的高电平
input m_axis_tready//输入 ready 信号（来自FFT IP）
);

parameter FFT_LEN    = 2048;

wire [11:0] data_unsigned = ext_data+2048;
reg [23:0] o_data1/* synthesis PAP_MARK_DEBUG="true" */;
reg [23:0] o_data2/* synthesis PAP_MARK_DEBUG="true" */;
reg signed [23:0] o_data/* synthesis PAP_MARK_DEBUG="true" */;
wire [11:0] hamming_data/* synthesis PAP_MARK_DEBUG="true" */;
assign m_axis_tdata = o_data[23:12];
reg [10:0] cnt;
reg valid;

always @(posedge i_aclk or negedge i_aresetn) 
begin
    if(i_aresetn == 0) 
    begin
        o_data <= 0;
        o_data1<=0;
        o_data2<=0;
        m_axis_tvalid<= 0;
        m_axis_tlast <= 0;
        valid<=0;
        cnt<=0;
    end else begin
        if(adc_valid)
            valid<=1;
        if(adc_last)
            valid<=0;
        if (ext_valid && m_axis_tready && valid) begin
            cnt<=cnt+1;;
            o_data1 <= data_unsigned * hamming_data;
            o_data2 <= hamming_data<<11;
            o_data <= o_data1-o_data2;
            m_axis_tvalid <= 1'b1;

            // 最后一个点拉高 tlast
            if (cnt == FFT_LEN-1) begin
                m_axis_tlast <= 1'b1;
                valid<=0;
                cnt<=0;
            end else begin
                m_axis_tlast <= 1'b0;
            end
        end else begin
            m_axis_tvalid <= 1'b0;  // 没有输入或下游没准备好
            m_axis_tlast  <= 1'b0;
            cnt<=0;
        end
    end
end

hamming hamming (
  .addr(cnt),          // input [10:0]
  .clk(i_aclk),            // input
  .rst(!i_aresetn),            // input
  .rd_data(hamming_data)     // output [11:0]
);

endmodule
