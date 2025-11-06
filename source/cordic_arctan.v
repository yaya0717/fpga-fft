module cordic_arctan #(
        parameter WIDTH = 16,
        parameter ITERS = 16,
        parameter PRECISION = 32
    )(

        input           clk,
        input           rst_n,
		//输入数据的请求使能信号   
        input           cordic_req,
        //输出数据的使能有效信号
        output          cordic_ack,
    
        input signed[WIDTH-1:0]  X,
        input signed[WIDTH-1:0]  Y,
    
        output[WIDTH-1:0]            amplitude,  //幅度，偏大1.64倍，这里做了近似处理
        output  signed[WIDTH-1:0]    theta 
);
	/* 这里注释掉是因为 需要要求输出角度值是16位，
	又因为cordic ip核的输出角度是弧度表示的*/
	// 角度值放大2^16次方
	//`define rot0  32'd2949120       //45度*2^16
	//`define rot1  32'd1740992       //26.5651度*2^16
	//`define rot2  32'd919872        //14.0362度*2^16
	//`define rot3  32'd466944        //7.1250度*2^16
	//`define rot4  32'd234368        //3.5763度*2^16
	//`define rot5  32'd117312        //1.7899度*2^16
	//`define rot6  32'd58688         //0.8952度*2^16
	//`define rot7  32'd29312         //0.4476度*2^16
	//`define rot8  32'd14656         //0.2238度*2^16
	//`define rot9  32'd7360          //0.1119度*2^16
	//`define rot10 32'd3648          //0.0560度*2^16
	//`define rot11 32'd1856          //0.0280度*2^16
	//`define rot12 32'd896           //0.0140度*2^16
	//`define rot13 32'd448           //0.0070度*2^16
	//`define rot14 32'd256           //0.0035度*2^16
	//`define rot15 32'd128           //0.0018度*2^16
	/*因此查找表修改成弧度值表示，从cordic的ip核输出theta_ip数据结构fix16_13，
	最高位表示符号位，theta_ip[14:13]表示整数位，theta_ip[12:0]表示小数位
	可以看出结果是theta_ip放大2^13倍，因此如下表示*/
	//角度的弧度值放大2^13次方
    `define rot0  16'd6433       //45度*2^13
    `define rot1  16'd3798       //26.5651度*2^13
    `define rot2  16'd2006        //14.0362度*2^13
    `define rot3  16'd1018        //7.1250度*2^13
    `define rot4  16'd511        //3.5763度*2^13
    `define rot5  16'd255        //1.7899度*2^13
    `define rot6  16'd128         //0.8952度*2^13
    `define rot7  16'd64         //0.4476度*2^13
    `define rot8  16'd32         //0.2238度*2^13
    `define rot9  16'd16          //0.1119度*2^13
    `define rot10 16'd8          //0.0560度*2^13
    `define rot11 16'd4          //0.0280度*2^13
    `define rot12 16'd2           //0.0140度*2^13
    `define rot13 16'd1           //0.0070度*2^13
    `define rot14 16'd0           //0.0035度*2^13
    `define rot15 16'd0           //0.0018度*2^13
    
    //定义输入数据的寄存器Xn、Yn、Zn
    reg signed[31:0]    Xn[16:0];
    reg signed[31:0]    Yn[16:0];
    reg signed[31:0]    Zn[16:0];
    reg[15:0]           rot[15:0];
    reg                 cal_delay[16:0];
    
    
    assign cordic_ack = cal_delay[ITERS];
    assign theta      = Zn[ITERS];
    //幅度，偏大1.64倍，这里做了近似处理 ,然后缩小了2^15
    assign amplitude  = ((Xn[ITERS] >>> 1) + (Xn[ITERS]  >>> 3) +(Xn[ITERS] >>> 4)) >>> (ITERS-1); 

always@(posedge clk)
begin
    rot[0] <= `rot0;
    rot[1] <= `rot1;
    rot[2] <= `rot2;
    rot[3] <= `rot3;
    rot[4] <= `rot4;
    rot[5] <= `rot5;
    rot[6] <= `rot6;
    rot[7] <= `rot7;
    rot[8] <= `rot8;
    rot[9] <= `rot9;
    rot[10] <= `rot10;
    rot[11] <= `rot11;
    rot[12] <= `rot12;
    rot[13] <= `rot13;
    rot[14] <= `rot14;
    rot[15] <= `rot15;
end

always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0)
        cal_delay[0] <= 1'b0;
    else
        cal_delay[0] <= cordic_req;
end
//这里输出使能的思路是从输入请求开始因为迭代计算延迟了16个时钟周期
genvar j;
generate
    for(j = 1 ;j < ITERS + 1 ; j = j + 1)
    begin: loop
        always@(posedge clk or negedge rst_n)
        begin
            if( rst_n == 1'b0)
                cal_delay[j] <= 1'b0;
            else
                cal_delay[j] <= cal_delay[j-1];
        end
    end
endgenerate

//将坐标挪到第一和四项限中
always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0)
    begin
        Xn[0] <= 'd0;
        Yn[0] <= 'd0;
        Zn[0] <= 'd0;
    end
    else if( cordic_req == 1'b1)
    begin
        if( X < $signed(0) && Y < $signed(0))
        begin
            Xn[0] <= -(X << 15);
            Yn[0] <= -(Y << 15);
            //这是-180度的弧度值表示
            Zn[0] <= -16'd25732;
        end
        else if( X < $signed(0) && Y >= $signed(0))
        /*如果输入数据X,Y很小的话，在旋转迭代更新Xn[i]、Yn[i]会有很大的误差，
        因此需要对输入数据进行放大2^15倍处理（网上很多都没有这一步），
        如果2^16倍后续计算会溢出*/
        begin
            Xn[0] <= -(X << 15);
            Yn[0] <= -(Y << 15);
            //这是180度的弧度值表示
            Zn[0] <= 16'd25732;
        end
        else
        begin
            Xn[0] <= X << 15;
            Yn[0] <= Y << 15;
            Zn[0] <= 'd0;
        end
    end
    else 
    begin
        Xn[0] <= Xn[0];
        Yn[0] <= Yn[0];
        Zn[0] <= Zn[0];
    end
end


//旋转迭代更新
genvar i;
generate
    for( i = 1 ;i < 17 ;i = i+1)
    begin: loop2
        always@(posedge clk or negedge rst_n)
        begin
            if( rst_n == 1'b0)
            begin
                Xn[i] <= 'd0;
                Yn[i] <= 'd0;
                Zn[i] <= 'd0;
            end
            else if( cal_delay[i-1] == 1'b1)
            begin
                if( Yn[i-1][31] == 1'b0)
                begin
                    Xn[i] <= Xn[i-1] + (Yn[i-1] >>> (i-1));
                    Yn[i] <= Yn[i-1] - (Xn[i-1] >>> (i-1));
                    Zn[i] <= Zn[i-1] + rot[i-1];
                end
                else
                begin
                    Xn[i] <= Xn[i-1] - (Yn[i-1] >>> (i-1));
                    Yn[i] <= Yn[i-1] + (Xn[i-1] >>> (i-1));
                    Zn[i] <= Zn[i-1] - rot[i-1];
                end
            end
            else
            begin
                Xn[i] <= Xn[i];
                Yn[i] <= Yn[i];
                Zn[i] <= Zn[i];
            end
        end
    end
endgenerate
endmodule

