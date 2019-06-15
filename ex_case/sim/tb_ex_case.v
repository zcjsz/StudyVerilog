`timescale 1ns/1ns

module tb_ex_case;

    reg             tb_sclk; 
    reg             tb_rst_n;
    reg     [9:0]   tb_i_data;
    reg     [7:0]   tb_i_addr;
    wire            tb_o_dv;
    wire    [7:0]   tb_o_data;

    initial begin
        tb_sclk <= 0;
        tb_rst_n <= 0;
        #200
        tb_rst_n <= 1;
    end

    initial begin
        tb_i_data <= 0;
        tb_i_addr <= 0;
        #500
        send_data(256);
    end

    always #10 tb_sclk <= ~tb_sclk;

    ex_case ex_case_inst(
        .rst_n      (tb_rst_n),
        .sclk       (tb_sclk),
        .i_data     (tb_i_data),
        .i_addr     (tb_i_addr),
        .o_dv       (tb_o_dv),
        .o_data     (tb_o_data)
    );

    task send_data(len); // 任务声明区
        integer len, i;  // 变量声明区
        begin // begin ... end 里面的语句是顺序执行的，所以要先经历 sclk 上升沿事件。这里是零延时的顺序执行。
            for(i=0; i<=len; i=i+1) begin
                @(posedge tb_sclk);
                tb_i_data <= i[7:0];
                tb_i_addr <= i[7:0];
            end
            @(posedge tb_sclk);
            tb_i_data <= 0;
            tb_i_addr <= 0;
        end
    endtask

endmodule