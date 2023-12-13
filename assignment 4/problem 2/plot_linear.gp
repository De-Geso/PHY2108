reset
set terminal pdfcairo
set output 'lin_fit.pdf'
# set size square
set key off
set grid
set xrange[0 to 10]
set yrange[0 to 10]
plot 'points.dat' using 1:2 pointtype 4 linecolor rgb 'black', \
	'points.dat' using 3:4 pointtype 3 linecolor rgb 'black', \
	'lin_fit.dat' using 1:2 w l linestyle -1, \
	'lin_fit.dat' using 1:3 w l linestyle -1 dashtype 2, \
	'lin_fit.dat' using 1:4 w l linestyle -1 dashtype 2


reset
set terminal pdfcairo
set output 'lin_weights.pdf'
set key center right
set grid
set logscale x
set yrange[-12 to 3]
set xlabel 'Iteration'
plot 'lin_iterative.dat' using 1:2 w l lw 2 title 'w0', \
	'lin_iterative.dat' using 1:3 w l lw 2 title 'w1', \
	'lin_iterative.dat' using 1:4 w l lw 2 title 'w2'
	

reset session
set terminal pdfcairo
set output 'lin_w2vsw1.pdf'
set key off
set grid
set xlabel 'w1'
set ylabel 'w2'
plot 'iterative.dat' using 2:3 w l linestyle -1 lw 2


reset session
set terminal pdfcairo
set output 'lin_objective.pdf'
set grid
set logscale x
plot 'iterative.dat' using 1:5 w l linestyle -1 lw 2 title 'G(w)'


reset session
set terminal pdfcairo
set output 'lin_magnitude.pdf'
set grid
set logscale x
plot 'iterative.dat' using 1:6 w l ls -1 lw 2 title 'E_w(w)'


reset
set terminal pdfcairo
set output 'quad_fit.pdf'
set key off
set grid
set xrange[0 to 10]
set yrange[0 to 10]
plot 'points.dat' using 1:2 pointtype 4 linecolor rgb 'black', \
	'points.dat' using 3:4 pointtype 3 linecolor rgb 'black', \
	'quad_fit.dat' using 1:2 w l linestyle -1 , \
	'quad_fit.dat' using 3:4 w l linestyle -1 dashtype 2, \
	'quad_fit.dat' using 5:6 w l linestyle -1 dashtype 2


reset
set terminal pdfcairo
set output 'quad_weights.pdf'
set key bottom center
set grid
set logscale x
set xlabel 'Iteration'
plot 'quad_iterative.dat' using 1:2 w l lw 2 title 'w0', \
	'quad_iterative.dat' using 1:3 w l lw 2 title 'w1', \
	'quad_iterative.dat' using 1:4 w l lw 2 title 'w2', \
	'quad_iterative.dat' using 1:5 w l lw 2 title 'w3', \
	'quad_iterative.dat' using 1:6 w l lw 2 title 'w4'


reset session
set terminal pdfcairo
set output 'quad_objective.pdf'
set grid
set logscale x
plot 'quad_iterative.dat' using 1:7 w l linestyle -1 lw 2 title 'G(w)'


reset session
set terminal pdfcairo
set output 'quad_magnitude.pdf'
set grid
set logscale x
plot 'quad_iterative.dat' using 1:8 w l ls -1 lw 2 title 'E_w(w)'

set terminal qt
