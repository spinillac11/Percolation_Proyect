dir="data";
Ls="16 32 64 128 256 512";
Ps="$(seq 0.0 0.05 0.5) $(seq 0.55 0.01 0.65) $(seq 0.70 0.05 1.0)";

parallel --progress './program.x {1} {2} >> data_{1}.txt' ::: $Ls ::: $Ps ::: $(seq 1 1 10);

for L in $Ls; do
    awk -F'\t' '
    {
        key = $1 "\t" $2;
        count[key]++;
        sum[key] += $3;
        xsquare[key] += ($3)^2;
    }
    END {
        for (k in sum) {
            N = count[k];
            mean = sum[k]/N;
            std = sqrt(xsquare[k] / N - mean^2);
            printf "%s\t%.3f\t%.3f\n", k, mean, std;
        }
    }
    ' data_${L}.txt | sort -k1,1n -k2,2n > ${dir}/perc_prob_${L}.txt;
done

for L in $Ls; do
    awk '
    {if($3 == 1) print $0}
    ' data_${L}.txt > data_percol_${L}.txt;
    rm -f data_${L}.txt;
done

for L in $Ls; do
    awk -F'\t' '
    {
        key = $1 "\t" $2;
        count[key]++;
        sum[key] += $5;
        xsquare[key] += ($5)^2;
    }
    END {
        for (k in sum) {
            N = count[k];
            mean = sum[k]/N;
            std = sqrt(xsquare[k] / N - mean^2);
            printf "%s\t%.3f\t%.3f\n", k, mean, std;
        }
    }
    ' data_percol_${L}.txt | sort -k1,1n -k2,2n > ${dir}/perc_size_${L}.txt;
    rm -f data_percol_${L}.txt;
done


