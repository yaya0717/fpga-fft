module esp8266(
input clk,
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
output tx_pin,
output reg [15:0] Vpp1_max,Vpp1_min,fre1_max,fre1_min,Vpp2_max,Vpp2_min,fre2_max,fre2_min,
output reg flag
   );

localparam WAIT = 60000;
localparam WAIT1 = 150000;

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
        tx_state<=0;
		wait_cnt <= 32'd0;
		tx_data <= 8'd0;
		state <= 0;
		tx_cnt <= 8'd0;
		tx_valid <= 1'b0;
	end
	else
    begin
        case(tx_state)
            0:                //通道1波形类型：0xff + 0xD1 + type + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hd1;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= wave1;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            1:                //通道1最大最小值：0xff + 0xD2 + data1_high + data1_low +  + data2_high + data2_low + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hd2;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= Vmax1[11:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= Vmax1[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= Vmin1[11:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= Vmin1[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            2:                //通道1频率：0xff + 0xD3 + data_high +data_mid + data_low + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hd3;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= freq1[23:16];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= freq1[15:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= freq1[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            3:                //通道1占空比：0xff + 0xD4 + data_high + data_low + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hd4;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= duty1[9:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= duty1[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            4:                //通道1THD：0xff + 0xD5 + data_high + data_low + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hd5;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= THD1[9:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= THD1[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            5:                //通道2波形类型：0xff + 0xe1 + type + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'he1;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= wave2;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            6:                //通道2最大最小值：0xff + 0xe2 + data1_high + data1_low +  + data2_high + data2_low + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'he2;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= Vmax2[11:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= Vmax2[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= Vmin2[11:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= Vmin2[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            7:                //通道2频率：0xff + 0xe3 + data_high +data_mid + data_low + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'he3;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= freq2[23:16];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= freq2[15:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= freq2[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            8:                //通道2占空比：0xff + 0xe4 + data_high + data_low + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'he4;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= duty2[9:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= duty2[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            9:                //通道2THD：0xff + 0xe5 + data_high + data_low + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'he5;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= THD2[9:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= THD2[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            10:               //相位：0xff + 0xE6 + data_high + data_low + 0xed + 0xfe
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'he6;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= phase[11:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= phase[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hfe;
    
        			if(tx_valid && tx_ready)
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
            11:                //分辨率：0xFF + 0xAE + 分辨率 + 0xED
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hae;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= fsc[23:16];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= fsc[15:8];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= fsc[7:0];
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
            12:                //通道1/2频谱0xFF + 0xC1/C2 + 1024字节数据 + 0xEE + 0xED
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hc1;
    
        			if(tx_valid && tx_ready)
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
                    tx_data <= fjw1_data;
        
        			if(tx_valid == 1'b1 && tx_ready == 1'b1 && fjw1_addr < 'd1023)
        			begin
        				fjw1_addr <= fjw1_addr + 'd1;
        			end
        			else if(tx_valid && tx_ready)
        			begin
        				fjw1_addr <= 'd0;
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
        			tx_data <= 8'hee;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
                endcase   
            end
            13:                //通道1/2频谱0xFF + 0xC1/C2 + 1024字节数据 + 0xEE + 0xED
            begin
                case(state)
        		0:
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
        		1:
        		begin
        			wait_cnt <= 32'd0;
        			tx_data <= 8'hc2;
    
        			if(tx_valid && tx_ready)
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
                    tx_data <= fjw2_data;
        			if(tx_valid == 1'b1 && tx_ready == 1'b1 && fjw2_addr < 'd1023)
        			begin
        				fjw2_addr <= fjw2_addr + 'd1;
        			end
        			else if(tx_valid && tx_ready)
        			begin
        				fjw2_addr <= 'd0;
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
        			tx_data <= 8'hee;
    
        			if(tx_valid && tx_ready)
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
        			tx_data <= 8'hed;
    
        			if(tx_valid && tx_ready)
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
                endcase   
            end
            14:
            begin
                state<=0;
                wait_cnt<=0;
                tx_state<=0;
            end
            default:
            begin
                tx_state<=0;
            end
        endcase
    end
end

always@(posedge clk or negedge rst)        //接收
begin
    if(!rst)
    begin
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
                    rx_state<=21;
                end
            end
            20:
            begin
                rx_state<=0;
                rx_all<=0;
            end
            21:
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