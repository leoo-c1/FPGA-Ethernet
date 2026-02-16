#include <winsock2.h>
#include <iostream>

int main() {
    WSADATA wsadata;

    int startup = WSAStartup(MAKEWORD(2, 2), &wsadata);

    if (startup == 0) {
        std::cout << "Winsock initialised." << std::endl;
        WSACleanup();
    }

    else {
        std::cout << "Failed. Error code: " << startup << std::endl;
    }

    return 0;
}