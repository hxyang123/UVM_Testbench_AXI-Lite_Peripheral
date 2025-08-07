//===========================================
// axi_transaction.sv
//===========================================

// Defines the read/write transaction

`ifndef AXI_TRANSACTION_SV
`define AXI_TRANSACTION_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_transaction extends uvm_sequence_item;
    rand bit [31:0] addr; // Address to read/write
    rand bit [31:0] data; // Data to write or read back
    rand bit        write; // 1 = write, 0 = read
    rand bit [3:0]  w_strb; // Byte enables for write strobe

    constraint legal_addr_range{
        addr inside {[32'h00000000 : 32'h0000000F]}; // Constraint of 4 registers
    }

    constraint legal_strobe {
        w_strb inside {4'b0001, 4'b0011, 4'b0111, 4'b1111}; // Allow 1B, 2B, 3B or full word writes
    }

    `uvm_object_utils(axi_transaction)

    function new(string name = "axi_transaction");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("addr", addr, 32);
        printer.print_field("data", data, 32);
        printer.print_field("write", write, 1);
        printer.print_field("w_strb", w_strb, 4);
    endfunction
endclass

`endif