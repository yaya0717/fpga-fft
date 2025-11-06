module display_HMI(
input clk/* synthesis PAP_MARK_DEBUG="1" */,
input rst,
input rx_pin,
input [7:0] fjw1_in,
input [9:0] fjw1_in_addr,
input [7:0] fjw2_in,
input [9:0] fjw2_in_addr,
input [1:0] wave1,wave2,
input [11:0] Vmax1,Vmin1,Vmax2,Vmin2,cnt1,cnt2,phase,
input [9:0] duty1,duty2,THD1,THD2,
input [25:0] freq1,freq2,fsc,
input [15:0] tx_Vpp1_max,tx_Vpp1_min,tx_fre1_max,tx_fre1_min,tx_Vpp2_max,tx_Vpp2_min,tx_fre2_max,tx_fre2_min,
output tx_pin,
output reg [15:0] Vpp1_max,Vpp1_min,fre1_max,fre1_min,Vpp2_max,Vpp2_min,fre2_max,fre2_min,
output reg weak_flag,flag
   );

reg start;
reg [31:0] st_timer;
always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        start<=0;
        st_timer<=0;
    end
    else
    begin
        if(st_timer==99999)
        begin
            st_timer<=st_timer+1;
            start<=1;
        end
        else if(st_timer==100000)
        begin
            st_timer<=0;
            start<=0;
        end
        else
            st_timer<=st_timer+1;
    end
end

wire [15:0] Vmax1_BCD,Vmin1_BCD,Vmax2_BCD,Vmin2_BCD,cnt1_BCD,cnt2_BCD,phase_BCD,cnt1_BCD,cnt2_BCD;
binary2BCD#(
.BIN_W(12),
.BCD_W(16)
)binary2BCD_Vmax1(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(Vmax1),    
.Bcd_data(Vmax1_BCD)
);
binary2BCD#(
.BIN_W(12),
.BCD_W(16)
)binary2BCD_Vmin1(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(Vmin1),    
.Bcd_data(Vmin1_BCD)
);
binary2BCD#(
.BIN_W(12),
.BCD_W(16)
)binary2BCD_Vmax2(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(Vmax2),    
.Bcd_data(Vmax2_BCD)
);
binary2BCD#(
.BIN_W(12),
.BCD_W(16)
)binary2BCD_Vmin2(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(Vmin2),    
.Bcd_data(Vmin2_BCD)
);
binary2BCD#(
.BIN_W(12),
.BCD_W(16)
)binary2BCD_phase(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(phase),    
.Bcd_data(phase_BCD)
);
binary2BCD#(
.BIN_W(12),
.BCD_W(16)
)binary2BCD_cnt1(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(cnt1),    
.Bcd_data(cnt1_BCD)
);
binary2BCD#(
.BIN_W(12),
.BCD_W(16)
)binary2BCD_cnt2(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(cnt2),    
.Bcd_data(cnt2_BCD)
);

wire [11:0] duty1_BCD,duty2_BCD,THD1_BCD,THD2_BCD;

binary2BCD#(
.BIN_W(10),
.BCD_W(12)
)binary2BCD_duty1(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(duty1),    
.Bcd_data(duty1_BCD)
);
binary2BCD#(
.BIN_W(10),
.BCD_W(12)
)binary2BCD_duty2(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(duty2),    
.Bcd_data(duty2_BCD)
);
binary2BCD#(
.BIN_W(10),
.BCD_W(12)
)binary2BCD_THD1(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(THD1),    
.Bcd_data(THD1_BCD)
);
binary2BCD#(
.BIN_W(10),
.BCD_W(12)
)binary2BCD_THD2(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(THD2),    
.Bcd_data(THD2_BCD)
);

wire [31:0] freq1_BCD,freq2_BCD,fsc_BCD;
binary2BCD#(
.BIN_W(26),
.BCD_W(32)
)binary2BCD_fre1(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(freq1),    
.Bcd_data(freq1_BCD)
);
binary2BCD#(
.BIN_W(26),
.BCD_W(32)
)binary2BCD_fre2(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(freq2),    
.Bcd_data(freq2_BCD)
);
binary2BCD#(
.BIN_W(26),
.BCD_W(32)
)binary2BCD_fsc(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(fsc),    
.Bcd_data(fsc_BCD)
);

wire [19:0] tx_Vpp1_max_BCD,tx_Vpp1_min_BCD,tx_fre1_max_BCD,tx_fre1_min_BCD,tx_Vpp2_max_BCD,tx_Vpp2_min_BCD,tx_fre2_max_BCD,tx_fre2_min_BCD;
binary2BCD#(
.BIN_W(16),
.BCD_W(20)
)binary2BCD_tx_Vpp1_max(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(tx_Vpp1_max),    
.Bcd_data(tx_Vpp1_max_BCD)
);
binary2BCD#(
.BIN_W(16),
.BCD_W(20)
)binary2BCD_tx_Vpp1_min(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(tx_Vpp1_min),    
.Bcd_data(tx_Vpp1_min_BCD)
);
binary2BCD#(
.BIN_W(16),
.BCD_W(20)
)binary2BCD_tx_fre1_max(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(tx_fre1_max),    
.Bcd_data(tx_fre1_max_BCD)
);
binary2BCD#(
.BIN_W(16),
.BCD_W(20)
)binary2BCD_tx_fre1_min(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(tx_fre1_min),    
.Bcd_data(tx_fre1_min_BCD)
);
binary2BCD#(
.BIN_W(16),
.BCD_W(20)
)binary2BCD_tx_Vpp2_max(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(tx_Vpp2_max),    
.Bcd_data(tx_Vpp2_max_BCD)
);
binary2BCD#(
.BIN_W(16),
.BCD_W(20)
)binary2BCD_tx_Vpp2_min(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(tx_Vpp2_min),    
.Bcd_data(tx_Vpp2_min_BCD)
);
binary2BCD#(
.BIN_W(16),
.BCD_W(20)
)binary2BCD_tx_fre2_max(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(tx_fre2_max),    
.Bcd_data(tx_fre2_max_BCD)
);
binary2BCD#(
.BIN_W(16),
.BCD_W(20)
)binary2BCD_tx_fre2_min(
.Clk(clk),
.Rst_n(rst),
.Start(start),
.Bin_data(tx_fre2_min),    
.Bcd_data(tx_fre2_min_BCD)
);

localparam WAIT = 400000;
localparam WAIT1 = 1500000;

reg[31:0] wait_cnt;
reg tx_valid,rx_ready;
wire tx_ready,rx_valid;
reg [7:0] tx_data;
wire [7:0] rx_data;
reg [151:0] rx_all;    //8*19
reg [4:0] tx_state,tx_cnt,state,rx_state;
wire [7:0] fjw1_data/* synthesis syn_keep=1 */;
wire [7:0] fjw2_data/* synthesis syn_keep=1 */;
reg [9:0] fjw1_addr/* synthesis syn_keep=1 */;
reg [9:0] fjw2_addr/* synthesis syn_keep=1 */;
reg inteface,addt_flag,inteface_flag,ch1,ch1_flag,ch2,ch2_flag;

wire [9:0] rd1_addr = fjw1_addr;
wire [9:0] rd2_addr = fjw2_addr;

wave_ram fjw1 (
  .wr_data(fjw1_in),    // input [7:0]
  .wr_addr(fjw1_in_addr),    // input [9:0]
  .wr_en(1'b1),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst),      // input
  .rd_addr(rd1_addr),    // input [9:0]
  .rd_data(fjw1_data),    // output [7:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst)       // input
);

wave_ram fjw2 (
  .wr_data(fjw2_in),    // input [7:0]
  .wr_addr(fjw2_in_addr),    // input [9:0]
  .wr_en(1'b1),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst),      // input
  .rd_addr(rd2_addr),    // input [9:0]
  .rd_data(fjw2_data),    // output [7:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst)       // input
);

always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
        fjw1_addr<=0;
        fjw2_addr<=0;
        ch1<=0;
        ch2<=0;
        tx_state<=0;
		wait_cnt <= 32'd0;
		tx_data <= 8'd0;
		state <= 0;
		tx_cnt <= 8'd0;
		tx_valid <= 1'b0;
        inteface_flag<=0;
	end
	else
    begin
        if(inteface_flag==0)        //如果在波形界面
        begin
            case(tx_state)
            0:                //send"cnt1.val=cnt1" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h63;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h74;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h31;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= cnt1_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= cnt1_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= cnt1_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= cnt1_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            1:                //send"cnt2.val=cnt2" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h63;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h74;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h32;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= cnt2_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= cnt2_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= cnt2_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= cnt2_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            2:            //send"fsc.val=fsc" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h66;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h73;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h63;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= fsc_BCD[27:24] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= fsc_BCD[23:20] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= fsc_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= fsc_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= fsc_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= fsc_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= fsc_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            3:            //send"Vmax1.val=Vmax1" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h56;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h31;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmax1_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmax1_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmax1_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmax1_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		17:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            4:            //send"Vmax2.val=Vmax2" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h56;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h32;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmax2_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmax2_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmax2_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmax2_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		17:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            5:            //send"Vmin1.val=Vmin1" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h56;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h69;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h31;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmin1_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmin1_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmin1_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmin1_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		17:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            6:            //send"Vmin2.val=Vmin2" ff ff ff为结束符
            begin
            case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h56;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h69;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h32;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmin2_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmin2_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmin2_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= Vmin2_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		17:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            7:            //send"fre1.val=freq1" ff ff ff为结束符
            begin
            case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h66;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h72;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h65;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h31;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq1_BCD[31:28] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq1_BCD[27:24] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq1_BCD[23:20] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq1_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq1_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq1_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq1_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq1_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                19:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		20:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            8:            //send"fre2.val=freq2" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h66;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h72;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h65;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h32;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq2_BCD[31:28] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq2_BCD[27:24] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq2_BCD[23:20] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq2_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq2_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq2_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq2_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= freq2_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                19:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		20:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            9:            //send"x8.val=duty1" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h38;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= duty1_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= duty1_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= duty1_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            10:            //send"x10.val=duty2" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h31;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h30;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= duty2_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= duty2_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= duty2_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            11:            //send"x7.val=THD1" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h37;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= THD1_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= THD1_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= THD1_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            12:            //send"x9.val=THD2" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h39;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= THD2_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= THD2_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= THD2_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            13:            //send"wave1.val=wave1" ff ff ff为结束符    0正弦1三角2矩形3其他
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h77;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h65;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h31;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= wave1 + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            14:            //send"wave2.val=wave2" ff ff ff为结束符    0正弦1三角2矩形3其他
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h77;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h65;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h32;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= wave2 + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            15:            //send"x6.val=phase" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h36;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= phase_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= phase_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= phase_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= phase_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            16:
            begin
                if(ch1)        //send "addt s0.id,0,1024" ff ff ff为结束符
                begin
                    case(state)
            		0:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h61;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    1:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h64;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		2:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h64;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    3:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h74;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		4:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h20;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    5:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h73;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		6:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h30;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    7:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h2e;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		8:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h69;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    9:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h64;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    10:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h2c;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    11:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h30;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		12:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h2c;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    13:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h31;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    14:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h30;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    15:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h32;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    16:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h34;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    17:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		18:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    19:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		20:
            		begin
            			wait_cnt <= wait_cnt + 32'd1;
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            			end
            			else if(wait_cnt >= WAIT1)
                        begin
            				state <= 0;
                            tx_state<=tx_state+1;
                        end
            		end
            		default:
            			state <= 0;
            	    endcase
                end
                else            //send "cle s0.id,0" ff ff ff为结束符
                begin
                    case(state)
            		0:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h63;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    1:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h6c;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		2:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h65;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    3:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h20;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		4:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h73;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    5:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h30;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		6:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h2e;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    7:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h69;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		8:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h64;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    9:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h2c;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    10:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h30;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    11:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		12:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    13:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		14:
            		begin
            			wait_cnt <= wait_cnt + 32'd1;
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            			end
            			else if(wait_cnt >= WAIT)
                        begin
            				state <= 0;
                            tx_state<=tx_state+1;
                        end
            		end
            		default:
            			state <= 0;
            	    endcase
                end
            end
            17:
            begin
                if(ch1)
                begin
            	    case(state)
            		0:
            		begin
            			wait_cnt <= 32'd0;
                        tx_data <= (fjw1_data>>1)+128;
            
            			if(tx_valid == 1'b1 && tx_ready == 1'b1 && fjw1_addr < 'd1023)
            			begin
            				fjw1_addr <= fjw1_addr + 'd1;
            			end
            			else if(tx_valid && tx_ready)
            			begin
            				fjw1_addr <= 'd0;
            				tx_valid <= 1'b0;
            				state <= 1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		1:
            		begin
            			wait_cnt <= wait_cnt + 32'd1;
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            			end
            			else if(wait_cnt >= WAIT)
                        begin
                            tx_state<=tx_state+1;
            				state <= 0;
                        end
            		end
            		default:
            			state <= 0;
                	endcase 
                end
                else
                    tx_state<=tx_state+1;
            end
            18:
            begin
                if(ch2)        //send "addt s0.id,1,1024" ff ff ff为结束符
                begin
                    case(state)
            		0:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h61;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    1:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h64;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		2:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h64;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    3:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h74;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		4:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h20;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    5:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h73;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		6:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h30;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    7:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h2e;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		8:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h69;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    9:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h64;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    10:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h2c;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    11:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h31;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		12:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h2c;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    13:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h31;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    14:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h30;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    15:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h32;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    16:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h34;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    17:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		18:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    19:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		20:
            		begin
            			wait_cnt <= wait_cnt + 32'd1;
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            			end
            			else if(wait_cnt >= WAIT1)
                        begin
            				state <= 0;
                            tx_state<=tx_state+1;
                        end
            		end
            		default:
            			state <= 0;
            	    endcase
                end
                else            //send "cle s0.id,1" ff ff ff为结束符
                begin
                    case(state)
                    0:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h63;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    1:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h6c;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		2:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h65;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    3:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h20;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		4:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h73;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    5:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h30;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		6:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h2e;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    7:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h69;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		8:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h64;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    9:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h2c;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    10:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'h31;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    11:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		12:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
                    13:
            		begin
            			wait_cnt <= 32'd0;
            			tx_data <= 8'hff;
        
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            				state <= state+1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		14:
            		begin
            			wait_cnt <= wait_cnt + 32'd1;
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            			end
            			else if(wait_cnt >= WAIT)
                        begin
            				state <= 0;
                            tx_state<=tx_state+1;
                        end
            		end
            		default:
            			state <= 0;
            	    endcase
                end
            end
            19:
            begin
                if(ch2)
                begin
            	    case(state)
            		0:
            		begin
            			wait_cnt <= 32'd0;
                        tx_data <= (fjw2_data>>1);
            			if(tx_valid == 1'b1 && tx_ready == 1'b1 && fjw2_addr < 'd1023)
            			begin
            				fjw2_addr <= fjw2_addr + 'd1;
            			end
            			else if(tx_valid && tx_ready)
            			begin
            				fjw2_addr <= 'd0;
            				tx_valid <= 1'b0;
            				state <= 1;
            			end
            			else if(~tx_valid)
            			begin
            				tx_valid <= 1'b1;
            			end
            		end
            		1:
            		begin
            			wait_cnt <= wait_cnt + 32'd1;
            			if(tx_valid && tx_ready)
            			begin
            				tx_valid <= 1'b0;
            			end
            			else if(wait_cnt >= WAIT)
                        begin
                            tx_state<=tx_state+1;
            				state <= 0;
                        end
            		end
            		default:
            			state <= 0;
                	endcase 
                end
                else
                    tx_state<=tx_state+1;
            end
            20:
            begin
                state<=0;
                wait_cnt<=0;
                ch1<=ch1_flag;
                ch2<=ch2_flag;
                inteface_flag<=inteface;
                tx_state<=0;
            end
            default:
            begin
                tx_state<=0;
            end
            endcase
        end
        else
        begin
            case(tx_state)
            0:            //send"vmin1.val=tx_Vpp1_min" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h69;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h31;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp1_min_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp1_min_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp1_min_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp1_min_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp1_min_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase 
            end
            1:            //send"vmax1.val=tx_Vpp1_max" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h31;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp1_max_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp1_max_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp1_max_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp1_max_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp1_max_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            2:            //send"fmin1.val=tx_fre1_min" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h66;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h69;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h31;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre1_min_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre1_min_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre1_min_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre1_min_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre1_min_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            3:            //send"fmax1.val=tx_fre1_max" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h66;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h31;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre1_max_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre1_max_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre1_max_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre1_max_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre1_max_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            4:            //send"vmin2.val=tx_Vpp2_min" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h69;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h32;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp2_min_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp2_min_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp2_min_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp2_min_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp2_min_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase 
            end
            5:            //send"vmax2.val=tx_Vpp2_max" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h32;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp2_max_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp2_max_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp2_max_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp2_max_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_Vpp2_max_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            6:            //send"fmin2.val=tx_fre2_min" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h66;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h69;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h32;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre2_min_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre2_min_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre2_min_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre2_min_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre2_min_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            7:            //send"fmax2.val=tx_fre2_max" ff ff ff为结束符
            begin
                case(state)
        		0:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h66;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		2:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                3:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h78;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		4:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h32;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                5:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h2e;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		6:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h76;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                7:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h61;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		8:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h6c;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                9:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'h3d;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		10:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre2_max_BCD[19:16] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                11:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre2_max_BCD[15:12] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		12:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre2_max_BCD[11:8] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		13:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre2_max_BCD[7:4] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		14:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= tx_fre2_max_BCD[3:0] + 48;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                15:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		16:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
                17:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hff;
    
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        				state <= state+1;
        			end
        			else if(~tx_valid)
        			begin
        				tx_valid <= 1'b1;
        			end
        		end
        		18:
        		begin
        			wait_cnt <= wait_cnt + 32'd1;
        			if(tx_valid && tx_ready)
        			begin
        				tx_valid <= 1'b0;
        			end
        			else if(wait_cnt >= WAIT)
                    begin
        				state <= 0;
                        tx_state<=tx_state+1;
                    end
        		end
        		default:
        			state <= 0;
        	    endcase
            end
            8:
            begin
                state<=0;
                wait_cnt<=0;
                inteface_flag<=inteface;
                tx_state<=0;
            end
            default:
            begin
                tx_state<=0;
            end
            endcase
        end
    end
end

always@(posedge clk or negedge rst)        //接收
begin
    if(!rst)
    begin
        weak_flag<=0;
        inteface<=0;
        ch1_flag<=0;
        ch2_flag<=0;
        addt_flag<=0;
        Vpp1_min<=0;
        Vpp1_max<=10000;
        fre1_min<=0;
        fre1_max<=50000;
        Vpp2_min<=0;
        Vpp2_max<=10000;
        fre2_min<=0;
        fre2_max<=50000;
        rx_ready<=1;
        rx_state<=0;
        rx_all<=0;
        flag<=0;
    end
    else
    begin
        if(rx_all[31:8]==24'hffffff)
        begin
            rx_state<=30;
        end
        case(rx_state)
            0:
            begin
                flag<=0;
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[7:0]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            1:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[15:8]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            2:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[23:16]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            3:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[31:24]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            4:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[39:32]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            5:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[47:40]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            6:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[55:48]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            7:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[63:56]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            8:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[71:64]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            9:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[79:72]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            10:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[87:80]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            11:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[95:88]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            12:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[103:96]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            13:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[111:104]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            14:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[119:112]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            15:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[127:120]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            16:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[135:128]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            17:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[143:136]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            18:
            begin
                rx_ready<=1;
                if(rx_valid)
                begin
                    rx_all[151:144]<=rx_data;
                    rx_ready<=0;
                    rx_state<=rx_state+1;
                end
            end
            19:
            begin
                rx_state<=20;
                if(rx_all[151:128]==24'hffffff)
                begin
                    rx_state<=29;
                end
            end
            20:
            begin
                rx_state<=0;
                rx_all<=0;
            end
            29:
            begin
                flag<=1;
                Vpp1_min<=rx_all[15:0];
                Vpp1_max<=rx_all[31:16];
                fre1_min<=rx_all[47:32];
                fre1_max<=rx_all[63:48];
                Vpp2_min<=rx_all[79:64];
                Vpp2_max<=rx_all[95:80];
                fre2_min<=rx_all[111:96];
                fre2_max<=rx_all[127:112];
                rx_all<=0;
                rx_state<=0;
            end
            30:
            begin
                if(rx_all[7:0]==8'hfd)        //透传结束
                begin
                    addt_flag<=0;
                end
                else if(rx_all[7:0]==8'hfe)        //透传开始
                begin
                    addt_flag<=1;
                end
                else if(rx_all[7:0]==8'h55)        //波形1
                begin
                    ch1_flag<=!ch1_flag;
                end
                else if(rx_all[7:0]==8'h56)        //波形2
                begin
                    ch2_flag<=!ch2_flag;
                end
                else if(rx_all[7:0]==8'h57)        //微弱信号
                begin
                    weak_flag<=!weak_flag;
                end 
                else if(rx_all[7:0]==8'h58)        //interface2
                begin
                    inteface<=1;
                end
                else if(rx_all[7:0]==8'h59)        //interface1
                begin
                    inteface<=0;
                end
                rx_all<=0;
                rx_state<=0;
            end
            31:
            begin
                rx_all<=0;
                rx_state<=0;
            end
        endcase
    end
end    

uart_tx#(
.CLK_FRE(6),
.BAUD_RATE(115200)
)uart_tx(
.clk(clk),
.rst_n(rst),
.tx_data(tx_data),
.tx_data_valid(tx_valid),
.tx_data_ready(tx_ready),
.tx_pin(tx_pin)
);

uart_rx#(
.CLK_FRE(6),
.BAUD_RATE(115200)
)uart_rx(
.clk(clk),              
.rst_n(rst),           
.rx_data(rx_data),         
.rx_data_valid(rx_valid),   
.rx_data_ready(rx_ready),   
.rx_pin(rx_pin)           
);


endmodule