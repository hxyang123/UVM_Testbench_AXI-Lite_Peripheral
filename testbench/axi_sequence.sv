//===========================================
// axi_sequence.sv
//===========================================

// Sequence to generate constrained-random AXI read/write traffic

`ifndef AXI_SEQUENCE_SV
`define AXI_SEQUENCE_SV

class axi_sequence extends uvm_sequence #(axi_transaction);
    `uvm_object_utils(axi_sequence)

    function new(string name = "axi_sequence");
        super.new(name);
    endfunction

    task body();
        axi_transaction tr;
        for (int i = 0; i<10; i++) begin
            tr = axi_transaction::type_id::create("tr");
            assert(tr.randomize() with {
                write inside {0, 1}; // random read/write
            });
            start_item(tr);
            finish_item(tr);
        end

        // Edge case: out-of-bound address
        tr = axi_transaction::type_id::create("edge_tr");
        tr.addr = 32'hFFFFFFFF;
        tr.data = 32'hBADADD4;
        tr.write = 1;
        tr.w_strb = 4'b1111;
        start_item(tr);
        finish_item(tr);
    endtask
endclass

`endif
