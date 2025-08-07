//===========================================
// axi_monitor.sv
//===========================================

// Observes bus activity and sends data to scoreboard

`ifndef AXI_MONITOR_SV
`define AXI_MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "axi_transaction.sv"

class axi_monitor extends uvm_monitor;
    virtual axi_lite_interface v_if;
    uvm_analysis_port #(axi_transaction) ap;

    covergroup cov_axi @(posedge v_if.A_CLK);
        option.per_instance = 1;

        // cover all addresses accessed
        coverpoint v_if.AW_ADDR {
            bins legal_addrs[] = {[32'h00000000 : 32'h0000000F]};
            bins illegal = default;
        }

        // cover read vs write transactions
        coverpoint v_if.AW_VALID ? 1 : (v_if.AR_VALID ? 0 : -1) {
            bins read = {0};
            bins write = {1};
            ignore_bins ignore = {-1};
        }

        // cover response codes
        coverpoint v_if.B_VALID ? v_if.B_RESP : (v_if.R_VALID ? v_if.R_RESP : 2'bxx) {
            bins okay = {2'b00};
            bins error = {2'b10};
        }
    endgroup
    

    cov_axi = new();
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

                cov_axi.sample();
            end
            if (v_if.R_VALID && v_if.R_READY) begin
                axi_transaction tr = new();
                tr.write = 0;
                tr.addr = v_if.AR_ADDR;
                tr.data = v_if.R_DATA;
                ap.write(tr);

                cov_axi.sample();
            end
        end
    endtask
endclass

`endif