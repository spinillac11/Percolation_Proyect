dir="data";
OpL="0 1 2 3 fast"
Ls="16 32 64 128 256 512 1024 2048";

for Op in $OpL; do
    echo "Compilando con -O$Op..."
    g++ -std=c++17 -O$Op -Iinclude source/main.cpp source/functions.cpp -o O$Op.x
done

parallel --progress './O{1}.x {2} 0.6 >> data_O{1}.txt' ::: $OpL ::: $Ls ::: $(seq 1 1 10);

for Op in $OpL; do
    awk -F'\t' '
    {
        key = $1;
        count[key]++;
        sum[key] += $6;
        xsquare[key] += ($6)^2;
    }
    END {
        for (k in sum) {
            N = count[k];
            mean = sum[k]/N;
            std = sqrt(xsquare[k] / N - mean^2);
            printf "%s\t%.3f\t%.3f\n", k, mean, std;
        }
    }
    ' data_O${Op}.txt | sort -k1,1n -k2,2n > ${dir}/opti_O${Op}.txt;
    rm -f data_O${Op}.txt;
done
rm -f data_O${Op}.txt;
