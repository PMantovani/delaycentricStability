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
#define RTOALPHA    0.125
#define PORT        34543
#define HISTERESIS  10000
#define TIMEOUT     20000000
#define HEADER      42
#define NUMPATHS    3
#define MIN_HB_INT  500000
#define RND_HB_INT  1000000
#define MIN_TG      1000000
#define RND_TG_INT  3000000

char *file_name;
float SINTERVAL;
unsigned long int MAX_LIMIT;

int sock;
struct sockaddr_in server[NUMPATHS];
unsigned int slen = sizeof(server[0]);

int *activepath;
int *path;
struct timeval *sendtime;
float **rtt;
int flag_end = 0;

long unsigned int count_send = 0;
long unsigned int count_recv = 0;

struct timeval beginning, ending;

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
    long unsigned int pathreccount[NUMPATHS];
    float rttacum[NUMPATHS];
    int pathiter;
    for (pathiter=0;pathiter<NUMPATHS;pathiter++) {
        pathreccount[pathiter] = 0;
        rttacum[pathiter]=0;
    }

    float difftime;

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

            fprintf(file_log, "%d; %d; %.0f; %ld\n"
                    , activepath[count], path[count], rtt[path[count]][count]
                    , (1000000*sendtime[count].tv_sec+sendtime[count].tv_usec));
        }
    }

    fclose(file_log);
    free(activepath);
    free(path);
    for(pathiter=0;pathiter<NUMPATHS;pathiter++)
        free(rtt[pathiter]);
    free(rtt);
	free(sendtime);

	if (flag_end == 0)
		gettimeofday(&ending,NULL);

    difftime = usec_diff(ending, beginning);

    printf("\n------------------------------------\n");
    for (pathiter=0;pathiter<NUMPATHS;pathiter++) {
        printf("Atraso Medio Caminho %d: %.2f us\n", pathiter+1, rttacum[pathiter]/pathreccount[pathiter]);
    }
    for (pathiter=0;pathiter<NUMPATHS;pathiter++) {
        printf("Caminho %d como Principal em: %.2f%% (%lu / %lu)\n", pathiter+1, 100*(float)pathreccount[pathiter]/(float)count_send, pathreccount[pathiter], count_send);
    }
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
    int count, count2;

    activepath = (int *)malloc((MAX_LIMIT+1)*sizeof(int));
    if (activepath == NULL)
        erro("malloc()");

    path = (int *)malloc((MAX_LIMIT+1)*sizeof(int));
    if (path == NULL)
        erro("malloc()");

    rtt = (float **)malloc((MAX_LIMIT+1)*sizeof(float *));
    if (rtt == NULL)
        erro("malloc()");

    for (count=0; count<NUMPATHS; count++) {
        rtt[count] = (float *)malloc((MAX_LIMIT+1)*sizeof(float));
        if (rtt[count] == NULL)
            erro("malloc()");
    }

    sendtime = (struct timeval *)malloc((MAX_LIMIT+1)*sizeof(struct timeval));
    if (sendtime == NULL)
        erro("malloc()");

    activepath[0] = 0;
    for (count=0; count<MAX_LIMIT; count++) {
        for (count2=0; count2<NUMPATHS; count2++) rtt[count2][count] = 0;
    }

    if ((sock=socket(PF_INET, SOCK_DGRAM | SOCK_NONBLOCK, 0)) == -1)
		erro("socket");

	for (count=0; count<NUMPATHS; count++) {
        memset((char *) &server[count], 0, slen);
        server[count].sin_family = AF_INET;
        server[count].sin_port = htons(PORT);
	}

    for (count=0; count<NUMPATHS; count++) {
        if (inet_aton(argv[count+1], &server[count].sin_addr)==0) {
            fprintf(stderr, "inet_aton() failed\n");
            exit(1);
        }
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
    int     pathiter;
    float   srtt[NUMPATHS];
    struct  timeval timeout_verify, temp_timeout, select_timeout;
    float   difftimesend;
    fd_set  readfds;
    int     ret;
    int     timeout_stop = 0;
    int     count_lost = 0;
    int     first_recv[NUMPATHS];
    int     flag_tg[NUMPATHS];

    for (pathiter=0;pathiter<NUMPATHS;pathiter++) {
        first_recv[pathiter] = 1;
        flag_tg[pathiter] = 0;
    }

    if (argc != NUMPATHS+4) {
        fprintf(stderr, "usage: %s <ip address 1> <ip address 2> <ip address 3> <CSV file> <bandwidth (kbps)> <n. of packets>\n\n", argv[0]);
        exit(1);
    }

    file_name = argv[NUMPATHS+1];

    signal(SIGINT, handler);

    SINTERVAL = ((double)8000UL*(double)PLENGHT/(double)atof(argv[NUMPATHS+2]));

    MAX_LIMIT = atoi(argv[NUMPATHS+3]);

    initialize(argv);

    FD_ZERO(&readfds);      // Initialize Select() Settings
    FD_SET(sock, &readfds);

    float HBINTERVAL = MIN_HB_INT+(rand()%RND_HB_INT);   // Set Random Heartbeat Interval between 0.5 and 1.5s
    struct timeval hb; gettimeofday(&hb, NULL);

    float TG[NUMPATHS];
	struct timeval tg_time[NUMPATHS];
	for (pathiter=0;pathiter<NUMPATHS;pathiter++) {
        TG[pathiter] = MIN_TG + (rand()%RND_TG_INT);  //Set Random Guard Time between 1 and 4s
	}

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
                select_timeout.tv_usec = 1;
        }

        if(count_send < MAX_LIMIT) {    // Send Packet
            send_func(activepath[count_send], server[activepath[count_send]], PLENGHT); // Send Packet
            count_send++;
            activepath[count_send] = activepath[count_send-1];
        }
        if ((count_send >= MAX_LIMIT) && (flag_end == 0)) {
        	gettimeofday(&ending, NULL);
        	flag_end = 1;
        }

        if ((usec_diff(sendtime[count_send-1], hb) > HBINTERVAL) && (count_send < MAX_LIMIT)) {      // Send Heartbeat
        	for (pathiter=0; pathiter<NUMPATHS; pathiter++) {
                int hbpath = pathiter;

                if (activepath[count_send] != pathiter) {
                    send_func(hbpath, server[hbpath], HBLENGHT);

                    count_send++;
                    activepath[count_send] = activepath[count_send-1];
                }
        	}
        	HBINTERVAL = MIN_HB_INT+(rand()%RND_HB_INT); // Random Heartbeat Interval between MIN_HB_INT and MIN_HB_INT+RND_HB_INT
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
                int flagNotRecv = 0;
                char msg[PLENGHT-HEADER];

                recvfrom(sock, msg, PLENGHT-HEADER, 0, NULL, &slen);

                gettimeofday(&recvtime, NULL);

                sscanf(msg, "#%d#%d", &recvpath, &recvmsg);

                if (rtt[recvpath][recvmsg] != -1) {     // Only count if timeout has not been expired
                    rtt[recvpath][recvmsg] = usec_diff(recvtime, sendtime[recvmsg]);
                    if (first_recv[recvpath]) {     // First SRTT Calculus
                        srtt[recvpath] = rtt[recvpath][recvmsg];
                        first_recv[recvpath] = 0;
                    }
                    else    // Other SRTT Calculus
                        srtt[recvpath] = RTOALPHA*rtt[recvpath][recvmsg] + (1-RTOALPHA)*srtt[recvpath];

                    if(first_recv[0]==0 && first_recv[1]==0 && first_recv[2]==0) {  // Only changes path if received packets from both paths -- NOT COMPATIBLE WITH PATH EXPANSION
                        for (pathiter=0;pathiter<NUMPATHS;pathiter++) {
                            if (activepath[count_send] != pathiter) {
                                if (srtt[activepath[count_send]] >= srtt[pathiter] + HISTERESIS) {    // Uses HISTERESIS to avoid multiple path changes
                                    if (flag_tg[pathiter] == 0) {
                                        flag_tg[pathiter] = 1;
                                        gettimeofday(&tg_time[pathiter], NULL);     // Initiates Time-Guard Counter
                                    }
                                }
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

        for (pathiter=0;pathiter<NUMPATHS;pathiter++) {
            if (flag_tg[pathiter] == 1) {
                if (usec_diff(temp_timeout, tg_time[pathiter]) >= TG[pathiter]) {

                    flag_tg[pathiter] = 0;

                    if (srtt[activepath[count_send]] >= srtt[pathiter] + HISTERESIS) {
                        activepath[count_send] = pathiter;
                        int pathiter2;
                        for (pathiter2=0;pathiter2<NUMPATHS;pathiter2++) {  // Reset All Time-Guard Flags when Switchover Occurs
                            flag_tg[pathiter2] = 0;
                        }
                    }

                    TG[pathiter] = MIN_TG+(rand()%RND_TG_INT);
                }
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
    print(argv[NUMPATHS+1]);

    return;
}
