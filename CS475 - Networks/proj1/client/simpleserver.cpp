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

using namespace std;

int port = 62500;

void error(const char *msg)
{
    perror(msg);
    exit(1);
}


int main()
{
    int SocketD;
    // create a socket
    // socket(int domain, int type, int protocol)
    SocketD = socket(AF_INET,SOCK_STREAM,0);
    if (SocketD < 0)
        error("ERROR opening socket");
    else
        cout << "My Socket Discriptor:"  << SocketD <<endl;
    struct sockaddr_in self;
    // clear address structure
    bzero ((char *) &self, sizeof(self));
    /* setup the host_addr structure for use in bind call */
    // server byte order
    self.sin_family = AF_INET;
    // convert short integer value for port must be converted into network byte order
    self.sin_port = htons(port);
    // automatically be filled with current host's IP address
    self.sin_addr.s_addr = INADDR_ANY;
     // bind(int fd, struct sockaddr *local_addr, socklen_t addr_length)
     // bind() passes file descriptor, the address structure,
     // and the length of the address structure
     // This bind() call will bind  the socket to the current IP address on port, portno
    if(bind(SocketD,(struct sockaddr*)&self,sizeof(self)) < 0 )
        error("Error On Binding");
    // This listen() call tells the socket to listen to the incoming connections.
    // The listen() function places all incoming connection into a backlog queue
    // until accept() call accepts the connection.
    // Here, we set the maximum size for the backlog queue to 20.
    listen(SocketD,20);
    cout << "Server is listening on port: " << port <<endl;
    struct sockaddr_in client_addr;
    // clear address structure
    bzero ((char *) &client_addr, sizeof(client_addr));
    int addrlen = sizeof(client_addr);
    // This accept() function will write the connecting client's address info
    // into the the address structure and the size of that structure is clilen.
    // The accept() returns a new socket file descriptor for the accepted connection.
    // So, the original socket file descriptor can continue to be used
    // for accepting new connections while the new socker file descriptor is used for
    // communicating with the connected client.
    int clientfd = accept(SocketD,(struct sockaddr*)&client_addr,(socklen_t*)&addrlen);
    struct linger sl;
    sl.l_onoff = 1;		/* non-zero value enables linger option in kernel */
    sl.l_linger = 0;	/* timeout interval in seconds */
    setsockopt(clientfd, SOL_SOCKET, SO_LINGER, &sl, sizeof(sl));
    sl.l_onoff = 1;		/* non-zero value enables linger option in kernel */
    sl.l_linger = 0;	/* timeout interval in seconds */
    setsockopt(SocketD, SOL_SOCKET, SO_LINGER, &sl, sizeof(sl));
    if(clientfd <0)
        error("error on exept");
    else
        cout << "client IP: " << inet_ntoa(client_addr.sin_addr) << " , " << "Port: " << ntohs(client_addr.sin_port) << endl;
    string Hello = "Hello Mom";

    send(clientfd,Hello.c_str(),Hello.length(),0);
    bool disconnect = false;
    while(!disconnect)
    {
        bool endofline = false;
        int received  = 0;
        int iter = 0;
        char rebuffer[80];
        char buffer [80];
        while(!endofline)
        {
            received = recv(clientfd, rebuffer, 80, 0);
            for(int i=0; i<received; i++, iter++)
            {
                if(rebuffer[i] == '\n')
                {
                    endofline = true;
                }
                buffer[iter] = rebuffer[i];
                if(endofline)
                {
                    buffer[iter+1] = 0;
                }
            }
            if(endofline){
                send(clientfd,buffer,iter,0);
                string arr = string (buffer);
                if(arr.compare("disconnect\r\n") == 0){
                    cout << "Client has disconnected" << endl;
                    disconnect = true;
                }
                else
                    cout << arr << endl;
            }
        }

    }

    cout << "Close client Stream" << endl;
    close(clientfd);
    cout << "Close Socket" << endl;
    close(SocketD);
    return 0;
}
