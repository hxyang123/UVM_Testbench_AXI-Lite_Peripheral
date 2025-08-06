//===========================================
// axi_test.sv
//===========================================

// top-level UVM test that runs the sequence

`ifndef AXI_TEST_SV
`define AXI_TEST_SV

class axi_test extends uvm_test;
    axi_env env;

    `uvm_component_utils(axi_test)

    function new(string name = "axi_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        axi_transaction tr;
        phase.raise_objection(this);

        // Example test transaction
        tr = axi_transaction::type_id::create("tr");
        tr.addr = 32'h00000004;
        tr.data = 32'hABCD1234;
        tr.write = 1;
        tr.wstrb = 4'b1111;
        env.agent.seqr.start_item(tr);
        env.agent.seqr.finish_item(tr);

        phase.drop_objection(this);
    endtask
endclass

`endif 