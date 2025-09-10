# 🔧 BMU Verification Environment

<div align="center">

![RISC-V](https://img.shields.io/badge/RISC--V-BitManip-blue?style=for-the-badge&logo=riscv)
![UVM](https://img.shields.io/badge/UVM-Verification-green?style=for-the-badge)
![SystemVerilog](https://img.shields.io/badge/SystemVerilog-RTL-orange?style=for-the-badge)
![Coverage](https://img.shields.io/badge/Coverage-Functional-red?style=for-the-badge)

**A UVM-based verification environment for the RISC-V Bit Manipulation Unit (BMU)**

</div>

---

## 📋 Table of Contents

- [🎯 Overview](#-overview)
- [✨ Features](#-features)
- [🏗️ BMU Architecture](#️-bmu-architecture)
- [🧪 Verification Environment](#-verification-environment)
- [📁 Directory Structure](#-directory-structure)
- [🚀 Quick Start](#-quick-start)
- [🔍 Verified Instruction Set](#-verified-instruction-set-16-instructions)
- [📊 Coverage Model](#-coverage-model)
- [🛠️ Usage](#️-usage)
- [📈 Results](#-results)

---

## 🎯 Overview

The **Bit Manipulation Unit (BMU)** is a synthesizable RTL block that implements bit manipulation functionality compliant with the **RISC-V BitManip extension**. This verification environment provides comprehensive testing for all supported instruction subsets and ensures robust functionality across various operational scenarios.

---

## ✨ Features

### 🔢 Currently Verified RISC-V BitManip Instructions (16 Total)

| Extension | Instructions | Status | Description |
|-----------|-------------|--------|-------------|
| **Zbb** | CLZ, CPOP, MIN, SEXT.H, AND/ANDN, XOR/XORN | ✅ Verified | Basic bit manipulation operations |
| **Zbs** | BEXT | ✅ Verified | Single bit operations |
| **Zbp** | ROL, PACKU, GORC | ✅ Verified | Bit permutation operations |
| **Zba** | SH3ADD | ✅ Verified | Address generation operations |
| **Basic** | ADD, SLL, SRA, SLT/SLTU | ✅ Verified | Core arithmetic and logical operations |

### 📊 Verified Instruction Details

| Instruction | Extension | Control Signals |
|-------------|-----------|----------------|
| **ADD** | Basic | `ap.add` |
| **CLZ** | Zbb | `ap.clz` |
| **CPOP** | Zbb | `ap.cpop` |
| **MIN** | Zbb | `ap.min + ap.sub` |
| **SEXT.H** | Zbb | `ap.siext_h` |
| **AND** | Basic | `ap.land` |
| **ANDN** | Zbb | `ap.land + ap.zbb` |
| **XOR** | Basic | `ap.lxor` |
| **XORN** | Zbb | `ap.lxor + ap.zbb` |
| **SLL** | Basic | `ap.sll` |
| **SRA** | Basic | `ap.sra` |
| **SLT** | Basic | `ap.slt + ap.sub` |
| **SLTU** | Basic | `ap.slt + ap.sub + ap.unsign` |
| **BEXT** | Zbs | `ap.bext` |
| **ROL** | Zbp | `ap.rol` |
| **PACKU** | Zbp | `ap.packu` |
| **GORC** | Zbp | `ap.gorc` |
| **SH3ADD** | Zba | `ap.sh3add + ap.zba` |



---

## 🏗️ BMU Architecture

### 📋 Interface Definition

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| `clk` | Input | 1 bit | System clock |
| `rst_l` | Input | 1 bit | Active-low synchronous reset |
| `scan_mode` | Input | 1 bit | Scan test mode control |
| `valid_in` | Input | 1 bit | Instruction valid flag |
| `ap` | Input | Struct | Decoded instruction control signals |
| `csr_ren_in` | Input | 1 bit | CSR read-enable |
| `csr_rddata_in` | Input | 32 bits | CSR read data |
| `a_in`, `b_in` | Input | 32 bits | Input operands A and B |
| `result_ff` | Output | 32 bits | Final computed result |
| `error` | Output | 1 bit | Error indicator |

### 🧩 Functional Submodules

- **➕ Arithmetic Unit**: ADD, SUB, SHxADD operations
- **🔄 Shift Logic**: SLL, SRL, SRA, ROL, ROR operations  
- **🔢 Count Logic**: CLZ, CTZ, CPOP implementations
- **📏 Extension Logic**: SEXT.B, SEXT.H sign extension
- **⚖️ Compare Logic**: MIN, MAX signed/unsigned comparison
- **🔀 Pack Logic**: PACK, PACKU, PACKH data combination
- **🎭 Bit Logic**: BSET, BCLR, BINV, BEXT operations

---

## 🧪 Verification Environment

This comprehensive UVM-based verification environment ensures thorough validation of the BMU design through:

### 🎯 Verification Components

- **🖥️ Environment**: Complete UVM environment with all necessary components
- **🤖 Agent**: Modular agent architecture for stimulus generation and monitoring
- **🚗 Driver**: Intelligent driver for transaction execution
- **👀 Monitor**: Comprehensive monitoring and protocol checking
- **📊 Scoreboard**: Advanced result checking and comparison
- **📝 Sequences**: Targeted and random test sequences
- **✅ Tests**: Comprehensive test suite covering all scenarios

### 🎪 Test Categories

- **🔧 Instruction-Specific Tests**: Individual instruction validation
- **🎲 Random Tests**: Pseudo-random stimulus generation  
- **⚠️ Error Tests**: Error condition validation
- **🔄 Regression Tests**: Complete test suite execution

---

## 📁 Directory Structure

```text
BMU-Verification/
├── 📄 README.md                    # This comprehensive documentation
├── 🔧 Makefile                     # Build and simulation scripts
├── 📊 .gitignore                   # Git ignore patterns
│
├── 🧩 components/                  # Core verification components
│   ├── bmu_interface.sv            # BMU interface definition
│   ├── bmu_pkg.sv                  # UVM package declarations
│   ├── bmu_sequence_item.sv        # Transaction/sequence item
│   ├── bmu_tb.sv                   # Top-level testbench
│   ├── BMU.sv                      # BMU design wrapper
│   └── env/                        # UVM Environment Components
│       ├── bmu_agent.sv            # UVM agent for BMU interface
│       ├── bmu_driver.sv           # Driver for stimulus generation
│       ├── bmu_environment.sv      # Top-level UVM environment
│       ├── bmu_monitor.sv          # Monitor for signal observation
│       ├── bmu_scoreboard.sv       # Result checking and comparison
│       ├── bmu_sequencer.sv        # Sequence coordination
│       └── bmu_subscriber.sv       # Coverage and analysis subscriber
│
├── 🎯 dut_rm/                      # Design Under Test Reference Model
│   └── bmu_reference_model.sv      # Golden reference implementation
│
├── 🏗️ rtl/                         # RTL Design Files
│   ├── Bit_Manibulation_Unit.sv    # Main BMU RTL implementation
│   ├── bmu_design.sv               # Design wrapper
│   ├── rtl_def.sv                  # RTL definitions
│   ├── rtl_defines.sv              # RTL macros and defines
│   ├── rtl_lib.sv                  # RTL library components
│   ├── rtl_param.vh                # RTL parameters
│   └── rtl_pdef.sv                 # RTL package definitions
│
├── 🎪 sequences/                   # UVM Test Sequences
│   ├── bmu_add_sequence.sv         # Addition operation sequence
│   ├── bmu_and_sequence.sv         # Logical AND sequence
│   ├── bmu_bext_sequence.sv        # Bit extract sequence
│   ├── bmu_clz_sequence.sv         # Count leading zeros sequence
│   ├── bmu_cpop_sequence.sv        # Population count sequence
│   ├── bmu_csr_write_sequence.sv   # CSR write sequence
│   ├── bmu_errors_sequence.sv      # Error condition sequence
│   ├── bmu_gorc_sequence.sv        # Generalized OR-combine sequence
│   ├── bmu_min_sequence.sv         # Minimum operation sequence
│   ├── bmu_packu_sequence.sv       # Pack upper sequence
│   ├── bmu_reset_sequence.sv       # Reset sequence
│   ├── bmu_rol_sequence.sv         # Rotate left sequence
│   ├── bmu_sh3add_sequence.sv      # Shift-add sequence
│   ├── bmu_siext_h_sequence.sv     # Sign extend halfword sequence
│   ├── bmu_sll_sequence.sv         # Shift left logical sequence
│   ├── bmu_slt_sequence.sv         # Set less than sequence
│   ├── bmu_sra_sequence.sv         # Shift right arithmetic sequence
│   ├── bmu_valid_in_sequence.sv    # Valid input sequence
│   └── bmu_xor_sequence.sv         # Logical XOR sequence
│
└── ✅ tests/                       # UVM Test Cases
    ├── bmu_add_test.sv             # Addition operation test
    ├── bmu_and_test.sv             # Logical AND test
    ├── bmu_bext_test.sv            # Bit extract test
    ├── bmu_clz_test.sv             # Count leading zeros test
    ├── bmu_cpop_test.sv            # Population count test
    ├── bmu_csr_write_test.sv       # CSR write test
    ├── bmu_errors_test.sv          # Error condition test
    ├── bmu_gorc_test.sv            # Generalized OR-combine test
    ├── bmu_min_test.sv             # Minimum operation test
    ├── bmu_packu_test.sv           # Pack upper test
    ├── bmu_regression_test.sv      # Complete regression test
    ├── bmu_rol_test.sv             # Rotate left test
    ├── bmu_sh3add_test.sv          # Shift-add test
    ├── bmu_siext_h_test.sv         # Sign extend halfword test
    ├── bmu_sll_test.sv             # Shift left logical test
    ├── bmu_slt_test.sv             # Set less than test
    ├── bmu_sra_test.sv             # Shift right arithmetic test
    ├── bmu_valid_in_test.sv        # Valid input test
    └── bmu_xor_test.sv             # Logical XOR test
```

---

## 🚀 Quick Start

### 📋 Prerequisites

- **Cadence Xcelium** or compatible SystemVerilog simulator
- **UVM 1.2** or later
- **Make** utility for build automation

### ⚡ Running Simulations

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd BMU-Verification
   ```

2. **Run regression test** (Recommended for first-time users)

   ```bash
   make all
   ```

3. **Run specific test**

   ```bash
   make TEST_NAME=bmu_add_test run_sim
   ```

4. **Run with different verbosity**

   ```bash
   make TEST_NAME=bmu_clz_test VERBOSITY=UVM_HIGH run_sim
   ```

5. **Clean build artifacts**

   ```bash
   make clean
   ```

### 🎛️ Available Make Targets

| Target | Description |
|--------|-------------|
| `all` | Clean and run regression test |
| `run_sim` | Run simulation with specified test |
| `test` | Run default test from testbench |
| `wave` | Open Verisium GUI |
| `imc` | Open IMC GUI |   
| `clean` | Remove simulation artifacts |

---

## 🔍 Verified Instruction Set (16 Instructions)

### 🟦 Zbb - Basic Bit Manipulation (6 Instructions)

| Instruction | Status | Description | Test Coverage |
|-------------|--------|-------------|---------------|
| **CLZ** | ✅ Verified | Count Leading Zeros - counts zeros from MSB before first '1' | Complete |
| **CPOP** | ✅ Verified | Count Population - counts total number of '1' bits | Complete |
| **MIN** | ✅ Verified | Minimum - returns smaller of two signed integers | Complete |
| **SEXT.H** | ✅ Verified | Sign Extend Halfword - extends sign bit from bit 15 | Complete |
| **ANDN** | ✅ Verified | AND with Negation - performs `a & (~b)` | Complete |
| **XORN** | ✅ Verified | Exclusive NOR - performs `(a ^ ~b)` | Complete |

### 🟩 Zbs - Single Bit Operations (1 Instruction)

| Instruction | Status | Description | Test Coverage |
|-------------|--------|-------------|---------------|
| **BEXT** | ✅ Verified | Bit Extract - copies specific bit to LSB, clears others | Complete |

### 🟨 Zbp - Bit Permutation (3 Instructions)

| Instruction | Status | Description | Test Coverage |
|-------------|--------|-------------|---------------|
| **ROL** | ✅ Verified | Rotate Left - rotates bits left, MSB wraps to LSB | Complete |
| **PACKU** | ✅ Verified | Pack Upper Halves - combines upper halves from two registers | Complete |
| **GORC** | ✅ Verified | Generalized OR-Combine - sets all bits in byte to '1' if any bit was '1' | Complete |

### 🟪 Zba - Address Generation (1 Instruction)

| Instruction | Status | Description | Test Coverage |
|-------------|--------|-------------|---------------|
| **SH3ADD** | ✅ Verified | Shift-Add 3 - performs `(a << 3) + b` | Complete |

### 🔧 Basic Operations (5 Instructions)

| Instruction | Status | Description | Test Coverage |
|-------------|--------|-------------|---------------|
| **ADD** | ✅ Verified | Addition - performs `a + b` | Complete |
| **AND** | ✅ Verified | Logical AND - performs `a & b` | Complete |
| **XOR** | ✅ Verified | Logical XOR - performs `a ^ b` | Complete |
| **SLL** | ✅ Verified | Shift Left Logical - shifts left by specified amount | Complete |
| **SRA** | ✅ Verified | Shift Right Arithmetic - arithmetic right shift | Complete |
| **SLT** | ✅ Verified | Set Less Than - signed comparison `a < b` | Complete |
| **SLTU** | ✅ Verified | Set Less Than Unsigned - unsigned comparison `a < b` | Complete |

### 📊 Summary: 16 Verified Instructions

- **Zbb Extension**: 6 instructions (CLZ, CPOP, MIN, SEXT.H, ANDN, XNOR)
- **Zbs Extension**: 1 instruction (BEXT)
- **Zbp Extension**: 3 instructions (ROL, PACKU, GORC)
- **Zba Extension**: 1 instruction (SH3ADD)
- **Basic Operations**: 5 instructions (ADD, AND, XOR, SLL, SRA, SLT, SLTU)

---

## 📊 Coverage Model

### 🎯 Functional Coverage Areas

- **✅ Instruction Coverage**: All supported instructions exercised
- **📊 Operand Coverage**: Various operand combinations and edge cases
- **🔄 State Coverage**: All internal FSM states and transitions
- **⚠️ Error Coverage**: All error conditions and recovery scenarios
- **🎪 Cross Coverage**: Instruction × operand × state combinations

---

## 🛠️ Usage

### 🎮 Running Individual Tests

Each instruction has dedicated test sequences and test cases:

```bash
# Test Zbb Extension Instructions
make TEST_NAME=bmu_clz_test run_sim        # Count leading zeros
make TEST_NAME=bmu_cpop_test run_sim       # Population count
make TEST_NAME=bmu_min_test run_sim        # Minimum operation
make TEST_NAME=bmu_siext_h_test run_sim    # Sign extend halfword
make TEST_NAME=bmu_and_test run_sim        # AND/ANDN operations
make TEST_NAME=bmu_xor_test run_sim        # XOR/XNOR operations

# Test Zbs Extension Instructions
make TEST_NAME=bmu_bext_test run_sim       # Bit extract

# Test Zbp Extension Instructions
make TEST_NAME=bmu_rol_test run_sim        # Rotate left
make TEST_NAME=bmu_packu_test run_sim      # Pack upper halves
make TEST_NAME=bmu_gorc_test run_sim       # Generalized OR-combine

# Test Zba Extension Instructions
make TEST_NAME=bmu_sh3add_test run_sim     # Shift-add-3

# Test Basic Operations
make TEST_NAME=bmu_add_test run_sim        # Addition
make TEST_NAME=bmu_sll_test run_sim        # Shift left logical
make TEST_NAME=bmu_sra_test run_sim        # Shift right arithmetic
make TEST_NAME=bmu_slt_test run_sim        # Set less than
```
### 🎛️ Running Full Regression
To execute the complete regression suite covering all instructions and scenarios:

```bash
make all
``` 

---

## 📈 Results

Coming soon: Detailed coverage reports and performance metrics.

### 🚀 Future Expansion Opportunities

- Additional Zbb instructions (CTZ, MAX, SEXT.B, ORN)
- Remaining Zbs instructions (BSET, BCLR, BINV)
- Additional Zbp instructions (ROR, PACK, PACKH, GREV)
- Additional Zba instructions (SH1ADD, SH2ADD)

---



![Made with SystemVerilog](https://img.shields.io/badge/Made%20with-SystemVerilog-blue)
![UVM Methodology](https://img.shields.io/badge/UVM-Methodology-green)
![RISC-V Compatible](https://img.shields.io/badge/RISC--V-Compatible-orange)
