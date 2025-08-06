// Axi Lite Slave

// Contains 4 32-bit registers at fixed addresses (0x00, 0x04, 0x08, 0x0C)
// Supports read and write transactions
// Returns (2'b00) for OKAY and (2'b10) for SLV_ERR
// Performs basic address decoding
// Implements valid/ready handshakes

module axi_lite_slave #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    // Write Address Channel
    input wire [ADDR_WIDTH-1:0] AW_ADDR,
    input wire                  AW_VALID,
    output reg                  AW_READY,

    // Write Data Channel
    input wire [DATA_WIDTH-1:0] W_DATA,
    input wire [DATA_WIDTH/8-1:0] W_STRB, // Write Stroke to selectively write certain bytes
    input wire                  W_VALID,
    output reg                  W_READY,

    // Write Response Channel
    output reg [1:0] B_RESP,
    output reg       B_VALID,
    input wire       B_READY,

    // Read Address Channel
    input wire [ADDR_WIDTH-1:0] AR_ADDR,
    input wire                  AR_VALID,
    output reg                  AR_READY,

    // Read Data Channel
    output reg [DATA_WIDTH-1:0] R_DATA,
    output reg [1:0]            R_RESP,
    output reg                  R_VALID,
    input wire                  R_READY,

    // Clock and reset
    input wire A_CLK,
    input wire A_RESET_n, 
);

    // 4 internal 32-bit registers
    reg [ADDR_WIDTH-1:0] reg_file [0:3];

    wire [1:0] addr_idx;
    assign addr_idx = (AW_VALID) ? AW_ADDR[3:2] : AR_ADDR[3:2];

    // Write logic
    always @(posedge A_CLK) begin
        if (!A_RESET_n) begin // reset
            AW_READY <= 0; W_READY <= 0; B_VALID <=; B_RESP <= 2'b00;
        end else begin
            AW_READY <= (!AW_READY && AW_VALID) ? 1'b1 : 1'b0;
            W_READY <= (!W_READY && W_VALID) ? 1'b1 : 1'b0;

            if (AW_READY && AW_VALID && W_READY && W_VALID) begin
                // if write addr is valid
                if (AW_ADDR[5:2] < 4) begin
                    if (W_STRB[0]) reg_file[addr_idx][7:0] <= W_DATA[7:0];
                    if (W_STRB[1]) reg_file[addr_idx][15:8] <= W_DATA[15:8];
                    if (W_STRB[2]) reg_file[addr_idx][23:16] <= W_DATA[23:16];
                    if (W_STRB[3]) reg_file[addr_idx][31:24] <= W_DATA[31:24];
                    B_RESP <= 2'b00; // OKAY
                end else begin
                    // addr not recognizable
                    B_RESP <= 2'b10; //SLV_ERR
                end
                B_VALID <= 1'b1;
            end else if (B_VALID && B_READY) begin
                B_VALID <= 1'b0;
            end
        end
    end

    // Read logic
    always @(posedge A_CLK) begin
        if (!A_RESET_n) begin
            AR_READY <= 0; R_VALID <= 0; R_RESP <= 2'b00; R_DATA <= 0;
        end else begin
            AR_READY <= (!AR_READY && AR_VALID) ? 1'b1 : 1'b0;

            if (AR_READY && AR_VALID) begin
                if (AR_ADDR[5:2] < 4) begin
                    R_DATA <= reg_file[addr_idx];
                    R_RESP <= 2'b00; // OKAY
                end else begin
                    R_DATA <= 32'hDEADFEED; // lol
                    R_RESP <= 2'b10; // SLV_ERR
                end
                R_VALID <= 1'b1;
            end else if (R_VALID && R_READY) begin
                R_VALID <= 1'b0;
            end
        end
    end

    // Incorrect behavior to trigger assertions in axi_lite_interface
    always_ff @(posedge A_CLK) begin
        if(!A_RESET_n)
            AW_READY <= 0;
        else
            AW_READY <= 1; // BUG: AW_READY asserted without AW_VALID
    end
    int bresp_delay = 6; // more than the allowed 5
    always_ff @(posedge A_CLK) begin
        if(!A_RESET_n) begin
            bresp_delay <= 6;
            B_VALID <= 0;
        end else if (W_VALID && W_READY) begin
            if (bresp_delay == 0)
                B_VALID <= 1;
            else
                bresp_delay <= bresp_delay - 1
        end
    end
    int rresp_delay = 10; // more than the allowed 5
    always_ff @(posedge A_CLK) begin
        if(!A_RESET_n) begin
            rresp_delay <= 10;
            B_VALID <= 0;
        end else if (AR_VALID && AR_READY) begin
            if (rresp_delay == 0)
                R_VALID <= 1;
            else
                rresp_delay <= rresp_delay - 1
        end
    end


endmodule