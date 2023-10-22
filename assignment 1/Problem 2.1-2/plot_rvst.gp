reset
set xlabel "Time"
set ylabel "<r>"
set title "<r> vs t for a=1 {/Symbol t}=1, steps=10^3, trajectories=10^6"
plot 'fort.1' using 1:2 with lines linewidth 2 notitle
unset output
unset terminal

reset
set xlabel "Time"
set ylabel "<r^2>"
set title "<r^2> vs t for a=1 {/Symbol t}=1, steps=10^3, trajectories=10^6"
plot 'fort.1' u 1:3 w l lw 3 title 'Data', 'fort.1' u 1:4 w l lw 2 dt 2 title '1.001t'
unset output
unset terminal
