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
#include <errno.h>

#define	PLENGHT	    52
#define RTOALPHA    0.90
#define PORT        34543
#define TIMEOUT     2000000
#define HEADER      42

float SINTERVAL;
unsigned long int MAX_LIMIT;

int sock;
struct sockaddr_in server[2];
unsigned int slen = sizeof(server[0]);

int *path;
struct timeval *sendtime;
float **rtt;

long unsigned int count_send = 0;
long unsigned int count_recv = 0;

void erro(char *s)
{
	perror(s);
	exit(1);
}

float usec_diff (struct timeval pos, struct timeval neg)
{
    return (1000000*(pos.tv_sec-neg.tv_sec) + (pos.tv_usec-neg.tv_usec));
}

void initialize(char **argv)
{
    long unsigned int count;

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

	return;
}

void send_func (int pathtosend, struct sockaddr_in addrtosend)
{
    char msg[PLENGHT-HEADER];   // Minus HEADER to discount all header and interpacket gaps

    sprintf(msg, "%d#%lu", pathtosend, count_send);
    path[count_send] = pathtosend;
    gettimeofday(&sendtime[count_send], NULL);
    sendto(sock, msg, PLENGHT-HEADER, 0, (struct sockaddr *)&addrtosend, slen);

    return;
}

int main(int argc, char* argv[])
{
    float srtt[2];
    struct timeval timeout_verify, temp_timeout, select_timeout;
    fd_set readfds;
    int ret;
    long unsigned int timeout_stop = 0;
    long unsigned int count_lost = 0;
    int first_recv[2];
        first_recv[0] = 1;
        first_recv[1] = 1;

    if (argc != 5) {
        fprintf(stderr, "usage: %s <ip address 1> <ip address 2> <bandwidth (kbps)> <n. of packets>\n\n", argv[0]);
        exit(1);
    }

    SINTERVAL = ((double)8000UL*(double)PLENGHT/(double)atoi(argv[3]));

    MAX_LIMIT = atoi(argv[4]);

    FILE *file_srtt = fopen("srtt.txt", "w");
    if (file_srtt == NULL) erro("fopen()");

    initialize(argv);

    FD_ZERO(&readfds);      // Initialize Select() Settings
    FD_SET(sock, &readfds);

    gettimeofday(&timeout_verify, NULL);

    while((count_recv+count_lost) < MAX_LIMIT) {

        if(count_send == 0) {   // Initial Select() Timeout
            select_timeout.tv_sec = (int)SINTERVAL/1000000;
            select_timeout.tv_usec = SINTERVAL - select_timeout.tv_sec*1000000;
        }
        else {
            struct timeval atual;
            gettimeofday(&atual, NULL);
            float diff = (count_send+1)*SINTERVAL - usec_diff(atual, sendtime[0]);
            select_timeout.tv_sec = (int)diff/1000000;
            select_timeout.tv_usec = diff - select_timeout.tv_sec*1000000;

            if(select_timeout.tv_sec < 0)
                select_timeout.tv_sec = 0;
            if(select_timeout.tv_usec < 0)
                select_timeout.tv_usec = 0;
        }

        if(count_send < MAX_LIMIT) {    // Send Packet
            send_func(0, server[0]); // Send Packet
            count_send++;
        }

        if(count_send < MAX_LIMIT) {    // Send Packet
            send_func(1, server[1]); // Send Packet
            count_send++;
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

                sscanf(msg, "%d#%d", &recvpath, &recvmsg);

                if (rtt[recvpath][recvmsg] != -1) {     // Only count if timeout has not been expired
                    rtt[recvpath][recvmsg] = usec_diff(recvtime, sendtime[recvmsg]);
                    if (first_recv[recvpath]) {     // First SRTT Calculus
                        srtt[recvpath] = rtt[recvpath][recvmsg];
                        first_recv[recvpath] = 0;
                    }
                    else    // Other SRTT Calculus
                        srtt[recvpath] = RTOALPHA*rtt[recvpath][recvmsg] + (1-RTOALPHA)*srtt[recvpath];

                    fseek(file_srtt, 0, SEEK_SET);
                    fprintf(file_srtt, "%f\n", srtt[0]);
                    fprintf(file_srtt, "%f", srtt[1]);
                    fflush(file_srtt);

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
    fclose(file_srtt);
    free(path);
    free(rtt[0]);
    free(rtt[1]);
    free(rtt);
	free(sendtime);

    return;
}
