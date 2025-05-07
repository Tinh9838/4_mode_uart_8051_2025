//    + luồng : clk ngoài,(data->tx) ->thanh ghi nhận từng bit -> nhận đủ 1 byte
//
//
//     đặc điểm :    +   nhận  start + 8 data + stop   
//
//
//                   + Baudrate điều khiển bằng Timer 1 (hoặc Timer 2 ở chip mới hơn): 1bit tương ứng với 1 tick_baud
//
//
//                   + là chế độ phổ biến nhất 
//                     
//
//
//
//
//
//
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module uart_rx_mode1 (
    input wire clk,              // Clock chính
    input wire rst,              // Reset đồng bộ
    input wire rx,               // Chân nhận UART
    input wire tick_baud,        // Xung baud rate (từ timer)
    output reg rx_done,          // Cờ nhận dữ liệu hoàn tất 
    output reg [7:0] rx_data     // Dữ liệu nhận được
);

    reg [3:0] bit_cnt;
    reg [9:0] shift_reg;         // start + 8 data + stop
    reg rx_d, rx_d1;             // Để lấy mẫu chân rx (differential signal)

    always @(posedge clk or posedge rst) begin
        if (rst) begin                                                                                  // rst
            rx_done <= 0;
            shift_reg <= 10'b1111111111;
            bit_cnt <= 0;
            rx_data <= 8'b0;
        end
        else begin
            rx_d1 <= rx_d;
            rx_d <= rx;  // Giữ giá trị mẫu của rx

            if (tick_baud && (bit_cnt == 0)) begin                                                       // trạng thái đợi bit 0 start
               
                if (rx_d == 0) begin 
                    shift_reg <= 10'b1111111111;  
                    bit_cnt <= bit_cnt + 1; 
                end
            end
            else if (bit_cnt > 0 && bit_cnt < 9) begin                                                  // trạng thái nhận từng bít
               
                if (tick_baud) begin
                    shift_reg <= {rx_d, shift_reg[9:1]};  
                    bit_cnt <= bit_cnt + 1;
                end
            end
            else if (bit_cnt == 9) begin                                                                 // trạng thái nạp ghi xong
         
                if (rx_d == 1) begin  
                    rx_data <= shift_reg[8:1]; 
                    rx_done <= 1; 
                end
                bit_cnt <= 0;
            end
            else begin
                rx_done <= 0;                                                                            // trạng thái chờ byte
            end
        end
    end
endmodule
