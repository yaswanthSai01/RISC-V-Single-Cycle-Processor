//////////////////////////////////////////////////////////////////////////////
//
// Project: RISC-V Single-Cycle Processor
// Module: reg_file.v
// Description:
//   This module implements the Register File for the RISC-V processor.
//   It consists of 32 general-purpose registers, each 32 bits wide.
//   The register file supports two simultaneous read operations and one
//   synchronous write operation.
//
//   - Reads are combinational: 'read_data_1' and 'read_data_2' reflect
//     the contents of 'read_address_1' and 'read_address_2' immediately.
//   - Writes are synchronous: 'write_data' is written to 'write_address'
//     on the positive edge of the clock when 'write_enable' is high.
//   - On reset (rst), all registers are initialized to 0. Additionally,
//     register x2 (stack pointer) is initialized to 32'h00000500.
//   - Register x0 (address 0) is hardwired to zero: any attempt to write
//     to x0 will result in 0 being stored, adhering to RISC-V specification.
//
// Parameters:
//   SIZE: The bit-width of each register (e.g., 32 bits).
//
// Author: Kotyada Yaswanth Sai
// About: EE undergraduate at NIT Rourkela, interested in Digital Design
//        and Computer Architecture.
//
//////////////////////////////////////////////////////////////////////////////

module reg_file (read_address_1, read_address_2, write_address, write_data, clk, write_enable, read_data_1, read_data_2, rst);
    
    // Size of the register file (32 registers, each 32 bits wide)
    parameter SIZE = 32;

    // input port
    input [SIZE-1:0] write_data;                                            // Input data to be written to the register file
    input [4:0] read_address_1, read_address_2, write_address;               // Addresses for reading and writing data (5 bits for 32 registers)
    input clk, write_enable, rst;                                           // Clock, write enable, and reset signals            

    // output port
    output [SIZE-1:0] read_data_1, read_data_2;                              // Data read from the specified registers

    // Register file array (32 registers, each 32 bits wide)
    reg [SIZE-1:0] reg_file [0:SIZE-1];

    // Integer for loop iteration
    integer i;

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (rst) begin
            // If reset is high, initialize all registers to 0
            for (i = 0; i < SIZE; i = i + 1) begin
                reg_file[i] <= 0;
            end
            // Initialize register x2 (sp) to a specific value
            reg_file[2] <= 32'h00000500;
        end else if (write_enable) begin
            // If write enable is high, write data to the specified register
            // RISC-V convention: writing to x0 (address 0) has no effect, it always reads 0.
            if (!write_address) begin // If write_address is 0 (x0)
                reg_file[write_address] <= 0; // Force x0 to 0
            end else begin
                reg_file[write_address] <= write_data; // Write data to other registers
            end
            
        end
    end

    // Assign the read data outputs to the values stored in the specified registers
    // Reads are combinational (asynchronous)
    assign read_data_1 = reg_file[read_address_1];
    assign read_data_2 = reg_file[read_address_2];

endmodule
