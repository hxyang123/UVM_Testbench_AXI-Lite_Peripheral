# UVM_Testbench_AXI-Lite_Peripheral
This project implements a Universal Verification Methodology testbench for verifying a simple AXI-Lite slave module.
The restbench supports:
  - AXI-Lite protocol compliance
  - Constrained-random transaction generation
  - Function coverage
  - SystemVerilog Assertions
  - Simulation and coverage reporting

---

## 🧱 DUT: AXI-Lite Slave
The DUT (`axi_lite_slave.v`) implements a basic AXI-Lite slave with 4 readable/writable 32-bit registers. It includes:
- Basic address decoding
- `OKAY` and `ERROR` response logic

---

## 🧪 UVM Testbench Structure

```text
                   +----------------------+
                   |     axi_test.sv      |
                   |  (defines scenario)  |
                   +----------------------+
                             |
                             v
                   +----------------------+
                   |      axi_env.sv      |
                   |  (agent + scoreboard)|
                   +----------------------+
                    /                 \
                   v                   v
        +------------------+   +---------------------+
        |    axi_agent.sv  |   |  axi_scoreboard.sv  |
        | driver+monitor+  |   |  Compares expected  |
        | sequencer        |   |  vs actual response |
        +------------------+   +---------------------+
```

---

## 🔁 Simulation Flow

### 1. **Build & Run**
Use the provided `Makefile`:
```bash
make            # compile + run + coverage
make compile    # only compile
make run        # only run
make coverage   # generate HTML report
```

### 2. **Functional Coverage**
- Tracked in `axi_monitor.sv`
- Covers:
  - Accessed addresses
  - Read vs write
  - Response codes

### 3. **Assertions**
Located in `axi_lite_if.sv` or testbench:
- Address must be valid before ready
- Response must arrive within 5 cycles

---

## 📁 Key Files
| File | Description |
|------|-------------|
| `axi_lite_slave.v` | DUT (Device Under Test) |
| `axi_lite_if.sv`   | Interface with SVA hooks |
| `axi_transaction.sv` | Sequence item definition |
| `axi_driver.sv`    | Drives DUT pins via interface |
| `axi_monitor.sv`   | Observes and collects transactions |
| `axi_scoreboard.sv`| Compares results |
| `axi_sequence.sv`  | Random and edge-case sequences |
| `axi_env.sv`       | Assembles agent + scoreboard |
| `axi_test.sv`      | Starts sequence and drives test |
| `axi_tb_top.sv`    | Top-level module for simulation |

---

## 📊 Output
- `coverage.ucdb`: Functional coverage file
- `covhtmlreport/`: HTML report with coverage bins and assertion hits

---

## ✅ To Do / Expand
- Add burst/illegal access sequences
- Integrate error injection for robustness
- Add memory-mapped scoreboard for data checking
- Hook into a real AXI4-Lite compliant DUT

---
