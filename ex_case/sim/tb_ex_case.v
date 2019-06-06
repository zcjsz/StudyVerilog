`timescale 1ns/100ps

module tb_ex_case;
    reg             tb_sclk, tb_rst_n;
    wire            tb_o_dv;
    wire    [7:0]   tb_o_data;

    initial begin
        tb_sclk <= 0;
        tb_rst_n <= 0;
        #200
        tb_rst_n <= 1;
    end

    always #10 tb_sclk <= ~tb_sclk;

    ex_case ex_case_inst(
        .rst_n  (tb_rst_n),
        .sclk   (tb_sclk),
        .o_dv   (tb_o_dv),
        .o_data (tb_o_data)
    );

endmodule