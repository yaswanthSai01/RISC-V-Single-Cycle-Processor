//////////////////////////////////////////////////////////////////////////////
//
// Project: RISC-V Single-Cycle Processor
// Module: data_memory.v
// Description:
//   This module implements the Data Memory for the RISC-V processor.
//   It provides storage for data and supports byte, half-word, and word
//   read and write operations.
//
//   - Writes are synchronous: data is written to the specified address
//     on the positive edge of the clock when 'write_enable' is high.
//     Byte enables are derived from the address's least significant bits
//     to support unaligned byte/half-word writes across a word boundary.
//   - Reads are combinational: data is read from the specified address
//     and is sign-extended or zero-extended based on 'extension_type'
//     and 'data_size' for byte and half-word accesses.
//
// Parameters:
//   SIZE: The bit-width of the data (e.g., 32 bits).
//   BASE_ADDRESS: The base address offset for memory access.
//   mem_SIZE: The total number of 32-bit words in the data memory.
//
// Author: Kotyada Yaswanth Sai
// About: EE undergraduate at NIT Rourkela, interested in Digital Design
//        and Computer Architecture.
//
//////////////////////////////////////////////////////////////////////////////

module data_memory(address, write_data, read_data, clk, rst, data_size, extension_type, write_enable);

    // Size of the address and instruction (32 bits)
    parameter SIZE = 32;
    // Base address for the instruction memory
    parameter BASE_ADDRESS = 32'h00000000;
    // Size of the instruction memory (1792 MB)
    parameter mem_SIZE = 2000;                                   //1792 * 2**20;

    // input port
    input [SIZE-1:0] write_data;                                     // Input data to be written to the data memory
    input [SIZE-1:0] address;                                        // Address for reading and writing data
    input [1:0] data_size;                                           // Data size (2 bits): 00=byte, 01=halfword, 10=word
    input clk,rst, write_enable, extension_type;                     // Clock, reset, write enable, and extension type (0=sign-extend, 1=zero-extend)

    // output port
    output reg [SIZE-1:0] read_data;                                 // Data read from the specified address

    // Memory array (32-bit wide words, indexed by word address)
    reg [31:0] data_memory [0:mem_SIZE-1];

    // Integer for loop iteration (used for initialization, though not present in this snippet)
    integer i;

    reg [3:0] byte_enable; // Byte enable for word-aligned accesses

    // Combinational logic to determine byte_enable based on address[1:0]
    // This maps byte address offsets within a word to a byte enable mask.
    always @(*) begin
        case (address[1:0])
            2'b00: byte_enable = 4'b0001; // Accessing byte 0 (LSB)
            2'b01: byte_enable = 4'b0010; // Accessing byte 1
            2'b10: byte_enable = 4'b0100; // Accessing byte 2
            2'b11: byte_enable = 4'b1000; // Accessing byte 3 (MSB)
            default: byte_enable = 4'b0000; // Should not happen with 2-bit select
        endcase
    end

    // Synchronous write operation
    always @(posedge clk) begin
        // The reset logic is missing here. Typically, memory would be initialized on reset.
        // For example:
        // if (rst) begin
        //     for (i = 0; i < mem_SIZE; i = i + 1) begin
        //         data_memory[i] <= 0;
        //     end
        // end else
        if (write_enable) begin
            // Calculate the word-aligned address
            // Assuming address is byte-aligned and needs to be converted to word index
            // (address - BASE_ADDRESS) >> 2 for word indexing if BASE_ADDRESS is 0
            // Or simply address[31:2] if BASE_ADDRESS is handled elsewhere and mem_SIZE is based on words
            // The current (address - BASE_ADDRESS) implies byte addressing for the array index.
            // This might lead to large indices if addresses are high and mem_SIZE is small.
            // It's crucial that (address - BASE_ADDRESS) is within [0, mem_SIZE-1].
            case (data_size)
                2'b00: begin // Store Byte (SB)
                    // Write only the relevant byte within the 32-bit word
                    if (byte_enable[0]) data_memory[address - BASE_ADDRESS][7:0]   <= write_data[7:0];
                    if (byte_enable[1]) data_memory[address - BASE_ADDRESS][15:8]  <= write_data[7:0];
                    if (byte_enable[2]) data_memory[address - BASE_ADDRESS][23:16] <= write_data[7:0];
                    if (byte_enable[3]) data_memory[address - BASE_ADDRESS][31:24] <= write_data[7:0];
                end
                2'b01: begin // Store Halfword (SH)
                    // Write only the relevant halfword within the 32-bit word
                    if (byte_enable[0]) data_memory[address - BASE_ADDRESS][15:0]   <= write_data[15:0]; // Covers address[1:0] = 00
                    if (byte_enable[2]) data_memory[address - BASE_ADDRESS][31:16] <= write_data[15:0]; // Covers address[1:0] = 10
                end
                2'b10: begin // Store Word (SW)
                    // Write the entire 32-bit word
                    data_memory[address - BASE_ADDRESS] <= write_data[31:0];
                end
                default: begin
                    // Default case for undefined data_size during write
                    // For robustness, could issue an error or do nothing.
                    // Here, it writes 0, which might not be desired.
                    data_memory[address - BASE_ADDRESS] <= 32'h00000000;
                end
            endcase
        end
    end

    // Combinational read operation
    always @(*) begin
        // Default assignment to avoid latches
        read_data = 32'hxxxxxxxx; // Undefined by default

        // Access the memory content based on the word-aligned address
        // The index (address - BASE_ADDRESS) is assumed to be within [0, mem_SIZE-1]
        case (data_size)
            2'b00: begin // Load Byte (LB/LBU)
                if (!extension_type) begin // Sign-Extend Byte (LB)
                    if (byte_enable[0]) read_data = {{24{data_memory[address - BASE_ADDRESS][7]}} ,data_memory[address - BASE_ADDRESS][7:0]};
                    else if (byte_enable[1]) read_data = {{24{data_memory[address - BASE_ADDRESS][15]}} ,data_memory[address - BASE_ADDRESS][15:8]};
                    else if (byte_enable[2]) read_data = {{24{data_memory[address - BASE_ADDRESS][23]}} ,data_memory[address - BASE_ADDRESS][23:16]};
                    else if (byte_enable[3]) read_data = {{24{data_memory[address - BASE_ADDRESS][31]}} ,data_memory[address - BASE_ADDRESS][31:24]};
                    else read_data = 32'h0; // Fallback if byte_enable is 0000
                end else begin // Zero-Extend Byte (LBU)
                    if (byte_enable[0]) read_data = {24'h000000 ,data_memory[address - BASE_ADDRESS][7:0]};
                    else if (byte_enable[1]) read_data = {24'h000000 ,data_memory[address - BASE_ADDRESS][15:8]};
                    else if (byte_enable[2]) read_data = {24'h000000 ,data_memory[address - BASE_ADDRESS][23:16]};
                    else if (byte_enable[3]) read_data = {24'h000000 ,data_memory[address - BASE_ADDRESS][31:24]};
                    else read_data = 32'h0; // Fallback if byte_enable is 0000
                end
            end
            2'b01: begin // Load Halfword (LH/LHU)
                if (!extension_type) begin // Sign-Extend Halfword (LH)
                    if (byte_enable[0]) read_data = {{16{data_memory[address - BASE_ADDRESS][15]}} ,data_memory[address - BASE_ADDRESS][15:0]}; // Covers address[1:0] = 00
                    else if (byte_enable[2]) read_data = {{16{data_memory[address - BASE_ADDRESS][31]}} ,data_memory[address - BASE_ADDRESS][31:16]}; // Covers address[1:0] = 10
                    else read_data = 32'h0; // Fallback if byte_enable is 0000
                end else begin // Zero-Extend Halfword (LHU)
                    if (byte_enable[0]) read_data = {16'h0000 ,data_memory[address - BASE_ADDRESS][15:0]}; // Covers address[1:0] = 00
                    else if (byte_enable[2]) read_data = {16'h0000 ,data_memory[address - BASE_ADDRESS][31:16]}; // Covers address[1:0] = 10
                    else read_data = 32'h0; // Fallback if byte_enable is 0000
                end
            end
            2'b10: read_data = data_memory[address - BASE_ADDRESS]; // Load Word (LW)
            default: read_data = 32'h0; // Default case for undefined data_size during read
        endcase
    end

endmodule
