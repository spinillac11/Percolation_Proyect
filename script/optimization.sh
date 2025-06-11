# Set output directory
dir="data";

# List of optimization levels
OpL="0 1 2 3 fast"

# List of lattice sizes
Ls="16 32 64 128 256 512 1024 2048";

# Compile the program with different optimization flags (-O0, -O1, ..., -Ofast)
for Op in $OpL; do
    echo "Compilando con -O$Op..."
    g++ -std=c++17 -O$Op -Iinclude source/main.cpp source/functions.cpp -o O$Op.x
done

# Run each compiled binary for each lattice size 10 times in parallel
parallel --progress './O{1}.x {2} 0.6 >> data_O{1}.txt' ::: $OpL ::: $Ls ::: $(seq 1 1 10);

# Aggregate and compute mean and std deviation of column 6 (execution time) for each L
for Op in $OpL; do
    awk -F'\t' '
    {
        key = $1;                                   # Use lattice size as key
        count[key]++;                               # Count the number of repetitions
        sum[key] += $6;                             # Sum the values in column 6 (execution time)
        xsquare[key] += ($6)^2;                     # For standar deviation
    }
    END {
        for (k in sum) {
            N = count[k];                           # Total number of samples
            mean = sum[k]/N;                        # Mean of execution time
            std = sqrt(xsquare[k] / N - mean^2);    # Calculate stddev using variance formula
            printf "%s\t%.3f\t%.3f\n", k, mean, std; 
        }
    }
    ' data_O${Op}.txt | sort -k1,1n -k2,2n > ${dir}/opti_O${Op}.txt;
    rm -f data_O${Op}.txt;
done
rm -f data_O${Op}.txt;
