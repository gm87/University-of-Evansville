#include <iostream>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string>
#include <netdb.h>
#include <openssl/ssl.h>
#include <openssl/err.h>

using namespace std;

int port = 62500;

void error(const char *msg)
{
    perror(msg);
    exit(1);
}

void getBuffer(int received, char* buffer, char* rebuffer) {
    for(int i=0; i<received; i++)
    {
        buffer[i] = rebuffer[i];
        if(i+1 == received)
            buffer[i] = '\0';
    }
}

int length(char* str) {
   int i=0;
   while(str[i] != '\0')
      i++;
   return i;
}

string getRate(int i, char* reBuffer) {
    string rate = "";
    i=i+5;
    while (reBuffer[i] != ','){
        rate=rate + reBuffer[i];
        i++;
    }
    rate = rate + '\0';
    return rate;
}
 
int main() {
    int SocketD;
    SocketD = socket(AF_INET,SOCK_STREAM,0);
    if (SocketD < 0){
        cerr << "Error creating client socket" << endl;
        exit(1);
    }
    else
        cout << "Client SocketD: " << SocketD << endl;
    struct sockaddr_in self;
    bzero ((char *) &self, sizeof(self));
    self.sin_family = AF_INET;
    self.sin_port = htons(port);
    self.sin_addr.s_addr = INADDR_ANY;
    if (bind(SocketD,(struct sockaddr*)&self,sizeof(self)) < 0)
        cerr << "Error on binding" << endl;  
    listen(SocketD,20);    
    cout << "Server is listening on port " << port << endl;
    struct sockaddr_in client_addr;
    bzero ((char*) &client_addr, sizeof(client_addr));
    int addrlen = sizeof(client_addr);
    int exchangeFD = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (exchangeFD < 0){
        std::cerr << "Error creating exchange FD socket." << std::endl;
        exit(1);
    }
    struct hostent *server;
    server = gethostbyname("api.exchangeratesapi.io");
    if (server == NULL) {
        std::cerr << "Failed to get host by name" << std::endl;
        exit(1);
    }
    struct sockaddr_in serv_addr;
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, (char *)&serv_addr.sin_addr.s_addr, server->h_length);
    serv_addr.sin_port = htons(443);

    std::cout << "Connecting..." << std::endl;
    if (connect(exchangeFD, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        std::cerr << "Error connecting." << std::endl;
        exit(1);
    } else {
        std::cout << "Connected!" << std::endl;
    }

    SSL_load_error_strings();
    SSL_library_init ();
    SSL_CTX *ssl_ctx = SSL_CTX_new (SSLv23_client_method ());
    // create an SSL connection and attach it to the socket
    SSL *conn = SSL_new(ssl_ctx);
    SSL_set_fd(conn, exchangeFD);

    int err = SSL_connect(conn);
    if (err != 1)
        exit(1); // handle error

    char exchangeRebuffer[2048];
    int received = 0;
    char buffer[2048];
    char rebuffer[2048];
    SSL_write(conn, "GET /latest HTTP/1.1\r\nHost: api.exchangeratesapi.io\r\n\r\n",strlen("GET /latest HTTP/1.1\r\nHost: api.exchangeratesapi.io\r\n\r\n"));
    SSL_read(conn,exchangeRebuffer,2048);

    int j=-1;
    for (int i=0; i<length(exchangeRebuffer); i++){
        if (exchangeRebuffer[i]=='r' && exchangeRebuffer[i+1] == 'a' && exchangeRebuffer[i+2] == 't' &&
            exchangeRebuffer[i+3] == 'e' && exchangeRebuffer[i+4] == 's') {
                j=i;
                break;
            }
    }
    string CADRate, AUDRate, RUBRate, GBPRate, HKDRate, PHPRate, DKKRate, CZKRate, USDRate;
    string EURRate = "1.0";
    for (j; j<length(exchangeRebuffer); j++){
        if (exchangeRebuffer[j] == 'C' && exchangeRebuffer[j+1] == 'A' && exchangeRebuffer[j+2] == 'D') {
            CADRate = getRate(j, exchangeRebuffer);
        }
        else if (exchangeRebuffer[j] == 'A' && exchangeRebuffer[j+1] == 'U' && exchangeRebuffer[j+2] == 'D') {
            AUDRate = getRate(j, exchangeRebuffer);
        }
        else if (exchangeRebuffer[j] == 'R' && exchangeRebuffer[j+1] == 'U' && exchangeRebuffer[j+2] == 'B') {
            RUBRate = getRate(j, exchangeRebuffer);
        }
        else if (exchangeRebuffer[j] == 'G' && exchangeRebuffer[j+1] == 'B' && exchangeRebuffer[j+2] == 'P') {
            GBPRate = getRate(j, exchangeRebuffer);
        }
        else if (exchangeRebuffer[j] == 'H' && exchangeRebuffer[j+1] == 'K' && exchangeRebuffer[j+2] == 'D') {
            HKDRate = getRate(j, exchangeRebuffer);
        }
        else if (exchangeRebuffer[j] == 'P' && exchangeRebuffer[j+1] == 'H' && exchangeRebuffer[j+2] == 'P') {
            PHPRate = getRate(j, exchangeRebuffer);
        }
        else if (exchangeRebuffer[j] == 'D' && exchangeRebuffer[j+1] == 'K' && exchangeRebuffer[j+2] == 'K') {
            DKKRate = getRate(j, exchangeRebuffer);
        }
        else if (exchangeRebuffer[j] == 'C' && exchangeRebuffer[j+1] == 'Z' && exchangeRebuffer[j+2] == 'K') {
            CZKRate = getRate(j, exchangeRebuffer);
        }
        else if (exchangeRebuffer[j] == 'U' && exchangeRebuffer[j+1] == 'S' && exchangeRebuffer[j+2] == 'D') {
            USDRate = getRate(j, exchangeRebuffer);
        }
    }
    while (1) {
        int clientfd = accept(SocketD,(struct sockaddr*)&client_addr,(socklen_t*)&addrlen);
        struct linger s1;
        s1.l_onoff = 1;
        s1.l_linger = 0;
        setsockopt(clientfd, SOL_SOCKET, SO_LINGER, &s1, sizeof(s1));
        s1.l_onoff = 1;
        s1.l_linger = 0;
        setsockopt(SocketD, SOL_SOCKET, SO_LINGER, &s1, sizeof(s1));
        if (clientfd < 0)
            cerr << "Error on accept" << endl;
        else
            cout << "client IP: " << inet_ntoa(client_addr.sin_addr) << " , " << "Port: " << ntohs(client_addr.sin_port) << endl;
        received = recv(clientfd, rebuffer, 2048, 0);
	getBuffer(received, buffer, rebuffer);
        string amount = "";
        for (int i=13; i<length(buffer); i++) {
            amount = amount+buffer[i];
            if (buffer[i] == '.'){
                amount = amount+buffer[i+1];
                amount = amount+buffer[i+2];
                amount = amount+'\0';
                break;
            }
        }
        cout << "convertFrom: " << buffer[4] << " convertTo: " << buffer[8] << " amount: " << amount << endl;
        string toRate = "";
        string fromRate = "";
    if (buffer[4] == '0')
 	    fromRate = CADRate;
    else if (buffer[4] == '1')
        fromRate = AUDRate;
    else if (buffer[4] == '2')
        fromRate = RUBRate;
    else if (buffer[4] == '3')
        fromRate = EURRate;
    else if (buffer[4] == '4')
        fromRate = GBPRate;
    else if (buffer[4] == '5')
        fromRate = HKDRate;
    else if (buffer[4] == '6')
        fromRate = PHPRate;
    else if (buffer[4] == '7')
        fromRate = DKKRate;
    else if (buffer[4] == '8')
        fromRate = CZKRate;
    else
        fromRate = USDRate;
	if (buffer[8] == '0')
	    toRate = CADRate;
    else if (buffer[8] == '1')
        toRate = AUDRate;
    else if (buffer[8] == '2')
        toRate = RUBRate;
    else if (buffer[8] == '3')
        toRate = EURRate;
    else if (buffer[8] == '4')
        toRate = GBPRate;
    else if (buffer[8] == '5')
        toRate = HKDRate;
    else if (buffer[8] == '6')
	    toRate = PHPRate;
    else if (buffer[8] == '7')
	    toRate = DKKRate;
	else if (buffer[8] == '8')
	    toRate = CZKRate;
	else
	    toRate = USDRate;
    string msg;
	double conversionRate = (stod(toRate)/stod(fromRate));
	double convertAmt = stod(amount);
	double convertedAmt = convertAmt * conversionRate;
	string convertedAmtStr = to_string(convertedAmt);
	for (int i=0; i<convertedAmtStr.length(); i++) {
	    if (convertedAmtStr[i] == '.'){
		convertedAmtStr[i+3] = '\0';
		break;
	    }
	}
	msg = "Conversion rate: " + to_string(conversionRate) + "\nConverted amount: " + convertedAmtStr + "\n\n";
        send(clientfd, msg.c_str(), msg.length(), 0);
        close(clientfd);
    }
    return 0;
 }
