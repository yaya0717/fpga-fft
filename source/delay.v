module delay#(
parameter S_DELAY = 18
)(
	input 		i_clk,
    input 		i_rst,
    input		i_din,// 输入的原始数据
    input   	i_en,
    output		o_dout,// 对齐延迟后的数据
    output 		o_vld
);
    
reg r_delay_chain [0:S_DELAY-1];
reg [S_DELAY-1:0] r_delay_chain_en;

integer i;

always @(posedge i_clk) begin
  r_delay_chain[0]  <= i_din;
  for (i=1; i<S_DELAY; i=i+1)
    r_delay_chain[i] <= r_delay_chain[i-1];
end

always @(posedge i_clk) begin
    if(!i_rst)
        r_delay_chain_en <= 'h0;
  	else
        r_delay_chain_en <= {r_delay_chain_en[S_DELAY-2:0],i_en};
end  

assign o_dout = r_delay_chain[S_DELAY-1]; // 对齐延迟后的数据
assign o_vld  = r_delay_chain_en[S_DELAY-1];            

endmodule

