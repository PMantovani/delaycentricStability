#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define	BUFFER	600

struct sockaddr_in client;

void erro(char *s)
{
	perror(s);	// Aborta o programa em caso de erro
	exit(1);
}

void mountTime(char * strToMount) {
	struct tm *local;
	time_t t = time(NULL);
	strcat(strToMount, "Date: ");

	char temp[35];
	ctime_r(&t, temp);
	strcat(strToMount, temp);	
	strcat(strToMount, "<br>\n");
}

void mountStr(char * strToMount) {
	strcat(strToMount, "HTTP/1.1 200 OK\n");
	strcat(strToMount, "Content-Type: text/html; charset=UTF-8\n");
	strcat(strToMount, "\nPedro Mantovani Antunes<br>\n");
	mountTime(strToMount);
	strcat(strToMount, inet_ntoa(client.sin_addr));
	strcat(strToMount, "<br>\n");
	char temp[12];
	sprintf(temp, "%d<br>\n", client.sin_port);
	strcat(strToMount, temp);
}

int main(int argc, char* argv[])
{
	int cfd, sfd, PORT, n_bytes_rec;
	struct sockaddr_in server;
	unsigned int slen=sizeof (client);
	char str[BUFFER];			// Buffer a ser recebido pelo server
	char strToSend[BUFFER+30];

    if (argc != 2) {
        printf("usage: %s <PORT>", argv[0]);
        exit(0);
    }

    PORT = atoi(argv[1]);

	if ((sfd=socket(PF_INET, SOCK_STREAM, 0))==-1)	// Create socket
		erro("Socket");

	memset ((char *) &server, 0, sizeof(server));
	server.sin_family = AF_INET;
	server.sin_port = htons(PORT);			// Defines the PORT to listen in
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// Receives packets from all network interfaces

	if (bind(sfd, (struct sockaddr *)&server, sizeof(server))==-1)
		erro("Bind");

    listen(sfd, 10);

    while(1) {
        printf("Esperando Conexões!\n");
        fflush(stdout);

        if ((cfd = accept(sfd, (struct sockaddr *)&client, &slen)) == -1)
            erro("Accept");

		if ((n_bytes_rec = recv(cfd, str, BUFFER, 0)) == 0)		// Se recv() retornar 0, significa que a conexão deve ser fechada
			close(cfd);

		else if (n_bytes_rec == -1)
			erro("recv()");

		else {
			mountStr(strToSend);
			strcat(strToSend, str);

			send(cfd, strToSend, strlen(strToSend), 0);
			memset(strToSend, 0, sizeof(strToSend));
			fflush(stdout);
		}
        close(cfd);
	}

	close(sfd);
	return 0;
}
