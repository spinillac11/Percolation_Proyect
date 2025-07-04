dir="../out_report"
input_gprof="out_report/report_gprof.txt"
output_gprof="out_report/report_gprof_filtered.txt"

# Filter Gprof

# List of functions to process
functions=("fill_laticce" "print" "Find" "Union" "HoshenKopelman" "find_clusters" "detec_perc")

# Extract the headlien. Importante >
head -n 5 "$input_gprof" > "$output_gprof"

# Add the first ocurrence of each function (keeping the order in seconds acumulated)
for fname in "${functions[@]}"; do
    grep "$fname" "$input_gprof" | head -n 1
done | sort -k2,2n >> "$output_gprof"

# Add the lines Manually
manual_lines="
 %         the percentage of the total running time of the
time       program used by this function.

cumulative a running sum of the number of seconds accounted
 seconds   for by this function and those listed above it.

 self      the number of seconds accounted for by this
seconds    function alone.  This is the major sort for this
           listing.

calls      the number of times this function was invoked, if
           this function is profiled, else blank.

 self      the average number of milliseconds spent in this
ms/call    function per call, if this function is profiled,
	   else blank.

 total     the average number of milliseconds spent in this
ms/call    function and its descendents per call, if this
	   function is profiled, else blank.

name       the name of the function.  This is the minor sort
           for this listing. The index shows the location of
	   the function in the gprof listing. If the index is
	   in parenthesis it shows where it would appear in
	   the gprof listing if it were to be printed.

Copyright (C) 2012-2024 Free Software Foundation, Inc.

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.

		     Call graph (explanation follows)


granularity: each sample hit covers 2 byte(s) for 1.72% of 0.58 seconds

index % time    self  children    called     name
                                                 <spontaneous>"

echo "$manual_lines" >> "$output_gprof"                                         

# Add the other occurences of each function that ARE NOT the firstAñadir las otras ocurrencias de cada función que NO son la primera
for fname in "${functions[@]}"; do
    grep "$fname" "$input_gprof" | tail -n +2 >> "$output_gprof"
done

# End
echo -e "\n# --- Fin del reporte filtrado ---" >> "$output_gprof"