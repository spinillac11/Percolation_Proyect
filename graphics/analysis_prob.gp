set terminal pdfcairo enhanced color font 'Arial,12'
set output "figures/Perc_prob.pdf"

set title "Probabilidad de percolación P(L,p)"
set xlabel "Probabilidad de llenado"
set ylabel "P(L,p)"
set grid

plot for [ii in "16 32 64 128 256 512"] 'data/perc_prob_'.ii.'.txt' u 2:3:4 w yerrorlines t 'L='.ii.''