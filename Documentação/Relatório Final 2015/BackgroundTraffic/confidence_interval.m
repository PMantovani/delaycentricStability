close all
clf
clear
clc

ro=[.66 .72 .75 .78 .81 .84 .87 .90 .93 .96 .99];

h = axes;
hold on
grid on
set(h, 'FontSize', 26)
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gca,'LooseInset',get(gca,'TightInset'))
xlabel('Utilização de banda (\rho)','FontSize',26)
ylabel('Atraso médio dos pacotes (ms)','FontSize',26)
set(gca,'XTick',[.66 .72 .75 .78 .81 .84 .87 .90 .93 .96 .99])
set(gca,'YTick',0:100:1000)
set(h,'XTickLabel',{'0.66','0.72','0.75','0.78','0.81','0.84','0.87','0.90','0.93','0.96','0.99'});
axis([0.66 0.99 -10 1000])
set(gcf,'color','w');
%title('Cenários com Tráfego de Fundo')

roinicio = 1;
rofinal = 11;
maxVectorSize = 200;

media = dlmread('RDC_40_60.csv',';');
media=media/1000;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
N = maxVectorSize;
c = tinv(0.025, N-1);
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k-','LineWidth',5)
hold on
%plot(ro,mediaTotal,'r-*','LineWidth',2)

clear media mediaTotal intervals
media = dlmread('RDC_TG_40_60.csv',';');
media=media/1000;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
N = maxVectorSize;
c = tinv(0.025, N-1);
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k-.','LineWidth',5)
hold on
%plot(ro,mediaTotal,'r-*','LineWidth',2)

clear media mediaTotal intervals
media = dlmread('PDC_40_60.csv',';');
media=media/1000;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
N = maxVectorSize;
c = tinv(0.025, N-1);
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k--','LineWidth',5)
hold on
%plot(ro,mediaTotal,'r-*','LineWidth',2)

clear media mediaTotal intervals
media = dlmread('PDC_TG_40_60.csv',';');
media=media/1000;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
N = maxVectorSize;
c = tinv(0.025, N-1);
intervals = c.*nanstd(media)./sqrt(N);
errorbar(ro,nanmean(media),intervals, 'k:','LineWidth',5)
hold on
%plot(ro,mediaTotal,'r-*','LineWidth',2)

[hL, hO] = legend('Delay-centric','Delay-centric com tempo de guarda','Delay-centric preditivo','Delay-centric preditivo com tempo de guarda','Location','Northwest')
linesInPlot = findobj('type','line'); % The second one is the line we are looking for
for i=10:2:16
    pos = get(linesInPlot(i),'XData') % returns 0.1231 0.7385
    set(linesInPlot(i),'XData',[pos(1) pos(2)+0.015]) % so that new length < 0.5*original, right?
end
textInPlot = findobj('type','text'); % The second one is the line we are looking for
for i=1:1:4
    pos = get(textInPlot(i),'Position') % returns 0.1231 0.7385
    set(textInPlot(i),'Position',[pos(1)+0.015 pos(2) 0]) % so that new length < 0.5*original, right?
end
leg_pos = get(hL,'Position');
leg_pos(3) = leg_pos(3)*1.04;
set(hL,'Position',leg_pos);
