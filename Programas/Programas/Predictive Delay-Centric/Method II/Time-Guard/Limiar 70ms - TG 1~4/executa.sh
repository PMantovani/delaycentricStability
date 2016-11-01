#!/bin/bash

gcc client.c -o /usr/sbin/client
tc qdisc add dev eth0 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc add dev eth1 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc change dev eth0 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc change dev eth1 root tbf rate 1000kbit latency 19s burst 280B

mkdir Teste20.80
cd Teste20.80

for n in {1..200}
do
	mkdir $n
	cd $n

	mkdir 0.99
	cd 0.99
	
	for i in {1..6}
	do
		client $1 $2 $i 264 3000 &
	done
		clientExpNoRTT $1 198 3000 &
		clientExpNoRTT $2 198 3000 &
	wait
	sleep 1

	cd ..
	mkdir 0.96
	cd 0.96
	
	for i in {1..6}
	do
		client $1 $2 $i 256 3000 &
	done
		clientExpNoRTT $1 192 3000 &
		clientExpNoRTT $2 192 3000 &
	wait
	sleep 1

	cd ..
	mkdir 0.93
	cd 0.93
	
	for i in {1..6}
	do
		client $1 $2 $i 248 3000 &
	done
		clientExpNoRTT $1 186 3000 &
		clientExpNoRTT $2 186 3000 &
	wait
	sleep 1

	cd ..
	mkdir 0.90
	cd 0.90
	
	for i in {1..6}
	do
		client $1 $2 $i 240 3000 &
	done
		clientExpNoRTT $1 180 3000 &
		clientExpNoRTT $2 180 3000 &
	wait
	sleep 1

	cd ..
	mkdir 0.87
	cd 0.87
	
	for i in {1..6}
	do
		client $1 $2 $i 232 3000 &
	done
		clientExpNoRTT $1 174 3000 &
		clientExpNoRTT $2 174 3000 &
	wait
	sleep 1

	cd ..
	mkdir 0.84
	cd 0.84
	
	for i in {1..6}
	do
		client $1 $2 $i 224 3000 &
	done
		clientExpNoRTT $1 168 3000 &
		clientExpNoRTT $2 168 3000 &
	wait
	sleep 1

	cd ..
	mkdir 0.81
	cd 0.81
	
	for i in {1..6}
	do
		client $1 $2 $i 216 3000 &
	done
		clientExpNoRTT $1 162 3000 &
		clientExpNoRTT $2 162 3000 &
	wait
	sleep 1

	cd ..
	mkdir 0.78
	cd 0.78
	
	for i in {1..6}
	do
		client $1 $2 $i 208 3000 &
	done
		clientExpNoRTT $1 156 3000 &
		clientExpNoRTT $2 156 3000 &
	wait
	sleep 1

	cd ..
	mkdir 0.75
	cd 0.75
	
	for i in {1..6}
	do
		client $1 $2 $i 200 3000 &
	done
		clientExpNoRTT $1 150 3000 &
		clientExpNoRTT $2 150 3000 &
	wait
	sleep 1

	cd ..
	mkdir 0.72
	cd 0.72
	
	for i in {1..6}
	do
		client $1 $2 $i 192 3000 &
	done
		clientExpNoRTT $1 144 3000 &
		clientExpNoRTT $2 144 3000 &
	wait
	sleep 1

	cd ..
	mkdir 0.66
	cd 0.66
	
	for i in {1..6}
	do
		client $1 $2 $i 176 3000 &
	done
		clientExpNoRTT $1 132 3000 &
		clientExpNoRTT $2 132 3000 &
	wait
	sleep 1

	cd ..
	cd ..
done

tc qdisc del dev eth0 root
tc qdisc del dev eth1 root
cd ..
octave calculo_rtts.m
