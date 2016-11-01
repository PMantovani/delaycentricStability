#!/bin/bash

gcc client.c -o /usr/sbin/client
tc qdisc add dev eth0 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc add dev eth1 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc change dev eth0 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc change dev eth1 root tbf rate 1000kbit latency 19s burst 280B

mkdir Teste00.100
cd Teste00.100

for n in {1..200}
do
	mkdir $n
	cd $n

	mkdir 0.99
	cd 0.99
	
	for i in {1..6}
	do
		client $1 $2 $i 330 3000 &
	done
	#	clientExpNoRTT $1 891 81000 &
	#	clientExpNoRTT $2 891 81000 &
	wait
	sleep 1

	cd ..
	mkdir 0.96
	cd 0.96
	
	for i in {1..6}
	do
		client $1 $2 $i 320 3000 &
	done
	#	clientExpNoRTT $1 864 81000 &
	#	clientExpNoRTT $2 864 81000 &
	wait
	sleep 1

	cd ..
	mkdir 0.93
	cd 0.93
	
	for i in {1..6}
	do
		client $1 $2 $i 310 3000 &
	done
	#	clientExpNoRTT $1 837 81000 &
	#	clientExpNoRTT $2 837 81000 &
	wait
	sleep 1

	cd ..
	mkdir 0.90
	cd 0.90
	
	for i in {1..6}
	do
		client $1 $2 $i 300 3000 &
	done
	#	clientExpNoRTT $1 810 81000 &
	#	clientExpNoRTT $2 810 81000 &
	wait
	sleep 1

	cd ..
	mkdir 0.87
	cd 0.87
	
	for i in {1..6}
	do
		client $1 $2 $i 290 3000 &
	done
	#	clientExpNoRTT $1 783 81000 &
	#	clientExpNoRTT $2 783 81000 &
	wait
	sleep 1

	cd ..
	mkdir 0.84
	cd 0.84
	
	for i in {1..6}
	do
		client $1 $2 $i 280 3000 &
	done
	#	clientExpNoRTT $1 756 81000 &
	#	clientExpNoRTT $2 756 81000 &
	wait
	sleep 1

	cd ..
	mkdir 0.81
	cd 0.81
	
	for i in {1..6}
	do
		client $1 $2 $i 270 3000 &
	done
	#	clientExpNoRTT $1 729 81000 &
	#	clientExpNoRTT $2 729 81000 &
	wait
	sleep 1

	cd ..
	mkdir 0.78
	cd 0.78
	
	for i in {1..6}
	do
		client $1 $2 $i 260 3000 &
	done
	#	clientExpNoRTT $1 702 81000 &
	#	clientExpNoRTT $2 702 81000 &
	wait
	sleep 1

	cd ..
	mkdir 0.75
	cd 0.75
	
	for i in {1..6}
	do
		client $1 $2 $i 250 3000 &
	done
	#	clientExpNoRTT $1 675 81000 &
	#	clientExpNoRTT $2 675 81000 &
	wait
	sleep 1

	cd ..
	mkdir 0.72
	cd 0.72
	
	for i in {1..6}
	do
		client $1 $2 $i 240 3000 &
	done
	#	clientExpNoRTT $1 648 81000 &
	#	clientExpNoRTT $2 648 81000 &
	wait
	sleep 1

	cd ..
	mkdir 0.66
	cd 0.66
	
	for i in {1..6}
	do
		client $1 $2 $i 220 3000 &
	done
	#	clientExpNoRTT $1 594 81000 &
	#	clientExpNoRTT $2 594 81000 &
	wait
	sleep 1

	cd ..
	cd ..
done

tc qdisc del dev eth0 root
tc qdisc del dev eth1 root
cd ..
octave calculo_rtts.m
