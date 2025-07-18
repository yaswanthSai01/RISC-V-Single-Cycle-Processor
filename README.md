# RISC-V Single-Cycle Core on FPGA

This repository contains a Verilog HDL implementation of a **32-bit RISC-V Single-Cycle Processor** (RV32I), designed for the **Basys 3 FPGA**. It uses **Block RAM (BRAM)** for instruction memory and includes **Integrated Logic Analyzer (ILA)** integration for real-time debugging.

## 🔧 Features

- Implements **RV32I base instruction set** (arithmetic, logic, load/store, branches, jump)
- **Single-cycle execution** for all instructions
- Modular design: ALU, Control Unit, Register File, PC, etc.
- **Instruction memory** via BRAM initialized with `program.mem`
- **ILA debugging** for PC, ALU result, register outputs
- Synchronous **reset via button** on Basys 3

## 🛠 Tools & Hardware

- **Language:** Verilog HDL  
- **Toolchain:** Xilinx Vivado  
- **Board:** Basys 3 (Artix-7)  
- **Memory:** BRAM (Block RAM Generator IP)  
- **Debug:** Integrated Logic Analyzer (ILA)

## 🧠 Architecture

Key Modules:
- Program Counter (PC)
- Instruction Memory (BRAM)
- Instruction Decoder & Control Unit
- ALU and Register File
- Immediate Generator
- Branch Comparator

*(Insert architecture diagram if available)*

## 🧪 Test Program

Example instructions used for testing (from `program.mem`):

```assembly
addi x1, x0, 5        // x1 = 5
addi x2, x0, 10       // x2 = 10
add  x3, x1, x2       // x3 = 15
sw   x3, 0(x0)        // Store to address 0
beq  x1, x2, skip     // No branch
jal  x0, -4           // Loop

---

## 🚀 Running the Design

### 🔧 Simulation (in Vivado)

1. Open the Vivado project.
2. Run behavioral simulation on `tb_top.v`.
3. Use waveform viewer to inspect ALU, regfile, PC values.

### 💻 FPGA Deployment (Basys 3)

1. Initialize and Configure BRAM Generator (Block RAM Generator) from IP Catalog of Vivado tool.
2. Convert the `program.mem` to `program.coe` and connect it to BRAM using Vivado's BRAM Generator.
3. Now instantiate BRAM module ` blk_mem_gen_0` in `top.v`.
4. Assign the reset to a **Basys 3 switch** using `Basys3_Master.xdc`.
5. Initialize and Configure ILA(Integrated Logic Analyzer) from IP Catalog of Viviado tool.
6. Now instantiate ILA module `ila_0` in top module
7. Connect ILA to signals like `PC`, `ALU result`, and `RegFile outputs`.
8. Synthesize and implement `top.v`.
9. Generate bitstream and program the FPGA.

*(Insert ila\_waveform.png here)*

---

## 🧑‍💻 Author

**Yaswanth Sai Kotyada**
B.Tech in Electrical Engineering, NIT Rourkela

---
