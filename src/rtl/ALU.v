//////////////////////////////////////////////////////////////////////////////
//
// Project: RISC-V Single-Cycle Processor
// Module: ALU.v
// Description:
//   This module implements the Arithmetic Logic Unit (ALU) for the RISC-V
//   processor. It performs various arithmetic and logical operations on two
//   32-bit input operands ('operand_1' and 'operand_2') based on the 5-bit
//   'ALU_control' signal. The result of the operation is output on 'result'.
//
//   Supported Operations:
//     - 5'b00000: ADD (Addition)
//     - 5'b00010: SUB (Subtraction)
//     - 5'b00100: SLL (Shift Left Logical)
//     - 5'b01000: SLT (Set Less Than - Signed)
//     - 5'b01100: SLTU (Set Less Than Unsigned)
//     - 5'b10000: XOR (Bitwise XOR)
//     - 5'b10100: SRL (Shift Right Logical)
//     - 5'b10110: SRA (Shift Right Arithmetic)
//     - 5'b11000: OR (Bitwise OR)
//     - 5'b11100: AND (Bitwise AND)
//
// Parameters:
//   SIZE: The bit-width of the operands and the result (typically 32 bits).
//
// Author: Kotyada Yaswanth Sai
// About: EE undergraduate at NIT Rourkela, interested in Digital Design
//        and Computer Architecture.
//
//////////////////////////////////////////////////////////////////////////////

module ALU(operand_1, operand_2, result, ALU_control);

    parameter SIZE = 32;

    // input port
    input signed [SIZE-1:0] operand_1, operand_2;                        // Input operands (32 bits each)
    input [4:0] ALU_control;                                             // ALU control signal (5 bits)

    // output port
    output reg signed [SIZE-1:0] result;                                 // ALU result (32 bits)

    // Always block to perform ALU operations based on ALU_control
    always @(*) begin
        case (ALU_control)
            5'b00000: result = operand_1 + operand_2; // ADD
            5'b00010: result = operand_1 - operand_2; // SUB
            5'b00100: result = operand_1 << operand_2; // SLL
            5'b01000: result = operand_1 < operand_2 ? 1 : 0; // SLT
            5'b01100: result = $unsigned(operand_1) < $unsigned(operand_2) ? 1 : 0; // SLTU
            5'b10000: result = operand_1 ^ operand_2; // XOR
            5'b10100: result = operand_1 >> operand_2; // SRL
            5'b10110: result = operand_1 >>> operand_2; // SRA
            5'b11000: result = operand_1 | operand_2; // OR
            5'b11100: result = operand_1 & operand_2; // AND
            default: result = 0; // Default case
        endcase
    end

endmodule
