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
%title('Predictive Delay-centric with Guard-Time (1s~4s) and HB reduction (20ms)')

roinicio = 2;
rofinal = 11;
maxVectorSize = 200;
N = maxVectorSize;
c = tinv(0.025, N-1);

media = dlmread('Method1NoTG.csv',';',0,roinicio-1);
media=media/1000;
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k-','LineWidth',5)
hold on

clear media intervals
media = dlmread('Method2NoTG.csv',';',0,roinicio-1);
media=media/1000;
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k--','LineWidth',5)
hold on

clear media intervals
media = dlmread('Method1TG.csv',';',0,roinicio-1);
media=media/1000;
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k:','LineWidth',5)
hold on

clear media intervals
media = dlmread('Method2TG.csv',';',0,roinicio-1);
media=media/1000;
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k-.','LineWidth',5)
hold on

legend('Original PDC','Modified PDC','Original PDC + Guard-Time','Modified PDC + Guard-Time','Location','Northwest')