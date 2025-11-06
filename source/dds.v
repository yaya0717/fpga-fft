module dds(
    input clk,
    input rst,
    input [31:0] freq,
    input [9:0] phase,
    output [11:0] dataout
);

reg [31:0]frechange; 
 
always @(posedge clk or negedge rst) begin
   if(!rst)
   begin
       frechange <= 32'd0; 
   end
   else
   begin
       frechange <= frechange + freq;
   end
end

reg [9:0]romaddr;
always @(posedge clk or negedge rst) begin
   if(!rst)
   begin
       romaddr <= 10'd0;
   end
   else
   begin
       romaddr <= frechange[31:22] + phase;
   end
end
 
wire [11:0] data_sin; 
 
//ÕıÏÒ²¨±í£º
ROM_sin ROM_sin (
  .addr(romaddr),          // input [9:0]
  .clk(clk),            // input
  .rst(!rst),            // input
  .rd_data(data_sin)     // output [11:0]
);


assign dataout = data_sin;

 
endmodule