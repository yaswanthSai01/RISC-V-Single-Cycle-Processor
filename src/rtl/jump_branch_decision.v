//////////////////////////////////////////////////////////////////////////////
//
// Project: RISC-V Single-Cycle Processor
// Module: jump_branch_decision.v
// Description:
//   This module determines the next Program Counter (PC) source based on
//   the 'jump_branch' control signal and the comparison results of two
//   operands. It calculates the 'zero', 'neg' (signed less than), and
//   'less_than' (unsigned less than) flags for branch conditions.
//
//   The 'pc_src' output selects between the incremented PC (sequential)
//   and the branch/jump target address (taken branch/jump).
//
// Input Control Signals:
//   - jump_branch: Specifies the type of jump or branch operation.
//     - 3'b010: No jump/branch (sequential PC)
//     - 3'b011: Unconditional Jump (JAL/JALR)
//     - 3'b000: BEQ (Branch if Equal)
//     - 3'b001: BNE (Branch if Not Equal)
//     - 3'b100: BLT (Branch if Less Than - Signed)
//     - 3'b101: BGE (Branch if Greater Than or Equal - Signed)
//     - 3'b110: BLTU (Branch if Less Than Unsigned)
//     - 3'b111: BGEU (Branch if Greater Than or Equal Unsigned)
//
// Author: Kotyada Yaswanth Sai
// About: EE undergraduate at NIT Rourkela, interested in Digital Design
//        and Computer Architecture.
//
//////////////////////////////////////////////////////////////////////////////

module jump_branch_decision(operand_1, operand_2, zero, neg, less_than, jump_branch, pc_src);

    parameter SIZE = 32;

    // input port    
    input [SIZE-1:0] operand_1, operand_2;                           // Input operands (32 bits each)
    input [2:0] jump_branch;                                         // Jump or branch signal (3 bits)
    
    // output port
    output reg pc_src;                                               // Output PC source (1 bit: 0=PC+4, 1=Branch/Jump Target)
    output zero, neg, less_than;                                     // Zero, negative (signed), and less than (unsigned) flags
    
    // Always block to decide the PC source
    always @(*) begin
        if (jump_branch == 3'b010) begin // NO JUMP/BRANCH
            pc_src <= 1'b0; // PC source is the incremented PC (PC + 4)
        end else if (jump_branch == 3'b011) begin // UNCONDITIONAL JUMP (JAL/JALR)
            pc_src <= 1'b1; // PC source is the jump target address (from ALU result)
        end else begin // CONDITIONAL BRANCHES
            case (jump_branch)
                3'b000: pc_src <= (zero) ? 1'b1 : 1'b0;          // BEQ (Branch if Equal)
                3'b001: pc_src <= (!zero) ? 1'b1 : 1'b0;         // BNE (Branch if Not Equal)
                3'b100: pc_src <= (neg) ? 1'b1 : 1'b0;           // BLT (Branch if Less Than - Signed)
                3'b101: pc_src <= (!neg || zero) ? 1'b1 : 1'b0;  // BGE (Branch if Greater Than or Equal - Signed)
                3'b110: pc_src <= (less_than) ? 1'b1 : 1'b0;     // BLTU (Branch if Less Than Unsigned)
                3'b111: pc_src <= (!less_than || zero) ? 1'b1 : 1'b0; // BGEU (Branch if Greater Than or Equal Unsigned)
                default: pc_src <= 1'b0; // Default case (no branch taken)
            endcase
        end
    end

    // Combinational logic for flags based on operand comparison
    assign zero = (operand_1 == operand_2);                     // Set if operands are equal
    assign neg = ($signed(operand_1) < $signed(operand_2));     // Set if operand_1 is signed less than operand_2
    assign less_than = ($unsigned(operand_1) < $unsigned(operand_2)); // Set if operand_1 is unsigned less than operand_2

endmodule
