module uart_tx_mode1 (
    input wire clk,              // Clock chính
    input wire rst,              // Reset đồng bộ
    input wire tx_start,         // Tín hiệu bắt đầu truyền
    input wire [7:0] tx_data,    // Dữ liệu cần truyền
    input wire tick_baud,        // Xung baud rate (từ timer)
    output reg tx,               // Chân truyền UART
    output reg tx_busy           // Cờ đang truyền
);

    reg [3:0] bit_cnt;           // đếm bít
    reg [9:0] shift_reg;         // thanh ghi chứa bit cần truyền 

    always @(posedge clk or posedge rst) begin
        if (rst) begin                                                                                             // rst
            tx <= 1'b1;         
            tx_busy <= 0;
            shift_reg <= 10'b1111111111;
            bit_cnt <= 0;
        end
        else if (tx_start && !tx_busy) begin                                                                       // trạng thái nạp data
 
            shift_reg <= {1'b1, tx_data, 1'b0}; 
            tx_busy <= 1;
            bit_cnt <= 0;
        end
        else if (tx_busy && tick_baud) begin                                                                       // trạng thái dịch bit
            tx <= shift_reg[0];
            shift_reg <= {1'b1, shift_reg[9:1]}; 
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 9) begin
                tx_busy <= 0;
            end
        end
    end

endmodule
