dir="../out_report"
input_perf="out_report/report_perf.txt"
output_perf="out_report/report_perf_filtered.txt"

# Filter perf

# List of functions to process
functions=("fill_laticce" "print" "Find" "Union" "HoshenKopelman" "find_clusters" "detec_perc")

# Extract the headline. Importante >
head -n 11 "$input_perf" > "$output_perf"

# Add the first ocurrence of each function
for fname in "${functions[@]}"; do
    grep "$fname" "$input_perf" | head -n 1
done | sort -k1,1nr >> "$output_perf"   # Order by first collumn in numeric decending order

# End
echo -e "\n# --- Fin del reporte filtrado (perf) ---" >> "$output_perf"
