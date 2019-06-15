`timescale 1ns/1ns

module tb_ex_fsm_sd;

reg     tb_sclk, tb_rst_n, tb_cin;
wire    tb_cout;

initial begin
    tb_sclk <= 0;
    tb_rst_n <= 0;
    #100
    tb_rst_n <= 1;
end

initial begin
    tb_cin <= 0;
    #200
    input_cin_1();
end

always #10 tb_sclk = ~tb_sclk;

ex_fsm_sd ex_fsm_sd_inst(
    .sclk   (tb_sclk),
    .rst_n  (tb_rst_n),
    .cin    (tb_cin),
    .cout   (tb_cout)
);

task input_cin_1();
    integer i;
    begin
        for(i=0;i<=4;i=i+1) begin 
            @(posedge tb_sclk);
            if(i==0)      tb_cin <= 1'b0;
            else if(i==1) tb_cin <= 1'b1;
            else if(i==2) tb_cin <= 1'b0;
            else if(i==3) tb_cin <= 1'b0;
            else if(i==4) tb_cin <= 1'b1;
            else          tb_cin <= 1'b0;
        end
    end
endtask

task input_cin_2();
    integer i;
    begin
        for(i=0;i<=4;i=i+1) begin 
            @(posedge tb_sclk);
            if(i==0)      tb_cin <= 1'b1;
            else if(i==1) tb_cin <= 1'b0;
            else if(i==2) tb_cin <= 1'b1;
            else if(i==3) tb_cin <= 1'b0;
            else if(i==4) tb_cin <= 1'b1;
            else          tb_cin <= 1'b0;
        end
    end
endtask

endmodule