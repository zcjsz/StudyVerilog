module ex_fsm(
    input   wire    sclk,
    input   wire    rst_n,
    input   wire    A,
    output  reg     k1,
    output  reg     k2
);

parameter IDLE  = 4'b0001;
parameter START = 4'b0010;
parameter STOP  = 4'b0100;
parameter CLEAR = 4'b1000;

reg     [3:0]   state;

/*
状态机表示采用 4-bits 独热码： 4'b0001, 4'b0010, 4'b0100, 4b'1000 
独热码可以避免信号多路径传输延迟产不同而引起的冒险竞争问题。独热码占用寄存器多，但是用的组合逻辑资源少。
二进制编码用的寄存器数量少，但是用的组合逻辑资源多。
if(state == 4'b0001) --> if(state[0] == 1'b1) 综合器优化
*/

// 第一段描述状态机迁移
always @(posedge sclk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        state <= IDLE;
    end else begin
        case(state)
            IDLE:  if(A == 1'b1) state <= START;
            START: if(A == 1'b0) state <= STOP;
            STOP:  if(A == 1'b1) state <= CLEAR;
            CLEAR: if(A == 1'b0) state <= IDLE;
            default:             state <= IDLE;
        endcase
    end
end

// 描述状态机 K1 寄存器变化
always @(posedge sclk or negedge rst_n ) begin
    if (rst_n == 1'b0) begin
        k1 <= 1'b0;
    end else if(state == IDLE && A == 1'b1) begin
        k1 <= 1'b0;
    end else if(state == STOP && A == 1'b1) begin
        k1 <= 1'b1;
    end
end

// 描述状态机 K2 寄存器变化
always @(posedge sclk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        k2 <= 1'b0;
    end else if(state == STOP && A == 1'b1) begin
        k2 <= 1'b1;
    end else if(state == CLEAR && A == 1'b0) begin
        k2 <= 1'b0;
    end
end

endmodule