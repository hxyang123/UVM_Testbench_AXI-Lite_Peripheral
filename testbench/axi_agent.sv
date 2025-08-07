//===========================================
// axi_agent.sv
//===========================================

// Combines driver, monitor, sequencer

`ifndef  AXI_AGENT_SV
`define AXI_AGENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "axi_driver.sv"
`include "axi_monitor.sv"
`include "axi_sequencer.sv"

class axi_agent extends uvm_agent;
    axi_driver drv;
    axi_monitor mon;
    axi_sequencer seqr;

    `uvm_component_utils(axi_agent)

    function new(string name = "axi_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = axi_driver::type_id::create("drv", this);
        mon = axi_driver::type_id::create("mon", this);
        seqr = axi_driver::type_id::create("seqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass

`endif
