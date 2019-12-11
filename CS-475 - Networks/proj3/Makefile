client: client.o
	g++ -Wall -std=c++11 -o client client.o
client.o: client.cpp
	g++ -Wall -std=c++11 -c client.cpp
server: server.o 
	g++ -Wall -std=c++11 -o server server.o -lssl
server.o: server.cpp
	g++ -Wall -std=c++11 -c server.cpp -lssl
