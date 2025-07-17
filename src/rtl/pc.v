//////////////////////////////////////////////////////////////////////////////
//
// Project: RISC-V Single-Cycle Processor
// Module: pc.v
// Description:
//   This module implements the Program Counter (PC) for the RISC-V processor.
//   It is a synchronous register that holds the address of the current
//   instruction being fetched. On a rising clock edge:
//   - If reset (rst) is active, the PC is initialized to BASE_INSTRUCTION.
//   - Otherwise, the PC is updated with the value from the 'in' port.
//
// Parameters:
//   BASE_INSTRUCTION: The initial address for the PC on reset (e.g., 32'h00000000).
//   SIZE: The bit-width of the PC register (e.g., 32 for RISC-V RV32I).
//
// Author: Kotyada Yaswanth Sai
// About: EE undergraduate at NIT Rourkela, interested in Digital Design
//        and Computer Architecture.
//
//////////////////////////////////////////////////////////////////////////////

module pc (clk, rst, in, out);
    // Base address for the first instruction
    parameter BASE_INSTRUCTION = 32'h00000000;
    // Size of the instruction (32 bits)
    parameter SIZE = 32;
    // input port
    input [SIZE-1:0] in;                                                // Input address (32 bits)
    input clk, rst;                                                   // Clock and reset signals
    // output port
    output reg [SIZE-1:0] out;                                          // Output address (32 bits)
    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (rst) begin
            // If reset is high, set the output to the base instruction address
            out <= BASE_INSTRUCTION;
        end else begin
            // Otherwise, update the PC with the input 'in' value
            out <= in;
        end
    end
endmodule
