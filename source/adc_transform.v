module adc_transform(
input adc_clk,
input clk_low,
input rst,
input [7:0] n,
input [11:0] adc_in,

output [11:0] adc_out,
output [10:0] addr,
output full,
output empty
   );

reg wr_clk;
wire almost_full,almost_empty;//almost_full,empty,
reg w_flag/* synthesis PAP_MARK_DEBUG="true" */;
reg wr_en/* synthesis PAP_MARK_DEBUG="true" */;
reg rd_en/* synthesis PAP_MARK_DEBUG="true" */;
wire [11:0] wr_data_count;
reg [11:0] w_data/* synthesis PAP_MARK_DEBUG="true" */;
wire [10:0] rd_addr;
reg [9:0] timer;
assign addr = rd_addr>2047 ? 2047 : rd_addr;
always@(posedge adc_clk or negedge rst)
begin
    if(!rst)
    begin
        w_flag<=0;
        w_data<=0;
        wr_en<=0;
        rd_en<=0;
        timer<=1;
        wr_clk<=0;
    end
    else
    begin
        if(empty)
        begin
            rd_en<=0;
            w_flag<=1;
        end
        if(w_flag)
        begin
            wr_en<=1;
            if(timer >= n)
            begin
                wr_en<=1;
                w_data<=adc_in;
                timer<=1;
            end
            else
            begin
                timer<=timer+1;
                wr_en<=0;
            end
        end
        else
        begin
            wr_en<=0;
        end
        if(full)
        begin
            rd_en<=1;
            w_flag<=0;
        end
    end
end

adc_fifo adc_fifo (
  .wr_clk(adc_clk),                    // input
  .wr_rst(!rst),                    // input
  .wr_en(wr_en),                      // input
  .wr_data(w_data),                  // input [11:0]
  .wr_full(full),                  // output
  .wr_water_level(wr_data_count),    // output [11:0]
  .almost_full(almost_full),          // output
  .rd_clk(clk_low),                    // input
  .rd_rst(!rst),                    // input
  .rd_en(rd_en),                      // input
  .rd_data(adc_out),                  // output [11:0]
  .rd_empty(empty),                // output
  .rd_water_level(rd_addr),    // output [11:0]
  .almost_empty(almost_empty)         // output
);

endmodule