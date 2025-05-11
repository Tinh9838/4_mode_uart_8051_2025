//       +   luồng: tín hiệu truyền+ data-> thanh ghi -> dịch bit -> chân tx
//
//
//       đặc điểm : + bit stat +[bit mở rộng]+ data + bit stop
//
//
//
//                  + tốc độ ko phụ thuộc time
//
//
//
//                 + bit mở rộng tb8 tùy theo mục đích
//
//
//
//
//
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module uart_mode2_tx (
    input wire clk,
    input wire rst,
    input wire start,              // Bắt đầu truyền
    input wire [7:0] data_in,      // 8-bit dữ liệu
    input wire tb8,                // Bit thứ 9 tùy chọn
    output reg txd,                // Dữ liệu ra (TxD)
    output reg busy                // Đang truyền
);

reg [3:0] bit_cnt;
reg [10:0] shift_reg;             // 1 start + 8 data + tb8 + 1 stop
reg [7:0] clk_cnt;
parameter CLK_PER_BIT = 100;      // Tùy chỉnh theo hệ thống (baud rate)

always @(posedge clk or posedge rst) begin
    if (rst) begin                                                             // rst
        txd <= 1;
        busy <= 0;
        bit_cnt <= 0;
        clk_cnt <= 0;
    end else begin                                                              //  state nạp data
        if (start && !busy) begin
     
            shift_reg <= {1'b1, tb8, data_in, 1'b0};
            bit_cnt <= 0;
            busy <= 1;
            clk_cnt <= 0;
        end else if (busy) begin                                                // state dịch bit
            if (clk_cnt == CLK_PER_BIT - 1) begin
                clk_cnt <= 0;
                txd <= shift_reg[0];
                shift_reg <= shift_reg >> 1;
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 10) begin
                    busy <= 0;
                    txd <= 1;
                end
            end else begin
                clk_cnt <= clk_cnt + 1;                                       //
            end
        end
    end
end

endmodule
