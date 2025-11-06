module fre_duty_measure(
input clk,
input rst,
input adc_fix,

output [9:0] duty,
output [25:0] fre,
output [31:0] timer2
   );

reg [31:0] high_timer,all_timer,timer1,timer2,flag;
reg low_flag;
wire [31:0] q1,q2;
reg [31:0] high_flag;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        high_timer <= 0;
        all_timer <= 0;
        low_flag <= 0;
        flag<=0;
    end
    else
    begin
        if(adc_fix)
        begin         
            if(low_flag)
            begin
                if(flag==4)
                begin
                    timer1<=high_timer;
                    timer2<=all_timer;
                    high_timer <= 0;
                    all_timer <= 0;
                    flag<=0;
                end
                else
                    flag<=flag+1;
            end
            else
            begin
                all_timer <= all_timer + 1;
                high_timer <= high_timer + 1;
            end
            low_flag <= 0;       
        end
        else
        begin
            all_timer <= all_timer + 1;
            low_flag <= 1;
        end    
    end
end

assign fre = q1[25:0];
assign duty = q2[9:0];

divider #(
.A_LEN(32),
.B_LEN(32)
)Divider1(
.CLK(clk),
.RSTN(rst),
.EN(1),
.Dividend(320000000),        //clk*5
.Divisor(timer2),
.Quotient(q1),                //ษฬ
.Mod(),                        //ำเ
.RDY()
);

divider #(
.A_LEN(32),
.B_LEN(32)
)Divider2(
.CLK(clk),
.RSTN(rst),
.EN(1),
.Dividend(timer1*1000),
.Divisor(timer2),
.Quotient(q2),                //ษฬ
.Mod(),                        //ำเ
.RDY()
);

endmodule