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
#include <string>

using namespace std;

int main(int argc, char* argv[])
{
    if (argc!=3){
	std::cout<<"USAGE: "<<argv[0]<<" hostname port"<<endl;
    	exit(1);
    }
    int port = atoi(argv[2]);
    
    // start project here
    string input;
    while (1) {
    int descriptor = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (descriptor < 0){
        std::cerr << "Error creating socket." << std::endl;
        exit(1);
    }

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

    bool valid = false;
    int convertFrom, convertTo = -1;
    double amount = -1.0;
    while (!valid) {
        cout << "Which currency do you want to convert from ('quit' to quit)?\n(0) CAD\n(1) AUD\n(2) RUB\n(3) EUR\n(4) GBP\n(5) HKD\n(6) PHP\n(7) DKK\n(8) CZK\n(9) USD" << endl;
        getline(cin, input);
	if (input == "quit") {
	    close(descriptor);
	    exit(0);
	}
        if (!((atoi(input.c_str()) >= 0) && (atoi(input.c_str()) <= 9)))
            cout << "Invalid input" << endl;
        else
            valid = true;
    }
    convertFrom = atoi(input.c_str());
    valid = false;
    while (!valid) {
        cout << "Which currency do you want to convert to?\n(0) CAD\n(1) AUD\n(2) RUB\n(3) EUR\n(4) GBP\n(5) HKD\n(6) PHP\n(7) DKK\n(8) CZK\n(9) USD" << endl;
        getline(cin, input);
        if (!((atoi(input.c_str()) >= 0) && (atoi(input.c_str()) <= 9))) {
            cout << "Invalid input" << endl;
        }
        else
            valid = true;
    }
    convertTo = atoi(input.c_str());
    valid = false;
    while(!valid) {
        cout << "Enter from amount: ";
        getline(cin, input);
        if (atof(input.c_str()) < 0)
            cout << "Invalid input" << endl;
        else
            valid = true;
    }
    amount = atof(input.c_str());

    if (connect(descriptor, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        std::cerr << "Error connecting." << std::endl;
        exit(1);
    }

    string msg = "FRM:" + to_string(convertFrom) + "TO:" + to_string(convertTo) + "AMT:" + to_string(amount) + '\n';
    char response[1024];
    send(descriptor, msg.c_str(), msg.length(), 0);
    recv(descriptor, response, 1024, 0);
    cout << response << endl;
    close(descriptor);
    }
    return 0;
}

