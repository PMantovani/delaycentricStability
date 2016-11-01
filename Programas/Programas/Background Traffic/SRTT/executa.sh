#!/bin/bash

gcc client.c -o /usr/sbin/clientExp -lm
tc qdisc add dev eth0 root tbf rate 1000kbit latency 19s burst 260B
tc qdisc change dev eth0 root tbf rate 1000kbit latency 19s burst 260B

mkdir Validacao2
cd Validacao2

for n in {1..200}
do
	mkdir $n
	cd $n

	mkdir 0.99
	cd 0.99
	clientExp $1 rtt.csv 990 30000 &
	wait
	sleep 1

	cd ..
	mkdir 0.96
	cd 0.96
	clientExp $1 rtt.csv 960 30000 &
	wait
	sleep 1

	cd ..
	mkdir 0.93
	cd 0.93
	clientExp $1 rtt.csv 930 30000 &
	wait
	sleep 1

	cd ..
	mkdir 0.90
	cd 0.90
	clientExp $1 rtt.csv 900 30000 &
	wait
	sleep 1

	cd ..
	mkdir 0.87
	cd 0.87
	clientExp $1 rtt.csv 870 30000 &
	wait
	sleep 1

	cd ..
	mkdir 0.84
	cd 0.84
	clientExp $1 rtt.csv 840 30000 &
	wait
	sleep 1

	cd ..
	mkdir 0.81
	cd 0.81
	clientExp $1 rtt.csv 810 30000 &
	wait
	sleep 1

	cd ..
	mkdir 0.78
	cd 0.78
	clientExp $1 rtt.csv 780 30000 &
	wait
	sleep 1

	cd ..
	mkdir 0.75
	cd 0.75
	clientExp $1 rtt.csv 750 30000 &
	wait
	sleep 1

	cd ..
	mkdir 0.72
	cd 0.72
	clientExp $1 rtt.csv 720 30000 &
	wait
	sleep 1

	cd ..
	mkdir 0.66
	cd 0.66
	clientExp $1 rtt.csv 660 30000 &
	wait
	sleep 1

	cd ..
	cd ..
done

tc qdisc del dev eth0 root
cd ..
octave calculo_rtts.m
