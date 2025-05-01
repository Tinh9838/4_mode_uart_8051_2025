module baud_generator (
    input        clk,           // System clock (e.g., 50 MHz)
    input        rst_n,         // Active-low reset
    output reg   baud_tick      // Baud rate tick
);
    parameter CLK_FREQ = 50000000;     // 50 MHz
    parameter BAUD     = 9600;
    localparam TICKS   = CLK_FREQ / BAUD;

    reg [$clog2(TICKS):0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter    <= 0;
            baud_tick  <= 0;
        end else begin
            if (counter == TICKS - 1) begin
                counter   <= 0;
                baud_tick <= 1;
            end else begin
                counter   <= counter + 1;
                baud_tick <= 0;
            end
        end
    end
endmodule
