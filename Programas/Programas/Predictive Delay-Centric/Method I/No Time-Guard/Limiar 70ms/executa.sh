#!/bin/bash

gcc client.c -o /usr/sbin/client
tc qdisc add dev eth0 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc add dev eth1 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc change dev eth0 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc change dev eth1 root tbf rate 1000kbit latency 19s burst 280B

mkdir 40BT.60FT
cd 40BT.60FT

for n in {1..2}
do
	mkdir $n
	cd $n

	mkdir 0.99
	cd 0.99
	
	for i in {1..6}
	do
		client $1 $2 $i 198 3000 &
	done
		clientExp $1 396 8000 &
		clientExp $2 396 8000 &
	wait
	sleep 1

	cd ..
	mkdir 0.96
	cd 0.96
	
	for i in {1..6}
	do
		client $1 $2 $i 192 3000 &
	done
		clientExp $1 384 8000 &
		clientExp $2 384 8000 &
	wait
	sleep 1

	cd ..
	mkdir 0.93
	cd 0.93
	
	for i in {1..6}
	do
		client $1 $2 $i 186 3000 &
	done
		clientExp $1 372 8000 &
		clientExp $2 372 8000 &
	wait
	sleep 1

	cd ..
	mkdir 0.90
	cd 0.90
	
	for i in {1..6}
	do
		client $1 $2 $i 180 3000 &
	done
		clientExp $1 360 8000 &
		clientExp $2 360 8000 &
	wait
	sleep 1

	cd ..
	mkdir 0.87
	cd 0.87
	
	for i in {1..6}
	do
		client $1 $2 $i 174 3000 &
	done
		clientExp $1 348 8000 &
		clientExp $2 348 8000 &
	wait
	sleep 1

	cd ..
	mkdir 0.84
	cd 0.84
	
	for i in {1..6}
	do
		client $1 $2 $i 168 3000 &
	done
		clientExp $1 336 8000 &
		clientExp $2 336 8000 &
	wait
	sleep 1

	cd ..
	mkdir 0.81
	cd 0.81
	
	for i in {1..6}
	do
		client $1 $2 $i 162 3000 &
	done
		clientExp $1 324 8000 &
		clientExp $2 324 8000 &
	wait
	sleep 1

	cd ..
	mkdir 0.78
	cd 0.78
	
	for i in {1..6}
	do
		client $1 $2 $i 156 3000 &
	done
		clientExp $1 312 8000 &
		clientExp $2 312 8000 &
	wait
	sleep 1

	cd ..
	mkdir 0.75
	cd 0.75
	
	for i in {1..6}
	do
		client $1 $2 $i 150 3000 &
	done
		clientExp $1 300 8000 &
		clientExp $2 300 8000 &
	wait
	sleep 1

	cd ..
	mkdir 0.72
	cd 0.72
	
	for i in {1..6}
	do
		client $1 $2 $i 144 3000 &
	done
		clientExp $1 288 8000 &
		clientExp $2 288 8000 &
	wait
	sleep 1

	cd ..
	mkdir 0.66
	cd 0.66
	
	for i in {1..6}
	do
		client $1 $2 $i 132 3000 &
	done
		clientExp $1 264 8000 &
		clientExp $2 264 8000 &
	wait
	sleep 1

	cd ..
	cd ..
done

tc qdisc del dev eth0 root
tc qdisc del dev eth1 root
cd ..
octave calculo_rtts.m

for n in {1..2}
do
	rm $n -R
done
