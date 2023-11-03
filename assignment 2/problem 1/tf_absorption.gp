# tf_absorption.gp

set terminal qt 0
set grid
set title 'Probability to NOT Fall Off (L=0, n_f=100, runs=10^3)'
set xlabel 'Starting Position, n_0'
set ylabel 'Probability to NOT Fall Off'
set yrange [-0.1:1.1]
set key center
plot 'p_0.4.dat' using 1:3 linetype 1 title 'p=0.4', \
	'p_0.4.dat' using 1:4 with lines linetype 1 title 'p=0.4 (Theoretical)', \
	'p_0.6.dat' using 1:3 linetype 2 title 'p=0.6', \
	'p_0.6.dat' using 1:4 with lines linetype 2 title 'p=0.6 (Theoretical)'

#	'p_0.5.dat' using 1:3 linetype 2 title 'p=0.5', \
	'p_0.5.dat' using 1:4 with lines linetype 2 title 'p=0.5 (Theoretical)', \


reset session

set terminal qt 1
set grid
set title 'Mean Time to Fall Off, p=0.6 (L=0, n_f=100, runs=10^3)'
set xlabel 'Starting Position, n_0'
set ylabel 'Time Steps to Fall Off (t/{/Symbol t})'
plot 'p_0.6.dat' using 1:5 linetype 1 title 'Simulation', \
	'p_0.6.dat' using 1:6 with lines linetype 1 title 'Theory'
