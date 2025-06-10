set terminal pdfcairo enhanced color font 'Arial,12'
set output "figures/Size.pdf"

set title "Tamaño promedio cluster percolante S(L,p)"
set xlabel "Probabilidad de llenado"
set ylabel "S(L,p)"
set grid

plot for [ii in "16 32 64 128 256 512"] 'data/perc_size_'.ii.'.txt' u 2:(3/($1*$1)):(4/($1*$1)) w yerrorlines t 'L='.ii.''