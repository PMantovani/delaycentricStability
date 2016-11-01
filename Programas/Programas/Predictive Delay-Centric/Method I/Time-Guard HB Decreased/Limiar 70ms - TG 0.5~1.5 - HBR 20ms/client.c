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
#define HBLENGHT    55
#define ALPHAS      0.667
#define ALPHAL      0.154
#define PORT        34543
#define THRESHOLD	70000
#define TIMEOUT     2000000
#define HEADER      42

char *file_name;
float SINTERVAL;
unsigned long int MAX_LIMIT;

int sock;
struct sockaddr_in server[2];
unsigned int slen = sizeof(server[0]);

int *activepath;
int *path;
struct timeval *sendtime;
float **rtt;

long unsigned int count_send = 0;
long unsigned int count_recv = 0;

struct timeval beginning;

void erro(char *s)
{
	perror(s);
	exit(1);
}

float usec_diff (struct timeval pos, struct timeval neg)
{
    return (1000000*(pos.tv_sec-neg.tv_sec) + (pos.tv_usec-neg.tv_usec));
}

void print(char *filename)
{
    FILE *file_log;
    char filename_final[20];
    long unsigned int count;
    long unsigned int lost = 0;
    long unsigned int pathacum = 0;
    long unsigned int pathreccount[2];
                      pathreccount[0] = 0;
                      pathreccount[1] = 0;
    float rttacum[2];
          rttacum[0]=0;
          rttacum[1]=0;
    struct timeval ending;
    float difftime;

    gettimeofday(&ending, NULL);

    strcpy(filename_final, filename);
    strcat(filename_final, ".csv");
    file_log = fopen(filename_final, "w");
    if (file_log == NULL)
        erro("fopen");

    for(count=0; count<count_send; count++) {
        if(rtt[path[count]][count] == -1) {
            lost++;
        }
        else {
            rttacum[path[count]] += rtt[path[count]][count];
            pathreccount[path[count]]++;
        }
        pathacum += (1-activepath[count]);

        fprintf(file_log, "%d; %d; %.0f; %ld\n"
                , activepath[count], path[count], rtt[path[count]][count]
                , (1000000*sendtime[count].tv_sec+sendtime[count].tv_usec));
    }

    fclose(file_log);
    free(activepath);
    free(path);
    free(rtt[0]);
    free(rtt[1]);
    free(rtt);
	free(sendtime);

    difftime = usec_diff(ending, beginning);

    printf("\n------------------------------------\n");
    printf("Atraso Medio Caminho 1: %.2f us\n", rttacum[0]/pathreccount[0]);
    printf("Atraso Medio Caminho 2: %.2f us\n", rttacum[1]/pathreccount[1]);
    printf("Caminho 1 como Principal em: %.2f%% (%lu / %lu)\n", 100*(float)pathacum/(float)count_send, pathacum, count_send);
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

    print(file_name);

    exit(1);
}

void initialize(char **argv)
{
    int count;

    activepath = (int *)malloc((MAX_LIMIT+1)*sizeof(int));
    if (activepath == NULL)
        erro("malloc()");

    path = (int *)malloc((MAX_LIMIT+1)*sizeof(int));
    if (path == NULL)
        erro("malloc()");

    rtt = (float **)malloc((MAX_LIMIT+1)*sizeof(float *));
    if (rtt == NULL)
        erro("malloc()");

    for (count=0; count<2; count++) {
        rtt[count] = (float *)malloc((MAX_LIMIT+1)*sizeof(float));
        if (rtt[count] == NULL)
            erro("malloc()");
    }

    sendtime = (struct timeval *)malloc((MAX_LIMIT+1)*sizeof(struct timeval));
    if (sendtime == NULL)
        erro("malloc()");

    activepath[0] = 0;
    for (count=0; count<MAX_LIMIT; count++) {
        rtt[0][count] = 0;
        rtt[1][count] = 0;
    }

    if ((sock=socket(PF_INET, SOCK_DGRAM | SOCK_NONBLOCK, 0)) == -1)
		erro("socket");

	for (count=0; count<2; count++) {
        memset((char *) &server[count], 0, slen);
        server[count].sin_family = AF_INET;
        server[count].sin_port = htons(PORT);
	}

	if (inet_aton(argv[1], &server[0].sin_addr)==0) {
        fprintf(stderr, "inet_aton() failed\n");
        exit(1);
	}

	if (inet_aton(argv[2], &server[1].sin_addr)==0) {
        fprintf(stderr, "inet_aton() failed\n");
        exit(1);
	}

	struct timeval t;
	gettimeofday(&t, NULL);
	srand((unsigned int)t.tv_usec);
	int r = (rand()%1000000);
	usleep(r);

	return;
}

void send_func (int pathtosend, struct sockaddr_in addrtosend, unsigned int packlenght)
{
    char msg[packlenght-HEADER];   // Minus HEADER to discount all headers until layer 2

    sprintf(msg, "#%d#%lu", pathtosend, count_send);
    path[count_send] = pathtosend;
    gettimeofday(&sendtime[count_send], NULL);
    sendto(sock, msg, packlenght-HEADER, 0, (struct sockaddr *)&addrtosend, slen);

    return;
}

int main(int argc, char* argv[])
{
    float srtts[2];
    float srttl[2];
    struct timeval timeout_verify, temp_timeout, select_timeout;
    float difftimesend;
    fd_set readfds;
    int ret;
    int timeout_stop = 0;
    int count_lost = 0;
    int first_recv[2];
        first_recv[0] = 1;
        first_recv[1] = 1;
    int flag_tg = 0;


    if (argc != 6) {
        fprintf(stderr, "usage: %s <ip address 1> <ip address 2> <CSV file> <bandwidth (kbps)> <n. of packets>\n\n", argv[0]);
        exit(1);
    }

    file_name = argv[3];

    signal(SIGINT, handler);

    SINTERVAL = ((double)8000UL*(double)PLENGHT/(double)atof(argv[4]));
    MAX_LIMIT = atoi(argv[5]);

    initialize(argv);

    FD_ZERO(&readfds);      // Initialize Select() Settings
    FD_SET(sock, &readfds);

    float HBINTERVAL = 500000+(rand()%1000000);   // Set Random Heartbeat Interval between 0.5 and 1.5s
    struct timeval hb; gettimeofday(&hb, NULL);

    float TG = 500000+(rand()%1000000);   // Set Random Guard Time between 0.5 and 1.5s
    struct timeval tg_time;

    gettimeofday(&timeout_verify, NULL);
    beginning = timeout_verify;

    while((count_recv+count_lost) < MAX_LIMIT) {

        if(count_send == 0) {   // Initial Select() Timeout
            select_timeout.tv_sec = (int)SINTERVAL/1000000;
            select_timeout.tv_usec = SINTERVAL - select_timeout.tv_sec*1000000;
        }
        else {   // Calculate Select() Timeout based on iteration time
            struct timeval atual;
            gettimeofday(&atual, NULL);

            float diff = (count_send+2)*SINTERVAL - usec_diff(atual, sendtime[0]);
            select_timeout.tv_sec = (int)diff/1000000;
            select_timeout.tv_usec = diff - select_timeout.tv_sec*1000000;

            if(select_timeout.tv_sec < 0)
                select_timeout.tv_sec = 0;
            if(select_timeout.tv_usec < 0)
                select_timeout.tv_usec = 0;
        }

        if(count_send < MAX_LIMIT) {    // Send Packet
            send_func(activepath[count_send], server[activepath[count_send]], PLENGHT); // Send Packet
            count_send++;
            activepath[count_send] = activepath[count_send-1];
        }

        if ((usec_diff(sendtime[count_send-1], hb) > HBINTERVAL) && (count_send < MAX_LIMIT)) {      // Send Heartbeat
            int hbpath;

            if (activepath[count_send])
                hbpath = 0;
            else hbpath = 1;

            send_func(hbpath, server[hbpath], HBLENGHT);

            count_send++;
            activepath[count_send] = activepath[count_send-1];

            if (flag_tg == 0) HBINTERVAL = 500000+(rand()%1000000);   // Set Random Heartbeat Interval between 0.5 and 1.5s if TG isn't active

            gettimeofday(&hb, NULL);
        }

        do {    // Read Socket Status
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

                sscanf(msg, "#%d#%d", &recvpath, &recvmsg);

                if (rtt[recvpath][recvmsg] != -1) {     // Only count if timeout has not been expired
                    rtt[recvpath][recvmsg] = usec_diff(recvtime, sendtime[recvmsg]);
                    if (first_recv[recvpath]) {     // First SRTT Calculus
                        srttl[recvpath] = srtts[recvpath] = rtt[recvpath][recvmsg];
                        first_recv[recvpath] = 0;
                    }
                    else {   // Other SRTT Calculus
                        srtts[recvpath] = ALPHAS*rtt[recvpath][recvmsg] + (1-ALPHAS)*srtts[recvpath];
                        srttl[recvpath] = ALPHAL*rtt[recvpath][recvmsg] + (1-ALPHAL)*srttl[recvpath];
                    }

                    if(first_recv[0]==0 && first_recv[1]==0) {  // Only changes path if received packets from both pathes
                        float d = srtts[activepath[count_send]] - srttl[activepath[count_send]];

                        if (activepath[count_send] == 0) {
                        	if ((d > 0) && (srtts[0] > THRESHOLD) && (srtts[1] < srtts[0]) && (flag_tg==0)) {
                        		flag_tg = 1;
                        		HBINTERVAL = 20000;
                        		gettimeofday(&tg_time, NULL);
                        	}
                        }

                        else if (activepath[count_send] == 1) {
                        	if ((d > 0) && (srtts[1] > THRESHOLD) && (srtts[0] < srtts[1]) && (flag_tg==0)) {
                        		flag_tg = 1;
                        		HBINTERVAL = 20000;
                        		gettimeofday(&tg_time, NULL);
                        	}
                        }
                    }

                    count_recv++;
                }
            }

            FD_ZERO(&readfds);      // Initialize Select() Settings
            FD_SET(sock, &readfds);

        } while ((select_timeout.tv_sec > 0) || (select_timeout.tv_usec > 0));

        gettimeofday(&temp_timeout, NULL);

        if (flag_tg == 1) {
            if (usec_diff(temp_timeout, tg_time) >= TG) {
                float d = srtts[activepath[count_send]] - srttl[activepath[count_send]];
                flag_tg = 0;

                if(activepath[count_send] == 0) {
                	if ((d > 0) && (srtts[0] > THRESHOLD) && (srtts[1] < srtts[0])) {
                		activepath[count_send] = 1;
                	}
                }

                else if(activepath[count_send] == 1) {
                	if ((d > 0) && (srtts[1] > THRESHOLD) && (srtts[0] < srtts[1])) {
                		activepath[count_send] = 0;
                	}
                }

                HBINTERVAL = 500000+(rand()%1000000);
                TG = 500000+(rand()%1000000);
            }
        }

        if (usec_diff(temp_timeout, timeout_verify) >= TIMEOUT) {    // Verify if any packet has been timed out
            gettimeofday(&timeout_verify, NULL);    // Resets the counter to verify

            while(timeout_stop < count_send) {

                if (rtt[path[timeout_stop]][timeout_stop] > 0) {  // Packet has already been received
                }

                else if(usec_diff(timeout_verify, sendtime[timeout_stop]) >= TIMEOUT) {  // Packet has timed out
                    count_lost++;
                    rtt[path[timeout_stop]][timeout_stop] = -1;
                }

                else if (usec_diff(timeout_verify, sendtime[timeout_stop]) < TIMEOUT)   // Packet hasn't timed out
                    break;

                timeout_stop++;
            }
        }
    }

    close(sock);
    print(argv[3]);

    return;
}
