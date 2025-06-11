dir="../out_report"
input_perf="out_report/report_perf.txt"
output_perf="out_report/report_perf_filtered.txt"

# Filtrar perf

## Lista de funciones a procesar
functions=("fill_laticce" "print" "Find" "Union" "HoshenKopelman" "find_clusters" "detec_perc")

## 1. Encabezado
head -n 11 "$input_perf" > "$output_perf"

## 2. Añadir la primera ocurrencia de cada función
for fname in "${functions[@]}"; do
    grep "$fname" "$input_perf" | head -n 1
done | sort -k1,1nr >> "$output_perf"   # Ordenar por columna 1 numérica descendente

# 3. fin
echo -e "\n# --- Fin del reporte filtrado (perf) ---" >> "$output_perf"
