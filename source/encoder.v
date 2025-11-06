module encoder(
                clk, 
                rst_n,
                A, //A相
                B, //B相
                left,
                right
);

input   clk,rst_n;
input   A,B;
output left,right;
reg [3:0] testcnt;

//10ms计数器，用于消抖。
reg ok_10ms;
reg [31:0]cnt0;
always@(posedge clk,negedge rst_n)
begin
    if(!rst_n)begin
        cnt0 <= 0;
        ok_10ms <= 1'b0;
    end
    else begin
        if(cnt0 < 32'd5_9999)begin
            cnt0 <= cnt0 + 1'b1;
            ok_10ms <= 1'b0;
        end
        else begin
            cnt0 <= 0;
            ok_10ms <= 1'b1;
        end
    end
end


//同步/消抖 A、B
reg A_reg,A_reg0;
reg B_reg,B_reg0;
wire A_Debounce;
wire B_Debounce;
always@(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
        A_reg <= 1'b1;
        A_reg0 <= 1'b1;
        B_reg <= 1'b1;
        B_reg0 <= 1'b1;
    end
    else begin
        if(ok_10ms)begin
            A_reg <= A;
            A_reg0 <= A_reg;
            B_reg <= B;
            B_reg0 <= B_reg;
        end
    end
end

assign A_Debounce = A_reg0 && A_reg && A;
assign B_Debounce = B_reg0 && B_reg && B;


//对消抖后的A进行上升沿，下降沿检测。
reg A_Debounce_reg;
wire A_posedge,A_negedge;
always@(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
        A_Debounce_reg <= 1'b1;
    end
    else begin
        A_Debounce_reg <= A_Debounce;
    end
end
assign A_posedge = !A_Debounce_reg && A_Debounce;
assign A_negedge = A_Debounce_reg && !A_Debounce;


//对AB相编码器的行为进行描述
reg rotary_right;
reg rotary_left;
always@(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
        rotary_right <= 1'b1;
        rotary_left <= 1'b1;
    end
    else begin
        //A的上升沿时候如果B为低电平，则旋转编码器向右转
        if(A_posedge && !B_Debounce)begin
            rotary_right <= 1'b1;
        end
        //A上升沿时候如果B为高电平，则旋转编码器向左转
        else if(A_posedge && B_Debounce)begin
            rotary_left <= 1'b1;
        end
        //A的下降沿B为高电平，则一次右转结束
        else if(A_negedge && B_Debounce)begin
            rotary_right <= 1'b0;
        end
        //A的下降沿B为低电平，则一次左转结束
        else if(A_negedge && !B_Debounce)begin
            rotary_left <= 1'b0;
        end
    end
end


//通过上面的描述，可以发现，
//"rotary_right"为上升沿的时候标志着一次右转
//"rotary_left" 为上升沿的时候标志着一次左转
//以下代码是对其进行上升沿检测
reg rotary_right_reg,rotary_left_reg;
wire rotary_right_pos,rotary_left_pos;
always@(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
        rotary_right_reg <= 1'b1;
        rotary_left_reg <= 1'b1;
    end
    else begin
        rotary_right_reg <= rotary_right;
        rotary_left_reg <= rotary_left;
    end
end

assign rotary_right_pos = !rotary_right_reg && rotary_right;
assign rotary_left_pos = !rotary_left_reg && rotary_left;

//用于测试的计数器 右转+1 左转-1
always@(posedge clk,negedge rst_n)begin
    if(!rst_n)
         testcnt <= 4'd0;
    else if(rotary_right_pos)
         testcnt <= testcnt + 4'd1;
    else if(rotary_left_pos)
         testcnt <= testcnt - 4'd1;
end

assign right = rotary_right_pos;
assign left = rotary_left_pos;

endmodule