// Interface definition for AXI-Lite
// Contains 4 32-bit registers at fixed addresses (0x00, 0x04, 0x08, 0x0C)
// Supports read and write transactions
// Returns (2'b00) for OKAY and (2'b10) for SLV_ERR
// Performs basic address decoding
// Implements valid/ready handshakes

interface axi_lite_interface #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) ();

    // Write Address Channel
    logic [ADDR_WIDTH-1:0] AW_ADDR;
    logic                  AW_VALID;
    logic                  AW_READY;

    // Write Data Channel
    logic [DATA_WIDTH-1:0] W_DATA;
    logic [DATA_WIDTH/8-1:0] W_STRB; // Write Stroke to selectively write certain bytes
    logic                  W_VALID;
    logic                  W_READY;

    // Write Response Channel
    logic [1:0] B_RESP; 
    logic       B_VALID;
    logic       B_READY;

    // Read Address Channel
    logic [ADDR_WIDTH-1:0] AR_ADDR;
    logic                  AR_VALID;
    logic                  AR_READY;

    // Read Data Channel
    logic [DATA_WIDTH-1:0] R_DATA;
    logic [1:0]            R_RESP;
    logic                  R_VALID;
    logic                  R_READY;

    // Clock and reset
    logic A_CLK;
    logic A_RESET_n;

    modport DUT (input A_CLK, A_RESET_n,
                 input AW_ADDR, AW_VALID, W_DATA, W_STRB, W_VALID, B_READY, AR_ADDR, AR_VALID, R_READY,
                 output AW_READY, W_READY, B_RESP, B_VALID, AR_READY, R_DATA, R_RESP, R_VALID);

endinterface