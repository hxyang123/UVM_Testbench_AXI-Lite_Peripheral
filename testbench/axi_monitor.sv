//===========================================
// axi_monitor.sv
//===========================================

// Observes bus activity and sends data to scoreboard

`ifndef AXI_MONITOR_SV
`define AXI_MONITOR_SV

class axi_monitor extends uvm_monitor;
    virtual axi_lite_interface v_if;
    uvm_analysis_port #(axi_transaction) ap;
    
    `uvm_component_utils(axi_monitor)

    function new(string name = "axi_monitor", uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // get virtual interface from configuration DB
        if(!uvm_config_db#(virtual axi_lite_interface)::get(this, "", "v_if", v_if))
            `uvm_fatal("NO_VIF", "virtual interface must be set")
    endfunction

    // monitors the AXI channels and sends observed transactions
    task run_phase(uvm_phase phase);
        forever begin
            @(posedge v_if.A_CLK);
            if(v_if.B_VALID && v_if.B_READY) begin
                axi_transaction tr = new();
                tr.write = 1;
                tr.addr = v_if.AW_ADDR;
                tr.data = v_if.W_DATA;
                tr.w_strb = v_if.W_STRB;
                ap.write(tr);
            end
            if (v_if.R_VALID && v_if.R_READY) begin
                axi_transaction tr = new();
                tr.write = 0;
                tr.addr = v_if.AR_ADDR;
                tr.data = v_if.R_DATA;
                ap.write(tr);
            end
        end
    endtask
endclass

`endif