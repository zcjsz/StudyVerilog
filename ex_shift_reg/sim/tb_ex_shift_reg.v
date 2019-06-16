`timescale 1ns/100ps

module tb_ex_shift_reg;

reg             tb_lvds_clk, tb_rst_n, tb_lvds_in;
wire    [7:0]   tb_lvds_out;
reg     [0:0]   mem1x16  [15:0]; // 1bit 16行深度的 memory 变量，相当于一个二维数组。  左边是memory的位宽，右边是memory的深度。
reg     [3:0]   cnt_i;


initial begin
    tb_lvds_clk <= 1'b0;
    tb_rst_n <= 1'b0;
    #100
    tb_rst_n <= 1'b1;
end

// $readmemb 是系统函数，在上电的时候就读入数据文件来初始化变量
initial begin
    // 第一个参数是 sim 目录下的文件，这个是要读入的数据文件 data.txt
    // 第二个参数是定义的 memory 变量 mem1x16，读入的数据就保存在这个变量中
    $readmemh("./data.txt", mem1x16);
end

initial begin
    tb_lvds_in <= 1'b0; // lvds_in 给初始值低电平，避免第一次抓数据时是 X
    #100
    lvds_in();
end

always #10 tb_lvds_clk = ~tb_lvds_clk;

ex_shift_reg ex_shift_reg_inst(
    .rst_n      (tb_rst_n),
    .lvds_clk   (tb_lvds_clk),
    .lvds_in    (tb_lvds_in),
    .lvds_out   (tb_lvds_out)
);

task lvds_in();
    integer i;
    begin
        for(i=0;i<256;i=i+1) begin
            @(negedge tb_lvds_clk) // 提前半个时钟周期出数据，等于下降沿出数据，上升沿就能锁存了
            tb_lvds_in <= mem1x16[i[3:0]]; // i 计数 0~255，i 的低四位 i[3:0] 计数 0~15，随着 i 增加，其低四位一直循环计数 0~15，lvds_in 循环16次发送 0x5511
            cnt_i <= i[3:0];
        end
    end
endtask

endmodule