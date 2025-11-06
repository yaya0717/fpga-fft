module Vpp_measure(
input clk/* synthesis PAP_MARK_DEBUG="1" */,
input rst,
input [11:0] data_in,

output reg [11:0] max,
output reg [11:0] min
   );

reg [10:0] ptr;
reg [11:0] max_val,min_val;

always@(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        ptr <= 0;
        max_val <= 0;
        min_val <= 4095;
    end
    else
    begin
        if (data_in > max_val) max_val <= data_in;
        if (data_in < min_val) min_val <= data_in;
    
        if(ptr == 2047) 
        begin 
            ptr <= 0;
            max <= max_val;
            min <= min_val;
            max_val <= 0;
            min_val <= 4095;
        end
        else
        begin
            ptr <= ptr + 1;
        end
    end
end

endmodule