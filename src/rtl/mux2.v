//////////////////////////////////////////////////////////////////////////////
//
// Project: RISC-V Single-Cycle Processor
// Module: mux2.v
// Description:
//   This module implements a 2-to-1 multiplexer. It selects one of two
//   input operands ('operand_1' or 'operand_2') based on the 'select'
//   signal and outputs the chosen operand.
//
// Parameters:
//   SIZE: The bit-width of the input and output data paths (e.g., 32 bits).
//
// Author: Kotyada Yaswanth Sai
// About: EE undergraduate at NIT Rourkela, interested in Digital Design
//        and Computer Architecture.
//
//////////////////////////////////////////////////////////////////////////////

module mux2(operand_1, operand_2, select, result);

    parameter SIZE = 32;

    // input port
    input [SIZE-1:0] operand_1, operand_2;                                   // Input operands (32 bits each)
    input select;                                                            // Select signal

    // output port
    output [SIZE-1:0] result;                                                // Output (32 bits)

    // Assign the output based on the select signal
    assign result = select ? operand_2 : operand_1;

endmodule
