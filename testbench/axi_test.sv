//===========================================
// axi_test.sv
//===========================================

// top-level UVM test that runs the sequence

`ifndef AXI_TEST_SV
`define AXI_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "axi_sequence.sv"
`include "axi_env.sv"

class axi_test extends uvm_test;
    axi_env env;

    `uvm_component_utils(axi_test)

    function new(string name = "axi_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi_env::type_id::create("env", this);
        `uvm_info(get_type_name(), "Testbench environment built.", UVM_LOW)
    endfunction

    task run_phase(uvm_phase phase);
	axi_sequence seq;
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "Starting AXI sequence", UVM_LOW)

        // Enable global verbosity level
        uvm_top.set_report_verbosity_level_hier(UVM_HIGH);

        // run sequence
        seq = axi_sequence::type_id::create("seq");
        if (!seq.randomize()) begin
            `uvm_fatal(get_type_name(), "Sequence randomization failed!")
        end
        seq.start(env.agent.seqr);

        `uvm_info(get_type_name(), "Completed AXI sequence", UVM_LOW)
        phase.drop_objection(this);
    endtask
endclass

`endif 