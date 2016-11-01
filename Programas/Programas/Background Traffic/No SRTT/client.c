#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <math.h>
#include <signal.h>
#include <errno.h>

#define	PLENGHT	    250
#define PORT        34543
#define HEADER      42

float SINTERVAL;
unsigned long int MAX_LIMIT;

int sock;
struct sockaddr_in server;
unsigned int slen = sizeof(server);

long unsigned int count_send = 0;

struct timeval beginning, ending;

void erro(char *s)
{
	perror(s);
	exit(1);
}

double generateLogRandomNum(double mean)
{
    double temp;

    temp = (double)rand() / (double)RAND_MAX;
    temp = -log(temp);

//    if (temp > 5)
  //  	temp = 5;

    return (mean * temp);
}

float usec_diff (struct timeval pos, struct timeval neg)
{
    return (1000000*(pos.tv_sec-neg.tv_sec) + (pos.tv_usec-neg.tv_usec));
}

void print(double ttsAcum)
{
    float difftime;
    gettimeofday(&ending,NULL);
    difftime = usec_diff(ending, beginning);

    printf("\n------------------------------------ Trafego Exponencial\n");
    printf("Media dos Intervalos de Sleep Normalizado: %.3f\n", ttsAcum/((count_send)*SINTERVAL));
    printf("Banda Enviada: %.2f kbps\n", 8000UL*PLENGHT*(count_send/difftime));
    printf("-----------------------------------------\n\n");
    fflush(stdout);
    return;
}

void handler(int param)
{
    close(sock);

    exit(1);
}

void initialize(char **argv)
{
    if ((sock=socket(PF_INET, SOCK_DGRAM | SOCK_NONBLOCK, 0)) == -1)
		erro("socket");

    memset((char *) &server, 0, slen);
    server.sin_family = AF_INET;
    server.sin_port = htons(PORT);

	if (inet_aton(argv[1], &server.sin_addr)==0) {
        fprintf(stderr, "inet_aton() failed\n");
        exit(1);
	}

	return;
}

void send_func (struct timeval* sendtime)
{
    char msg[PLENGHT-HEADER];   // Minus HEADER to discount all header and interpacket gaps

    sprintf(msg, "#%lu", count_send);
    gettimeofday(sendtime, NULL);
    sendto(sock, msg, PLENGHT-HEADER, 0, (struct sockaddr *)&server, slen);

    return;
}

int main(int argc, char* argv[])
{
    struct timeval sleepTime;
    struct timeval *sendtime;
    double ttsAcum = 0;

    if (argc != 4) {
        fprintf(stderr, "usage: %s <ip address 1> <bandwidth (kbps)> <n. of packets>\n\n", argv[0]);
        exit(1);
    }

    signal(SIGINT, handler);

    SINTERVAL = ((double)8000UL*(double)PLENGHT/(double)atof(argv[2]));
    MAX_LIMIT = atoi(argv[3]);

    sendtime = (struct timeval *)malloc(MAX_LIMIT*sizeof(struct timeval));
    if (sendtime == NULL)
        erro("malloc()");

    initialize(argv);

    gettimeofday(&beginning, NULL);
    srand((unsigned)beginning.tv_usec);

    while(count_send < MAX_LIMIT) {
    	float tts;
    	float n;

        if(count_send == 0) {
        	tts = generateLogRandomNum(SINTERVAL);
        	ttsAcum = tts;
            sleepTime.tv_sec = (int)tts/1000000;   // Calculate Sleep Time based on random SINTERVAL
            sleepTime.tv_usec = tts - sleepTime.tv_sec*1000000;
        }
        else {
        	tts = generateLogRandomNum(SINTERVAL);
        	ttsAcum += tts;

            struct timeval atual;
            gettimeofday(&atual, NULL);
            float diff = ttsAcum - usec_diff(atual, sendtime[0]);
            sleepTime.tv_sec = (int)diff/1000000;
            sleepTime.tv_usec = diff - sleepTime.tv_sec*1000000;

            if(sleepTime.tv_sec < 0)
            	sleepTime.tv_sec = 0;
            if(sleepTime.tv_usec < 0)
            	sleepTime.tv_usec = 1;
        }

        send_func(&sendtime[count_send]); // Send Packet
        count_send++;

        usleep(sleepTime.tv_usec);	//Sleep Time
        if (sleepTime.tv_sec != 0) {
        	for (n=0; n<1000000; n++) {
        		usleep(sleepTime.tv_sec);
        	}
        }
    }

    close(sock);
    print(ttsAcum);

    return;
}
