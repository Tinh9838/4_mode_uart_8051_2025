# 4_mode_uart_8051_2025
| Chế độ | Loại truyền   | Bit           | Tốc độ     | Ứng dụng                  |
|--------|---------------|---------------|------------|---------------------------|
| Mode 0 | Đồng bộ       | 8             | fosc/12    | Hiếm dùng, shift register |
| Mode 1 | Không đồng bộ | 10 (1+8+1)    | Theo Timer | UART phổ biến             |
| Mode 2 | Không đồng bộ | 11 (1+8+1+1)  | Cố định    | Truyền đa điểm, đơn giản  |
| Mode 3 | Không đồng bộ | 11            | Theo Timer | Truyền đa điểm, linh hoạt |
