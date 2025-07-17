//////////////////////////////////////////////////////////////////////////////
//
// Project: RISC-V Single-Cycle Processor
// Module: control_unit.v
// Description:
//   This module acts as the control unit for the RISC-V processor.
//   It decodes the instruction's opcode, funct3, and funct7 fields
//   to generate all necessary control signals for other components
//   of the processor, including the ALU, Register File, Data Memory,
//   and Immediate Extender.
//
//   Output Control Signals:
//     - alu_control: Determines the operation performed by the ALU.
//     - imm_src: Selects the type of immediate extension.
//     - result_src: Selects the source of data to be written back to the register file.
//     - alu_src: Selects the second operand for the ALU.
//     - jump_branch: Controls jump/branch logic.
//     - data_size: Specifies data size for memory accesses (byte, half-word, word).
//     - extension_type: Determines sign or zero extension for loads.
//     - mem_write: Enables write operation to data memory.
//     - reg_write: Enables write operation to the register file.
//
// Author: Kotyada Yaswanth Sai
// About: EE undergraduate at NIT Rourkela, interested in Digital Design
//        and Computer Architecture.
//
//////////////////////////////////////////////////////////////////////////////

module control_unit(op, funct3, funct7, jump_branch, result_src, mem_write, alu_control, alu_src, imm_src, reg_write, data_size, extension_type);

    // input port
    input [6:0] op;                                                          // Input opcode (7 bits)
    input [6:0] funct7;                                                      // Input funct7 (7 bits)
    input [2:0] funct3;                                                      // Input funct3 (3 bits)

    // output port
    output reg [4:0] alu_control;                                            // Output ALU control (5 bits)
    output reg [2:0] imm_src;                                                // Output immediate source (3 bits)
    output reg [1:0] result_src;                                             // Output result source (2 bits)
    output reg [1:0] alu_src;                                                // Output ALU source (2 bits)
    output reg [2:0] jump_branch;                                            // Output jump branch (3 bits)
    output reg [1:0] data_size;                                              // Output data size (2 bits)
    output reg extension_type;                                               // Output extension type (1 bit)
    output reg mem_write;                                                    // Output memory write (1 bit)
    output reg reg_write;                                                    // Output register write (1 bit)

    // Always block to determine the control signals based on the opcode and funct3 and funct7

    always @(*) begin

        // Default assignments to avoid latches
        alu_control    = 5'b00000;
        imm_src        = 3'b000;
        result_src     = 2'b00;
        alu_src        = 2'b00;
        jump_branch    = 3'b010; // Default to No Jump/Branch
        data_size      = 2'b00;
        extension_type = 1'b0;
        mem_write      = 1'b0;
        reg_write      = 1'b0;


        // alu_control signal generation
        case (op)
            // R-FORMAT-INSTRUCTIONS (opcode 0110011)
            7'b0110011: case ({funct7, funct3})
                10'b0000000000: alu_control = 5'b00000;     // ADD
                10'b0100000000: alu_control = 5'b00010;     // SUB
                10'b0000000001: alu_control = 5'b00100;     // SLL
                10'b0000000010: alu_control = 5'b01000;     // SLT
                10'b0000000011: alu_control = 5'b01100;     // SLTU
                10'b0000000100: alu_control = 5'b10000;     // XOR
                10'b0000000101: alu_control = 5'b10100;     // SRL
                10'b0100000101: alu_control = 5'b10110;     // SRA
                10'b0000000110: alu_control = 5'b11000;     // OR
                10'b0000000111: alu_control = 5'b11100;     // AND
                default: alu_control = 5'b00000;
            endcase
            // I-FORMAT-INSTRUCTIONS (opcode 0010011)
            7'b0010011: case (funct3)
                3'b000: alu_control = 5'b00000;             // ADDI
                3'b001: alu_control = 5'b00100;             // SLLI
                3'b010: alu_control = 5'b01000;             // SLTI
                3'b011: alu_control = 5'b01100;             // SLTIU
                3'b100: alu_control = 5'b10000;             // XORI
                3'b110: alu_control = 5'b11000;             // ORI
                3'b111: alu_control = 5'b11100;             // ANDI
                3'b101: case (funct7) // SRLI / SRAI
                    7'b0000000: alu_control = 5'b10100;     // SRLI
                    7'b0100000: alu_control = 5'b10110;     // SRAI
                    default: alu_control = 5'b00000;
                endcase
                default: alu_control = 5'b00000;
            endcase
            // LOAD-INSTRUCTIONS (opcode 0000011)
            7'b0000011: alu_control = 5'b00000;             // ADD (for address calculation)
            // S-FORMAT-INSTRUCTIONS (opcode 0100011)
            7'b0100011: alu_control = 5'b00000;             // ADD (for address calculation)
            // J-FORMAT-INSTRUCTIONS (JAL: 1101111, JALR: 1100111)
            7'b1101111, 7'b1100111: alu_control = 5'b00000; // ADD (for address calculation)
            // U-FORMAT-INSTRUCTIONS (LUI: 0110111, AUIPC: 0010111)
            7'b0010111, 7'b0110111: alu_control = 5'b00000; // ADD (for address calculation)
            // B-FORMAT-INSTRUCTIONS (opcode 1100011)
            7'b1100011: alu_control = 5'b00000;             // ADD (for branch target calculation, or comparison in ALU)
            // FENCE/PAUSE INSTRUCTION (opcode 0001111)
            7'b0001111: alu_control = 5'b00000;             // No ALU operation needed, or default
            default: alu_control = 5'b00000;
        endcase

        // imm_src signal generation
        case (op)
            // I-FORMAT-SIGNED-INSTRUCTIONS & JALR instruction (0010011, 0000011, 1100111)
            7'b0010011, 7'b0000011, 7'b1100111: begin
                case (funct3)
                    // Specific I-type instructions that use a 12-bit signed immediate (case 4 in imm_extend)
                    3'b000, 3'b010, 3'b011, 3'b100, 3'b110, 3'b111: imm_src = 3'b100; // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, Load instructions
                    // I-FORMAT-SHIFT-INSTRUCTIONS (SLLI, SRLI, SRAI) use a 5-bit immediate (case 5 in imm_extend)
                    3'b001: imm_src = 3'b101; // SLLI
                    3'b101: begin
                        case (funct7)
                            7'b0000000: imm_src = 3'b101; // SRLI
                            7'b0100000: imm_src = 3'b101; // SRAI
                            default: imm_src = 3'b000; // Default
                        endcase
                    end
                    default: imm_src = 3'b000; // Default
                endcase
            end
            // S-FORMAT-INSTRUCTIONS (0100011)
            7'b0100011: imm_src = 3'b010;
            // B-FORMAT-INSTRUCTIONS (1100011)
            7'b1100011: imm_src = 3'b011;
            // U-FORMAT-INSTRUCTIONS (LUI: 0110111, AUIPC: 0010111)
            7'b0110111, 7'b0010111: imm_src = 3'b000;
            // JAL-INSTRUCTION (1101111)
            7'b1101111: imm_src = 3'b001;
            default: imm_src = 3'b000; // Default immediate source
        endcase

        // result_src signal generation
        case (op)
            // I-FORMAT-ARITHMETIC-INSTRUCTIONS & R-FORMAT-INSTRUCTIONS & AUIPC-INSTRUCTION
            7'b0010011, 7'b0110011, 7'b0010111: result_src = 2'b00; // ALU result
            // I-FORMAT-LOAD-INSTRUCTIONS
            7'b0000011: result_src = 2'b01; // Data Memory read data
            // JAL-INSTRUCTION & JALR-INSTRUCTION
            7'b1101111, 7'b1100111: result_src = 2'b10; // PC + 4 (return address)
            // LUI-INSTRUCTION
            7'b0110111: result_src = 2'b11; // Extended Immediate (for LUI)
            default: result_src = 2'b00;
        endcase

        // alu_src signal generation
        case (op)
            // R-FORMAT-INSTRUCTIONS
            7'b0110011: alu_src = 2'b00; // rs1, rs2 (both register operands)
            // I-FORMAT-INSTRUCTIONS & S-FORMAT-INSTRUCTIONS & JALR-INSTRUCTION
            7'b0000011, 7'b0010011, 7'b0100011, 7'b1100111: alu_src = 2'b01; // rs1, immediate
            // B-FORMAT-INSTRUCTIONS & JAL-INSTRUCTION & AUIPC-INSTRUCTION
            7'b1101111, 7'b1100011, 7'b0010111: alu_src = 2'b11; // PC, immediate (for branch/jump target or AUIPC)
            default: alu_src = 2'b00;
        endcase

        // jump_branch signal generation
        case (op)
            // JAL-INSTRUCTION & JALR-INSTRUCTION
            7'b1101111, 7'b1100111: jump_branch = 3'b011; // J (Unconditional Jump)
            // B-FORMAT-INSTRUCTIONS
            7'b1100011: case (funct3)
                3'b000: jump_branch = 3'b000; // BEQ
                3'b001: jump_branch = 3'b001; // BNE
                3'b100: jump_branch = 3'b100; // BLT
                3'b101: jump_branch = 3'b101; // BGE
                3'b110: jump_branch = 3'b110; // BLTU
                3'b111: jump_branch = 3'b111; // BGEU
                default: jump_branch = 3'b010; // NO (No branch)
            endcase
            default: jump_branch = 3'b010; // NO (No branch or jump)
        endcase

        // data_size signal generation (for Load/Store instructions)
        case (op)
            7'b0000011: case (funct3) // Load instructions
                3'b000: data_size = 2'b00; // LB / LBU
                3'b001: data_size = 2'b01; // LH / LHU
                3'b010: data_size = 2'b10; // LW
                3'b100: data_size = 2'b00; // LBU
                3'b101: data_size = 2'b01; // LHU
                default: data_size = 2'b00;
            endcase
            7'b0100011: case (funct3) // Store instructions
                3'b000: data_size = 2'b00; // SB
                3'b001: data_size = 2'b01; // SH
                3'b010: data_size = 2'b10; // SW
                default: data_size = 2'b00;
            endcase
            default: data_size = 2'b00; // Default to byte size if not load/store
        endcase

        // extension_type signal generation (for Load instructions)
        case (op)
            7'b0000011: case (funct3) // Load instructions
                3'b000, 3'b001 : extension_type = 1'b0; // LB, LH (Sign Extend)
                3'b100, 3'b101 : extension_type = 1'b1; // LBU, LHU (Zero Extend)
                default: extension_type = 1'b0;
            endcase
            default: extension_type = 1'b0; // Default to sign-extend behavior
        endcase

        // mem_write signal generation
        case (op)
            // S-FORMAT-INSTRUCTIONS
            7'b0100011: mem_write = 1'b1;
            default: mem_write = 1'b0;
        endcase

        // reg_write signal generation
        case (op)
            // I-FORMAT-INSTRUCTIONS & R-FORMAT-INSTRUCTIONS & JAL-INSTRUCTION & JALR-INSTRUCTION & AUIPC-INSTRUCTION & LUI
            7'b0000011, 7'b0010011, 7'b0110011, 7'b1101111, 7'b1100111, 7'b0010111, 7'b0110111 : reg_write = 1'b1;
            default: reg_write = 1'b0;
        endcase
    end

endmodule
