close all
clf
clear
clc

ro=[.66 .72 .75 .78 .81 .84 .87 .90 .93 .96 .99];

h = axes;
hold on
grid on
set(h, 'FontSize', 22)
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gca,'LooseInset',get(gca,'TightInset'))
xlabel('Aggregated utilization (\rho)','FontSize',22)
ylabel('Mean packet delay (ms)','FontSize',22)
set(gca,'XTick',[.66 .72 .75 .78 .81 .84 .87 .90 .93 .96 .99])
set(gca,'YTick',[0 100 200 300 400 500 600 700 800 900 1000])
set(h,'XTickLabel',{'0.66','0.72','0.75','0.78','0.81','0.84','0.87','0.90','0.93','0.96','0.99'});
axis([0.66 0.99 -10 1000])
title('Predictive Delay-centric with Guard-Time (1s~4s) and HB reduction (20ms)')

roinicio = 1;
rofinal = 11;
maxVectorSize = 200;

media = dlmread('Method1.csv',';');
media=media/1000;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
N = maxVectorSize;
c = tinv(0.025, N-1);
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k-','LineWidth',4)
hold on
%plot(ro,mediaTotal,'r-*','LineWidth',2)

clear media mediaTotal intervals
media = dlmread('Method2.csv',';');
media=media/1000;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
N = maxVectorSize;
c = tinv(0.025, N-1);
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'r:','LineWidth',4)
hold on
%plot(ro,mediaTotal,'r-*','LineWidth',2)

legend('Primary Path Trend','All Paths Trend Comparison','Location','Northwest')