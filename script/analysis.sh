# Set output directory
dir="data";

# List of lattice sizes to simulate
Ls="16 32 64 128 256 512";

# Define probabilities p to simulate
# Fine-grained step around critical region (~0.59)
Ps="$(seq 0 0.06 0.54) $(seq 0.55 0.01 0.65) $(seq 0.66 0.04 1) 1";

# For each combination of L and p, run program.x 10 times and append to data_L.txt
parallel --progress './program.x {1} {2} >> data_{1}.txt' ::: $Ls ::: $Ps ::: $(seq 1 1 10);

# Compute mean and stddev of percolation probability for each L
for L in $Ls; do
    awk -F'\t' '
    {
        key = $1 "\t" $2;                           # Create key based on L and p
        count[key]++;                               # Count number of samples for this key
        sum[key] += $3;                             # Sum percolation result (0 or 1)
        xsquare[key] += ($3)^2;                     # For standard deviation
    }
    END {
        for (k in sum) {
            N = count[k];                           # Total number of samples
            mean = sum[k]/N;                        # Calculate average
            std = sqrt(xsquare[k] / N - mean^2);    # Calculate stddev using variance formula
            printf "%s\t%.3f\t%.3f\n", k, mean, std; # Output result
        }
    }
    ' data_${L}.txt | sort -k1,1n -k2,2n > ${dir}/perc_prob_${L}.txt;
    # Output: columns [L, p, mean_perc, std_perc]
done
# Filter data where percolation occurred (p = 1)
# This keeps only rows where the system percolated
for L in $Ls; do
    awk '
    {if($3 == 1) print $0}
    ' data_${L}.txt > data_percol_${L}.txt;
    rm -f data_${L}.txt; # Clean up intermediate file
done
# Compute mean and stddev of percolating cluster size (S)
for L in $Ls; do
    awk -F'\t' '
    {
        key = $1 "\t" $2;                           # use L and p as key
        count[key]++;                               # count entries
        sum[key] += $5;                             # sum of percolating cluster size S
        xsquare[key] += ($5)^2;                     # for standard deviation
    }
    END {
        for (k in sum) {
            N = count[k];                           # Total number of samples
            mean = sum[k]/N;                        # Calculate average
            std = sqrt(xsquare[k] / N - mean^2);    # Calculate stddev using variance formula
            printf "%s\t%.3f\t%.3f\n", k, mean, std; # Output result
        }
    }
    ' data_percol_${L}.txt | sort -k1,1n -k2,2n > ${dir}/perc_size_${L}.txt;
    rm -f data_percol_${L}.txt;
done


