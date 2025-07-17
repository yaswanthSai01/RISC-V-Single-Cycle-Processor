# RISC-V Single-Cycle Processor on FPGA

This project implements a 32-bit **RISC-V single-cycle processor** (RV32I ISA) using **Verilog HDL**, simulated using **Xilinx Vivado**, and deployed on a **Basys 3 FPGA**. The processor uses **Block RAM (BRAM)** for instruction memory and is debugged using the **Integrated Logic Analyzer (ILA)**. A reset functionality is provided via an external switch on the FPGA board.

---

## 📌 Features

* ✅ Supports the full RV32I base instruction set (arithmetic, logic, load/store, branches, jump)
* ✅ **Single-cycle architecture**: all instructions execute in a single clock cycle
* ✅ **Modular design** with separate ALU, Control Unit, Register File, PC, and Datapath
* ✅ **BRAM** used for instruction memory (initialized with `.mem`)
* ✅ **ILA Debugging** to monitor internal signals such as PC, ALU result, RegFile output
* ✅ Reset via external **Basys 3 button** mapped as synchronous reset

---

## 🛠 Tools & Hardware

| Tool/Component           | Description                            |
| ------------------------ | -------------------------------------- |
| **Verilog HDL**          | RTL design language                    |
| **Xilinx Vivado**        | Synthesis, Simulation & FPGA flow      |
| **Basys 3 FPGA Board**   | Target hardware (Artix-7)              |
| **BRAM Generator**       | Instruction memory (program.mem)       |
| **Xilinx ILA**           | Real-time debugging and signal probing |

---

## 🧠 Architecture Overview

The processor implements the following core blocks:

* **Program Counter (PC)** with synchronous reset
* **Instruction Memory** using BRAM
* **Instruction Decoder + Control Unit**
* **ALU** for arithmetic and logic ops
* **Register File** (x0–x31)
* **Immediate Generator**
* **Branch Comparator** for conditional jumps

*(Insert block\_diagram.png here)*

---

## 🧪 Test Program Example

The following test instructions (in `program.mem`) were used to verify functionality:

```assembly
addi x1, x0, 5        ; x1 = 5
addi x2, x0, 10       ; x2 = 10
add  x3, x1, x2       ; x3 = x1 + x2 = 15
sw   x3, 0(x0)        ; Store x3 to address 0
beq  x1, x2, skip     ; Should not branch
jal  x0, -4           ; Loop to previous instruction
```

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
🔗 [LinkedIn](#) • 🔗 [GitHub](#) • 📧 [yaswanth@email.com](mailto:yaswanth@email.com)

---

## 📎 License

This project is open-source and available under the MIT License.

---
