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
#define TIMEOUT     20000000
#define HEADER      42

char *file_name;
float SINTERVAL;
unsigned long int MAX_LIMIT;

int sock;
struct sockaddr_in server;
unsigned int slen = sizeof(server);

float *rtt;

long unsigned int count_send = 0;
long unsigned int count_recv = 0;
int flag_end = 0;

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

void print(char *filename, double ttsAcum)
{
    FILE *file_log;
    long unsigned int count;
    long unsigned int lost = 0;
    float rttacum;
          rttacum=0;
    float difftime;

    if (flag_end == 0)
	gettimeofday(&ending, NULL);

    file_log = fopen(filename, "w");
    if (file_log == NULL)
        erro("fopen");

    for(count=0; count<count_send; count++) {
        if(rtt[count] == -1) {
            lost++;
        }
        else {
            rttacum += rtt[count];
	    fprintf(file_log, "%.0f\n", rtt[count]);
        }
    }

    fclose(file_log);
    free(rtt);
    difftime = usec_diff(ending, beginning);

    printf("\n------------------------------------\n");
    printf("Media dos Intervalos de Sleep Normalizado: %.3f\n", ttsAcum/((count_send)*SINTERVAL));
    printf("Atraso Medio: %.2f us\n", rttacum/(count_send-lost));
    printf("Pacotes Perdidos: %.2f%% (%lu / %lu)\n", 100*(float)lost/(float)count_send, lost, count_send);
    printf("Banda Enviada: %.2f kbps\n", 8000UL*PLENGHT*(count_send/difftime));
    printf("Banda Recebida: %.2f kbps\n", 8000UL*PLENGHT*(count_recv/difftime));
    printf("-----------------------------------------\n\n");
    fflush(stdout);
    return;
}

void handler(int param)
{
    close(sock);

  //  print(file_name);

    exit(1);
}

void initialize(char **argv)
{
    int count;

    rtt = (float *)malloc(MAX_LIMIT*sizeof(float));
    if (rtt == NULL)
        erro("malloc()");

    for (count=0; count<MAX_LIMIT; count++) {
        rtt[count] = 0;
    }

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
    float srtt = 1000000;
    struct timeval timeout_verify, temp_timeout, select_timeout;
    struct timeval *sendtime;
    float difftimesend;
    fd_set readfds;
    int ret;
    int timeout_stop = 0;
    int count_lost = 0;
    double ttsAcum = 0;

    if (argc != 5) {
        fprintf(stderr, "usage: %s <ip address 1> <CSV file> <bandwidth (kbps)> <n. of packets>\n\n", argv[0]);
        exit(1);
    }

    file_name = argv[2];

    signal(SIGINT, handler);

    SINTERVAL = ((double)8000UL*(double)PLENGHT/(double)atof(argv[3]));
    srand((unsigned)time(NULL));
    MAX_LIMIT = atoi(argv[4]);

    sendtime = (struct timeval *)malloc(MAX_LIMIT*sizeof(struct timeval));
    if (sendtime == NULL)
        erro("malloc()");

    initialize(argv);

    FD_ZERO(&readfds);      // Initialize Select() Settings
    FD_SET(sock, &readfds);

    gettimeofday(&timeout_verify, NULL);
    beginning = timeout_verify;

    while((count_recv+count_lost) < MAX_LIMIT) {
    	float tts;

        if(count_send == 0) {
        	tts = generateLogRandomNum(SINTERVAL);
        	ttsAcum = tts;
            select_timeout.tv_sec = (int)tts/1000000;   // Calculate Select() Timeout based on SINTERVAL
            select_timeout.tv_usec = tts - select_timeout.tv_sec*1000000;
        }
        else if (count_send < MAX_LIMIT){
        	tts = generateLogRandomNum(SINTERVAL);
        	ttsAcum += tts;
            struct timeval atual;
            gettimeofday(&atual, NULL);
            float diff = ttsAcum - usec_diff(atual, sendtime[0]);
            select_timeout.tv_sec = (int)diff/1000000;
            select_timeout.tv_usec = diff - select_timeout.tv_sec*1000000;

            if(select_timeout.tv_sec < 0)
                select_timeout.tv_sec = 0;
            if(select_timeout.tv_usec < 0)
                select_timeout.tv_usec = 1;
        }

        if(count_send < MAX_LIMIT) {    // Send Packet
            send_func(&sendtime[count_send]); // Send Packet
            count_send++;
        }
        if (count_send >= MAX_LIMIT && flag_end == 0){
        	gettimeofday(&ending, NULL);
        	flag_end = 1;
        }

        do {
            ret = select(sock+1, &readfds, NULL, NULL, &select_timeout);

            if (ret == -1)      // Select() Error
                erro("select()");

            else if (ret) {      // Packet to receive
                struct timeval recvtime;
                int recvpath;
                int recvmsg;
                char msg[PLENGHT-HEADER];

                recvfrom(sock, msg, PLENGHT-HEADER, 0, NULL, &slen);

                gettimeofday(&recvtime, NULL);

                sscanf(msg, "#%d", &recvmsg);

                if (rtt[recvmsg] != -1) {     // Only count if timeout has not been expired
                    rtt[recvmsg] = usec_diff(recvtime, sendtime[recvmsg]);

                    count_recv++;
                }
            }

            FD_ZERO(&readfds);      // Initialize Select() Settings
            FD_SET(sock, &readfds);

        } while ((select_timeout.tv_sec > 0) || (select_timeout.tv_usec > 0));

        gettimeofday(&temp_timeout, NULL);
        if (usec_diff(temp_timeout, timeout_verify) >= TIMEOUT) {    // Verify if any packet has been timed out
            gettimeofday(&timeout_verify, NULL);    // Resets the counter to verify

            while(timeout_stop < count_send) {

                if (rtt[timeout_stop] > 0) {  // Packet has already been received
                }

                else if(usec_diff(timeout_verify, sendtime[timeout_stop]) >= TIMEOUT) {  // Packet has timed out
                    count_lost++;
                    rtt[timeout_stop] = -1;
                }

                else if (usec_diff(timeout_verify, sendtime[timeout_stop]) < TIMEOUT)   // Packet hasn't timed out
                    break;

                timeout_stop++;
            }
        }

    }

    close(sock);
    print(argv[2], ttsAcum);

    return;
}
