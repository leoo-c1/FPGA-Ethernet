import eth_types_pkg::*

module eth_parser #(
    parameter FPGA_MAC = 48'h00_1A_2B_3C_4D_5E, // FPGA's MAC address (theoretical)
    parameter FPGA_IP = 32'hC0_00_02_92,        // FPGA's IP address (theoretical)
    parameter FPGA_PORT = 16'd5005              // FPGA's UDP port (theoretical)
    ) (
    input logic clk,                    // 50MHz LAN8720 clock
    input logic resetn,                 // Reset button (active low)

    input logic [7:0] received_byte,    // The byte of data we have received from the LAN8720
    input logic byte_valid,             // Pulses for one clock cycle on valid byte

    output logic data,                  // The payload data
    output logic data_valid,            // Whether we are currently sending payload data
    output logic data_last              // Pulses on the last byte of our payload data
    );

    eth_states state;                   // The current ethernet state we are in

    logic [15:0] byte_counter = 0;      // Counts the number of bytes we have received

    always_ff @ (posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= IDLE;
            data <= 8'b0;
            data_valid <= 1'b0;
            data_last <= 1'b0;
            byte_counter <= 0;
        end else begin
            if (state == IDLE) begin
                if (byte_valid) begin
                    if (received_byte == )
                end
            end else if (state == ETH_HEADER) begin

            end else (if state == IP_HEADER) begin

            end else if (state == UDP_HEADER) begin

            end else (if state == PAYLOAD) begin

            end else if (state == FCS) begin

            end else if (state == DONE) begin

            end else begin
                state <= IDLE;
            end
        end
    end

endmodule