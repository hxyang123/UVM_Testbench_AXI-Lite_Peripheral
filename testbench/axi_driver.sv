//===========================================
// axi_driver.sv
//===========================================

// Drives interface signals based on transaction

`ifndef AXI_DRIVER_SV
`define AXI_DRIVER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "axi_transaction.sv"

class axi_driver extends uvm_driver #(axi_transaction);
    virtual axi_lite_interface v_if;

    `uvm_component_utils(axi_driver)

    function new(string name = "axi_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // get virtual interface from configuration DB
        if(!uvm_config_db#(virtual axi_lite_interface)::get(this, "", "v_if", v_if))
            `uvm_fatal("NO_VIF", "virtual interface must be set");
    endfunction

    // Main run loop: gets transaction and performs drive
    task run_phase(uvm_phase phase);
        axi_transaction tr;
        forever begin
            seq_item_port.get_next_item(tr);
            drive(tr);
            seq_item_port.item_done();
        end
    endtask

    // Drives the transaction onto the AXI bus
    task drive(axi_transaction tr);
        @(posedge v_if.A_CLK);
        if (tr.write) begin
            // write address
            v_if.AW_ADDR <= tr.addr;
            v_if.AW_VALID <= 1;
            wait(v_if.AW_READY);
            v_if.AW_VALID <= 0;

            // write data
            v_if.W_DATA <= tr.data;
            v_if.W_STRB <= tr.w_strb;
            v_if.W_VALID <= 1;
            wait(v_if.W_READY);
            v_if.W_VALID <= 0;

            // write response
            wait(v_if.B_VALID);
            v_if.B_READY <= 1;
            @(posedge v_if.A_CLK);
            v_if.B_READY <= 0;
        end else begin
            // read address
            v_if.AR_ADDR <= tr.addr;
            v_if.AR_VALID <= 1;
            wait(v_if.AR_READY);
            v_if.AR_VALID <= 0;

            // read response
            wait(v_if.R_VALID);
            v_if.R_READY <= 1;
            @(posedge v_if.A_CLK);
            v_if.R_READY <= 0;
        end
    endtask
endclass

`endif