close all
clear
clc

h=axes;
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gca,'LooseInset',get(gca,'TightInset'))

media = dlmread('D:\Dropbox\Iniciacao\Resultados Testes\Multi-Agente\L 250B H 10ms HB 0.5-1.5s\medias_testes.csv',';');

testes = 1:10:2000;

media2 = media(:,8)/1000;
for i=1:200
    atraso(i)=100*mean(media2(1:10*i)/mean(media2(1:2000)));
    if (atraso(i) >= 100)
        atraso(i)=atraso(i)-100;
    else
        atraso(i)=100-atraso(i);
    end
end
h(1) = subplot(3,1,1)
set(h(1),'YTickLabel',{'0%','10%','20%','30%','40%'});
plot(testes, atraso,'LineWidth',2)
grid on
title('\rho = 0.90','FontSize',17)

media2 = media(:,9)/1000;
for i=1:200
    atraso(i)=100*mean(media2(1:10*i))/mean(media2(1:2000));
    if (atraso(i) >= 100)
        atraso(i)=atraso(i)-100;
    else
        atraso(i)=100-atraso(i);
    end
end
h(2) = subplot(3,1,2)
plot(testes, atraso,'LineWidth',2)
grid on
ylabel('Erro percentual das médias','FontSize',18)
title('\rho = 0.93','FontSize',17)

media2 = media(:,10)/1000;
for i=1:200
    atraso(i)=100*mean(media2(1:10*i))/mean(media2(1:2000));
    if (atraso(i) >= 100)
        atraso(i)=atraso(i)-100;
    else
        atraso(i)=100-atraso(i);
    end
end
h(3) = subplot(3,1,3)
plot(testes, atraso,'LineWidth',2)
grid on
title('\rho = 0.96','FontSize',17)

linkaxes([h(1),h(2),h(3)],'xy')
ylim(h(1),[0 40])
xlabel('Número de Simulações','FontSize',18)
set(h,'FontSize',18)

