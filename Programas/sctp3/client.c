#include <arpa/inet.h>
#include <netinet/in.h>
#include <netinet/sctp.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#define	BUFFER	18
#define	PORT	34543

void erro(char *s)
{
	perror(s);	// Aborta o programa em caso de erro
	fflush(stdout);
	exit(1);
}

void muda_prim(int sfd, struct sockaddr_in addr_sec)
{
	struct sctp_setprim end_prim;
	struct sockaddr_storage sas;
	struct sockaddr_in *sai;

	memset(&end_prim, 0, sizeof(struct sctp_setprim));

	sai = (struct sockaddr_in*)&sas; //Atribui o endereco de memoria a 'sai'
	*sai = addr_sec;

	end_prim.ssp_addr = sas;

	if(setsockopt(sfd, SOL_SCTP, SCTP_PRIMARY_ADDR, &end_prim, sizeof(end_prim)) == -1)
		erro("setsockopt(primaddr)");

	return;
}

int main(void)
{
	struct sockaddr_in server[2];
	struct sctp_paddrparams params;
	struct sctp_rtoinfo rto;
	int cont, i=1, shbb = sizeof(struct sctp_paddrparams);
	int sfd, n_bytes_rec, slen = sizeof (server[0]);
	char str[BUFFER], srv_ip[15];

    memset(&params, 0, sizeof(struct sctp_paddrparams)); // Zera as estruturas para manter os valores padrões para os que não forem alterados
    memset(&rto, 0, sizeof(struct sctp_rtoinfo));

    if ((sfd=socket(PF_INET, SOCK_STREAM, IPPROTO_SCTP)) == -1)	// Cria o socket
        erro("Socket()");

    printf("Digite o primeiro IP do servidor: ");	// Possibilita o usuário de entrar com o IP no formato xxx.xxx.xxx.xxx
	fflush(stdin);
	fflush(stdout);
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

	params.spp_flags = SPP_HB_ENABLE+SPP_SACKDELAY_DISABLE;	// Para que as alterações abaixo tenham efeito
	params.spp_pathmaxrxt = 2;
	//params.spp_sackdelay = 0;
	rto.srto_initial = 20;
	rto.srto_min = 20;
    rto.srto_max = 100;      

	printf("Digite o valor para o intervalo de HB: ");
	scanf("%d", &params.spp_hbinterval);

    if(setsockopt(sfd, SOL_SCTP, SCTP_PEER_ADDR_PARAMS, &params, sizeof (params)) == -1)
        erro("setsockopt(hb)");
    if(setsockopt(sfd, SOL_SCTP, SCTP_RTOINFO, &rto, sizeof (rto)) == -1)
        erro("setsockopt(rto)");

	getsockopt(sfd, SOL_SCTP, SCTP_PEER_ADDR_PARAMS, &params, &shbb);
	printf("Intervalo de params: %d ms", params.spp_hbinterval);
	fflush(stdout);

	if (sctp_connectx(sfd, (struct sockaddr *)&server, 2, &i) == -1)
		erro("sctp_connectx()");

	for (cont=1;;cont++) {

        memset((char *)&str, 0, BUFFER);

		sprintf(str, "Pacote numero %d", cont);

		if (send(sfd, str, BUFFER, 0) == -1)	// Envia a string digitada para o servidor
			erro("Send()");

        if (cont==120)
            muda_prim(sfd, server[1]);

        if (cont==2048)
            cont=0;

        sleep(1);
	}

	return 0;
}
