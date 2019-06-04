`timescale 1ns/100ps

module tb_ext_cnt; // testbench 模块声明不需要端口列表

    reg     tb_sclk, tb_rst_n; // 激励信号声明
    wire    [9:0]   tb_cnt;    // 原始模块输出信号连线声明

    initial begin // 上电初始化过程，一次上电仅执行一次
    // initial 块内只能对寄存器变量赋值
    // 在 testbench initial begin end 里面的语句是顺序执行
        tb_sclk <= 0;
        tb_rst_n <= 0;
        #200.1
        tb_rst_n <= 1;
    end

    always #10 tb_sclk <= ~tb_sclk; // 时钟周期为20ns

    // 例化的方法
    // 原始模块名称  例化模块名称
    ex_cnt ex_cnt_inst(
        .sclk   (tb_sclk),
        .rst_n  (tb_rst_n), // 例化模块的时候，如果原始模块是输入信号，那么括号可以是wire变量，也可以是reg变量
        .cnt    (tb_cnt)    // 例化模块的时候，如果原始模块是输出信号，那么括号内必须是wire变量
    );

endmodule
