`default_nettype none

module cold_chain_temp_monitor #(
    parameter integer THRESHOLD_CYCLES = 8,
    parameter integer COUNTER_WIDTH = (THRESHOLD_CYCLES <= 1) ? 1 : $clog2(THRESHOLD_CYCLES)
) (
    input  wire clk,
    input  wire rst_n,
    input  wire temp_high,
    output reg  alarm
);

    reg [COUNTER_WIDTH-1:0] excursion_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            excursion_count <= {COUNTER_WIDTH{1'b0}};
            alarm           <= 1'b0;
        end else if (!alarm) begin
            if (!temp_high) begin
                excursion_count <= {COUNTER_WIDTH{1'b0}};
            end else if (excursion_count >= THRESHOLD_CYCLES - 1) begin
                // The alarm asserts on the THRESHOLD_CYCLES-th consecutive
                // sampled high cycle. It remains latched until reset.
                alarm <= 1'b1;
            end else begin
                excursion_count <= excursion_count + 1'b1;
            end
        end
    end

endmodule

`default_nettype wire
