close all
clf
clear
clc

ro=[.72 .75 .78 .81 .84 .87 .90 .93 .96 .99];

h = axes;
hold on
grid on
set(h, 'FontSize', 26)
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gca,'LooseInset',get(gca,'TightInset'))
xlabel('Aggregated utilization (\rho)','FontSize',26)
ylabel('Mean packet delay (ms)','FontSize',26)
set(gca,'XTick',[.72 .75 .78 .81 .84 .87 .90 .93 .96 .99])
set(gca,'YTick',[0 200 400 600 800 1000])
set(h,'XTickLabel',{'0.72','0.75','0.78','0.81','0.84','0.87','0.90','0.93','0.96','0.99'});
axis([0.72 0.99 -10 1000])
%title('Cenários com Tráfego de Fundo')

roinicio = 1;
rofinal = 10;
maxVectorSize = 200;

media = dlmread('RDC_40_60.csv',';',0,1);
media=media/1000;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
N = maxVectorSize;
c = tinv(0.025, N-1);
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k-','LineWidth',5)
hold on
%plot(ro,mediaTotal,'r-*','LineWidth',2)

clear media mediaTotal intervals
media = dlmread('RDC_TG_40_60.csv',';',0,1);
media=media/1000;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
N = maxVectorSize;
c = tinv(0.025, N-1);
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k-.','LineWidth',5)
hold on
%plot(ro,mediaTotal,'r-*','LineWidth',2)

clear media mediaTotal intervals
media = dlmread('PDC_40_60.csv',';',0,1);
media=media/1000;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
N = maxVectorSize;
c = tinv(0.025, N-1);
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k--','LineWidth',5)
hold on
%plot(ro,mediaTotal,'r-*','LineWidth',2)

clear media mediaTotal intervals
media = dlmread('PDC_TG_40_60.csv',';',0,1);
media=media/1000;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
N = maxVectorSize;
c = tinv(0.025, N-1);
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k:','LineWidth',5)
hold on
%plot(ro,mediaTotal,'r-*','LineWidth',2)

legend('Delay-centric','Delay-centric with guard-time','Predictive delay-centric','Predictive delay-centric with guard-time','Location','Northwest')