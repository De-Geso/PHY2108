reset
set terminal pdfcairo
set output 'absolute_training_set.pdf'
# set size square
set key off
set grid
set logscale
set format y '%2.0t{/Symbol \264}10^{%L}'
set xlabel 'Training Dataset Size'
set key on
plot 'nodes=10.dat' using 1:3 w l lw 2 title "Bias", \
	'nodes=10.dat' using 1:4 w l lw 2 title "Variance"

reset
set terminal pdfcairo
set output 'fraction_training_set.pdf'
# set size square
set key off
set grid
set xlabel 'Training Dataset Size'
set ylabel 'Fraction of Total Error'
set key on
plot 'nodes=10.dat' using 1:($3/($3+$4)) w l lw 2 title "Bias", \
	'nodes=10.dat' using 1:($4/($3+$4)) w l lw 2 title "Variance"

reset
set terminal pdfcairo
set output 'absolute_nodes.pdf'
# set size square
set key off
set grid
set logscale
set format y '%2.0t{/Symbol \264}10^{%L}'
set xlabel 'Number of Nodes'
set key bottom center
plot 'train=20000.dat' using 2:3 w l lw 2 title "Bias", \
	'train=20000.dat' using 2:4 w l lw 2 title "Variance"

reset
set terminal pdfcairo
set output 'fraction_nodes.pdf'
# set size square
set grid
set xlabel 'Number of Nodes'
set ylabel 'Fraction of Total Error'
set key center right
plot 'train=20000.dat' using 2:($3/($3+$4)) w l lw 2 title "Bias", \
	'train=20000.dat' using 2:($4/($3+$4)) w l lw 2 title "Variance"

set output
