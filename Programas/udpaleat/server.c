#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#define	BUFFER	50
#define	PORT	45654

pthread_t trh;
int rec, rep = 0;
struct sockaddr_in server, client;
int sock;
unsigned int slen=sizeof (client);
char str[BUFFER-42];			// Buffer a ser recebido pelo server

void erro(char *s)
{
	perror(s);	// Aborta o programa em caso de erro
	exit(1);
}

void *thrFunc(void* arg){
    while(1) {
        rec=0;
        if (recvfrom(sock, str, BUFFER-42, 0, (struct sockaddr *)&client, &slen)==-1)		// Recebe a string do client
			erro("Recvfrom()");
        rec=1;
		rep=0;
        usleep(100);
    }
}

int main(void)
{
	if ((sock=socket(PF_INET, SOCK_DGRAM, 0))==-1)	// Cria socket do servidor
		erro("Socket");

	memset ((char *) &server, 0, sizeof(server));	//Preenche o struct com zeros para que sockaddr_in fique com mesmo tamanho que sockaddr
	server.sin_family = AF_INET;			// Família = Internet
	server.sin_port = htons(PORT);			// Define a Porta a ser ouvida, realizando a conversão host to network
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// Define o Endereço IP do server como o endereço ip atual da máquina

	if (bind(sock, (struct sockaddr *)&server, sizeof(server))==-1)		// Associa o socket ao struct server
		erro("Bind");

    pthread_create(&trh,NULL,thrFunc,NULL);

	while(1) {
	if (rec==1 && rep==0) {
    	if (sendto(sock, str, BUFFER-42, 0, (struct sockaddr *)&client, slen)==-1)	// Envia pacote de confirmação
        	erro("Sendto()");
		rep=1;
        }
	}

	close(sock);
	return 0;
}
