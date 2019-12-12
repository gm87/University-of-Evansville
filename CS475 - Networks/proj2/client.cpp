#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h> // gethostbyname
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

using namespace std;

int main(int argc, char* argv[])
{
    if (argc!=3){
	std::cout<<"USAGE: "<<argv[0]<<" hostname port"<<endl;
    	exit(1);
    }
    int port = atoi(argv[2]);
    int descriptor = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    std::cout << "Creating socket..." << std::endl;
    if (descriptor < 0){
        std::cerr << "Error creating socket." << std::endl;
        exit(1);
    }
    std::cout << "Socket " << descriptor << " created!" << std::endl;

    struct hostent *server;
    server = gethostbyname(argv[1]);
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
    char response[1024];
    recv(descriptor, response, 1024, 0);
    std::cout << response << std::endl;
    bool disconnected = false;
    while(!disconnected) {
        memset(response, 0, sizeof(response));
        getline(cin, msg);
        if (msg == "disconnect")
                disconnected = true;
        msg = msg+'\n';
        send(descriptor, msg.c_str(), msg.length(), 0);

        recv(descriptor, response, 1024, 0);
        cout << response;
    }

    close(descriptor);
    return 0;
}
