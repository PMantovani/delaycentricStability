clear
clc

M = dlmread('D:\Dropbox\Iniciacao\Programas\udpaleat\rtt.csv', ';');

[x y] = size(M);

rtt = M(:,1);

seq = 1:1:x;
t = sort (rtt, 'descend');

plot(seq, rtt)

media = mean (rtt)