#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/sctp.h>
#include <ifaddrs.h>
#include <string.h>

#define	BUFFER	20
#define	PORT	34543

void erro(char *s)
{
	perror(s);	// Aborta o programa em caso de erro
	exit(1);
}

int main(void)
{
	struct sockaddr_in server, client, *sa;
	struct ifaddrs *ifap, *ifa;
	struct sctp_paddrparams heartbeat;
	struct sctp_rtoinfo rto;
	int sfd, cfd, n_bytes_rec, cont, i=1;
	unsigned int clen= sizeof client;
	char str[BUFFER];

    memset(&heartbeat, 0, sizeof(struct sctp_paddrparams)); // Zera as estruturas para manter os valores padr�es para os que n�o forem alterados
    memset(&rto, 0, sizeof(struct sctp_rtoinfo));

    memset ((char *) &server, 0, sizeof (struct sockaddr_in));
    server.sin_family = AF_INET;
    server.sin_port = htons(PORT);
    server.sin_addr.s_addr = INADDR_ANY;

	if ((sfd=socket(PF_INET, SOCK_STREAM, IPPROTO_SCTP))==-1)	// Cria socket do servidor
		erro("Socket()");

	heartbeat.spp_flags = SPP_HB_ENABLE;
    heartbeat.spp_hbinterval = 20000;   //Intervalo entre HB de 20s
    heartbeat.spp_pathmaxrxt = 2;       //Tentativas de retransmiss�o = 2
    rto.srto_initial = 20;
	rto.srto_min = 20;
    rto.srto_max = 100;                 //Timeout de Retransmiss�o de 1s

    if(setsockopt(sfd, SOL_SCTP, SCTP_PEER_ADDR_PARAMS, &heartbeat, sizeof (heartbeat)) == -1)
        erro("setsockopt(hb)");
    if(setsockopt(sfd, SOL_SCTP, SCTP_RTOINFO, &rto, sizeof (rto)) == -1)
        erro("setsockopt(rto)");
	if(setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, &i, sizeof(int))==-1)
        erro("setsockopt(reuseaddr)");


	getifaddrs (&ifap);
	for (ifa = ifap, cont=0; ifa, cont<2; ifa = ifa->ifa_next) {
		if (ifa->ifa_addr->sa_family==AF_INET) {
			sa = (struct sockaddr_in *) ifa->ifa_addr;
			if (!strcmp(ifa->ifa_name,"lo"))
				continue;
			else {
				printf("Interface: %s\tEndereco: %s\n", ifa->ifa_name, inet_ntoa(sa->sin_addr));
				cont++;
			}
		}
	}
	printf("\n");
	fflush(stdout);
	freeifaddrs(ifap);

	if (bind(sfd, (struct sockaddr *)&server, sizeof (struct sockaddr_in))==-1)		// Associa o socket ao struct server
		erro("Bind()");

	if(listen (sfd, 10)==-1)
		erro("Listen()");

	if((cfd = accept(sfd, (struct sockaddr *)&client, &clen)) == -1)
			erro("accept()");

	for (;;) {

		if ((n_bytes_rec=recvfrom(cfd, str, BUFFER, 0, (struct sockaddr *)&client, &clen))==-1)	// Recebe a string do client
			erro("Recv()");

		if (n_bytes_rec==0) {
			close(sfd);
			break;
		}

		else {
			printf("[%s]: %s\n", inet_ntoa(client.sin_addr), str);	// E imprime na tela
			fflush(stdout);
		}
	}

	return 0;
}
