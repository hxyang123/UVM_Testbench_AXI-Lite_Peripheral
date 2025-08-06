//===========================================
// axi_transaction.sv
//===========================================

// Defines the read/write transaction

`ifndef AXI_TRANSACTION_SV
`define AXI_TRANSCATION_SV

class axi_transaction extends uvm_sequence_item;
    rand bit [31:0] addr; // Address to read/write
    rand bit [31:0] data; // Data to write or read back
    rand bit        write; // 1 = write, 0 = read
    rand bit [3:0]  w_strb; // Byte enables for write strobe

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