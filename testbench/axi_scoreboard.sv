//===========================================
// axi_scoreboard.sv
//===========================================

// Scoreboard to check DUT output vs expected behavior

`ifndef AXI_SCOREBOARD_SV
`define AXI_SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "axi_transaction.sv"

class axi_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(axi_transaction, axi_scoreboard) analysis_export;

    `uvm_component_utils(axi_scoreboard)

    function new(string name = "axi_scoreboard", uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    // called for each transaction observed by the monitor
    function void write(axi_transaction tr);
        `uvm_info("SCOREBOARD", $sformatf("Received: addr=0x%08x data=0x%08x write=%0b",
                    tr.addr, tr.data, tr.write), UVM_MEDIUM);
    endfunction
endclass

`endif