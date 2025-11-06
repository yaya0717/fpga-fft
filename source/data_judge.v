module data_judge(
input clk,
input rst,
input a,
input b,

output reg [7:0] n,
output reg [25:0] fc
   );

reg [3:0] state;
wire right,left;

encoder encoder(
.clk(clk), 
.rst_n(rst),
.A(a),
.B(b),
.left(left),
.right(right)
);

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        state<=0;
    end
    else
    begin
        if(left && !right)
        begin
            if(state!=0)
            begin
                state<=state-1;
            end
        end
        else if(!left && right)
        begin
            if(state!=5)
            begin
                state<=state+1;
            end
        end
    end
end

always@(*)
begin
    case(state)
        0:
        begin
            n=1;
            fc=2000000;
        end
        1:
        begin
            n=2;
            fc=1000000;
        end
        2:
        begin
            n=4;
            fc=500000;
        end
        3:
        begin
            n=10;
            fc=200000;
        end
        4:
        begin
            n=20;
            fc=100000;
        end
        5:
        begin
            n=100;
            fc=20000;
        end
        5:
        begin
            n=200;
            fc=10000;
        end
        default:
        begin
            n=1;
            fc=2000000;
        end
    endcase
end

endmodule