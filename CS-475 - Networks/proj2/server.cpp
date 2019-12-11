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
#include <unistd.h>
#include <time.h>

using namespace std;

int port = 62500;

void error(const char *msg)
{
    perror(msg);
    exit(1);
}

void getBuffer(char* input, char* output, int rec) {
  bool eol = false;
  int iter = 0;

  for(int i=0; i<rec; i++, iter++) {
    if(input[i] == '\n')
        eol = true;
      output[iter] = input[i];
    if(eol)
      output[iter+1] = 0;
    }
}

string exec(string command) {
   char buffer[1024];
   string result = "";

   // Open pipe to file
   FILE* pipe = popen(command.c_str(), "r");
   if (!pipe) {
      return "popen failed!";
   }

   // read till end of process:
   while (!feof(pipe)) {

      // use buffer to read and add to result
      if (fgets(buffer, 1024, pipe) != NULL)
         result += buffer;
   }

   pclose(pipe);
   return result;
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

    while(1) {
      pid_t childpid;
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
      // string Hello = "Hello Mom";
      if((childpid = fork()) == 0) {
        close(SocketD);
        bool disconnect = false;
        while(!disconnect)
        {
            char *args[]={"fortune",NULL}; 
            pid_t pid = fork();
            if (pid < 0) {
              cerr << "Fork failed before exec call." << endl;
              exit(1);
            }
            else if (pid == 0){
              execvp(args[0], args);
            }
            else {
            }
            bool endofline = false;
            int received  = 0;
            int iter = 0;
            char rebuffer[1024];
            char buffer [1024];
            string str;

            str = exec("fortune");
            send(clientfd, str.c_str(), str.length(), 0);
            string inst = "Do you want a (f)ortune or your (l)ucky number?";
            send(clientfd, inst.c_str(), inst.length(), 0);
            while(!endofline)
            {
                received = recv(clientfd, rebuffer, 1024, 0);
                getBuffer(rebuffer, buffer, received);
                if (buffer[0] == 'f'){
                  str = exec("fortune");
                  str = str + "\nDo you want a (f)ortune or your (l)ucky number?";
                }
                else if (buffer[0] == 'l'){
                  srand (time(NULL));
                  string minStr, maxStr;
                  int min, max, lucky;
                  str = "Enter min: ";
                  send(clientfd, str.c_str(), str.length(), 0);
                  received = recv(clientfd, rebuffer, 1024, 0);
                  getBuffer(rebuffer, buffer, received);
                  minStr = buffer;
                  str = "Enter max: ";
                  send(clientfd, str.c_str(), str.length(), 0);
                  received = recv(clientfd, rebuffer, 1024, 0);
                  getBuffer(rebuffer, buffer, received);
                  maxStr = buffer;
                  min = atoi(minStr.c_str());
                  max = atoi(maxStr.c_str());
                  lucky = (rand() % (max-min)) + min;
                  str = "Your lucky number is: " + to_string(lucky) + "\nDo you want a (f)ortune or your (l)ucky number?";
                } else if (strcmp(buffer, "disconnect")) {
                  str = "Disconnecting\n";
                }  
                else {
                  str = "Unknown input\n";
                }
                send(clientfd, str.c_str(), str.length(), 0);
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
    }
    cout << "Close client Stream" << endl;
    close(clientfd);
    }
    cout << "Close Socket" << endl;
    close(SocketD);
    return 0;
}
