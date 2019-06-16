/*
串行转并行，模拟 LVDS 接口
*/

module ex_shift_reg (
    input   wire        rst_n,
    input   wire        lvds_clk,
    input   wire        lvds_in,      // lvds 串行输入，低位先入
    output  reg   [7:0] lvds_out
);

reg     [7:0]   shift_reg;  // 用于存储串转并的数据
reg     [2:0]   shift_cnt;  // 右移计数器，每移8次取一次数据
reg             shift_flag; // 右移寄存器移位计数满8次的标志位

// 位拼接符 {7'b1010_000, 3'b010} --> 10'b1010_000_010
// shift_reg 是右移的移位寄存器，lvds_in 先入的数据经过8个时钟周期后移到最低位
// init: | reg[7] | reg[6] | reg[5] | reg[4] | reg[3] | reg[2] | reg[1] | reg[0] |
// clk1: | in_1   | reg[7] | reg[6] | reg[5] | reg[4] | reg[3] | reg[2] | reg[1] |
// clk2: | in_2   | in_1   | reg[7] | reg[6] | reg[5] | reg[4] | reg[3] | reg[2] |
// ...
// clk7: | in_7   | in_6   | in_5   | in_4   | in_3   | in_2   | in_1   | reg[7] |
// clk8: | in_8   | in_7   | in_6   | in_5   | in_4   | in_3   | in_2   | in_1   |

always @(posedge lvds_clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        shift_reg <= 8'b0;
    else
        shift_reg <= {lvds_in, shift_reg[7:1]};  // lvds_in 每输入一个数据都会把当前 shift_reg 数据往右移一个
end

always @(posedge lvds_clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        shift_cnt <= 3'b111; // 这里给初始值为 3'b111 等第一个 clk 加 1 后溢出为 3'b000， shift_cnt 计数 0~7，第一次 0 的时候代表了第一次时钟上升沿，也是复位后的第一个时钟周期
    else
        shift_cnt <= shift_cnt + 1'b1;
end

always  @(shift_cnt) begin  // 如何写全敏感列表：条件列表里的所有变量，赋值语句右边的变量。这里也可以用 always @* 来代替。
    if(shift_cnt == 3'b111)
        shift_flag <= 1'b1;
    else
        shift_flag <= 1'b0;  // 这个分支条件一定要写，不然会生成锁存器，在 FPGA 中是危险的
end

always @(posedge lvds_clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        lvds_out <= 8'b0;
    else if(shift_flag == 1'b1)
        lvds_out <= shift_reg;
end

endmodule