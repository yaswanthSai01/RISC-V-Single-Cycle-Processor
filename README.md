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
| **GTKWAVE** *(optional)* | Waveform viewing (simulation)          |

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

## 📂 File Structure

```
riscv-single-cycle-processor/
│
├── src/                  # RTL Modules
│   ├── top.v
│   ├── alu.v
│   ├── regfile.v
│   ├── control_unit.v
│   ├── datapath.v
│   ├── pc.v
│   ├── imm_gen.v
│   └── branch_comp.v
│
├── tb/                   # Testbench
│   ├── tb_top.v
│   └── program.mem       # Instruction memory init
│
├── bram_init/            # For Vivado BRAM init
│   └── program.mem
│
├── vivado_project/       # Optional Vivado project
│
├── images/               # Diagrams and screenshots
│   ├── block_diagram.png
│   └── ila_waveform.png
│
└── README.md             # You're here!
```

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

1. Synthesize and implement `top.v`.
2. Connect the `program.mem` to BRAM using Vivado's BRAM Generator.
3. Assign the reset to a **Basys 3 push button (e.g., btnC)**.
4. Connect ILA to signals like `PC`, `ALU result`, and `RegFile outputs`.
5. Generate bitstream and program the FPGA.

*(Insert ila\_waveform.png here)*

---

## 🧑‍💻 Author

**Yaswanth Sai Kotyada**
B.Tech in Electrical Engineering, NIT Rourkela
Samsung–IISc ISWDP Grade 2 Fellow | GATE 2026 Aspirant
🔗 [LinkedIn](#) • 🔗 [GitHub](#) • 📧 [yaswanth@email.com](mailto:yaswanth@email.com)

---

## 📎 License

This project is open-source and available under the MIT License.

---

## 📌 Related Projects

* 🔁 [RISC-V 5-Stage Pipelined Processor (in progress)](https://github.com/yourusername/riscv-5stage)
* 🔁 [Asynchronous FIFO](https://github.com/yourusername/async-fifo)
* 💡 [Verilog Design Library](https://github.com/yourusername/verilog-design-library)
