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
set(h,'XTickLabel',{'0.72','0.75','0.78','0.81','0.84','0.87','0.90','0.93','0.96','0.99'});
axis([0.72 0.99 -10 1000])
hold on

roinicio = 1;
rofinal = 10;
maxVectorSize = 200;
N = maxVectorSize;
c = tinv(0.025, N-1);

media = dlmread('RDC.csv',';',0,1);
media=media(1:maxVectorSize,:)/1000;
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals,'k-','LineWidth',5)

clear media intervals
media = dlmread('TG_HB_Alterado.csv',';',0,1);
media=media(1:maxVectorSize,:)/1000;
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals,'k-.','LineWidth',5)

clear media intervals
media = dlmread('PDC.csv',';',0,1);
media=media(1:maxVectorSize,:)/1000;
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals,'k:','LineWidth',5)

clear media intervals
media = dlmread('PDC_TG_HB_Alterado.csv',';',0,1);
media=media(1:maxVectorSize,:)/1000;
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals,'k--','LineWidth',5)

legend('RDC','RDC+Guard-Time','PDC','PDC+Guard-Time','Location','Northwest')
axis([-inf inf -10 1000])
