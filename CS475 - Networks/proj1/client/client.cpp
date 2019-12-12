
#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h> // gethostbyname
#include <sys/types.h>
#include <stdio.h>

using namespace std;

int main(int argc, char* argv[])
{
    int port = atoi(argv[1]);
    int descriptor = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    std::cout << "Creating socket..." << std::endl;
    if (descriptor < 0){
        std::cerr << "Error creating socket." << std::endl;
        exit(1);
    }
    std::cout << "Socket " << descriptor << " created!" << std::endl;
    
    struct hostent *server;
    server = gethostbyname("homesrv");
    if (server == NULL) {
        std::cerr << "Failed to get host by name" << std::endl;
        exit(1);
    }
    
    struct sockaddr_in serv_addr;
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, (char *)&serv_addr.sin_addr.s_addr, server->h_length);
    serv_addr.sin_port = htons(port);
    
    std::cout << "Connecting..." << std::endl;
    if (connect(descriptor, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        std::cerr << "Error connecting." << std::endl;
        exit(1);
    } else {
        std::cout << "Connected!" << std::endl;
    }
    
    string msg;
    
    char response[80];
    recv(descriptor, response, 80, 0);
    std::cout << "Server response: " << std::endl;
    
    while(true) {
        std::cout << "Enter message: ";
        getline(cin, msg);
        msg = msg + '\n';
        
        send(descriptor, msg.c_str(), msg.length(), 0);
        
        recv(descriptor, response, 80, 0);
        
        cout << "Server response: " << response << std::endl;
    }
    
    close(descriptor);
    return 0;
}
