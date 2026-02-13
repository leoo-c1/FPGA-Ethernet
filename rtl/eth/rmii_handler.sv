module rmii_handler (
    input logic clk,                    // 50MHz LAN8720 clock
    input logic resetn,                 // Reset button

    input logic data_valid,             // Flag to indicate we are receiving valid data

    input logic rx0,                    // The data on the first receiving pin
    input logic rx1,                    // The data on the second receiving pin

    output logic [7:0] received_byte,   // The 8-bit data made by combining both data pins' inputs
    output logic byte_valid             // Pulses when we just received a valid byte
    );

    parameter max_bit_count = 8;        // We want to count a total of 8 bits
    logic [1:0] bit_count = 0;          // Counts how many 2-bits we have received

    logic [7:0] bit_storage;            // Holds onto each received bit until full byte is received

    always_ff @ (posedge clk or negedge resetn) begin
        if (!resetn) begin              // On reset/startup, reset our collected byte
            received_byte <= 8'b0;
            byte_valid <= 8'b0;
            bit_count <= 2'b0;
            bit_storage <= 8'b0;
        end else begin
            if (data_valid) begin       // If we are receiving valid data
                // If we are about to receive the first two bits for a new byte
                if (bit_count == 0) begin
                    bit_storage[1:0] <= {rx1, rx0};
                    bit_count <= bit_count + 1;
                    byte_valid <= 1'b0;
                // If we are about to receive the 3rd and 4th bits of our byte
                end else if (bit_count == 1) begin
                    bit_storage[3:2] <= {rx1, rx0};
                    bit_count <= bit_count + 1;
                    byte_valid <= 1'b0;
                // If we are about to receive the 5th and 6th bits of our byte
                end else if (bit_count == 2) begin
                    bit_storage[5:4] <= {rx1, rx0};
                    bit_count <= bit_count + 1;
                    byte_valid <= 1'b0;
                // If we are about to receive the 7th and 8th bits of our byte
                end else if (bit_count == 3) begin
                    received_byte <= {rx1, rx0, bit_storage[5:0]};
                    byte_valid <= 1'b1;
                    bit_count <= 0;
                end else begin
                    bit_count <= 0;
                    byte_valid <= 1'b0;
                end
            end else begin              // If we aren't receiving valid data
                bit_count <= 0;
                byte_valid <= 1'b0;
            end
        end
    end

endmodule