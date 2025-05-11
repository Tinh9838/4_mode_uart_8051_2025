// + luồng : data + tb8 -> ghi -> dịch bít  -> tx
//
//
//
//
//
//+ như mode 2 nhưng chỉ khác là tốc độ linh hoạt theo time.
//
//
//
//
//
//
//
//
//
//
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module uart_tx_mode3 (
    input clk,
    input rst_n,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_done
);

parameter CLK_PER_BIT = 5208;  // tùy theo baud rate (VD: 9600bps với 50MHz)

reg [3:0] bit_cnt;
reg [13:0] clk_cnt;
reg [9:0] shift_reg;
reg busy;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tx <= 1'b1;  // idle high
        bit_cnt <= 0;
        clk_cnt <= 0;
        busy <= 0;
        tx_done <= 0;
    end else begin
        if (tx_start && !busy) begin
            // bắt đầu truyền
            shift_reg <= {1'b1, tx_data, 1'b0};  // stop + data + start
            busy <= 1;
            clk_cnt <= 0;
            bit_cnt <= 0;
            tx_done <= 0;
        end else if (busy) begin
            if (clk_cnt < CLK_PER_BIT - 1)
                clk_cnt <= clk_cnt + 1;
            else begin
                clk_cnt <= 0;
                tx <= shift_reg[0];
                shift_reg <= {1'b1, shift_reg[9:1]};  // dịch phải
                bit_cnt <= bit_cnt + 1;

                if (bit_cnt == 9) begin
                    busy <= 0;
                    tx_done <= 1;
                    tx <= 1'b1;  // idle sau truyền xong
                end
            end
        end else begin
            tx_done <= 0;
        end
    end
end

endmodule
