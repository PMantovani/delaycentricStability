clear
clc

M = dlmread('D:\Dropbox\Iniciacao\Programas\udp3\rtt.csv', ';');

[x y] = size(M);

seq = 1:1:x;
plost = M(:,1); % 1 for Packet Lost
path = M(:,2);
perc0 = M(:,3);
perc1 = M(:,4);
rtt0 = M(:,5);
rtt1 = M(:,6);
srtt0 = M(:,7);
srtt1 = M(:,8);
teta0 = M(:,9);
teta1 = M(:,10);
activepath = M(:,11);

perc0 = perc0 * 100;
perc1 = perc1 * 100;
temp1 = max(perc0);
temp2 = max(perc1);
if (temp2 > temp1);
    temp1 = temp2;
end

for i=1:x
    if (path(i) == 0)
        plost1(i) = NaN;
        if (plost(i) == 1)
            plost0(i) = temp1/2;
        else
            plost0(i) = NaN;
        end
    else
        plost0(i) = NaN;
        if (plost(i) == 1)
            plost1(i) = temp1/2;
        else
            plost1(i) = NaN;
        end
    end
end

temp1 = max(teta0);
temp2 = max(teta1);
if (temp2 > temp1)
    temp1 = temp2;
end

activepath = activepath * temp1/2;


subplot(3,1,1)
plot(seq, rtt0, 'b.', seq, rtt1, 'r.', seq, srtt0, 'b', seq, srtt1, 'r')
legend('RTT Path 0', 'RTT Path 1', 'SRTT Path 0', 'SRTT Path 1')
title ('Delay Analysis')
ylabel ('Time in microseconds')
xlabel ('Packet Sequence')


subplot(3,1,2)
plot(seq, plost0, 'b*', seq, plost1, 'r*', seq, perc0, 'b', seq, perc1, 'r')
legend('Packet Lost 0', 'Packet Lost 1', '% Packet Loss 0', '% Packet Loss 1')
title ('Packet Loss Analysis')
ylabel ('Packet Loss Percentage (considers last 50)')
xlabel ('Packet Sequence')


subplot(3,1,3)
plot(seq, teta0, 'b--', seq, teta1, 'r--', seq, activepath, 'k')
legend('Teta Path 0', 'Teta Path 1', 'Active Path')
title ('Path Quality Analysis')
ylabel ('Teta Index')
xlabel ('Packet Sequence')
axis ([-Inf Inf -.1 1.1])