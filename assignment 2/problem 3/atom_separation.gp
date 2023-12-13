# atom_separatoin.gp

set terminal qt 0
set grid
set title '<r> (a=2, runs=64)'
set xlabel 'Time'
set ylabel '<r>'
plot 'mean_r.dat' using 1:2 with lines title 'Simulated', \
	'mean_r.dat' using 1:3 with lines title 'Theoretical'

reset session

set key bottom

set terminal qt enhanced 1
set grid
set title 'var(r) (a=2, runs=64)'
set xlabel 'Time'
set ylabel 'var(r)'
plot 'var_r.dat' using 1:2 with lines title 'Simulation', \
	'var_r.dat' using 1:3 with lines title 'Theoretical/π^{1/2}'
