//          luồng: tín hiệu truyền+ data-> thanh ghi -> dịch bit -> chân tx
//
//
//          Đặc điểm :   + truyền 8 bit ,ko có bít stop,start ra TxD (p3.1)
//
//                       + truyền clk đồng bộ và tùng bít ra TxD (P3.1)
//
//                       + tốc độ 1 bit ứng với 1 clk
//                        
//
//
//
//    8051 mod 0 uart được thiết kế từ thập niên 1980
//
//
//
//
//
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module uart_mode0_tx (
    input wire clk,            // clock hệ thống (chu kỳ gửi 1 bit)
    input wire rst,
    input wire start_tx,       // yêu cầu bắt đầu truyền
    input wire [7:0] data_in,  // dữ liệu cần truyền
    output reg txd,            // chân TxD - dữ liệu ra
    output reg rxd_clk,        // chân RxD - clock ra cho thiết bị ngoài
    output reg tx_done         // báo đã truyền xong
);

reg [7:0] shift_reg;
reg [3:0] bit_cnt;
reg busy;

always @(posedge clk or posedge rst) begin
  if (rst) begin                                                             // rst
        txd <= 1;
        rxd_clk <= 0;
        tx_done <= 0;
        shift_reg <= 0;
        bit_cnt <= 0;
        busy <= 0;
    end else begin
      if (start_tx && !busy) begin                                            //   state nạp byte
            shift_reg <= data_in;
            bit_cnt <= 0;
            busy <= 1;
            tx_done <= 0;
      end else if (busy) begin                                                //   state nạp từng bit
            rxd_clk <= ~rxd_clk; 
            if (rxd_clk == 0) begin 
                txd <= shift_reg[7];        
                shift_reg <= {shift_reg[6:0], 1'b0}; 
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 7) begin
                    busy <= 0;
                    tx_done <= 1;
                end
            end
        end else begin
            tx_done <= 0;                                                    // cờ báo 
        end
    end
end

endmodule
