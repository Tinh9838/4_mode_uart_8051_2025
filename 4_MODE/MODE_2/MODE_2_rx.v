//  + luồng : clk ngoài,(data->tx) ->thanh ghi nhận từng bit -> nhận đủ 1 byte
//
//
//
//   đặc điểm :
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
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module uart_mode2_rx (
    input wire clk,
    input wire rst,
    input wire rxd,               // Dữ liệu từ ngoài vào
    output reg [7:0] data_out,    // Dữ liệu 8-bit đã nhận
    output reg rb8,               // Bit thứ 9 nhận được
    output reg done               // Cờ báo nhận xong
);

parameter CLK_PER_BIT = 100;      // Điều chỉnh cho phù hợp baudrate

reg [3:0] bit_cnt;
reg [10:0] shift_reg;
reg [7:0] clk_cnt;
reg sampling;
reg prev_rxd;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sampling <= 0;
        clk_cnt <= 0;
        bit_cnt <= 0;
        done <= 0;
        data_out <= 0;
        rb8 <= 0;
        prev_rxd <= 1;
    end else begin
        done <= 0;
        prev_rxd <= rxd;

        // Nhận Start bit (falling edge)
        if (!sampling && prev_rxd == 1 && rxd == 0) begin
            sampling <= 1;
            clk_cnt <= 0;
            bit_cnt <= 0;
        end

        if (sampling) begin
            if (clk_cnt == CLK_PER_BIT - 1) begin
                clk_cnt <= 0;
                shift_reg <= {rxd, shift_reg[10:1]};
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 10) begin
                    sampling <= 0;
                    data_out <= shift_reg[8:1];  // 8-bit data
                    rb8 <= shift_reg[9];         // Bit thứ 9
                    done <= 1;
                end
            end else begin
                clk_cnt <= clk_cnt + 1;
            end
        end
    end
end

endmodule
