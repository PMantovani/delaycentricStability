clear all
close all
clc

%medias = dlmread('medias_testes.csv', ';');
cd ('Validacao2');

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
        M1 = dlmread('rtt.csv', ';');
        temp = mean(M1(501:end));
	
	medias(i,n) = temp;
        clear M1
               
        cd ..
    end
    cd ..
end

%cd ..
dlmwrite('medias_testes.csv', medias, ';')
