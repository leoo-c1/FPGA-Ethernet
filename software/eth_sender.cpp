#include <winsock2.h>
#include <iostream>

int main() {
    WSADATA wsadata;

    int startup = WSAStartup(MAKEWORD(2, 2), &wsadata);

    if (startup == 0) {
        std::cout << "Winsock initialised." << std::endl;

        SOCKET data_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);

        if (data_socket == INVALID_SOCKET) {
            std::cout << "Socket creation failed, error code: " << WSAGetLastError() << std::endl;
        }

        else {
            std::cout << "Socket created." << std::endl;
            closesocket(data_socket);
        }

        WSACleanup();
    }

    else {
        std::cout << "Failed. Error code: " << startup << std::endl;
    }

    return 0;
}