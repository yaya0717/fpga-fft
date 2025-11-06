module fft_transform(
input clk/* synthesis PAP_MARK_DEBUG="1" */,
input rst,
input [11:0] data/* synthesis PAP_MARK_DEBUG="true" */,
input [10:0] addr_in/* synthesis PAP_MARK_DEBUG="true" */,
input adc_valid,
input adc_last,

output [11:0] fjw/* synthesis PAP_MARK_DEBUG="1" *//* synthesis syn_keep=1 */,
output [9:0] THD/* synthesis PAP_MARK_DEBUG="1" *//* synthesis syn_keep=1 */,
output reg [10:0] addr/* synthesis PAP_MARK_DEBUG="1" *//* synthesis syn_keep=1 */,
output signed [11:0] phase
   );

reg [9:0] addr1;
wire [9:0] phase_addr/* synthesis PAP_MARK_DEBUG="true" */;
wire [31:0] fft_data/* synthesis PAP_MARK_DEBUG="true" */;
wire valid,last/* synthesis PAP_MARK_DEBUG="true" */;
wire signed [15:0] fft_img = fft_data[31:16]/* synthesis PAP_MARK_DEBUG="true" */;
wire signed [15:0] fft_rel = fft_data[15:0]/* synthesis PAP_MARK_DEBUG="true" */;
reg signed [15:0] phase_img,phase_rel;
wire [31:0] fft_img_square = fft_img * fft_img/* synthesis PAP_MARK_DEBUG="true" */;
wire [31:0] fft_rel_square = fft_rel * fft_rel/* synthesis PAP_MARK_DEBUG="true" */;
wire [31:0] fft_square = fft_img_square + fft_rel_square/* synthesis PAP_MARK_DEBUG="true" */;
wire [15:0] q/* synthesis PAP_MARK_DEBUG="true" */;
assign fjw=q[11:0];
square_root#( 	
.d_width(32)
)square_root(
.clk(clk),
.rst(!rst),
.i_vaild(1),
.data_i(fft_square),
.data_o(q)
    );

delay#(
.S_DELAY(17)
)delay1(
.i_clk(clk),
.i_rst(rst),
.i_din(valid),
.i_en(1),
.o_dout(fft_valid)
);

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        addr<=0;
    end
    else
    begin
        if(fft_valid)
        begin
            addr<=addr+1;
        end
        if(addr==2047)
        begin
            addr<=0;
        end
    end
end

FFT_calculation FFT_calculation(
.i_aclk(clk),
.i_aresetn(rst),
.ext_data(data-2048),
.addr_in(addr_in),
.adc_valid(adc_valid),
.adc_last(adc_last),
.fft_data(fft_data),
.fft_valid(valid),
.fft_last(last)
);

thd_measure thd_measure(
.clk(clk),
.rst(rst),
.data(fjw),
.addr(addr),

.thd(THD),
.addr_out(phase_addr)
    );

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        addr1<=0;
    end
    else
    begin
        if(valid)
        begin
            addr1<=addr1+1;
        end
        if(addr1==phase_addr)
        begin
            addr1<=0;
            phase_img<=fft_img;
            phase_rel<=fft_rel;
        end
    end
end

phase_measure phase_measure(
.clk(clk),
.rst(rst),
.img(phase_img),
.rel(phase_rel),

.phase(phase)
);

endmodule