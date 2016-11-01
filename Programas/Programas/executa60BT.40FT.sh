#!/bin/bash

eval cd $3
gcc client.c -o /usr/sbin/client
tc qdisc add dev eth0 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc add dev eth1 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc add dev eth2 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc change dev eth0 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc change dev eth1 root tbf rate 1000kbit latency 19s burst 280B
tc qdisc change dev eth2 root tbf rate 1000kbit latency 19s burst 280B

mkdir 40BT.60FT
cd 40BT.60FT

for n in {1..200}
do
	mkdir $n
	cd $n

	mkdir 0.99
	cd 0.99
	
	for i in {1..6}
	do
		client $1 $2 $i 132 3000 &
	done
		clientExp $1 594 13500 &
		clientExp $2 594 13500 &
	wait
	sleep 1

	cd ..
	mkdir 0.96
	cd 0.96
	
	for i in {1..6}
	do
		client $1 $2 $i 128 3000 &
	done
		clientExp $1 576 13500 &
		clientExp $2 576 13500 &
	wait
	sleep 1

	cd ..
	mkdir 0.93
	cd 0.93
	
	for i in {1..6}
	do
		client $1 $2 $i 124 3000 &
	done
		clientExp $1 558 13500 &
		clientExp $2 558 13500 &
	wait
	sleep 1

	cd ..
	mkdir 0.90
	cd 0.90
	
	for i in {1..6}
	do
		client $1 $2 $i 120 3000 &
	done
		clientExp $1 540 13500 &
		clientExp $2 540 13500 &
	wait
	sleep 1

	cd ..
	mkdir 0.87
	cd 0.87
	
	for i in {1..6}
	do
		client $1 $2 $i 116 3000 &
	done
		clientExp $1 522 13500 &
		clientExp $2 522 13500 &
	wait
	sleep 1

	cd ..
	mkdir 0.84
	cd 0.84
	
	for i in {1..6}
	do
		client $1 $2 $i 112 3000 &
	done
		clientExp $1 504 13500 &
		clientExp $2 504 13500 &
	wait
	sleep 1

	cd ..
	mkdir 0.81
	cd 0.81
	
	for i in {1..6}
	do
		client $1 $2 $i 108 3000 &
	done
		clientExp $1 486 13500 &
		clientExp $2 486 13500 &
	wait
	sleep 1

	cd ..
	mkdir 0.78
	cd 0.78
	
	for i in {1..6}
	do
		client $1 $2 $i 104 3000 &
	done
		clientExp $1 468 13500 &
		clientExp $2 468 13500 &
	wait
	sleep 1

	cd ..
	mkdir 0.75
	cd 0.75
	
	for i in {1..6}
	do
		client $1 $2 $i 100 3000 &
	done
		clientExp $1 450 13500 &
		clientExp $2 450 13500 &
	wait
	sleep 1

	cd ..
	mkdir 0.72
	cd 0.72
	
	for i in {1..6}
	do
		client $1 $2 $i 96 3000 &
	done
		clientExp $1 432 13500 &
		clientExp $2 432 13500 &
	wait
	sleep 1

	cd ..
	mkdir 0.66
	cd 0.66
	
	for i in {1..6}
	do
		client $1 $2 $i 92 3000 &
	done
		clientExp $1 414 13500 &
		clientExp $2 414 13500 &
	wait
	sleep 1

	cd ..
	cd ..
done

tc qdisc del dev eth0 root
tc qdisc del dev eth1 root
tc qdisc del dev eth2 root
cd ..
octave calculo_rtts.m

cd 40BT.60FT
for n in {1..200}
do
	rm $n -R
done
