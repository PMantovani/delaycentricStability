#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/sctp.h>
#include <ifaddrs.h>

#define	BUFFER	512
#define	PORT	34543

void erro(char *s)
{
	perror(s);	// Aborta o programa em caso de erro
	exit(1);
}

int main(void)
{
	struct sockaddr_in server[2], client, *sa;
	struct ifaddrs *ifap, *ifa;
	int sfd, cfd, n_bytes_rec, cont, i=1;
	unsigned int clen= sizeof client;
	char str[BUFFER];

	for (cont=0; cont<2; cont++) {
        memset ((char *) &server[cont], 0, sizeof (struct sockaddr_in));
        server[cont].sin_family = AF_INET;
        server[cont].sin_port = htons(PORT);
	}

	if ((sfd=socket(PF_INET, SOCK_STREAM, IPPROTO_SCTP))==-1)	// Cria socket do servidor
		erro("Socket()");

	if(setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, &i, sizeof(int))==-1)
        	perror("setsockopt");


	getifaddrs (&ifap);
	for (ifa = ifap, cont=0; ifa, cont<2; ifa = ifa->ifa_next) {
		if (ifa->ifa_addr->sa_family==AF_INET) {
			sa = (struct sockaddr_in *) ifa->ifa_addr;
			if (!strcmp(ifa->ifa_name,"lo"))
				continue;
			else {
                		server[cont].sin_addr = sa->sin_addr;
				printf("Interface: %s\tEndereco: %s\n", ifa->ifa_name, inet_ntoa(sa->sin_addr));
				cont++;
			}
		}
	}
	printf("\n");
	fflush(stdout);
	freeifaddrs(ifap);


	if (bind(sfd, (struct sockaddr *)&server[0], sizeof (struct sockaddr_in))==-1)		// Associa o socket ao struct server
		erro("Bind()");

	if (cont==2)
        	if (sctp_bindx(sfd, (struct sockaddr *)&server[1], 1, SCTP_BINDX_ADD_ADDR)==-1)
            		erro("sctp_bindx()");


	if(listen (sfd, 10)==-1)
		erro("Listen()");

	if((cfd = accept(sfd, (struct sockaddr *)&client, &clen)) == -1)
			erro("accept()");

	for (;;) {

		if ((n_bytes_rec = recvfrom(cfd, str, BUFFER, 0, (struct sockaddr *)&client, &clen))==-1)	// Recebe a string do client
			erro("Recv()");

		else if (n_bytes_rec == 0) {
			if (send(cfd, "Desconectado!", 14, 0)==-1)	// Envia pacote para desconectar
				erro("Send()");
			close(cfd);
		}

		else {
			printf("[%s]: %s\n", inet_ntoa(client.sin_addr), str);	// E imprime na tela
			fflush(stdout);
		}
	}

	return 0;
}
