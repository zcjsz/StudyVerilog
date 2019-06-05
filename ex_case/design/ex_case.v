module ex_case(
    input   wire            rst_n,
    input   wire            sclk,
    output  reg             o_dv,
    output  reg     [7:0]   o_data
);

reg  [2:0]  cnt_7;


always @(posedge sclk or negedge rst_n) begin
    
end

// 不同功能的寄存器写在不同的always块里面，可读性强，可维护
always @(posedge sclk or negedge rst_n) begin
    if(rst_n = 1'b0) begin
        o_data <= 8'd0;
        o_dv <= 1'b0;
    end else begin
        case(cnt_7)
            3'd0: begin 
                    o_data <= 3'd7;
                    o_dv <= 1'b1;
                  end
            3'd1: begin
                    o_data <= 3'd0;
                    o_dv <= 1'b0;
                  end
            3'd2: begin
                    o_data <= 3'd5;
                    o_dv <= 1'b1;
                  end
        endcase
    end
end



endmodule
