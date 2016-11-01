clear all
clc

h = axes;
hold on
grid on
set(h, 'FontSize', 26)
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gca,'LooseInset',get(gca,'TightInset'))
xlabel('Time (s)','FontSize',26)
ylabel('Transmissions in Path 1','FontSize',26)
set(gca,'YTick',[0 1 2 3 4 5 6])
axis([-inf inf -.1 6.1])
title('Path distribution in RDC with background traffic')


cd('BG_RDC\1\0.96')
info1 = dlmread('1.csv',';');
path1 = info1(1:end,1);
time1 = (info1(1:end,4))/1000;
minimo(1) = min(time1);
maximo(1) = max(time1);

info2 = dlmread('2.csv',';');
path2 = info2(1:end,1);
time2 = (info2(1:end,4))/1000;
minimo(2) = min(time2);
maximo(2) = max(time2);

info3 = dlmread('3.csv',';');
path3 = info3(1:end,1);
time3 = (info3(1:end,4))/1000;
minimo(3) = min(time3);
maximo(3) = max(time3);

info4 = dlmread('4.csv',';');
path4 = info4(1:end,1);
time4 = (info4(1:end,4))/1000;
minimo(4) = min(time4);
maximo(4) = max(time4);

info5 = dlmread('5.csv',';');
path5 = info5(1:end,1);
time5 = (info5(1:end,4))/1000;
minimo(5) = min(time5);
maximo(5) = max(time5);

info6 = dlmread('6.csv',';');
path6 = info6(1:end,1);
time6 = (info6(1:end,4))/1000;
minimo(6) = min(time6);
maximo(6) = max(time6);

timeInterp = linspace(max(minimo), min(maximo), 3000);
pathInterp1 = interp1(time1, path1, timeInterp,'Linear');
pathInterp2 = interp1(time2, path2, timeInterp,'Linear');
pathInterp3 = interp1(time3, path3, timeInterp,'Linear');
pathInterp4 = interp1(time4, path4, timeInterp,'Linear');
pathInterp5 = interp1(time5, path5, timeInterp,'Linear');
pathInterp6 = interp1(time6, path6, timeInterp,'Linear');
pathSum = 6 - (pathInterp1 + pathInterp2 + pathInterp3 + pathInterp4 + pathInterp5 + pathInterp6);
timeInterp = (timeInterp-timeInterp(1))/1000;

cd('../../..')
plot(timeInterp, pathSum,'LineWidth',5)