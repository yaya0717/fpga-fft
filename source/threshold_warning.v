module threshold_warning(
input clk,
input rst,
input [11:0] Vmax1,Vmin1,Vmax2,Vmin2,
input [25:0] freq1,freq2,
input [15:0] Vpp1_max,Vpp1_min,fre1_max,fre1_min,Vpp2_max,Vpp2_min,fre2_max,fre2_min,
output reg [7:0] led
   );

wire [11:0] Vpp1 = Vmax1 - Vmin1;
wire [11:0] Vpp2 = Vmax2 - Vmin2;
wire [15:0] Vpp1_real = (Vpp1*10000)>>12;
wire [15:0] Vpp2_real = (Vpp2*10000)>>12;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        led<=0;
    end
    else
    begin
        if(Vpp1_real < Vpp1_min)
        begin
            led[0] <= 1;
        end
        else if(Vpp1_real > Vpp1_max)
        begin
            led[1] <= 1;
        end
        else
        begin
            led[1:0] <= 0;
        end

        if(freq1 < fre1_min * 1000)
        begin
            led[2] <= 1;
        end
        else if(freq1 > fre1_max * 1000)
        begin
            led[3] <= 1;
        end
        else
        begin
            led[3:2] <= 0;
        end

        if(Vpp2_real < Vpp2_min)
        begin
            led[4] <= 1;
        end
        else if(Vpp2_real > Vpp2_max)
        begin
            led[5] <= 1;
        end
        else
        begin
            led[5:4] <= 0;
        end

        if(freq2 < fre2_min * 1000)
        begin
            led[6] <= 1;
        end
        else if(freq2 > fre2_max * 1000)
        begin
            led[7] <= 1;
        end
        else
        begin
            led[7:6] <= 0;
        end
    end
end



endmodule