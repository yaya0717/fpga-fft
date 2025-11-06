module data2uart(
input data_clk,
input uart_clk,
input rst,
input [11:0] i_data/* synthesis PAP_MARK_DEBUG="true" */,
input [10:0] addr_in/* synthesis PAP_MARK_DEBUG="true" */,

output [7:0] o_data/* synthesis PAP_MARK_DEBUG="1" *//* synthesis syn_keep=1 */,
output [9:0] o_addr/* synthesis PAP_MARK_DEBUG="1" *//* synthesis syn_keep=1 */
   );

wire full,empty,almost_full,almost_empty;
reg w_flag/* synthesis PAP_MARK_DEBUG="true" */;
reg wr_en/* synthesis PAP_MARK_DEBUG="true" */;
reg rd_en/* synthesis PAP_MARK_DEBUG="true" */;
wire [11:0] wr_data_count;
reg [11:0] w_data/* synthesis PAP_MARK_DEBUG="true" */;
wire [11:0] rd_data/* synthesis PAP_MARK_DEBUG="true" */;
wire [10:0] rd_addr;
assign o_data = rd_data>>4;
assign o_addr = rd_en ? rd_addr : 1023;
always@(posedge data_clk or negedge rst)
begin
    if(!rst)
    begin
        w_flag<=0;
        w_data<=0;
    end
    else
    begin
        if(empty)
        begin
            rd_en<=0;
            if(addr_in==1)
            begin
                w_flag<=1;
            end
        end
        if(w_flag && addr_in<1025)
        begin
            wr_en<=1;
            w_data<=i_data;
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

uart_fifo uart_fifo (
  .wr_clk(data_clk),                    // input
  .wr_rst(!rst),                    // input
  .wr_en(wr_en),                      // input
  .wr_data(w_data),                  // input [11:0]
  .wr_full(full),                  // output
  .wr_water_level(wr_data_count),    // output [10:0]
  .almost_full(almost_full),          // output
  .rd_clk(uart_clk),                    // input
  .rd_rst(!rst),                    // input
  .rd_en(rd_en),                      // input
  .rd_data(rd_data),                  // output [11:0]
  .rd_empty(empty),                // output
  .rd_water_level(rd_addr),    // output [10:0]
  .almost_empty(almost_empty)         // output
);

endmodule