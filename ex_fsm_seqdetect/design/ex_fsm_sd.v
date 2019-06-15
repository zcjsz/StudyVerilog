module ex_fsm_sd(
    input wire sclk,
    input wire rst_n,
    input wire cin,
    output reg cout
);

// 检测输入序列是否为 10010，如果满足条件则 cout 输出 1，否则一直未 0
// 低位先输入，cin 接收的数据顺序：0 -> 1 -> 0 -> 0 -> 1
// 状态机初始状态为 S0，后面根据 cin 接收数据的情况进行状态迁移
// cin   :  X ->  0  -> 1  -> 0  -> 0  -> 1  -> 0  / 1
// State :  S0 -> S1 -> S2 -> S3 -> S4 -> S5 -> S1 / S0
// cout  :   0 ->  0 ->  0 ->  0 ->  0 ->  1 ->  0 /  0

parameter S0 = 6'b100000;
parameter S1 = 6'b000001;
parameter S2 = 6'b000010;
parameter S3 = 6'b000100;
parameter S4 = 6'b001000;
parameter S5 = 6'b010000;

reg [5:0] state;

// 描述状态机迁移
always @(posedge sclk or negedge rst_n ) begin
    if(rst_n == 1'b0) begin
        state <= S0;
    end else begin
        case(state)
            S0: begin
                if(cin == 1'b0) state <= S1;
                else state <= S0;
            end
            S1: begin
                if(cin == 1'b1) state <= S2;
                else state <= S0;
            end
            S2: begin
                if(cin == 1'b0) state <= S3;
                else state <= S0;
            end
            S3: begin
                if(cin == 1'b0) state <= S4;
                else state <= S0;
            end
            S4: begin
                if(cin == 1'b1) state <= S5;
                else state <= S0;
            end
            S5: begin
                if(cin == 1'b0) state <= S1;
                else state <= S0;
            end
            default: state <= S0;
        endcase
    end
end


// 描述状态机寄存器变化
always @(posedge sclk or negedge rst_n) begin
    if(rst_n == 1'b0)
        cout <= 1'b0;
    else begin
        case(state)
                 S5: cout <= 1'b1;
            default: cout <= 1'b0;
        endcase
    end
end


endmodule