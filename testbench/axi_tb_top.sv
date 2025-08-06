//===========================================
// axi_tb_top.sv
//===========================================

// Testbench top: instantiates DUT, interface, and connects to UVM

`ifndef AXI_TB_TOP_SV
`define AXI_TB_TOP_SV

module axi_tb_top;
    bit A_CLK;
    bit A_RESET_n;

    // clock generation
    initial A_CLK = 0;
    always #5 A_CLK = ~A_CLK;

    initial begin
        A_RESET_n = 0;
        #20;
        A_RESET_n = 1;
    end

    // Instantiate interface
    axi_lite_interface axi_if();
    assign axi_if.A_CLK = A_CLK;
    assign axi_if.A_RESET_n = A_RESET_n;

    // Instantiate DUT (connect to interface)
    axi_lite_slave dut (
        .A_CLK (axi_if.A_CLK),
        .A_RESET_n (axi_if.A_RESET_n),
        .AW_ADDR (axi_if.AW_ADDR),
        .AW_VALID (axi_if.AW_VALID),
        .AW_READY (axi_if.AW_READY),
        .W_DATA (axi_if.W_DATA),
        .W_STRB (axi_if.W_STRB),
        .W_VALID (axi_if.W_VALID),
        .W_READY (axi_if.W_READY),
        .B_RESP (axi_if.B_RESP),
        .B_VALID (axi_if.B_VALID),
        .B_READY (axi_if.B_READY),
        .AR_ADDR (axi_if.AR_ADDR),
        .AR_VALID (axi_if.AR_VALID),
        .AR_READY (axi_if.AR_READY),
        .R_DATA (axi_if.R_DATA),
        .R_RESP (axi_if.R_RESP),
        .R_VALID (axi_if.R_VALID),
        .R_READY (axi_if.R_READY)
    );

    // start uvm
    initial begin
        uvm_config_db#(virtual axi_lite_interface)::set(null, "*", "v_if", axi_if);
        run_test("axi_test");
    end
endmodule

`endif