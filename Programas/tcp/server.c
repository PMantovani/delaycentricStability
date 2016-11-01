#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>

#define	BUFFER	512
#define	PORT	"34543"

void erro(char *s)
{
	perror(s);	// Aborta o programa em caso de erro
	exit(1);
}

int main(void)
{
	struct addrinfo *server, hints, *temp;
	struct sockaddr_in client;
	int sfd, cfd, n_bytes_rec;
	unsigned int slen=sizeof (client);
	char str[BUFFER];	// Buffer a ser recebido pelo server


	memset(&hints, 0, sizeof(hints));
	hints.ai_flags = AI_PASSIVE;
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;	// Preenche a struct com as informações de conexão

	getaddrinfo(NULL, PORT, &hints, &server);	// Coleta as informações e passa para "server"

	for (temp=server; temp!=NULL;temp=temp->ai_next) {	// Testa próximos endereços até conseguir realizar o socket() e bind()
		if ((sfd = socket(temp->ai_family, temp->ai_socktype, temp->ai_protocol)) == -1)
			continue;
		if (bind(sfd, temp->ai_addr, temp->ai_addrlen) == -1)
			continue;
		break;
	}

	if (temp==NULL)		// Caso não consiga fazer ao menos uma vez o socket() e bind()
		erro("Socket, Bind");

	freeaddrinfo(server);

	listen(sfd, 10);	// Espera conexões no socket sfd

	printf("Esperando Conexões!\n");
	fflush(stdout);

	cfd = accept (sfd, (struct sockaddr *)&client, &slen);	// Aceita as conexões pendentes
	for (;;) {

		if ((n_bytes_rec = recv(cfd, str, BUFFER, 0)) == 0) {		// Se recv() retornar 0, significa que a conexão deve ser fechada
			shutdown (cfd, SHUT_RDWR);
			close(cfd);
		}
		else if (n_bytes_rec == -1)
			erro("recv()");
		else {
			printf("[%s]: %s\n", inet_ntoa(client.sin_addr), str);	// Printf() a mensagem e envia um pacote de retorno
			send(cfd, "Pacote Recebido!", 17, 0);
			fflush(stdout);
		}
	}

	close(sfd);
	return 0;
}
