//===========================================
// axi_env.sv
//===========================================

// Environment that includes agent and scoreboard

`ifndef AXI_ENV_SV
`define AXI_ENV_SV

class axi_env extends uvm_env;
    axi_agent agent;
    axi_scoreboard sb;

    `uvm_component_utils(axi_env)

    function new(string name = "axi_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = axi_agent::type_id::create("agent", this);
        sb    = axi_scoreboard::type_id::create("sb", this);
    endfunction

    function void connet_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.mon.ap.connect(sb.analysis_export);
    endfunction
endclass

`endif