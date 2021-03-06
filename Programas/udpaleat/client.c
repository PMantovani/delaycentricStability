#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <memory.h>
#include <math.h>

#define	PACK_LENGHT	6000
#define	PORT	    45654
#define MEAN_DELAY  10000

struct sockaddr_in server;
int sock;
unsigned int slen = sizeof(server);
char str[PACK_LENGHT-42];
unsigned int count = 0;
struct timespec sent[100000];
struct timespec rec;
int timetosleep;

void erro(char *s)
{
	perror(s);	// Aborta o programa em caso de erro
	exit(1);
}

float us_sleep(float tts)
{
    struct timespec t0, t1;
    float diff;

	clock_gettime(CLOCK_MONOTONIC_RAW, &t0);
	do {
		clock_gettime(CLOCK_MONOTONIC_RAW, &t1);
    	diff = 1000000000*(t1.tv_sec-t0.tv_sec)+(t1.tv_nsec - t0.tv_nsec);
	} while (diff < (tts*1000));

    return (diff/1000);
}


double exponential(void)
{
    double temp;

    temp = (double)rand() / (double)RAND_MAX;
    if (temp < 0.000001)
        temp = 0.000001;

    temp = -log(temp);
    if (temp < 0.005)
        temp = 0.005;

    return (MEAN_DELAY * temp);
}

void rec_func(void)
{
    char msg[PACK_LENGHT-42];
    int count_temp;
    double diff;
    FILE *rtt;

    rtt = fopen("rtt.csv", "w");
    if (rtt == NULL)
        erro("fopen");

    for(;;) {

    if(recvfrom(sock, msg, PACK_LENGHT-42, 0, (struct sockaddr *)&server, &slen) == -1)
            erro("recvfrom()");

    clock_gettime(CLOCK_MONOTONIC_RAW, &rec);

    sscanf(msg, "%d", &count_temp);

    diff = 1000000000*(rec.tv_sec - sent[count_temp-1].tv_sec) + (rec.tv_nsec - sent[count_temp-1].tv_nsec);

    fprintf(rtt, "%.0f\n", diff);

    }

    fclose(rtt);
    return;
}

void send_func (void)
{
    /*FILE *tts;

    tts = fopen("tts.csv", "w+");
    if (tts == NULL)
        erro("fopen"); */

    memset((char *) &str, 0, sizeof(str));

    for (;;) {

    timetosleep = exponential();

   // fprintf(tts,"%d\n", timetosleep);

    count++;
    sprintf(str, "%d", count);

    clock_gettime(CLOCK_MONOTONIC_RAW, &sent[count-1]);

    if (sendto(sock, str, PACK_LENGHT-42, 0, (struct sockaddr *)&server, slen) == -1)	// Envia a string digitada para o servidor
        erro("Sendto()");

    if (timetosleep<=5.0)
        us_sleep((float)timetosleep-5.0);

    if (count==10000)
        count=0;

	}
}

int main(void)
{
    char srv_ip[15];
    char key = 0;
    pthread_t thr_rec, thr_send;

	printf("Digite o IP do servidor: ");	// Possibilita o usu�rio de entrar com o IP no formato xxx.xxx.xxx.xxx
	fgets(srv_ip, 15, stdin);

	if ((sock=socket(PF_INET, SOCK_DGRAM, 0)) == -1)	// Cria o socket
		erro("Socket");

	memset((char *) &server, 0, slen);		// Preenche o struct com zeros para que sockaddr_in fique com mesmo tamanho que sockaddr
	server.sin_family = PF_INET;			// Fam�lia = Internet
	server.sin_port = htons(PORT);			// Define a Porta a ser ouvida, realizando a convers�o host to network
	if (inet_aton(srv_ip, &server.sin_addr)==0) {	// Define o Endere�o IP do server como o endere�o ip atual da m�quina
		fprintf(stderr, "inet_aton() failed\n");
		exit(1);
	}

    srand((unsigned)time(NULL));

	pthread_create(&thr_rec,NULL,rec_func,NULL);
	pthread_create(&thr_send,NULL,send_func,NULL);

	do {
        key = getchar();
	} while(key != 'q');

	pthread_cancel(thr_rec);
	pthread_cancel(thr_send);
	close(sock);
	return 0;
}
