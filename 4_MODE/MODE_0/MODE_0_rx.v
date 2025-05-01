module uart_mode0_rx (
    input wire clk_rx,         // clock đến từ thiết bị truyền (TxD)
    input wire rst,
    input wire rxd,            // dữ liệu đến (RxD)
    output reg [7:0] data_out, // dữ liệu nhận được
    output reg rx_done         // báo nhận xong 1 byte
);

reg [7:0] shift_reg;
reg [3:0] bit_cnt;
reg receiving;

always @(posedge clk_rx or posedge rst) begin
  if (rst) begin                                          //
        shift_reg <= 8'b0;
        bit_cnt <= 0;
        rx_done <= 0;
        receiving <= 0;
    end else begin                                        //
        if (!receiving) begin
            receiving <= 1;
            bit_cnt <= 0;
            rx_done <= 0;
        end else begin                                    //
            shift_reg <= {shift_reg[6:0], rxd};  
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 7) begin
                data_out <= {shift_reg[6:0], rxd};
                rx_done <= 1;
                receiving <= 0;
            end
        end
    end
end

endmodule
