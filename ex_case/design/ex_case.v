module ex_case(
    input   wire            rst_n,
    input   wire            sclk,
    output  reg             o_dv,
    output  reg     [7:0]   o_data,
    // 添加输入数据
    input   wire    [9:0]   i_data,
    input   wire    [7:0]   i_addr
);

reg  [2:0]  cnt_7;


// 不同功能的寄存器写在不同的always块里面，可读性强，可维护

always @(posedge sclk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        cnt_7 <= 3'd0;
    end else begin
        cnt_7 <= cnt_7 + 1'b1;
    end   
end


always @(posedge sclk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
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
            default: 
                  begin
                    o_data <= 3'd0;
                    o_dv <= 1'b0;
                  end
        endcase
    end
end

/*
// 组合逻辑，消除锁存器的注意点
// 1. 敏感列表要写全，比如下面的 case 语音的判断条件，还有赋值语句右边的变量，这些都要添加到敏感列表里面
// 2. 所有条件分支要写全，比如 case 语句要加上 default
always @(cnt_7) begin
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
        default: 
                begin
                o_data <= 3'd0;
                o_dv <= 1'b0;
                end
    endcase
end
*/

endmodule
