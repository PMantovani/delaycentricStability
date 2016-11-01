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
set(h,'XTickLabel',{'0.66','0.72','0.75','0.78','0.81','0.84','0.87','0.90','0.93','0.96','0.99'});
axis([0.66 0.99 -10 1000])

media = dlmread('PDC.csv',';');
media=media/1000;

roinicio = 1;
rofinal = 11;
%[maxVectorSize, useless] = size(media);
maxVectorSize = 200;

mediaTotal=mean(media(1:maxVectorSize,roinicio:rofinal));
separador = (max(media)-min(media))/2;
for i=1:maxVectorSize
    for n=roinicio:rofinal
        if(separador(n)*2>100)
            if (media(i,n) < separador(n))
                valoresMenores(i,n) = media(i,n);
                valoresMaiores(i,n) = NaN;
            elseif (media(i,n) >= separador(n))
                valoresMaiores(i,n) = media(i,n);
                valoresMenores(i,n) = NaN;
            end
        elseif(media(i,n) > 450)
            valoresMaiores(i,n) = media(i,n);
            valoresMenores(i,n) = NaN;
        else
            valoresMaiores(i,n) = NaN;
            valoresMenores(i,n) = media(i,n);
        end
    end
end

N = maxVectorSize - sum(isnan(valoresMaiores));
c = tinv(0.025, N-1);
intervals = c.*nanstd(valoresMaiores)./sqrt(N);
h1 = errorbar(ro,nanmean(valoresMaiores),intervals, 'k--','LineWidth',5)
hold on

N = maxVectorSize - sum(isnan(valoresMenores));
c = tinv(0.025, N-1);
intervals = c.*nanstd(valoresMenores)./sqrt(N);
h2 = errorbar(ro,nanmean(valoresMenores),intervals, 'k:','LineWidth',5)
h3 = plot(ro,mediaTotal,'k-','LineWidth',5)

legend([h1 h2 h3], 'Moda superior', 'Moda inferior', 'Média total','Location','Northwest')