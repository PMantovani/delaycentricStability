clear all
clc

h = axes;
hold on
grid on
set(h, 'FontSize', 26)
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gca,'LooseInset',get(gca,'TightInset'))
title('Instability scenario in RDC')
alfa = 0.125;


%cd('estab\1\0.96')
cd('instab\1\0.96')    % Usei porque o meu arquivo está em outra pasta
%cd('..\PDC_CBR+BG\BG_PDC+TG\1\0.96')
%cd('..\RDC_CBR+BG\BG_RDC\1\0.96')
info1 = dlmread('1.csv',';');   % Ler o arquivo log da transmissão 1
activePath1 = info1(1:end,1);   % Caminho ativo, usado no primeiro gráfico
time1 = (info1(1:end,4))/1000;  % Timestamp do tempo do envio cada pacote
path1 = info1(1:end,2);         % Caminho pelo qual o pacote foi enviado
rtt1 = info1(1:end,3)/1000;     % RTT do pacote

info2 = dlmread('2.csv',';');   % Ler o arquivo log da transmissão 2
activePath2 = info2(1:end,1);   % Caminho ativo, usado no primeiro gráfico
time2 = (info2(1:end,4))/1000;  % Timestamp do tempo do envio cada pacote
path2 = info2(1:end,2);         % Caminho pelo qual o pacote foi enviado
rtt2 = info2(1:end,3)/1000;     % RTT do pacote

info3 = dlmread('3.csv',';');   % Ler o arquivo log da transmissão 3
activePath3 = info3(1:end,1);   % Caminho ativo, usado no primeiro gráfico
time3 = (info3(1:end,4))/1000;  % Timestamp do tempo do envio cada pacote
path3 = info3(1:end,2);         % Caminho pelo qual o pacote foi enviado
rtt3 = info3(1:end,3)/1000;     % RTT do pacote

info4 = dlmread('4.csv',';');   % Ler o arquivo log da transmissão 4
activePath4 = info4(1:end,1);   % Caminho ativo, usado no primeiro gráfico
time4 = (info4(1:end,4))/1000;  % Timestamp do tempo do envio cada pacote
path4 = info4(1:end,2);         % Caminho pelo qual o pacote foi enviado
rtt4 = info4(1:end,3)/1000;     % RTT do pacote

info5 = dlmread('5.csv',';');   % Ler o arquivo log da transmissão 5
activePath5 = info5(1:end,1);   % Caminho ativo, usado no primeiro gráfico
time5 = (info5(1:end,4))/1000;  % Timestamp do tempo do envio cada pacote
path5 = info5(1:end,2);         % Caminho pelo qual o pacote foi enviado
rtt5 = info5(1:end,3)/1000;     % RTT do pacote

info6 = dlmread('6.csv',';');   % Ler o arquivo log da transmissão 1
activePath6 = info6(1:end,1);   % Caminho ativo, usado no primeiro gráfico
time6 = (info6(1:end,4))/1000;  % Timestamp do tempo do envio cada pacote
path6 = info6(1:end,2);         % Caminho pelo qual o pacote foi enviado
rtt6 = info6(1:end,3)/1000;     % RTT do pacote

minTimes(1) = min(time1); 
minTimes(2) = min(time2); 
minTimes(3) = min(time3); 
minTimes(4) = min(time4); 
minTimes(5) = min(time5); 
minTimes(6) = min(time6); 
minTime = min(minTimes);        % Obter o menor tempo das 6 transmissões

maxTimes(1) = max(time1); 
maxTimes(2) = max(time2); 
maxTimes(3) = max(time3); 
maxTimes(4) = max(time4); 
maxTimes(5) = max(time5); 
maxTimes(6) = max(time6); 
maxTime = max(maxTimes);        % Obter o maior tempo das 6 transmissões

timeInterp = linspace(minTime, maxTime, 3000); % Vetor para interpolação dos caminhos
activePathInterp1 = interp1(time1, activePath1, timeInterp, 'Linear');    % Interpolação dos caminhos
activePathInterp2 = interp1(time2, activePath2, timeInterp, 'Linear');
activePathInterp3 = interp1(time3, activePath3, timeInterp, 'Linear');
activePathInterp4 = interp1(time4, activePath4, timeInterp, 'Linear');
activePathInterp5 = interp1(time5, activePath5, timeInterp, 'Linear');
activePathInterp6 = interp1(time6, activePath6, timeInterp, 'Linear');

timeInterp = (timeInterp-timeInterp(1))/1000;   % Tempo inicial = 0s
activePath = 6 - (activePathInterp1 + activePathInterp2 + activePathInterp3 + activePathInterp4 + activePathInterp5 + activePathInterp6);
subplot(3,1,1)
plot(timeInterp, activePath)
xlabel('Time (s)')
ylabel('Number of transmissions in Path 1')
axis([0 timeInterp(3000) -.1 6.1])
grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count1 = 1;   % Contador de pacotes no caminho 1    
count2 = 1;   % Contador de pacotes no caminho 2
for i=1:size(info1,1)
    if (path1(i) == 0)  % Caminho 1
        rttPath1(count1) = rtt1(i); % RTT dos pacotes do caminho 1
        timePath1(count1) = time1(i) + rttPath1(count1);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count1 == 1)
            srttPath1(1) = rttPath1(1); % SRTT = RTT
        else
            srttPath1(count1) = (1-alfa)*srttPath1(count1-1)+alfa*rttPath1(count1); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count1=count1+1;   
    else % Caminho 2
        rttPath2(count2) = rtt1(i); % RTT dos pacotes do caminho 1
        timePath2(count2) = time1(i) + rttPath2(count2);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count2 == 1) 
            srttPath2(1) = rttPath2(1); % SRTT = RTT
        else
            srttPath2(count2) = (1-alfa)*srttPath2(count2-1)+alfa*rttPath2(count2); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count2=count2+1;
    end
end

timePath1 = (timePath1-minTime)/1000;
timePath2 = (timePath2-minTime)/1000;


subplot(3,1,2)
plot(timePath1, rttPath1,'b*-',timePath1, srttPath1,'b--')
hold on
plot(timePath2, rttPath2,'r*-',timePath2, srttPath2,'r--')
plot(timeInterp, activePathInterp1*max(rttPath1),'k','LineWidth',3)
legend('RTT Path 1', 'SRTT Path 1', 'RTT Path 2', 'SRTT Path 2','Location','Northeast')
xlabel('Time Received (s)')
ylabel('Packet Delay (ms)')
axis([0 timeInterp(3000) -inf inf])
grid on

clear count1 count2 i rttPath1 rttPath2 timePath1 timePath2 srttPath1 srttPath2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count1 = 1;   % Contador de pacotes no caminho 1    
count2 = 1;   % Contador de pacotes no caminho 2
for i=1:size(info1,1)
    if (path1(i) == 0)  % Caminho 1
        rttPath1(count1) = rtt1(i); % RTT dos pacotes do caminho 1
        timePath1(count1) = time1(i);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count1 == 1)
            srttPath1(1) = rttPath1(1); % SRTT = RTT
        else
            srttPath1(count1) = (1-alfa)*srttPath1(count1-1)+alfa*rttPath1(count1); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count1=count1+1;   
    else % Caminho 2
        rttPath2(count2) = rtt1(i); % RTT dos pacotes do caminho 1
        timePath2(count2) = time1(i);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count2 == 1) 
            srttPath2(1) = rttPath2(1); % SRTT = RTT
        else
            srttPath2(count2) = (1-alfa)*srttPath2(count2-1)+alfa*rttPath2(count2); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count2=count2+1;
    end
end

timePath1 = (timePath1-minTime)/1000;
timePath2 = (timePath2-minTime)/1000;


subplot(3,1,3)
plot(timePath1, rttPath1,'b*-',timePath1, srttPath1,'b--')
hold on
plot(timePath2, rttPath2,'r*-',timePath2, srttPath2,'r--')
plot(timeInterp, activePathInterp1*max(rttPath1),'k','LineWidth',3)
legend('RTT Path 1', 'SRTT Path 1', 'RTT Path 2', 'SRTT Path 2','Location','Northeast')
xlabel('Time Sent (s)')
ylabel('Packet Delay (ms)')
axis([0 timeInterp(3000) -inf inf])
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
count1 = 1;   % Contador de pacotes no caminho 1    
count2 = 1;   % Contador de pacotes no caminho 2
for i=1:size(info2,1)
    if (path2(i) == 0)  % Caminho 1
        rttPath1(count1) = rtt2(i); % RTT dos pacotes do caminho 1
        timePath1(count1) = time2(i) + rttPath1(count1);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count1 == 1)
            srttPath1(1) = rttPath1(1); % SRTT = RTT
        else
            srttPath1(count1) = (1-alfa)*srttPath1(count1-1)+alfa*rttPath1(count1); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count1=count1+1;   
    else % Caminho 2
        rttPath2(count2) = rtt2(i); % RTT dos pacotes do caminho 1
        timePath2(count2) = time2(i) + rttPath2(count2);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count2 == 1) 
            srttPath2(1) = rttPath2(1); % SRTT = RTT
        else
            srttPath2(count2) = (1-alfa)*srttPath2(count2-1)+alfa*rttPath2(count2); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count2=count2+1;
    end
end

timePath1 = (timePath1-minTime)/1000;
timePath2 = (timePath2-minTime)/1000;

subplot(7,1,3)
plot(timePath1, rttPath1,'b*-',timePath1, srttPath1,'b--')
hold on
plot(timePath2, rttPath2,'r*-',timePath2, srttPath2,'r--')
legend('RTT Path 1', 'SRTT Path 1', 'RTT Path 2', 'SRTT Path 2','Location','Northeast')
xlabel('Time (s)')
ylabel('Packet Delay (ms)')
axis([0 timeInterp(3000) -inf inf])
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count1 = 1;   % Contador de pacotes no caminho 1    
count2 = 1;   % Contador de pacotes no caminho 2
for i=1:size(info3,1)
    if (path3(i) == 0)  % Caminho 1
        rttPath1(count1) = rtt3(i); % RTT dos pacotes do caminho 1
        timePath1(count1) = time3(i) + rttPath1(count1);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count1 == 1)
            srttPath1(1) = rttPath1(1); % SRTT = RTT
        else
            srttPath1(count1) = (1-alfa)*srttPath1(count1-1)+alfa*rttPath1(count1); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count1=count1+1;   
    else % Caminho 2
        rttPath2(count2) = rtt3(i); % RTT dos pacotes do caminho 1
        timePath2(count2) = time3(i) + rttPath2(count2);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count2 == 1) 
            srttPath2(1) = rttPath2(1); % SRTT = RTT
        else
            srttPath2(count2) = (1-alfa)*srttPath2(count2-1)+alfa*rttPath2(count2); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count2=count2+1;
    end
end

timePath1 = (timePath1-minTime)/1000;
timePath2 = (timePath2-minTime)/1000;

subplot(7,1,4)
plot(timePath1, rttPath1,'b*-',timePath1, srttPath1,'b--')
hold on
plot(timePath2, rttPath2,'r*-',timePath2, srttPath2,'r--')
legend('RTT Path 1', 'SRTT Path 1', 'RTT Path 2', 'SRTT Path 2','Location','Northeast')
xlabel('Time (s)')
ylabel('Packet Delay (ms)')
axis([0 timeInterp(3000) -inf inf])
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count1 = 1;   % Contador de pacotes no caminho 1    
count2 = 1;   % Contador de pacotes no caminho 2
for i=1:size(info4,1)
    if (path4(i) == 0)  % Caminho 1
        rttPath1(count1) = rtt4(i); % RTT dos pacotes do caminho 1
        timePath1(count1) = time4(i) + rttPath1(count1);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count1 == 1)
            srttPath1(1) = rttPath1(1); % SRTT = RTT
        else
            srttPath1(count1) = (1-alfa)*srttPath1(count1-1)+alfa*rttPath1(count1); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count1=count1+1;   
    else % Caminho 2
        rttPath2(count2) = rtt4(i); % RTT dos pacotes do caminho 1
        timePath2(count2) = time4(i) + rttPath2(count2);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count2 == 1) 
            srttPath2(1) = rttPath2(1); % SRTT = RTT
        else
            srttPath2(count2) = (1-alfa)*srttPath2(count2-1)+alfa*rttPath2(count2); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count2=count2+1;
    end
end

timePath1 = (timePath1-minTime)/1000;
timePath2 = (timePath2-minTime)/1000;

subplot(7,1,5)
plot(timePath1, rttPath1,'b*-',timePath1, srttPath1,'b--')
hold on
plot(timePath2, rttPath2,'r*-',timePath2, srttPath2,'r--')
legend('RTT Path 1', 'SRTT Path 1', 'RTT Path 2', 'SRTT Path 2','Location','Northeast')
xlabel('Time (s)')
ylabel('Packet Delay (ms)')
axis([0 timeInterp(3000) -inf inf])
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count1 = 1;   % Contador de pacotes no caminho 1    
count2 = 1;   % Contador de pacotes no caminho 2
for i=1:size(info5,1)
    if (path5(i) == 0)  % Caminho 1
        rttPath1(count1) = rtt5(i); % RTT dos pacotes do caminho 1
        timePath1(count1) = time5(i) + rttPath1(count1);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count1 == 1)
            srttPath1(1) = rttPath1(1); % SRTT = RTT
        else
            srttPath1(count1) = (1-alfa)*srttPath1(count1-1)+alfa*rttPath1(count1); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count1=count1+1;   
    else % Caminho 2
        rttPath2(count2) = rtt5(i); % RTT dos pacotes do caminho 1
        timePath2(count2) = time5(i) + rttPath2(count2);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count2 == 1) 
            srttPath2(1) = rttPath2(1); % SRTT = RTT
        else
            srttPath2(count2) = (1-alfa)*srttPath2(count2-1)+alfa*rttPath2(count2); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count2=count2+1;
    end
end

timePath1 = (timePath1-minTime)/1000;
timePath2 = (timePath2-minTime)/1000;

subplot(7,1,6)
plot(timePath1, rttPath1,'b*-',timePath1, srttPath1,'b--')
hold on
plot(timePath2, rttPath2,'r*-',timePath2, srttPath2,'r--')
legend('RTT Path 1', 'SRTT Path 1', 'RTT Path 2', 'SRTT Path 2','Location','Northeast')
xlabel('Time (s)')
ylabel('Packet Delay (ms)')
axis([0 timeInterp(3000) -inf inf])
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count1 = 1;   % Contador de pacotes no caminho 1    
count2 = 1;   % Contador de pacotes no caminho 2
for i=1:size(info6,1)
    if (path6(i) == 0)  % Caminho 1
        rttPath1(count1) = rtt6(i); % RTT dos pacotes do caminho 1
        timePath1(count1) = time6(i) + rttPath1(count1);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count1 == 1)
            srttPath1(1) = rttPath1(1); % SRTT = RTT
        else
            srttPath1(count1) = (1-alfa)*srttPath1(count1-1)+alfa*rttPath1(count1); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count1=count1+1;   
    else % Caminho 2
        rttPath2(count2) = rtt6(i); % RTT dos pacotes do caminho 1
        timePath2(count2) = time6(i) + rttPath2(count2);    % Timestamp dos pacotes no caminho 1. Somado ao rtt do pacote porque o timestamp é do tempo no envio, não no recebimento.
        if(count2 == 1) 
            srttPath2(1) = rttPath2(1); % SRTT = RTT
        else
            srttPath2(count2) = (1-alfa)*srttPath2(count2-1)+alfa*rttPath2(count2); % SRTT = (1-ALFA)*SRTT + ALFA*RTT
        end
        count2=count2+1;
    end
end

timePath1 = (timePath1-minTime)/1000;
timePath2 = (timePath2-minTime)/1000;

subplot(7,1,7)
plot(timePath1, rttPath1,'b*-',timePath1, srttPath1,'b--')
hold on
plot(timePath2, rttPath2,'r*-',timePath2, srttPath2,'r--')
legend('RTT Path 1', 'SRTT Path 1', 'RTT Path 2', 'SRTT Path 2','Location','Northeast')
xlabel('Time (s)')
ylabel('Packet Delay (ms)')
axis([0 timeInterp(3000) -inf inf])
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd('../../..') % Não necessário
%}