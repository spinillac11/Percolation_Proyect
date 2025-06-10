mkdir -p resultados_p2
for rep in $(seq 1 10); do
  parallel --progress '
    ./program.x {1} {2} |
    awk "{val=\$3} END {print {1}, {2}, val}"
  ' ::: 32 64 128 256 512 ::: $(seq 0 0.06 0.54) $(seq 0.55 0.01 0.65) $(seq 0.66 0.04 1) 1 \
  > resultados_p2/resultados_rep${rep}.txt
done
