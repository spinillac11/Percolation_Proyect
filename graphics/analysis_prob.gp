set terminal pdfcairo enhanced color font 'Arial,12'
set output "figures/Perc_prob.pdf"

set title "Probabilidad de percolación P(L,p)"
set xlabel "Probabilidad de llenado"
set ylabel "P(L,p)"
set grid

# Reduce el tamaño de los puntos y líneas
set style line 1 lt 1 lw 1 pt 7 ps 0.5 lc rgb "#1f77b4"
set style line 2 lt 1 lw 1 pt 7 ps 0.5 lc rgb "#ff7f0e"
set style line 3 lt 1 lw 1 pt 7 ps 0.5 lc rgb "#2ca02c"
set style line 4 lt 1 lw 1 pt 7 ps 0.5 lc rgb "#d62728"
set style line 5 lt 1 lw 1 pt 7 ps 0.5 lc rgb "#9467bd"
set style line 6 lt 1 lw 1 pt 7 ps 0.5 lc rgb "#8c564b"

# Mueve la leyenda a un lugar menos invasivo
set key outside right top vertical samplen 1 spacing 1


L_values = "16 32 64 128 256 512"
plot for [ii=1:words(L_values)] sprintf("data/perc_prob_%s.txt", word(L_values, ii)) \
     using 2:3:4 with yerrorbars ls ii title sprintf("L=%s", word(L_values, ii))
