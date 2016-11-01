clear all

ro = [0.66 0.72 0.75 0.78 0.81 0.84 0.87 0.90 0.93 0.96 0.99];

atraso = [ 4364
	5901
	7083.2
	8071
	10046
	12183
	17766
	24599
	41369
	127850
	601370];

a = 1000000*ro*(250*8/500000)./(2*(1-ro));

plot(ro, atraso, 'r-', 'LineWidth', 2.5)
hold on
plot(ro, a, 'k-', 'LineWidth', 2.5)