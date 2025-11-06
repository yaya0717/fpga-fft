module binary2BCD #(parameter BIN_W = 32, BCD_W = 40)(
	input  					Clk		, //system clock 50MHz
	input  			 		Rst_n	, //reset, low valid
	
	input					Start	, //
	input 	   [BIN_W-1:00]	Bin_data, //
	output reg				bcd_vld	, //	
	output reg [BCD_W-1:00]	Bcd_data  //
);
//Parameter Declarations
	//状态机参数定义
	localparam	
		IDLE	=	4'b0001, 
		READY	=	4'b0010,
		SHIFT	=	4'b0100,
		DONE	=	4'b1000;

//Internal wire/reg declarations
	reg		[BIN_W-1:00] 	din_r; //
	
	reg		[05:00]	cnt		; //Counter 移位计数器
	wire			add_cnt ; //Counter Enable
	wire			end_cnt ; //Counter Reset 

	reg		[03:00]	state_c, state_n; //

	reg		[03:00] mem_r  	[09:00]	; //
	wire	[03:00] mem_w	[09:00]	; //
	
	wire	[39:00] bcd_res ; //
	wire 			idle2ready	; //
	wire 			shift2done	; //
	// reg			 	bcd_vld 	; //
	
	
//Logic Description
	always @(posedge Clk or negedge Rst_n)begin
		if(!Rst_n)begin  
			cnt <= 'd0; 
		end  
		else if(add_cnt)begin  
			if(end_cnt)begin  
				cnt <= 'd0; 
			end  
			else begin  
				cnt <= cnt + 1'b1; 
			end  
		end  
		else begin  
			cnt <= cnt;  
		end  
	end 
			
	assign add_cnt = state_c == SHIFT; 
	assign end_cnt = add_cnt && cnt >= BIN_W - 1; 

	
	//第一段设置状态转移空间
	always @(posedge Clk or negedge Rst_n)begin
		if(!Rst_n)begin
			state_c <= IDLE;
		end
		else begin
			state_c <= state_n;
		end
	end //always end
	//第二段、组合逻辑定义状态转移
	always@(*)begin
		case(state_c)
			IDLE:begin
				if(idle2ready)begin
					state_n = READY;
				end
				else begin
					state_n = state_c;
				end
			end
			READY:begin
				state_n = SHIFT;
			end
			SHIFT:begin
				if(shift2done)begin
					state_n = DONE;
				end 
				else begin
					state_n = state_c;	
				end 
			end
			DONE:begin
				state_n = IDLE;
			end 
			default: begin
				state_n = IDLE;
			end
		endcase
	end //always end
			
	assign	idle2ready	=	state_c == IDLE	 && Start;
	assign	shift2done	=	state_c	== SHIFT &&	end_cnt;
			
	//第三段，定义状态机输出情况，可以时序逻辑，也可以组合逻辑
	always @(posedge Clk or negedge Rst_n)begin  
		if(!Rst_n)begin  
			din_r <= 'd0;
		end  
		else if(Start)begin  
			din_r <= Bin_data;
		end  
		else if(state_c == SHIFT)begin //移位状态下，每个时钟周期向左移1位
			din_r <= din_r << 1;
		end
		else begin  
			din_r <= din_r;
		end  
	end //always end

	always @(posedge Clk or negedge Rst_n)begin 
		if(!Rst_n)begin
			mem_r[0] <= 4'd0;		
			mem_r[1] <= 4'd0;	
			mem_r[2] <= 4'd0;	
			mem_r[3] <= 4'd0;	
			mem_r[4] <= 4'd0;	
			mem_r[5] <= 4'd0;	
			mem_r[6] <= 4'd0;	
			mem_r[7] <= 4'd0;	
			mem_r[8] <= 4'd0;	
			mem_r[9] <= 4'd0;		
		end  
		else if(idle2ready)begin
			mem_r[0] <= 4'd0;		
			mem_r[1] <= 4'd0;	
			mem_r[2] <= 4'd0;	
			mem_r[3] <= 4'd0;	
			mem_r[4] <= 4'd0;	
			mem_r[5] <= 4'd0;	
			mem_r[6] <= 4'd0;	
			mem_r[7] <= 4'd0;	
			mem_r[8] <= 4'd0;	
			mem_r[9] <= 4'd0;	
		end  
		else if(state_c == SHIFT)begin
			mem_r[0] <= {mem_w[0][2:0],din_r[BIN_W-1]};		
			mem_r[1] <= {mem_w[1][2:0],mem_w[0][3]   };	
			mem_r[2] <= {mem_w[2][2:0],mem_w[1][3]   };	
			mem_r[3] <= {mem_w[3][2:0],mem_w[2][3]   };	
			mem_r[4] <= {mem_w[4][2:0],mem_w[3][3]   };	
			mem_r[5] <= {mem_w[5][2:0],mem_w[4][3]   };	
			mem_r[6] <= {mem_w[6][2:0],mem_w[5][3]   };	
			mem_r[7] <= {mem_w[7][2:0],mem_w[6][3]   };	
			mem_r[8] <= {mem_w[8][2:0],mem_w[7][3]   };	
			mem_r[9] <= {mem_w[9][2:0],mem_w[8][3]   };	
		end
		else ;
	end //always end
	
	//组合逻辑近乎没有时延
	assign mem_w[0] = (mem_r[0] > 4'd4) ? (mem_r[0] + 4'd3) : mem_r[0];
	assign mem_w[1] = (mem_r[1] > 4'd4) ? (mem_r[1] + 4'd3) : mem_r[1];
	assign mem_w[2] = (mem_r[2] > 4'd4) ? (mem_r[2] + 4'd3) : mem_r[2];
	assign mem_w[3] = (mem_r[3] > 4'd4) ? (mem_r[3] + 4'd3) : mem_r[3];
	assign mem_w[4] = (mem_r[4] > 4'd4) ? (mem_r[4] + 4'd3) : mem_r[4];
	assign mem_w[5] = (mem_r[5] > 4'd4) ? (mem_r[5] + 4'd3) : mem_r[5];
	assign mem_w[6] = (mem_r[6] > 4'd4) ? (mem_r[6] + 4'd3) : mem_r[6];
	assign mem_w[7] = (mem_r[7] > 4'd4) ? (mem_r[7] + 4'd3) : mem_r[7];
	assign mem_w[8] = (mem_r[8] > 4'd4) ? (mem_r[8] + 4'd3) : mem_r[8];
	assign mem_w[9] = (mem_r[9] > 4'd4) ? (mem_r[9] + 4'd3) : mem_r[9];

	assign bcd_res = {mem_r[9],mem_r[8],mem_r[7],mem_r[6],mem_r[5],mem_r[4],mem_r[3],mem_r[2],mem_r[1],mem_r[0]};

	always @(posedge Clk or negedge Rst_n)begin 
		if(!Rst_n)begin
			bcd_vld <= 1'b0;
		end  
		else begin
			bcd_vld <= (state_c == DONE);
		end
	end //always end
	
	always @(posedge Clk or negedge Rst_n)begin 
		if(!Rst_n)begin
			Bcd_data <= 'd0;
		end  
		else if(state_c == DONE)begin
			Bcd_data <= bcd_res[BCD_W-1:0];
		end  
		else begin
			Bcd_data <= Bcd_data;
		end
	end //always end
	
endmodule
