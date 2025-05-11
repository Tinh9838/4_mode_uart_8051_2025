// + luồng : rx -> dịch bít vào thanh ghi-> data + bt8
//
//
//
// đặc điểm : + giống mode 2 chỉ khác ở tốc độ phụ thuộc time.
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
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module uart_rx_mode3 (
    input        clk,         // System clock
    input        rst_n,       // Active low reset
    input        rx,          // RX line
    input        sample_tick, // Sampling strobe (from Timer 1)
    output reg   rx_done,     // Data received
    output reg [7:0] rx_data, // 8-bit data
    output reg   rb8          // 9th bit (address/data flag)
);

    reg [3:0] bit_cnt;
    reg [8:0] shift_reg;
    reg       receiving;
    reg [3:0] sample_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_done    <= 0;
            bit_cnt    <= 0;
            shift_reg  <= 0;
            rx_data    <= 0;
            rb8        <= 0;
            receiving  <= 0;
            sample_cnt <= 0;
        end else if (sample_tick) begin
            if (!receiving) begin
                // Detect start bit (falling edge)
                if (rx == 0) begin
                    receiving  <= 1;
                    bit_cnt    <= 0;
                    sample_cnt <= 0;
                end
            end else begin
                sample_cnt <= sample_cnt + 1;
                if (sample_cnt == 7) begin  // Mid-bit sampling
                    bit_cnt <= bit_cnt + 1;
                    shift_reg <= {rx, shift_reg[8:1]};

                    if (bit_cnt == 9) begin // After stop bit
                        rx_data <= shift_reg[7:0];
                        rb8     <= shift_reg[8]; // 9th bit
                        rx_done <= 1;
                        receiving <= 0;
                    end
                end
            end
        end else begin
            rx_done <= 0;
        end
    end
endmodule
