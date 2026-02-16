#include <winsock2.h>
#include <iostream>
#include <ws2tcpip.h>

int main() {
    WSADATA wsadata;

    // Initialise winsocket
    int startup = WSAStartup(MAKEWORD(2, 2), &wsadata);

    if (startup == 0) {
        std::cout << "Winsock initialised." << std::endl;

        // Create a socket with IPv4 and UDP
        SOCKET data_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);

        if (data_socket == INVALID_SOCKET) {
            std::cout << "Socket creation failed, error code: " << WSAGetLastError() << std::endl;
        }

        else {
            std::cout << "Socket created." << std::endl;
            
            // Create socket address struct
            sockaddr_in server_addr{0};
            server_addr.sin_family = AF_INET;
            server_addr.sin_port = htons(5005);     // Format the bytes as big endian instead of little endian
            inet_pton(AF_INET, "192.0.2.146", &server_addr.sin_addr);

            std::cout << "Address struct created." << std::endl;
            

            closesocket(data_socket);
        }

        WSACleanup();
    }

    else {
        std::cout << "Failed. Error code: " << startup << std::endl;
    }

    return 0;
}