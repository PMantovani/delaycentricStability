#include <arpa/inet.h>
#include <netinet/in.h>
#include <netinet/sctp.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#define	BUFFER	512
#define	PORT	34543

void erro(char *s)
{
	perror(s);	// Aborta o programa em caso de erro
	fflush(stdout);
	exit(1);
}

int main(void)
{
	struct sockaddr_in server[3];
	int teste=1;
	int sfd, n_bytes_rec, slen = sizeof (server[0]);
	char str[BUFFER], srv_ip[15];		// Buffer a ser enviado pelo client

    if ((sfd=socket(PF_INET, SOCK_STREAM, IPPROTO_SCTP)) == -1)	// Cria o socket
        erro("Socket()");

        printf("Digite o primeiro IP do servidor: ");	// Possibilita o usuário de entrar com o IP no formato xxx.xxx.xxx.xxx
        fgets(srv_ip,16,stdin);

        memset((char *) &server[0], 0, sizeof (struct sockaddr_in));
        server[0].sin_family = AF_INET;			// Família = Internet
        server[0].sin_port = htons(PORT);			// Define a Porta a ser ouvida, realizando a conversão host to network
        if (inet_aton(srv_ip, &server[0].sin_addr)==0) {	// Define o Endereço IP do server como o endereço ip atual da máquina
            fprintf(stderr, "inet_aton() failed\n");
            exit(1);
        }

	printf("Digite o segundo IP do servidor: ");
	fgets(srv_ip,16,stdin);

        memset((char *) &server[1], 0, sizeof (struct sockaddr_in));
        server[1].sin_family = AF_INET;			// Família = Internet
        server[1].sin_port = htons(PORT);			// Define a Porta a ser ouvida, realizando a conversão host to network
        if (inet_aton(srv_ip, &server[1].sin_addr)==0) {	// Define o Endereço IP do server como o endereço ip atual da máquina
            fprintf(stderr, "inet_aton() failed\n");
            exit(1);
        }

	if (sctp_connectx(sfd, (struct sockaddr *)&server, 2, &teste) == -1)
		erro("sctp_connectx()");

	for (;;) {
		printf("Digite a string a ser enviada: ");
		fgets(str,BUFFER,stdin);

		if ((str[0] == 'q') && (str[1] == '\0')) {
			close(sfd);
			break;
        }

		if (send(sfd, str, BUFFER, 0) == -1)	// Envia a string digitada para o servidor
			erro("Send()");
	}

	return 0;
}
