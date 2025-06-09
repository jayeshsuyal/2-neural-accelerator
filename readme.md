# UVM-Based Verification of a 2-Layer Neural Inference Accelerator (Ongoing)

##  Overview

This project implements a UVM-based functional verification environment for a fixed-point RTL design of a simple 2-layer neural inference accelerator using hardcoded weights, MAC (Multiply-Accumulate) units, and ReLU activation. The goal is to validate the correctness of the inference pipeline for basic matrix-vector operations.

## 🔧 Design Summary

- **Inputs**: 4 signed 8-bit neurons
- **Hidden Layer**: 4 neurons, ReLU activation
- **Output Layer**: 2 neurons, linear (no activation)
- **Weights/Biases**: Hardcoded (configurable for test extension)
- **Precision**: Fixed-point (8-bit input, 16-bit output)

---

##  Verification Strategy

- **UVM Testbench Components**:
  - `neural_txn`: Transaction with randomized inputs and expected/actual outputs
  - `neural_seq`: Base, zero, and edge-case sequences
  - `neural_drv`: Modular driver to drive inputs and capture outputs
  - `neural_mon`: Passive monitor to observe DUT responses
  - `neural_sb`: Scoreboard comparing DUT vs reference outputs
  - `neural_cov`: Functional coverage on input ranges and output activations
  - `neural_env` and `neural_test`: Top-level environment and test instantiation

- **Assertions**:
  - Protocol checks: `input_valid` pulsing, `output_valid` timing
  - Added inside the interface using SystemVerilog Assertions (SVA)

- **Golden Reference Model**:
  - Built using NumPy for matrix-vector and ReLU computation
  - Used in scoreboard to validate functional correctness

---

## Features Completed

- [x] RTL implementation of 2-layer neural block
- [x] Transaction, sequences, and UVM driver
- [x] Assertion-based protocol checking
- [x] Output capture and comparison framework
- [ ] Scoreboard with NumPy golden model (in progress)
- [ ] Python-based regression test driver for multiple test scenarios
- [ ] Functional coverage (in progress)
- [ ] Monitor integration

---

## 🚀 How to Run

Simulation is supported using **Synopsys VCS** or **any simulator with UVM support**.

```bash
vcs -full64 -sverilog +acc +vpi +vcs+lic+wait -ntb_opts uvm -debug_all \
    rtl/neural_net_2layer.sv \
    tb/neural_if.sv tb/neural_txn.sv tb/neural_seq.sv \
    tb/neural_drv.sv tb/neural_mon.sv tb/neural_sb.sv \
    tb/neural_env.sv tb/neural_test.sv \
    -l sim.log

./simv
