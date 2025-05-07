//  + luồng : clk ngoài,(data->tx) ->thanh ghi nhận từng bit -> nhận đủ 1 byte
//
//
//          Đặc điểm :   + nhận lần lượt 8 bit ,"ko có" bít stop,start  chân RxD (P3.0)
//
//                       + nhận clk đồng bộ qua  TxD (P3.1)
//
//                       + tốc độ 1 bit ứng với 1 clk = 1/f = 1/ 12Mhz (bít/s)
//
//
//
//
//
//
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module uart_mode0_rx (
    input wire clk_rx,         // clock đến từ thiết bị truyền (TxD)
    input wire rst,
    input wire rxd,            // dữ liệu đến (RxD)
    output reg [7:0] data_out, // dữ liệu nhận được
    output reg rx_done         // cờ báo nhận xong 1 byte
);

    reg [7:0] shift_reg;       // thanh ghi dịch
    reg [3:0] bit_cnt;         // đếm số bit nhận
    reg receiving;             // phát hiện truyền 

 always @(posedge clk_rx or posedge rst) begin            // cần clk ngoài
  if (rst) begin                                          
        shift_reg <= 8'b0;
        bit_cnt <= 0;
        rx_done <= 0;
        receiving <= 0;
    end else begin                                        
        if (!receiving) begin                             //phát hiện truyền
            receiving <= 1;
            bit_cnt <= 0;
            rx_done <= 0;
        end else begin                                                           // state nhận từng bit
            shift_reg <= {shift_reg[6:0], rxd};  
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 7) begin                                              // state nhận xong 1 byte
                data_out <= {shift_reg[6:0], rxd};
                rx_done <= 1;                             // cờ
                receiving <= 0;
            end
        end
    end
end

endmodule
