clear all
close all
clc

%medias = dlmread('medias_testes.csv', ';');
cd ('Teste00.100');

inicio = 1;
final = 200;
roinicio = 1;
rofinal = 11;

ro = [0.66, 0.72, 0.75, 0.78, 0.81, 0.84, 0.87, 0.90, 0.93, 0.96, 0.99];

for i=inicio:final
    cd (num2str(i))
    count = 0;
    for n=roinicio:rofinal;
        count=count+1;
        
        if (n ~= 8)
            cd(num2str(ro(n)))
        else
            cd('0.90')
        end
        M1 = dlmread('1.csv', ';');
        temp(1) = mean(M1(501:end,3),1);
        M2 = dlmread('2.csv', ';');
        temp(2) = mean(M2(501:end,3),1);
        M3 = dlmread('3.csv', ';');
        temp(3) = mean(M3(501:end,3),1);
        M4 = dlmread('4.csv', ';');
        temp(4) = mean(M4(501:end,3),1);
        M5 = dlmread('5.csv', ';');
        temp(5) = mean(M5(501:end,3),1);
        M6 = dlmread('6.csv', ';');
        temp(6) = mean(M6(501:end,3),1);
        
        medias(i,n) = mean(temp);
        clear M1 M2 M3 M4 M5 M6
               
        cd ..
    end
    cd ..
end

%cd ..
dlmwrite('medias_testes.csv', medias, ';')
