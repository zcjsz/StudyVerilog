`timescale 1ns/1ns

module tb_ex_fsm;

reg     tb_sclk, tb_rst_n, tb_A;
wire    tb_k1, tb_k2;

initial begin
    tb_sclk <= 0;
    tb_rst_n <= 0;
    #100
    tb_rst_n <= 1;
end

initial begin
    tb_A <= 0;
    #200
    input_A();
end

always #10 tb_sclk = ~tb_sclk;

ex_fsm ex_fsm_inst(
    .sclk   (tb_sclk),
    .rst_n  (tb_rst_n),
    .A      (tb_A),
    .k1     (tb_k1),
    .k2     (tb_k2)
);

task input_A();
    integer i;
    begin
        for(i=0;i<1024;i=i+1) begin
            @(posedge tb_sclk);
            if(i<50)        tb_A <= 1'b0;
            else if(i<300)  tb_A <= 1'b1;
            else if(i<500)  tb_A <= 1'b0;
            else if(i<700)  tb_A <= 1'b1;
            else if(i<900)  tb_A <= 1'b0;
        end
    end
endtask

endmodule