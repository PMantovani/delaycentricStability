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

int main (void)
{
	struct addrinfo server, *res;
	int sfd, n_bytes_rec; 
	unsigned int slen = sizeof(server);
	char str[BUFFER], ip[15];

	printf("Digite o ip do servidor: ");
	gets(ip);

	memset(&server, 0, slen);
	server.ai_flags = AI_PASSIVE;
	server.ai_family = AF_UNSPEC;
	server.ai_socktype = SOCK_STREAM;	// Preenche o struct com os dados de conexão com o servidor

	getaddrinfo(ip, PORT, &server, &res);	// Coleta as informações do servidor e passa para res

	sfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);	// Abre o socket com as informações anteriores
	if (sfd == -1)
		erro ("socket()");

	if (connect(sfd, res->ai_addr, res->ai_addrlen)==-1)	// Conecta ao servidor
		erro("connect()");

	freeaddrinfo(res);	// Libera as informações contidas no struct addrinfo
	
	for(;;) {
		printf("Digite a string a ser enviada: ");
		gets(str);
		send(sfd, str, BUFFER, 0);	// Envia a mensagem digitada para o servidor
		
		if ((n_bytes_rec = recv(sfd, str, BUFFER, 0)) == 0) {	// Desconecta caso seja enviado o pedido (recv() == 0)
			shutdown(sfd, SHUT_RDWR);
			close(sfd);
		}
		else if (n_bytes_rec > 0)
			printf("%s\n",str);
		else if (n_bytes_rec == -1)
			erro("recv()");
	}
	return 0;
}

