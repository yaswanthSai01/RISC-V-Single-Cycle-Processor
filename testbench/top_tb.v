//////////////////////////////////////////////////////////////////////////////
//
// Project: RISC-V Single-Cycle Processor
// Module: top_tb.v
// Description:
//   This is the top-level test bench for the RISC-V Single-Cycle Processor for behavioural simulation.
//
// Author: Kotyada Yaswanth Sai
// About: EE undergraduate at NIT Rourkela, interested in Digital Design
//        and Computer Architecture.
// Date: July 17, 2025
//
//////////////////////////////////////////////////////////////////////////////

module top_tb();

    reg clk,rst;

    // Instantiate the Device Under Test (DUT) - the top-level processor module
    top top_inst(.clk(clk), .rst(rst));

    // Clock generation
    initial begin
        clk = 0;
        forever begin
            #20; // Half-period delay (e.g., 20ns for a 25MHz clock)
            clk = ~clk;
        end
    end

    // Reset sequence and simulation control
    initial begin
        rst = 1; // Assert reset
        @(negedge clk); // Wait for one negative clock edge
        rst = 0; // Deassert reset
        repeat(220) @(negedge clk); // Run for 220 negative clock edges (cycles)
        $stop; // Stop simulation
    end

endmodule
