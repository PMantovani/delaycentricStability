#!/bin/bash

gcc client.c -o /usr/sbin/client lrt
tc qdisc add dev eth0 root tbf rate 500kbit latency 1.9s burst 1300B
tc qdisc add dev eth1 root tbf rate 500kbit latency 1.9s burst 1300B
tc qdisc change dev eth0 root tbf rate 500kbit latency 1.9s burst 1300B
tc qdisc change dev eth1 root tbf rate 500kbit latency 1.9s burst 1300B

mkdir Teste1
cd Teste1
mkdir 165
cd 165
client $1 $2 1.csv 165 10000 &
client $1 $2 2.csv 165 10000 &
client $1 $2 3.csv 165 10000 &
client $1 $2 4.csv 165 10000 &
client $1 $2 5.csv 165 10000 &
client $1 $2 6.csv 165 10000
wait

cd ..
mkdir 160
cd 160
client $1 $2 1.csv 160 10000 &
client $1 $2 2.csv 160 10000 &
client $1 $2 3.csv 160 10000 &
client $1 $2 4.csv 160 10000 &
client $1 $2 5.csv 160 10000 &
client $1 $2 6.csv 160 10000
wait

cd ..
mkdir 155
cd 155
client $1 $2 1.csv 155 10000 &
client $1 $2 2.csv 155 10000 &
client $1 $2 3.csv 155 10000 &
client $1 $2 4.csv 155 10000 &
client $1 $2 5.csv 155 10000 &
client $1 $2 6.csv 155 10000
wait

cd ..
mkdir 150
cd 150
client $1 $2 1.csv 150 10000 &
client $1 $2 2.csv 150 10000 &
client $1 $2 3.csv 150 10000 &
client $1 $2 4.csv 150 10000 &
client $1 $2 5.csv 150 10000 &
client $1 $2 6.csv 150 10000
wait

cd ..
mkdir 145
cd 145
client $1 $2 1.csv 145 10000 &
client $1 $2 2.csv 145 10000 &
client $1 $2 3.csv 145 10000 &
client $1 $2 4.csv 145 10000 &
client $1 $2 5.csv 145 10000 &
client $1 $2 6.csv 145 10000
wait

cd ..
mkdir 140
cd 140
client $1 $2 1.csv 140 10000 &
client $1 $2 2.csv 140 10000 &
client $1 $2 3.csv 140 10000 &
client $1 $2 4.csv 140 10000 &
client $1 $2 5.csv 140 10000 &
client $1 $2 6.csv 140 10000
wait

cd ..
mkdir 135
cd 135
client $1 $2 1.csv 135 10000 &
client $1 $2 2.csv 135 10000 &
client $1 $2 3.csv 135 10000 &
client $1 $2 4.csv 135 10000 &
client $1 $2 5.csv 135 10000 &
client $1 $2 6.csv 135 10000
wait

cd ..
mkdir 130
cd 130
client $1 $2 1.csv 130 10000 &
client $1 $2 2.csv 130 10000 &
client $1 $2 3.csv 130 10000 &
client $1 $2 4.csv 130 10000 &
client $1 $2 5.csv 130 10000 &
client $1 $2 6.csv 130 10000
wait

cd ..
mkdir 125
cd 125
client $1 $2 1.csv 125 10000 &
client $1 $2 2.csv 125 10000 &
client $1 $2 3.csv 125 10000 &
client $1 $2 4.csv 125 10000 &
client $1 $2 5.csv 125 10000 &
client $1 $2 6.csv 125 10000
wait

cd ..
mkdir 120
cd 120
client $1 $2 1.csv 120 10000 &
client $1 $2 2.csv 120 10000 &
client $1 $2 3.csv 120 10000 &
client $1 $2 4.csv 120 10000 &
client $1 $2 5.csv 120 10000 &
client $1 $2 6.csv 120 10000
wait

cd ..
mkdir 110
cd 110
client $1 $2 1.csv 110 10000 &
client $1 $2 2.csv 110 10000 &
client $1 $2 3.csv 110 10000 &
client $1 $2 4.csv 110 10000 &
client $1 $2 5.csv 110 10000 &
client $1 $2 6.csv 110 10000
wait

cd ..
cd ..
mkdir Teste2
cd Teste2
mkdir 165
cd 165
client $1 $2 1.csv 165 10000 &
client $1 $2 2.csv 165 10000 &
client $1 $2 3.csv 165 10000 &
client $1 $2 4.csv 165 10000 &
client $1 $2 5.csv 165 10000 &
client $1 $2 6.csv 165 10000
wait

cd ..
mkdir 160
cd 160
client $1 $2 1.csv 160 10000 &
client $1 $2 2.csv 160 10000 &
client $1 $2 3.csv 160 10000 &
client $1 $2 4.csv 160 10000 &
client $1 $2 5.csv 160 10000 &
client $1 $2 6.csv 160 10000
wait

cd ..
mkdir 155
cd 155
client $1 $2 1.csv 155 10000 &
client $1 $2 2.csv 155 10000 &
client $1 $2 3.csv 155 10000 &
client $1 $2 4.csv 155 10000 &
client $1 $2 5.csv 155 10000 &
client $1 $2 6.csv 155 10000
wait

cd ..
mkdir 150
cd 150
client $1 $2 1.csv 150 10000 &
client $1 $2 2.csv 150 10000 &
client $1 $2 3.csv 150 10000 &
client $1 $2 4.csv 150 10000 &
client $1 $2 5.csv 150 10000 &
client $1 $2 6.csv 150 10000
wait

cd ..
mkdir 145
cd 145
client $1 $2 1.csv 145 10000 &
client $1 $2 2.csv 145 10000 &
client $1 $2 3.csv 145 10000 &
client $1 $2 4.csv 145 10000 &
client $1 $2 5.csv 145 10000 &
client $1 $2 6.csv 145 10000
wait

cd ..
mkdir 140
cd 140
client $1 $2 1.csv 140 10000 &
client $1 $2 2.csv 140 10000 &
client $1 $2 3.csv 140 10000 &
client $1 $2 4.csv 140 10000 &
client $1 $2 5.csv 140 10000 &
client $1 $2 6.csv 140 10000
wait

cd ..
mkdir 135
cd 135
client $1 $2 1.csv 135 10000 &
client $1 $2 2.csv 135 10000 &
client $1 $2 3.csv 135 10000 &
client $1 $2 4.csv 135 10000 &
client $1 $2 5.csv 135 10000 &
client $1 $2 6.csv 135 10000
wait

cd ..
mkdir 130
cd 130
client $1 $2 1.csv 130 10000 &
client $1 $2 2.csv 130 10000 &
client $1 $2 3.csv 130 10000 &
client $1 $2 4.csv 130 10000 &
client $1 $2 5.csv 130 10000 &
client $1 $2 6.csv 130 10000
wait

cd ..
mkdir 125
cd 125
client $1 $2 1.csv 125 10000 &
client $1 $2 2.csv 125 10000 &
client $1 $2 3.csv 125 10000 &
client $1 $2 4.csv 125 10000 &
client $1 $2 5.csv 125 10000 &
client $1 $2 6.csv 125 10000
wait

cd ..
mkdir 120
cd 120
client $1 $2 1.csv 120 10000 &
client $1 $2 2.csv 120 10000 &
client $1 $2 3.csv 120 10000 &
client $1 $2 4.csv 120 10000 &
client $1 $2 5.csv 120 10000 &
client $1 $2 6.csv 120 10000
wait

cd ..
mkdir 110
cd 110
client $1 $2 1.csv 110 10000 &
client $1 $2 2.csv 110 10000 &
client $1 $2 3.csv 110 10000 &
client $1 $2 4.csv 110 10000 &
client $1 $2 5.csv 110 10000 &
client $1 $2 6.csv 110 10000
wait

cd ..
cd ..
mkdir Teste3
cd Teste3
mkdir 165
cd 165
client $1 $2 1.csv 165 10000 &
client $1 $2 2.csv 165 10000 &
client $1 $2 3.csv 165 10000 &
client $1 $2 4.csv 165 10000 &
client $1 $2 5.csv 165 10000 &
client $1 $2 6.csv 165 10000
wait

cd ..
mkdir 160
cd 160
client $1 $2 1.csv 160 10000 &
client $1 $2 2.csv 160 10000 &
client $1 $2 3.csv 160 10000 &
client $1 $2 4.csv 160 10000 &
client $1 $2 5.csv 160 10000 &
client $1 $2 6.csv 160 10000
wait

cd ..
mkdir 155
cd 155
client $1 $2 1.csv 155 10000 &
client $1 $2 2.csv 155 10000 &
client $1 $2 3.csv 155 10000 &
client $1 $2 4.csv 155 10000 &
client $1 $2 5.csv 155 10000 &
client $1 $2 6.csv 155 10000
wait

cd ..
mkdir 150
cd 150
client $1 $2 1.csv 150 10000 &
client $1 $2 2.csv 150 10000 &
client $1 $2 3.csv 150 10000 &
client $1 $2 4.csv 150 10000 &
client $1 $2 5.csv 150 10000 &
client $1 $2 6.csv 150 10000
wait

cd ..
mkdir 145
cd 145
client $1 $2 1.csv 145 10000 &
client $1 $2 2.csv 145 10000 &
client $1 $2 3.csv 145 10000 &
client $1 $2 4.csv 145 10000 &
client $1 $2 5.csv 145 10000 &
client $1 $2 6.csv 145 10000
wait

cd ..
mkdir 140
cd 140
client $1 $2 1.csv 140 10000 &
client $1 $2 2.csv 140 10000 &
client $1 $2 3.csv 140 10000 &
client $1 $2 4.csv 140 10000 &
client $1 $2 5.csv 140 10000 &
client $1 $2 6.csv 140 10000
wait

cd ..
mkdir 135
cd 135
client $1 $2 1.csv 135 10000 &
client $1 $2 2.csv 135 10000 &
client $1 $2 3.csv 135 10000 &
client $1 $2 4.csv 135 10000 &
client $1 $2 5.csv 135 10000 &
client $1 $2 6.csv 135 10000
wait

cd ..
mkdir 130
cd 130
client $1 $2 1.csv 130 10000 &
client $1 $2 2.csv 130 10000 &
client $1 $2 3.csv 130 10000 &
client $1 $2 4.csv 130 10000 &
client $1 $2 5.csv 130 10000 &
client $1 $2 6.csv 130 10000
wait

cd ..
mkdir 125
cd 125
client $1 $2 1.csv 125 10000 &
client $1 $2 2.csv 125 10000 &
client $1 $2 3.csv 125 10000 &
client $1 $2 4.csv 125 10000 &
client $1 $2 5.csv 125 10000 &
client $1 $2 6.csv 125 10000
wait

cd ..
mkdir 120
cd 120
client $1 $2 1.csv 120 10000 &
client $1 $2 2.csv 120 10000 &
client $1 $2 3.csv 120 10000 &
client $1 $2 4.csv 120 10000 &
client $1 $2 5.csv 120 10000 &
client $1 $2 6.csv 120 10000
wait

cd ..
mkdir 110
cd 110
client $1 $2 1.csv 110 10000 &
client $1 $2 2.csv 110 10000 &
client $1 $2 3.csv 110 10000 &
client $1 $2 4.csv 110 10000 &
client $1 $2 5.csv 110 10000 &
client $1 $2 6.csv 110 10000
wait

cd ..
cd ..
mkdir Teste4
cd Teste4
mkdir 165
cd 165
client $1 $2 1.csv 165 10000 &
client $1 $2 2.csv 165 10000 &
client $1 $2 3.csv 165 10000 &
client $1 $2 4.csv 165 10000 &
client $1 $2 5.csv 165 10000 &
client $1 $2 6.csv 165 10000
wait

cd ..
mkdir 160
cd 160
client $1 $2 1.csv 160 10000 &
client $1 $2 2.csv 160 10000 &
client $1 $2 3.csv 160 10000 &
client $1 $2 4.csv 160 10000 &
client $1 $2 5.csv 160 10000 &
client $1 $2 6.csv 160 10000
wait

cd ..
mkdir 155
cd 155
client $1 $2 1.csv 155 10000 &
client $1 $2 2.csv 155 10000 &
client $1 $2 3.csv 155 10000 &
client $1 $2 4.csv 155 10000 &
client $1 $2 5.csv 155 10000 &
client $1 $2 6.csv 155 10000
wait

cd ..
mkdir 150
cd 150
client $1 $2 1.csv 150 10000 &
client $1 $2 2.csv 150 10000 &
client $1 $2 3.csv 150 10000 &
client $1 $2 4.csv 150 10000 &
client $1 $2 5.csv 150 10000 &
client $1 $2 6.csv 150 10000
wait

cd ..
mkdir 145
cd 145
client $1 $2 1.csv 145 10000 &
client $1 $2 2.csv 145 10000 &
client $1 $2 3.csv 145 10000 &
client $1 $2 4.csv 145 10000 &
client $1 $2 5.csv 145 10000 &
client $1 $2 6.csv 145 10000
wait

cd ..
mkdir 140
cd 140
client $1 $2 1.csv 140 10000 &
client $1 $2 2.csv 140 10000 &
client $1 $2 3.csv 140 10000 &
client $1 $2 4.csv 140 10000 &
client $1 $2 5.csv 140 10000 &
client $1 $2 6.csv 140 10000
wait

cd ..
mkdir 135
cd 135
client $1 $2 1.csv 135 10000 &
client $1 $2 2.csv 135 10000 &
client $1 $2 3.csv 135 10000 &
client $1 $2 4.csv 135 10000 &
client $1 $2 5.csv 135 10000 &
client $1 $2 6.csv 135 10000
wait

cd ..
mkdir 130
cd 130
client $1 $2 1.csv 130 10000 &
client $1 $2 2.csv 130 10000 &
client $1 $2 3.csv 130 10000 &
client $1 $2 4.csv 130 10000 &
client $1 $2 5.csv 130 10000 &
client $1 $2 6.csv 130 10000
wait

cd ..
mkdir 125
cd 125
client $1 $2 1.csv 125 10000 &
client $1 $2 2.csv 125 10000 &
client $1 $2 3.csv 125 10000 &
client $1 $2 4.csv 125 10000 &
client $1 $2 5.csv 125 10000 &
client $1 $2 6.csv 125 10000
wait

cd ..
mkdir 120
cd 120
client $1 $2 1.csv 120 10000 &
client $1 $2 2.csv 120 10000 &
client $1 $2 3.csv 120 10000 &
client $1 $2 4.csv 120 10000 &
client $1 $2 5.csv 120 10000 &
client $1 $2 6.csv 120 10000
wait

cd ..
mkdir 110
cd 110
client $1 $2 1.csv 110 10000 &
client $1 $2 2.csv 110 10000 &
client $1 $2 3.csv 110 10000 &
client $1 $2 4.csv 110 10000 &
client $1 $2 5.csv 110 10000 &
client $1 $2 6.csv 110 10000
wait

cd ..
cd ..
mkdir Teste5
cd Teste5
mkdir 165
cd 165
client $1 $2 1.csv 165 10000 &
client $1 $2 2.csv 165 10000 &
client $1 $2 3.csv 165 10000 &
client $1 $2 4.csv 165 10000 &
client $1 $2 5.csv 165 10000 &
client $1 $2 6.csv 165 10000
wait

cd ..
mkdir 160
cd 160
client $1 $2 1.csv 160 10000 &
client $1 $2 2.csv 160 10000 &
client $1 $2 3.csv 160 10000 &
client $1 $2 4.csv 160 10000 &
client $1 $2 5.csv 160 10000 &
client $1 $2 6.csv 160 10000
wait

cd ..
mkdir 155
cd 155
client $1 $2 1.csv 155 10000 &
client $1 $2 2.csv 155 10000 &
client $1 $2 3.csv 155 10000 &
client $1 $2 4.csv 155 10000 &
client $1 $2 5.csv 155 10000 &
client $1 $2 6.csv 155 10000
wait

cd ..
mkdir 150
cd 150
client $1 $2 1.csv 150 10000 &
client $1 $2 2.csv 150 10000 &
client $1 $2 3.csv 150 10000 &
client $1 $2 4.csv 150 10000 &
client $1 $2 5.csv 150 10000 &
client $1 $2 6.csv 150 10000
wait

cd ..
mkdir 145
cd 145
client $1 $2 1.csv 145 10000 &
client $1 $2 2.csv 145 10000 &
client $1 $2 3.csv 145 10000 &
client $1 $2 4.csv 145 10000 &
client $1 $2 5.csv 145 10000 &
client $1 $2 6.csv 145 10000
wait

cd ..
mkdir 140
cd 140
client $1 $2 1.csv 140 10000 &
client $1 $2 2.csv 140 10000 &
client $1 $2 3.csv 140 10000 &
client $1 $2 4.csv 140 10000 &
client $1 $2 5.csv 140 10000 &
client $1 $2 6.csv 140 10000
wait

cd ..
mkdir 135
cd 135
client $1 $2 1.csv 135 10000 &
client $1 $2 2.csv 135 10000 &
client $1 $2 3.csv 135 10000 &
client $1 $2 4.csv 135 10000 &
client $1 $2 5.csv 135 10000 &
client $1 $2 6.csv 135 10000
wait

cd ..
mkdir 130
cd 130
client $1 $2 1.csv 130 10000 &
client $1 $2 2.csv 130 10000 &
client $1 $2 3.csv 130 10000 &
client $1 $2 4.csv 130 10000 &
client $1 $2 5.csv 130 10000 &
client $1 $2 6.csv 130 10000
wait

cd ..
mkdir 125
cd 125
client $1 $2 1.csv 125 10000 &
client $1 $2 2.csv 125 10000 &
client $1 $2 3.csv 125 10000 &
client $1 $2 4.csv 125 10000 &
client $1 $2 5.csv 125 10000 &
client $1 $2 6.csv 125 10000
wait

cd ..
mkdir 120
cd 120
client $1 $2 1.csv 120 10000 &
client $1 $2 2.csv 120 10000 &
client $1 $2 3.csv 120 10000 &
client $1 $2 4.csv 120 10000 &
client $1 $2 5.csv 120 10000 &
client $1 $2 6.csv 120 10000
wait

cd ..
mkdir 110
cd 110
client $1 $2 1.csv 110 10000 &
client $1 $2 2.csv 110 10000 &
client $1 $2 3.csv 110 10000 &
client $1 $2 4.csv 110 10000 &
client $1 $2 5.csv 110 10000 &
client $1 $2 6.csv 110 10000
wait

cd ..
cd ..
mkdir Teste6
cd Teste6
mkdir 165
cd 165
client $1 $2 1.csv 165 10000 &
client $1 $2 2.csv 165 10000 &
client $1 $2 3.csv 165 10000 &
client $1 $2 4.csv 165 10000 &
client $1 $2 5.csv 165 10000 &
client $1 $2 6.csv 165 10000
wait

cd ..
mkdir 160
cd 160
client $1 $2 1.csv 160 10000 &
client $1 $2 2.csv 160 10000 &
client $1 $2 3.csv 160 10000 &
client $1 $2 4.csv 160 10000 &
client $1 $2 5.csv 160 10000 &
client $1 $2 6.csv 160 10000
wait

cd ..
mkdir 155
cd 155
client $1 $2 1.csv 155 10000 &
client $1 $2 2.csv 155 10000 &
client $1 $2 3.csv 155 10000 &
client $1 $2 4.csv 155 10000 &
client $1 $2 5.csv 155 10000 &
client $1 $2 6.csv 155 10000
wait

cd ..
mkdir 150
cd 150
client $1 $2 1.csv 150 10000 &
client $1 $2 2.csv 150 10000 &
client $1 $2 3.csv 150 10000 &
client $1 $2 4.csv 150 10000 &
client $1 $2 5.csv 150 10000 &
client $1 $2 6.csv 150 10000
wait

cd ..
mkdir 145
cd 145
client $1 $2 1.csv 145 10000 &
client $1 $2 2.csv 145 10000 &
client $1 $2 3.csv 145 10000 &
client $1 $2 4.csv 145 10000 &
client $1 $2 5.csv 145 10000 &
client $1 $2 6.csv 145 10000
wait

cd ..
mkdir 140
cd 140
client $1 $2 1.csv 140 10000 &
client $1 $2 2.csv 140 10000 &
client $1 $2 3.csv 140 10000 &
client $1 $2 4.csv 140 10000 &
client $1 $2 5.csv 140 10000 &
client $1 $2 6.csv 140 10000
wait

cd ..
mkdir 135
cd 135
client $1 $2 1.csv 135 10000 &
client $1 $2 2.csv 135 10000 &
client $1 $2 3.csv 135 10000 &
client $1 $2 4.csv 135 10000 &
client $1 $2 5.csv 135 10000 &
client $1 $2 6.csv 135 10000
wait

cd ..
mkdir 130
cd 130
client $1 $2 1.csv 130 10000 &
client $1 $2 2.csv 130 10000 &
client $1 $2 3.csv 130 10000 &
client $1 $2 4.csv 130 10000 &
client $1 $2 5.csv 130 10000 &
client $1 $2 6.csv 130 10000
wait

cd ..
mkdir 125
cd 125
client $1 $2 1.csv 125 10000 &
client $1 $2 2.csv 125 10000 &
client $1 $2 3.csv 125 10000 &
client $1 $2 4.csv 125 10000 &
client $1 $2 5.csv 125 10000 &
client $1 $2 6.csv 125 10000
wait

cd ..
mkdir 120
cd 120
client $1 $2 1.csv 120 10000 &
client $1 $2 2.csv 120 10000 &
client $1 $2 3.csv 120 10000 &
client $1 $2 4.csv 120 10000 &
client $1 $2 5.csv 120 10000 &
client $1 $2 6.csv 120 10000
wait

cd ..
mkdir 110
cd 110
client $1 $2 1.csv 110 10000 &
client $1 $2 2.csv 110 10000 &
client $1 $2 3.csv 110 10000 &
client $1 $2 4.csv 110 10000 &
client $1 $2 5.csv 110 10000 &
client $1 $2 6.csv 110 10000
wait

cd ..
cd ..
mkdir Teste7
cd Teste7
mkdir 165
cd 165
client $1 $2 1.csv 165 10000 &
client $1 $2 2.csv 165 10000 &
client $1 $2 3.csv 165 10000 &
client $1 $2 4.csv 165 10000 &
client $1 $2 5.csv 165 10000 &
client $1 $2 6.csv 165 10000
wait

cd ..
mkdir 160
cd 160
client $1 $2 1.csv 160 10000 &
client $1 $2 2.csv 160 10000 &
client $1 $2 3.csv 160 10000 &
client $1 $2 4.csv 160 10000 &
client $1 $2 5.csv 160 10000 &
client $1 $2 6.csv 160 10000
wait

cd ..
mkdir 155
cd 155
client $1 $2 1.csv 155 10000 &
client $1 $2 2.csv 155 10000 &
client $1 $2 3.csv 155 10000 &
client $1 $2 4.csv 155 10000 &
client $1 $2 5.csv 155 10000 &
client $1 $2 6.csv 155 10000
wait

cd ..
mkdir 150
cd 150
client $1 $2 1.csv 150 10000 &
client $1 $2 2.csv 150 10000 &
client $1 $2 3.csv 150 10000 &
client $1 $2 4.csv 150 10000 &
client $1 $2 5.csv 150 10000 &
client $1 $2 6.csv 150 10000
wait

cd ..
mkdir 145
cd 145
client $1 $2 1.csv 145 10000 &
client $1 $2 2.csv 145 10000 &
client $1 $2 3.csv 145 10000 &
client $1 $2 4.csv 145 10000 &
client $1 $2 5.csv 145 10000 &
client $1 $2 6.csv 145 10000
wait

cd ..
mkdir 140
cd 140
client $1 $2 1.csv 140 10000 &
client $1 $2 2.csv 140 10000 &
client $1 $2 3.csv 140 10000 &
client $1 $2 4.csv 140 10000 &
client $1 $2 5.csv 140 10000 &
client $1 $2 6.csv 140 10000
wait

cd ..
mkdir 135
cd 135
client $1 $2 1.csv 135 10000 &
client $1 $2 2.csv 135 10000 &
client $1 $2 3.csv 135 10000 &
client $1 $2 4.csv 135 10000 &
client $1 $2 5.csv 135 10000 &
client $1 $2 6.csv 135 10000
wait

cd ..
mkdir 130
cd 130
client $1 $2 1.csv 130 10000 &
client $1 $2 2.csv 130 10000 &
client $1 $2 3.csv 130 10000 &
client $1 $2 4.csv 130 10000 &
client $1 $2 5.csv 130 10000 &
client $1 $2 6.csv 130 10000
wait

cd ..
mkdir 125
cd 125
client $1 $2 1.csv 125 10000 &
client $1 $2 2.csv 125 10000 &
client $1 $2 3.csv 125 10000 &
client $1 $2 4.csv 125 10000 &
client $1 $2 5.csv 125 10000 &
client $1 $2 6.csv 125 10000
wait

cd ..
mkdir 120
cd 120
client $1 $2 1.csv 120 10000 &
client $1 $2 2.csv 120 10000 &
client $1 $2 3.csv 120 10000 &
client $1 $2 4.csv 120 10000 &
client $1 $2 5.csv 120 10000 &
client $1 $2 6.csv 120 10000
wait

cd ..
mkdir 110
cd 110
client $1 $2 1.csv 110 10000 &
client $1 $2 2.csv 110 10000 &
client $1 $2 3.csv 110 10000 &
client $1 $2 4.csv 110 10000 &
client $1 $2 5.csv 110 10000 &
client $1 $2 6.csv 110 10000
wait

cd ..
cd ..
mkdir Teste8
cd Teste8
mkdir 165
cd 165
client $1 $2 1.csv 165 10000 &
client $1 $2 2.csv 165 10000 &
client $1 $2 3.csv 165 10000 &
client $1 $2 4.csv 165 10000 &
client $1 $2 5.csv 165 10000 &
client $1 $2 6.csv 165 10000
wait

cd ..
mkdir 160
cd 160
client $1 $2 1.csv 160 10000 &
client $1 $2 2.csv 160 10000 &
client $1 $2 3.csv 160 10000 &
client $1 $2 4.csv 160 10000 &
client $1 $2 5.csv 160 10000 &
client $1 $2 6.csv 160 10000
wait

cd ..
mkdir 155
cd 155
client $1 $2 1.csv 155 10000 &
client $1 $2 2.csv 155 10000 &
client $1 $2 3.csv 155 10000 &
client $1 $2 4.csv 155 10000 &
client $1 $2 5.csv 155 10000 &
client $1 $2 6.csv 155 10000
wait

cd ..
mkdir 150
cd 150
client $1 $2 1.csv 150 10000 &
client $1 $2 2.csv 150 10000 &
client $1 $2 3.csv 150 10000 &
client $1 $2 4.csv 150 10000 &
client $1 $2 5.csv 150 10000 &
client $1 $2 6.csv 150 10000
wait

cd ..
mkdir 145
cd 145
client $1 $2 1.csv 145 10000 &
client $1 $2 2.csv 145 10000 &
client $1 $2 3.csv 145 10000 &
client $1 $2 4.csv 145 10000 &
client $1 $2 5.csv 145 10000 &
client $1 $2 6.csv 145 10000
wait

cd ..
mkdir 140
cd 140
client $1 $2 1.csv 140 10000 &
client $1 $2 2.csv 140 10000 &
client $1 $2 3.csv 140 10000 &
client $1 $2 4.csv 140 10000 &
client $1 $2 5.csv 140 10000 &
client $1 $2 6.csv 140 10000
wait

cd ..
mkdir 135
cd 135
client $1 $2 1.csv 135 10000 &
client $1 $2 2.csv 135 10000 &
client $1 $2 3.csv 135 10000 &
client $1 $2 4.csv 135 10000 &
client $1 $2 5.csv 135 10000 &
client $1 $2 6.csv 135 10000
wait

cd ..
mkdir 130
cd 130
client $1 $2 1.csv 130 10000 &
client $1 $2 2.csv 130 10000 &
client $1 $2 3.csv 130 10000 &
client $1 $2 4.csv 130 10000 &
client $1 $2 5.csv 130 10000 &
client $1 $2 6.csv 130 10000
wait

cd ..
mkdir 125
cd 125
client $1 $2 1.csv 125 10000 &
client $1 $2 2.csv 125 10000 &
client $1 $2 3.csv 125 10000 &
client $1 $2 4.csv 125 10000 &
client $1 $2 5.csv 125 10000 &
client $1 $2 6.csv 125 10000
wait

cd ..
mkdir 120
cd 120
client $1 $2 1.csv 120 10000 &
client $1 $2 2.csv 120 10000 &
client $1 $2 3.csv 120 10000 &
client $1 $2 4.csv 120 10000 &
client $1 $2 5.csv 120 10000 &
client $1 $2 6.csv 120 10000
wait

cd ..
mkdir 110
cd 110
client $1 $2 1.csv 110 10000 &
client $1 $2 2.csv 110 10000 &
client $1 $2 3.csv 110 10000 &
client $1 $2 4.csv 110 10000 &
client $1 $2 5.csv 110 10000 &
client $1 $2 6.csv 110 10000
wait

cd ..
cd ..
mkdir Teste9
cd Teste9
mkdir 165
cd 165
client $1 $2 1.csv 165 10000 &
client $1 $2 2.csv 165 10000 &
client $1 $2 3.csv 165 10000 &
client $1 $2 4.csv 165 10000 &
client $1 $2 5.csv 165 10000 &
client $1 $2 6.csv 165 10000
wait

cd ..
mkdir 160
cd 160
client $1 $2 1.csv 160 10000 &
client $1 $2 2.csv 160 10000 &
client $1 $2 3.csv 160 10000 &
client $1 $2 4.csv 160 10000 &
client $1 $2 5.csv 160 10000 &
client $1 $2 6.csv 160 10000
wait

cd ..
mkdir 155
cd 155
client $1 $2 1.csv 155 10000 &
client $1 $2 2.csv 155 10000 &
client $1 $2 3.csv 155 10000 &
client $1 $2 4.csv 155 10000 &
client $1 $2 5.csv 155 10000 &
client $1 $2 6.csv 155 10000
wait

cd ..
mkdir 150
cd 150
client $1 $2 1.csv 150 10000 &
client $1 $2 2.csv 150 10000 &
client $1 $2 3.csv 150 10000 &
client $1 $2 4.csv 150 10000 &
client $1 $2 5.csv 150 10000 &
client $1 $2 6.csv 150 10000
wait

cd ..
mkdir 145
cd 145
client $1 $2 1.csv 145 10000 &
client $1 $2 2.csv 145 10000 &
client $1 $2 3.csv 145 10000 &
client $1 $2 4.csv 145 10000 &
client $1 $2 5.csv 145 10000 &
client $1 $2 6.csv 145 10000
wait

cd ..
mkdir 140
cd 140
client $1 $2 1.csv 140 10000 &
client $1 $2 2.csv 140 10000 &
client $1 $2 3.csv 140 10000 &
client $1 $2 4.csv 140 10000 &
client $1 $2 5.csv 140 10000 &
client $1 $2 6.csv 140 10000
wait

cd ..
mkdir 135
cd 135
client $1 $2 1.csv 135 10000 &
client $1 $2 2.csv 135 10000 &
client $1 $2 3.csv 135 10000 &
client $1 $2 4.csv 135 10000 &
client $1 $2 5.csv 135 10000 &
client $1 $2 6.csv 135 10000
wait

cd ..
mkdir 130
cd 130
client $1 $2 1.csv 130 10000 &
client $1 $2 2.csv 130 10000 &
client $1 $2 3.csv 130 10000 &
client $1 $2 4.csv 130 10000 &
client $1 $2 5.csv 130 10000 &
client $1 $2 6.csv 130 10000
wait

cd ..
mkdir 125
cd 125
client $1 $2 1.csv 125 10000 &
client $1 $2 2.csv 125 10000 &
client $1 $2 3.csv 125 10000 &
client $1 $2 4.csv 125 10000 &
client $1 $2 5.csv 125 10000 &
client $1 $2 6.csv 125 10000
wait

cd ..
mkdir 120
cd 120
client $1 $2 1.csv 120 10000 &
client $1 $2 2.csv 120 10000 &
client $1 $2 3.csv 120 10000 &
client $1 $2 4.csv 120 10000 &
client $1 $2 5.csv 120 10000 &
client $1 $2 6.csv 120 10000
wait

cd ..
mkdir 110
cd 110
client $1 $2 1.csv 110 10000 &
client $1 $2 2.csv 110 10000 &
client $1 $2 3.csv 110 10000 &
client $1 $2 4.csv 110 10000 &
client $1 $2 5.csv 110 10000 &
client $1 $2 6.csv 110 10000
wait

cd ..
cd ..
mkdir Teste10
cd Teste10
mkdir 165
cd 165
client $1 $2 1.csv 165 10000 &
client $1 $2 2.csv 165 10000 &
client $1 $2 3.csv 165 10000 &
client $1 $2 4.csv 165 10000 &
client $1 $2 5.csv 165 10000 &
client $1 $2 6.csv 165 10000
wait

cd ..
mkdir 160
cd 160
client $1 $2 1.csv 160 10000 &
client $1 $2 2.csv 160 10000 &
client $1 $2 3.csv 160 10000 &
client $1 $2 4.csv 160 10000 &
client $1 $2 5.csv 160 10000 &
client $1 $2 6.csv 160 10000
wait

cd ..
mkdir 155
cd 155
client $1 $2 1.csv 155 10000 &
client $1 $2 2.csv 155 10000 &
client $1 $2 3.csv 155 10000 &
client $1 $2 4.csv 155 10000 &
client $1 $2 5.csv 155 10000 &
client $1 $2 6.csv 155 10000
wait

cd ..
mkdir 150
cd 150
client $1 $2 1.csv 150 10000 &
client $1 $2 2.csv 150 10000 &
client $1 $2 3.csv 150 10000 &
client $1 $2 4.csv 150 10000 &
client $1 $2 5.csv 150 10000 &
client $1 $2 6.csv 150 10000
wait

cd ..
mkdir 145
cd 145
client $1 $2 1.csv 145 10000 &
client $1 $2 2.csv 145 10000 &
client $1 $2 3.csv 145 10000 &
client $1 $2 4.csv 145 10000 &
client $1 $2 5.csv 145 10000 &
client $1 $2 6.csv 145 10000
wait

cd ..
mkdir 140
cd 140
client $1 $2 1.csv 140 10000 &
client $1 $2 2.csv 140 10000 &
client $1 $2 3.csv 140 10000 &
client $1 $2 4.csv 140 10000 &
client $1 $2 5.csv 140 10000 &
client $1 $2 6.csv 140 10000
wait

cd ..
mkdir 135
cd 135
client $1 $2 1.csv 135 10000 &
client $1 $2 2.csv 135 10000 &
client $1 $2 3.csv 135 10000 &
client $1 $2 4.csv 135 10000 &
client $1 $2 5.csv 135 10000 &
client $1 $2 6.csv 135 10000
wait

cd ..
mkdir 130
cd 130
client $1 $2 1.csv 130 10000 &
client $1 $2 2.csv 130 10000 &
client $1 $2 3.csv 130 10000 &
client $1 $2 4.csv 130 10000 &
client $1 $2 5.csv 130 10000 &
client $1 $2 6.csv 130 10000
wait

cd ..
mkdir 125
cd 125
client $1 $2 1.csv 125 10000 &
client $1 $2 2.csv 125 10000 &
client $1 $2 3.csv 125 10000 &
client $1 $2 4.csv 125 10000 &
client $1 $2 5.csv 125 10000 &
client $1 $2 6.csv 125 10000
wait

cd ..
mkdir 120
cd 120
client $1 $2 1.csv 120 10000 &
client $1 $2 2.csv 120 10000 &
client $1 $2 3.csv 120 10000 &
client $1 $2 4.csv 120 10000 &
client $1 $2 5.csv 120 10000 &
client $1 $2 6.csv 120 10000
wait

cd ..
mkdir 110
cd 110
client $1 $2 1.csv 110 10000 &
client $1 $2 2.csv 110 10000 &
client $1 $2 3.csv 110 10000 &
client $1 $2 4.csv 110 10000 &
client $1 $2 5.csv 110 10000 &
client $1 $2 6.csv 110 10000
wait

cd ..

