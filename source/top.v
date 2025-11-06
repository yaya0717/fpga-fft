module top(
input clk/* synthesis PAP_MARK_DEBUG="1" */,
input rst,
input A1,B1,
input [11:0] adc1/* synthesis PAP_MARK_DEBUG="1" */,
input [11:0] adc2/* synthesis PAP_MARK_DEBUG="1" */,
output adc1_clk/* synthesis PAP_MARK_DEBUG="1" *//* synthesis syn_keep=1 */,
output adc2_clk/* synthesis PAP_MARK_DEBUG="1" *//* synthesis syn_keep=1 */,
input hmi_rx/* synthesis PAP_MARK_DEBUG="1" */,
output hmi_tx/* synthesis PAP_MARK_DEBUG="1" *//* synthesis syn_keep=1 */,
input esp8266_rx,
output esp8266_tx,
output [7:0] led
   );

wire flag1,flag2;
wire uart_clk/* synthesis PAP_MARK_DEBUG="1" */;
wire adc_clk/* synthesis PAP_MARK_DEBUG="1" */;
wire lock/* synthesis PAP_MARK_DEBUG="1" */;
assign adc1_clk = ~adc_clk;
assign adc2_clk = ~adc_clk;
PLL PLL (
  .clkout0(adc_clk),    // output  64MHZ
  .clkout1(uart_clk),    // output  6MHZ
  .lock(lock),          // output
  .clkin1(clk)       // input  27MHZ
);

wire signed [11:0] phase1,phase2;
wire [11:0] phase = phase1 - phase2 > 0 ? phase1 - phase2 : phase2 - phase1;
wire adc1_fix = (adc1 >= ((Vmax1 + Vmin1) >> 1)) ? 1 : 0/* synthesis PAP_MARK_DEBUG="1" */;
wire adc2_fix = (adc2 >= ((Vmax2 + Vmin2) >> 1)) ? 1 : 0/* synthesis PAP_MARK_DEBUG="1" */;
wire [11:0] Vmax1,Vmax2,Vmin1,Vmin2/* synthesis PAP_MARK_DEBUG="1" */;
wire [25:0] fre1,fre2/* synthesis PAP_MARK_DEBUG="1" */;
wire [9:0] THD1,THD2,duty1,duty2/* synthesis PAP_MARK_DEBUG="1" */;
wire wave1,wave2/* synthesis PAP_MARK_DEBUG="1" */;

wire [11:0] data1,data2/* synthesis PAP_MARK_DEBUG="1" */;
wire signed [11:0] weak_data1,weak_data2/* synthesis PAP_MARK_DEBUG="1" */;
wire [10:0] addr1,addr2/* synthesis PAP_MARK_DEBUG="1" */;
wire [10:0] adc1_addr,adc2_addr/* synthesis PAP_MARK_DEBUG="1" */;
wire [9:0] uart_addr1,uart_addr2/* synthesis PAP_MARK_DEBUG="1" */;
wire [7:0] uart_data1,uart_data2/* synthesis PAP_MARK_DEBUG="1" */; 
wire [15:0] Vpp1_max1,Vpp1_min1,fre1_max1,fre1_min1,Vpp2_max1,Vpp2_min1,fre2_max1,fre2_min1/* synthesis PAP_MARK_DEBUG="1" */;
wire [15:0] Vpp1_max2,Vpp1_min2,fre1_max2,fre1_min2,Vpp2_max2,Vpp2_min2,fre2_max2,fre2_min2/* synthesis PAP_MARK_DEBUG="1" */;
wire [15:0] tx_Vpp1_max,tx_Vpp1_min,tx_fre1_max,tx_fre1_min,tx_Vpp2_max,tx_Vpp2_min,tx_fre2_max,tx_fre2_min/* synthesis PAP_MARK_DEBUG="1" */;
wire weak_flag/* synthesis PAP_MARK_DEBUG="1" */;

wire [11:0] fjw1,fjw2/* synthesis PAP_MARK_DEBUG="1" */;
wire valid1,valid2,last1,last2;
wire [7:0] n;
wire [25:0] fc;
wire [31:0] timer;

data_judge data_judge(            //编码器调节采样频率模块
.clk(uart_clk),
.rst(rst),
.a(A1),
.b(B1),

.n(n),
.fc(fc)
   );

Vpp_measure Vpp_measure1(        //幅值测量模块
.clk(uart_clk),
.rst(rst),
.data_in(data1),

.max(Vmax1),
.min(Vmin1)
   );

fre_duty_measure fre_duty_measure1(        //频率及占空比测量模块
.clk(adc_clk),
.rst(rst),
.adc_fix(adc1_fix),

.duty(duty1),
.fre(fre1),
.timer2(timer2)
   );

Vpp_measure Vpp_measure2(
.clk(uart_clk),
.rst(rst),
.data_in(data2),

.max(Vmax2),
.min(Vmin2)
   );

fre_duty_measure fre_duty_measure2(
.clk(adc_clk),
.rst(rst),
.adc_fix(adc2_fix),

.duty(duty2),
.fre(fre2)
   );

adc_transform adc_transform1(            //adc数据缓存模块
.adc_clk(adc_clk),
.clk_low(uart_clk),
.rst(rst),
.n(n),
.adc_in(adc1),
.adc_out(data1),
.addr(adc1_addr),
.full(valid1),
.empty(last1)
   );

fft_transform fft_transform1(            //FFT及THD 相位计算模块
.clk(uart_clk),
.rst(rst),
.data(data1),
.adc_valid(valid1),
.adc_last(last1),
.addr_in(adc1_addr),
.fjw(fjw1),
.THD(THD1),
.addr(addr1),
.phase(phase1)
   );

data2uart data2uart1(                    //FFT数据转存准备打包给屏幕
.data_clk(uart_clk),
.uart_clk(uart_clk),
.rst(rst),
.i_data(fjw1),
.addr_in(addr2),

.o_data(uart_data1),
.o_addr(uart_addr1)
   );

adc_transform adc_transform2(
.adc_clk(adc_clk),
.clk_low(uart_clk),
.rst(rst),
.n(n),
.adc_in(adc2),
.adc_out(data2),
.addr(adc2_addr),
.full(valid2),
.empty(last2)
   );

fft_transform fft_transform2(
.clk(uart_clk),
.rst(rst),
.data(data2),
.addr_in(adc2_addr),
.adc_valid(valid2),
.adc_last(last1),
.fjw(fjw2),
.THD(THD2),
.addr(addr2),
.phase(phase2)
   );

data2uart data2uart2(
.data_clk(uart_clk),
.uart_clk(uart_clk),
.rst(rst),
.i_data(fjw2),
.addr_in(addr2),

.o_data(uart_data2),
.o_addr(uart_addr2)
   );

wave_judge wave1_judge(                //模板匹配鉴别波形
.clk(uart_clk),
.rst(rst),
.data(data1),

.wave(wave1)
    );

wave_judge wave2_judge(
.clk(uart_clk),
.rst(rst),
.data(data2),

.wave(wave2)
    );

display_HMI display_HMI(                    //LCD驱动
.clk(uart_clk),
.rst(rst),
.rx_pin(hmi_rx),
.fjw1_in(uart_data1),
.fjw1_in_addr(uart_addr1),
.fjw2_in(uart_data2),
.fjw2_in_addr(uart_addr2),
.wave1(wave1),
.wave2(wave2),
.Vmax1(Vmax1),
.Vmin1(Vmin1),
.Vmax2(Vmax2),
.Vmin2(Vmin2),
.freq1(fre1),
.freq2(fre2),
.duty1(duty1),
.duty2(duty2),
.THD1(THD1),
.THD2(THD2),
.phase(phase),
.cnt1(500),
.cnt2(500),
.fsc(fc),
.tx_Vpp1_max(tx_Vpp1_max),
.tx_Vpp1_min(tx_Vpp1_min),
.tx_fre1_max(tx_fre1_max),
.tx_fre1_min(tx_fre1_min),
.tx_Vpp2_max(tx_Vpp2_max),
.tx_Vpp2_min(tx_Vpp2_min),
.tx_fre2_max(tx_fre2_max),
.tx_fre2_min(tx_fre2_min),
.tx_pin(hmi_tx),
.Vpp1_max(Vpp1_max1),
.Vpp1_min(Vpp1_min1),
.fre1_max(fre1_max1),
.fre1_min(fre1_min1),
.Vpp2_max(Vpp2_max1),
.Vpp2_min(Vpp2_min1),
.fre2_max(fre2_max1),
.fre2_min(fre2_min1),
.weak_flag(weak_flag),
.flag(flag1)
   );

esp8266 esp8266(                    //WIFI模块驱动
.clk(uart_clk),
.rst(rst),
.rx_pin(esp8266_rx),
.fjw1_in(uart_data1),
.fjw1_in_addr(uart_addr1),
.fjw2_in(uart_data2),
.fjw2_in_addr(uart_addr2),
.wave1(wave1),
.wave2(wave2),
.Vmax1(Vmax1),
.Vmin1(Vmin1),
.Vmax2(Vmax2),
.Vmin2(Vmin2),
.freq1(fre1),
.freq2(fre2),
.duty1(duty1),
.duty2(duty2),
.THD1(THD1),
.THD2(THD2),
.phase(phase),
.cnt1(500),
.cnt2(500),
.fsc(fc),
.Vpp1_max(Vpp1_max2),
.Vpp1_min(Vpp1_min2),
.fre1_max(fre1_max2),
.fre1_min(fre1_min2),
.Vpp2_max(Vpp2_max2),
.Vpp2_min(Vpp2_min2),
.fre2_max(fre2_max2),
.fre2_min(fre2_min2),
.tx_pin(esp8266_tx),
.flag(flag2)
   );

data_select data_select(            //判断上位机数据和屏幕数据
.clk(uart_clk),
.rst(rst),
.flag1(flag1),
.flag2(flag2),
.Vpp1_max1(Vpp1_max1),
.Vpp1_min1(Vpp1_min1),
.fre1_max1(fre1_max1),
.fre1_min1(fre1_min1),
.Vpp2_max1(Vpp2_max1),
.Vpp2_min1(Vpp2_min1),
.fre2_max1(fre2_max1),
.fre2_min1(fre2_min1),
.Vpp1_max2(Vpp1_max2),
.Vpp1_min2(Vpp1_min2),
.fre1_max2(fre1_max2),
.fre1_min2(fre1_min2),
.Vpp2_max2(Vpp2_max2),
.Vpp2_min2(Vpp2_min2),
.fre2_max2(fre2_max2),
.fre2_min2(fre2_min2),

.tx_Vpp1_max(tx_Vpp1_max),
.tx_Vpp1_min(tx_Vpp1_min),
.tx_fre1_max(tx_fre1_max),
.tx_fre1_min(tx_fre1_min),
.tx_Vpp2_max(tx_Vpp2_max),
.tx_Vpp2_min(tx_Vpp2_min),
.tx_fre2_max(tx_fre2_max),
.tx_fre2_min(tx_fre2_min)
   );

threshold_warning threshold_warning(            //报警模块
.clk(uart_clk),
.rst(rst),
.Vmax1(Vmax1),
.Vmin1(Vmin1),
.Vmax2(Vmax2),
.Vmin2(Vmin2),
.freq1(fre1),
.freq2(fre2),
.Vpp1_max(tx_Vpp1_max),
.Vpp1_min(tx_Vpp1_min),
.fre1_max(tx_fre1_max),
.fre1_min(tx_fre1_min),
.Vpp2_max(tx_Vpp2_max),
.Vpp2_min(tx_Vpp2_min),
.fre2_max(tx_fre2_max),
.fre2_min(tx_fre2_min),
.led(led)
   );

weak_signal weak_signal(            //锁相放大模块
.clk(uart_clk),
.rst(rst),
.data(data1 - 2048),
.fre(fre1),

.data_out(weak_data1)
   );

weak_signal weak_signa2(
.clk(uart_clk),
.rst(rst),
.data(data2 - 2048),
.fre(fre2),

.data_out(weak_data2)
   );

endmodule