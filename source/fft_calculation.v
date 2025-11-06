module FFT_calculation(
input i_aclk,
input i_aresetn,
input signed [11:0] ext_data,
input [10:0] addr_in,
input adc_valid,
input adc_last,
output signed [31:0] fft_data,
output fft_valid,
output fft_last
);

parameter FFT_LEN = 2048;     // FFT数据量

wire signed [11:0] ext_data;//输入

wire [11:0] i_axi4s_data_tdata1/* synthesis syn_keep=1 */;
wire        i_axi4s_data_tvalid/* synthesis syn_keep=1 */;
wire        i_axi4s_data_tlast/* synthesis syn_keep=1 */;
wire        o_axi4s_data_tready/* synthesis syn_keep=1 */;

wire        i_axi4s_cfg_tdata   = 1'b1/* synthesis syn_keep=1 */;   // 功能配置1=FFT 0=IFFT
wire        i_axi4s_cfg_tvalid  = 1'b1/* synthesis syn_keep=1 */;

wire signed [31:0] i_axi4s_data_tdata = {20'b0, ext_data}/* synthesis syn_preserve = 1 */;

adc_sample sampler_inst (
    .i_aclk     (i_aclk),
    .i_aresetn  (i_aresetn),

    .ext_data   (ext_data),
    .addr_in (addr_in),
    .adc_valid(adc_valid),
    .adc_last(adc_last),
    .ext_valid  (1'b1),//外部采样有效信号

    .m_axis_tdata (i_axi4s_data_tdata1),
    .m_axis_tvalid(i_axi4s_data_tvalid),
    .m_axis_tlast (i_axi4s_data_tlast),
    .m_axis_tready(o_axi4s_data_tready)
);


fft fft (
    .i_axi4s_data_tdata (i_axi4s_data_tdata),
    .i_axi4s_data_tvalid(i_axi4s_data_tvalid),
    .i_axi4s_data_tlast (i_axi4s_data_tlast),
    .o_axi4s_data_tready(o_axi4s_data_tready),

    .i_axi4s_cfg_tdata  (i_axi4s_cfg_tdata),
    .i_axi4s_cfg_tvalid (i_axi4s_cfg_tvalid),

    .i_aclk   (i_aclk),
    .i_aclken (1'b1),
    .i_aresetn(i_aresetn),

    .o_axi4s_data_tdata (fft_data),
    .o_axi4s_data_tvalid(fft_valid),
    .o_axi4s_data_tlast (fft_last)
);

endmodule
