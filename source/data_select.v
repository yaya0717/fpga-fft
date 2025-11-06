module data_select(
input clk,
input rst,
input flag1,
input flag2,
input [15:0] Vpp1_max1,Vpp1_min1,fre1_max1,fre1_min1,Vpp2_max1,Vpp2_min1,fre2_max1,fre2_min1,
input [15:0] Vpp1_max2,Vpp1_min2,fre1_max2,fre1_min2,Vpp2_max2,Vpp2_min2,fre2_max2,fre2_min2,

output reg [15:0] tx_Vpp1_max,tx_Vpp1_min,tx_fre1_max,tx_fre1_min,tx_Vpp2_max,tx_Vpp2_min,tx_fre2_max,tx_fre2_min
   );

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        tx_Vpp1_min<=0;
        tx_Vpp1_max<=10000;
        tx_fre1_min<=0;
        tx_fre1_max<=50000;
        tx_Vpp2_min<=0;
        tx_Vpp2_max<=10000;
        tx_fre2_min<=0;
        tx_fre2_max<=50000;
    end
    else
    begin
        if(flag1)
        begin
            tx_Vpp1_min<=Vpp1_min1;
            tx_Vpp1_max<=Vpp1_max1;
            tx_fre1_min<=fre1_min1;
            tx_fre1_max<=fre1_max1;
            tx_Vpp2_min<=Vpp2_min1;
            tx_Vpp2_max<=Vpp2_max1;
            tx_fre2_min<=fre2_min1;
            tx_fre2_max<=fre2_max1;
        end
        else if(flag2)
        begin
            tx_Vpp1_min<=Vpp1_min2;
            tx_Vpp1_max<=Vpp1_max2;
            tx_fre1_min<=fre1_min2;
            tx_fre1_max<=fre1_max2;
            tx_Vpp2_min<=Vpp2_min2;
            tx_Vpp2_max<=Vpp2_max2;
            tx_fre2_min<=fre2_min2;
            tx_fre2_max<=fre2_max2;
        end
    end
end


endmodule