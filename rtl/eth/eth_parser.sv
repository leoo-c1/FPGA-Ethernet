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

    frame_header frame_header_content;  // Each component of the ethernet frame header
    ip_header ip_header_content;        // Each component of the IP packet header
    udp_header udp_header_content;      // Each component of the UDP datagram header

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
                data_valid <= 1'b0;
                data_last <= 1'b0;
                byte_counter <= 0;
                if (byte_valid) begin
                    // If we just received the SFD
                    if (received_byte == 8'hD5)
                        state <= ETH_HEADER;        // Get ready to start reading the frame header
                    else
                        state <= IDLE;
                end else
                    state <= IDLE;
            end else if (state == ETH_HEADER) begin
                // Assign bytes based on the current byte counter
                if (byte_valid) begin
                    if (byte_counter < 6)
                        frame_header_content.dest_mac[byte_counter] <= received_byte;
                    else if (byte_counter < 12)
                        frame_header_content.src_mac[byte_counter-6] <= received_byte;
                    else if (byte_counter < 14)
                        frame_header_content.ethertype[byte_counter-12] <= received_byte;

                    if (byte_counter < 13)
                        byte_counter <= byte_counter + 1;
                    else begin
                        byte_counter <= 0;
                        // Make sure the destination mac is ours and ethertype is 0x0800 (IPv4)
                        if (({>>{frame_header_content.dest_mac}} == FPGA_MAC)
                            & ({frame_header_content.ethertype[0], received_byte} == 16'h0800))
                            state <= IP_HEADER;
                    end
                    
                end
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