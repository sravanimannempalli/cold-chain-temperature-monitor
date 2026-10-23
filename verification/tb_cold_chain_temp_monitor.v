`timescale 1ns/1ps
`default_nettype none

module tb_cold_chain_temp_monitor;

    localparam integer THRESHOLD_CYCLES = 8;
    localparam integer CLK_PERIOD = 10;

    reg clk;
    reg rst_n;
    reg temp_high;
    wire alarm;

    integer errors;

    cold_chain_temp_monitor #(
        .THRESHOLD_CYCLES(THRESHOLD_CYCLES)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .temp_high(temp_high),
        .alarm(alarm)
    );

    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    task check_alarm;
        input expected;
        input [8*80-1:0] test_name;
        begin
            if (alarm !== expected) begin
                $display("FAIL: %0s | expected alarm=%b, got=%b at time %0t",
                         test_name, expected, alarm, $time);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s | alarm=%b at time %0t",
                         test_name, alarm, $time);
            end
        end
    endtask

    task apply_reset;
        begin
            @(negedge clk);
            rst_n = 1'b0;
            temp_high = 1'b0;
            repeat (2) @(negedge clk);
            check_alarm(1'b0, "reset clears alarm");
            rst_n = 1'b1;
            @(negedge clk);
        end
    endtask

    integer i;

    initial begin
        $dumpfile("cold_chain_temp_monitor.vcd");
        $dumpvars(0, tb_cold_chain_temp_monitor);

        errors = 0;
        rst_n = 1'b0;
        temp_high = 1'b0;
        repeat (2) @(negedge clk);
        check_alarm(1'b0, "initial reset");
        rst_n = 1'b1;

        // Normal input must not trigger an alarm.
        repeat (3) @(negedge clk);
        check_alarm(1'b0, "normal temperature");

        // A short excursion must not trigger the alarm; returning low clears
        // the consecutive-cycle counter.
        temp_high = 1'b1;
        repeat (3) @(negedge clk);
        check_alarm(1'b0, "short excursion below threshold");
        temp_high = 1'b0;
        @(negedge clk);
        check_alarm(1'b0, "short excursion resets counter");

        // A second short excursion must not accumulate with the first one.
        temp_high = 1'b1;
        repeat (4) @(negedge clk);
        check_alarm(1'b0, "second short excursion");
        temp_high = 1'b0;
        @(negedge clk);
        check_alarm(1'b0, "counter clears between excursions");

        // Exactly THRESHOLD_CYCLES consecutive sampled high cycles.
        temp_high = 1'b1;
        for (i = 1; i <= THRESHOLD_CYCLES; i = i + 1) begin
            @(negedge clk);
            if (i < THRESHOLD_CYCLES)
                check_alarm(1'b0, "alarm remains low before threshold");
            else
                check_alarm(1'b1, "alarm asserts at threshold");
        end

        // Alarm remains latched after temperature returns to normal.
        temp_high = 1'b0;
        repeat (3) @(negedge clk);
        check_alarm(1'b1, "alarm remains latched after recovery");

        // Reset must clear the latched alarm.
        apply_reset();
        check_alarm(1'b0, "alarm cleared after reset");

        // Reset while an excursion is in progress.
        temp_high = 1'b1;
        repeat (4) @(negedge clk);
        apply_reset();
        temp_high = 1'b1;
        repeat (THRESHOLD_CYCLES-1) @(negedge clk);
        check_alarm(1'b0, "post-reset excursion below threshold");
        @(negedge clk);
        check_alarm(1'b1, "post-reset excursion reaches threshold");

        if (errors == 0)
            $display("\\nALL TESTS PASSED");
        else
            $display("\\nTESTS FAILED: %0d error(s)", errors);

        #20;
        $finish;
    end

endmodule

`default_nettype wire
