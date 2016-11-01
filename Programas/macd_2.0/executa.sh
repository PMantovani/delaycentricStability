#!/bin/bash

gcc client.c -o /usr/sbin/client
tc qdisc add dev eth0 root tbf rate 500kbit latency 1.9s burst 1300B
tc qdisc add dev eth1 root tbf rate 500kbit latency 1.9s burst 1300B
tc qdisc change dev eth0 root tbf rate 500kbit latency 1.9s burst 1300B
tc qdisc change dev eth1 root tbf rate 500kbit latency 1.9s burst 1300B

for n in {1..10}
do
	case $n in
		1) mkdir Teste1
		   cd Teste1  ;;
		2) mkdir Teste2
		   cd Teste2  ;;
		3) mkdir Teste3
		   cd Teste3  ;;
		4) mkdir Teste4
		   cd Teste4  ;;
		5) mkdir Teste5
		   cd Teste5  ;;
		6) mkdir Teste6
		   cd Teste6  ;;
		7) mkdir Teste7
		   cd Teste7  ;;
		8) mkdir Teste8
		   cd Teste8  ;;
		9) mkdir Teste9
		   cd Teste9  ;;
		10) mkdir Teste10
			cd Teste10  ;;
		*) echo "Erro Case!"  ;;
	esac

	mkdir 0.99
	cd 0.99
	for i in {1..6}
	do
		client $1 $2 $i 165 10000 &
	done
	wait

	cd ..
	mkdir 0.96
	cd 0.96
	for i in {1..6}
	do
		client $1 $2 $i 160 10000 &
	done
	wait

	cd ..
	mkdir 0.93
	cd 0.93
	for i in {1..6}
	do
		client $1 $2 $i 155 10000 &
	done
	wait

	cd ..
	mkdir 0.90
	cd 0.90
	for i in {1..6}
	do
		client $1 $2 $i 150 10000 &
	done
	wait

	cd ..
	mkdir 0.87
	cd 0.87
	for i in {1..6}
	do
		client $1 $2 $i 145 10000 &
	done
	wait

	cd ..
	mkdir 0.84
	cd 0.84
	for i in {1..6}
	do
		client $1 $2 $i 140 10000 &
	done
	wait

	cd ..
	mkdir 0.81
	cd 0.81
	for i in {1..6}
	do
		client $1 $2 $i 135 10000 &
	done
	wait

	cd ..
	mkdir 0.78
	cd 0.78
	for i in {1..6}
	do
		client $1 $2 $i 130 10000 &
	done
	wait

	cd ..
	mkdir 0.75
	cd 0.75
	for i in {1..6}
	do
		client $1 $2 $i 125 10000 &
	done
	wait

	cd ..
	mkdir 0.72
	cd 0.72
	for i in {1..6}
	do
		client $1 $2 $i 120 10000 &
	done
	wait

	cd ..
	mkdir 0.66
	cd 0.66
	for i in {1..6}
	do
		client $1 $2 $i 110 10000 &
	done
	wait

	cd ..
	cd ..
done
