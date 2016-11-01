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

#define	PLENGHT	250
#define	HEADER	42
#define	SERVERPORT	34543
#define	RECVPORT	45654
#define TIMEOUT		10000000


double MEAN;
unsigned long int MAX_LIMIT;
int sock;
struct sockaddr_in server;
unsigned int slen = sizeof(server);
struct timeval *sendTime;
struct timeval *rtt;

void erro(char *s)
{
	perror(s);	// Aborta o programa em caso de erro
	exit(1);
}

void handler(int param)
{
    close(sock);
    exit(1);
}

float usecDiff (struct timeval pos, struct timeval neg)
{
    return (1000000*(pos.tv_sec-neg.tv_sec) + (pos.tv_usec-neg.tv_usec));
}

double generateLogRandomNum(double mean)
{
    double temp;

    temp = (double)rand() / (double)RAND_MAX;
    temp = -log(temp);

    if (temp > 5)
    	temp = 5;

    return (mean * temp);
}

void rec_func(void)
{
    char msg[PLENGHT-HEADER];
    unsigned long int countRecv;
    unsigned long int totalRecv = 0;
    struct timeval recvTime; gettimeofday(&recvTime, NULL);
    struct timeval lastIteration; lastIteration = recvTime;

    for(; totalRecv<MAX_LIMIT && (usecDiff(lastIteration, recvTime)<TIMEOUT);
    		totalRecv++, gettimeofday(&lastIteration, NULL)) {

    	if(recvfrom(sock, msg, PLENGHT-HEADER, 0, (struct sockaddr *)&server, &slen) == -1)
    		erro("recvfrom()");
    	sscanf(msg, "#%lu", &countRecv);
    	gettimeofday(&recvTime, NULL);
    	rtt[countRecv] = usecDiff(recvTime, sendTime[countRecv]);

    }
    return;
}

void send_func (void)
{
	unsigned long int countSend = 0;
	char msg[PLENGHT-HEADER];

	for (; countSend<MAX_LIMIT; countSend++) {

		tts = generateLogRandomNum(MEAN);

		memset((char *) &msg, 0, sizeof(msg));
		sprintf(msg, "#%lu", countSend);
		if (sendto(sock, msg, PLENGHT-HEADER, 0, (struct sockaddr *)&server, slen) == -1)	// Envia a string digitada para o servidor
			erro("Sendto()");

		gettimeofday(&sendTime[countSend], NULL);
		countSend++;

		usleep(1000*tts);
	}
	return;
}

int main(int argc, char* argv[])
{
	pthread_t thr_rec, thr_send;

	if (argc != 5) {
		fprintf(stderr, "usage: %s <ip address 1> <CSV file> <bandwidth (kbps)> <n. of packets>\n\n", argv[0]);
		exit(1);
	}

    signal(SIGINT, handler);
    srand((unsigned)time(NULL));
    MEAN = ((double)8000UL*(double)PLENGHT/(double)atoi(argv[3]));
    MAX_LIMIT = atoi(argv[4]);

	if ((sock = socket(PF_INET, SOCK_DGRAM | SOCK_NONBLOCK, 0)) == -1)	// Cria o socket
		erro("Socket");
	memset((char *) &server, 0, slen);
	server.sin_family = PF_INET;
	server.sin_port = htons(PORT);
	if (inet_aton((char*)argv[1], &server.sin_addr)==0) {
		fprintf(stderr, "inet_aton() failed\n");
		exit(1);
	}

    sendTime = (struct timeval *)malloc(MAX_LIMIT*sizeof(struct timeval));
    if (sendTime == NULL)
        erro("malloc()");

    rtt = (struct timeval *)malloc(MAX_LIMIT*sizeof(struct timeval));
    if (rtt == NULL)
    	erro("malloc()");
    memset((char *)&rtt, 0, sizeof(rtt));


	pthread_create(&thr_rec,NULL,rec_func,(void *)argv;
	pthread_create(&thr_send,NULL,send_func,NULL);

	close(sock);
	return 0;
}
