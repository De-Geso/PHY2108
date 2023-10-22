# p2_plot.gp

set terminal qt
set grid
set title 'Cumulative Probability (r_1=4, r_2=6, 10^5 trials, 64 bins)'
set xlabel 'Dimensionless Time (t/{/Symbol t})'
set ylabel 'Probability (t_{Event} < t)'
plot 'two_path_decay_hist.dat' using 1:2 with steps linetype 1 title 'Survival', \
	'two_path_decay_theory.dat' using 1:2 with lines linetype 1 dashtype 2 title 'Theoretical Survival', \
	'two_path_decay_hist.dat' using 1:3 with steps linetype 2 title 'Decay via 1', \
	'two_path_decay_theory.dat' using 1:3 with lines linetype 2 dashtype 2 title 'Theoretical Decay via 1', \
	'two_path_decay_hist.dat' using 1:4 with steps linetype 3 title 'Decay via 2', \
	'two_path_decay_theory.dat' using 1:4 with lines linetype 3 dashtype 2 title 'Theoretical Decay via 2'
