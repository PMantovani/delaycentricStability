#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define	BUFFER	10

void erro(char *s)
{
	perror(s);	// Aborta o programa em caso de erro
	exit(1);
}

int main(int argc, char* argv[])
{
	int rec, sock, PORT;
	fd_set readset;
	struct sockaddr_in server, client;
	unsigned int slen=sizeof (client);
	char str[BUFFER];			// Buffer a ser recebido pelo server

    if (argc != 2) {
        printf("usage: %s <PORT>", argv[0]);
        exit(0);
    }

    PORT = atoi(argv[1]);

	if ((sock=socket(PF_INET, SOCK_DGRAM | SOCK_NONBLOCK, 0))==-1)	// Create socket
		erro("Socket");

	memset ((char *) &server, 0, sizeof(server));
	server.sin_family = AF_INET;
	server.sin_port = htons(PORT);			// Defines the PORT to listen in
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// Receives packets from all network interfaces

	if (bind(sock, (struct sockaddr *)&server, sizeof(server))==-1)
		erro("Bind");

	while(1) {

	do {
		FD_ZERO(&readset);
		FD_SET(sock, &readset);
		rec = select(sock+1, &readset, NULL, NULL, NULL);
	} while (rec <= 0 && errno == EINTR);

	if (rec > 0) {
		recvfrom(sock, str, BUFFER, 0, (struct sockaddr *)&client, &slen);
		sendto(sock, str, BUFFER, 0, (struct sockaddr *)&client, slen);	// Send ACK
		rec = -1;
		}
	}

	close(sock);
	return 0;
}
